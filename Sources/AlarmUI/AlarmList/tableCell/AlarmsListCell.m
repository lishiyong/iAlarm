//
//  AlarmsListCell.m
//  iAlarm
//
//  Created by li shiyong on 11-1-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import "YCSystemStatus.h"
#import "YCLib.h"
#import "IAPerson.h"
#import "YCPlacemark.h"
#import "CLLocation+YC.h"
#import "UIColor+YC.h"
#import "IARegionsCenter.h"
#import "IANotifications.h"
#import "IAAlarm.h"
#import "LocalizedString.h"
#import "AlarmsListCell.h"

@interface AlarmsListCell (Private) 

- (void)handleStandardLocationDidFinish: (NSNotification*) notification;
- (void)registerNotifications;
- (void)unRegisterNotifications;

@end

@implementation AlarmsListCell

@synthesize alarm;
@synthesize alarmTitleLabel, alarmDetailLabel, isEnabledLabel, flagImageView, topShadowView, bottomShadowView;


- (void)updateCell{
    
    //可用状态时候就更新距离
    _subTitleIsDistanceString = self.alarm.enabled;
    
    NSString *theTitle  = self.alarm.alarmName;
    theTitle = theTitle ? theTitle : self.alarm.person.personName;
    theTitle = theTitle ? theTitle : self.alarm.placemark.name;
    theTitle = [theTitle stringByTrim];
    theTitle = (theTitle.length > 0) ? theTitle : nil;
    theTitle = theTitle ? theTitle : self.alarm.person.organization;
    theTitle = theTitle ? theTitle : self.alarm.positionTitle; 
    theTitle = theTitle ? theTitle : KDefaultAlarmName;
    
    alarmTitleLabel.text = theTitle;
    alarmDetailLabel.text = self.alarm.enabled ? _distanceString : self.alarm.position;
    if (!alarmDetailLabel.text) 
        alarmDetailLabel.text = self.alarm.position;
    NSString *imageName = self.alarm.enabled ? self.alarm.alarmRadiusType.alarmRadiusTypeImageName : @"IAFlagGray.png";
    self.flagImageView.image = [UIImage imageNamed:imageName];
    
    if (self.alarm.enabled) {
        self.isEnabledLabel.text = KDicOn; 
        self.isEnabledLabel.alpha = 1.0;
        self.alarmDetailLabel.alpha = 1.0;
        self.alarmTitleLabel.textColor = [UIColor colorWithWhite:0.03 alpha:0.9];
        self.alarmDetailLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        self.isEnabledLabel.textColor = [UIColor colorWithWhite:0.03 alpha:0.85];
    }else{
        self.isEnabledLabel.text = KDicOff; //文字:关闭
        self.alarmTitleLabel.textColor = [UIColor darkGrayColor];
        self.alarmDetailLabel.textColor = [UIColor darkGrayColor];
        self.isEnabledLabel.textColor = [UIColor grayColor];
    }

}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [UIView animateWithDuration:0.25 animations:^{ self.isEnabledLabel.alpha = editing ? 0.0 : 1.0;}];
}

#pragma mark - Init and Memery

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _distanceFromCurrentLocation = -1;//未设置过的标识
        
        CLLocation *curLocation = [YCSystemStatus deviceStatusSingleInstance].lastLocation;
        BOOL curLocationAndRealCoordinateIsValid = (curLocation && CLLocationCoordinate2DIsValid(self.alarm.realCoordinate));
        if (curLocationAndRealCoordinateIsValid) {
            _distanceString = [curLocation distanceStringFromCoordinate:self.alarm.realCoordinate withFormat1:KTextPromptDistanceCurrentLocation withFormat2:KTextPromptCurrentLocation];
            [_distanceString retain];
        }else{
            _distanceString = nil;
        }
        
        [self registerNotifications];
    }
    return self;
}

+ (id)viewWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle{
    nibName = nibName ? nibName : @"AlarmsListCell";
    nibBundle = nibBundle ? nibBundle : [NSBundle mainBundle];
    
    NSArray *nib = [nibBundle loadNibNamed:nibName owner:self options:nil];
	AlarmsListCell *cell =nil;
	for (id oneObject in nib){
		if ([oneObject isKindOfClass:[AlarmsListCell class]]){
			cell = (AlarmsListCell *)oneObject;
		}
	}
	
	NSString *backgroundImagePath = [nibBundle pathForResource:@"iAlarmList_row" ofType:@"png"];
    UIImage *backgroundImage = [[UIImage imageWithContentsOfFile:backgroundImagePath] stretchableImageWithLeftCapWidth:0.0 topCapHeight:1.0];
	cell.backgroundView = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
	cell.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	cell.backgroundView.frame = cell.bounds;
    
	return cell; 
}


- (void)dealloc {
    [self unRegisterNotifications];
    
    [_distanceString release];
	[alarm release];
    [alarmTitleLabel release];
    [alarmDetailLabel release];
    [isEnabledLabel release];
    [flagImageView release];
    [topShadowView release];
	[bottomShadowView release];
    [super dealloc];
}


- (void)handleStandardLocationDidFinish: (NSNotification*) notification{
    
    CLLocation *curLocation = [[notification userInfo] objectForKey:IAStandardLocationKey];
    BOOL curLocationAndRealCoordinateIsValid = (curLocation && CLLocationCoordinate2DIsValid(self.alarm.realCoordinate));
    
    //设置与当前位置的距离值
    if (curLocationAndRealCoordinateIsValid) {        
        CLLocationDistance distance = [curLocation distanceFromCoordinate:self.alarm.realCoordinate];
        _distanceFromCurrentLocation = distance;
        
        NSString *distanceString = [curLocation distanceStringFromCoordinate:self.alarm.realCoordinate withFormat1:KTextPromptDistanceCurrentLocation withFormat2:KTextPromptCurrentLocation];
        [_distanceString release];
        _distanceString = [distanceString retain];
        
    }else{
        _distanceFromCurrentLocation = -1;
        [_distanceString release];
        _distanceString = nil;
    }
    
    //设置与当前位置的subtitle的字符串
    if (_subTitleIsDistanceString) {
        [UIView transitionWithView:self.alarmDetailLabel duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^()
         {
             if (_distanceString) {
                 if (![self.alarmDetailLabel.text isEqualToString:_distanceString])
                     self.alarmDetailLabel.text = _distanceString;
             }else{
                 self.alarmDetailLabel.text = nil;
             }
             
         } completion:NULL];         
    }
    
}

- (void)registerNotifications {
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver: self
						   selector: @selector (handleStandardLocationDidFinish:)
							   name: IAStandardLocationDidFinishNotification
							 object: nil];
	
}

- (void)unRegisterNotifications{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self	name: IAStandardLocationDidFinishNotification object: nil];
}



@end
