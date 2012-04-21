//
//  AlarmsListCell.m
//  iAlarm
//
//  Created by li shiyong on 11-1-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import "UIColor+YC.h"
#import "IARegionsCenter.h"
#import "IANotifications.h"
#import "IAAlarm.h"
#import "LocalizedString.h"
#import "AlarmsListCell.h"


@implementation AlarmsListCell

@synthesize alarm, enabled;
@synthesize alarmTitleLabel, alarmDetailLabel, isEnabledLabel, flagImageView, topShadowView, bottomShadowView;

- (void)setEnabled:(BOOL)theEnabled{
    enabled = theEnabled;
    if (enabled) {
        self.isEnabledLabel.text = KDicOn; 
        self.isEnabledLabel.alpha = 1.0;
        self.alarmDetailLabel.alpha = 1.0;
        self.alarmTitleLabel.textColor = [UIColor blackColor];
        self.alarmDetailLabel.textColor = [UIColor darkGrayColor];
    }else{
        self.flagImageView.image = [UIImage imageNamed:@"IAFlagGray.png"];//灰色的旗帜
        self.isEnabledLabel.text = KDicOff; //文字:关闭
        self.isEnabledLabel.alpha = 0.8;
        self.alarmDetailLabel.alpha = 0.8;
        self.alarmTitleLabel.textColor = [UIColor darkGrayColor];
        self.alarmDetailLabel.textColor = [UIColor darkGrayColor];
    }
}

- (void)setAlarm:(IAAlarm *)theAlarm{
    [theAlarm retain];
    [alarm release];
    alarm = theAlarm;
    
    alarmTitleLabel.text = self.alarm.alarmName;
    self.enabled = alarm.enabling;
    if (self.enabled) {
        NSString *imageName = self.alarm.alarmRadiusType.alarmRadiusTypeImageName;
        self.flagImageView.image = [UIImage imageNamed:imageName];
    }
}

- (void)setDistanceWithCurrentLocation:(CLLocation*)curLocation{ 
    //最后位置过久，不用
    NSTimeInterval ti = [curLocation.timestamp timeIntervalSinceNow];
    if (ti < -120) curLocation = nil; //120秒内的数据可用
    
    
    if (curLocation && alarm) {
        
        CLLocation *aLocation = [[[CLLocation alloc] initWithLatitude:alarm.coordinate.latitude longitude:alarm.coordinate.longitude] autorelease];
        CLLocationDistance distance = [curLocation distanceFromLocation:aLocation];
        
        NSString *s = nil;
        if (distance > 100.0) 
            s = [NSString stringWithFormat:KTextPromptDistanceCurrentLocation,[curLocation distanceFromLocation:aLocation]/1000.0];
        else
            s = KTextPromptCurrentLocation;
        
        //未设置过 或 与上次的距离超过100米
        if (distanceFromCurrentLocation < 0.0 || fabs(distanceFromCurrentLocation - distance) > 100.0) {
            distanceFromCurrentLocation = distance;

            if (![self.alarmDetailLabel.text isEqualToString:s]) {
                
                //转换动画
                self.userInteractionEnabled = NO;
                [UIView transitionWithView:self.alarmDetailLabel duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^()
                 {
                     self.alarmDetailLabel.text = s;
                 } completion:^(BOOL finished)
                 {
                     self.userInteractionEnabled = YES;
                 }];
                
            }
            
        }
        
    }else{
        if (![self.alarmDetailLabel.text isEqualToString:self.alarm.positionShort]) {
            
            //转换动画
            self.userInteractionEnabled = NO;
            [UIView transitionWithView:self.alarmDetailLabel duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^()
             {
                 self.alarmDetailLabel.text = self.alarm.positionShort;
             } completion:^(BOOL finished)
             {
                 self.userInteractionEnabled = YES;
             }];

        }
        
    }
    
    
}

- (void) handleStandardLocationDidFinish: (NSNotification*) notification{
    CLLocation *location = [[notification userInfo] objectForKey:IAStandardLocationKey];
    [self setDistanceWithCurrentLocation:location];    
}

- (void)registerNotifications{
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	//有新的定位数据产生
	[notificationCenter addObserver: self
						   selector: @selector (handleStandardLocationDidFinish:)
							   name: IAStandardLocationDidFinishNotification
							 object: nil];
}

- (void)unRegisterNotifications{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter removeObserver:self	name: IAStandardLocationDidFinishNotification object: nil];
}


#pragma mark - Init and Memery

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        distanceFromCurrentLocation = -1;//未设置过的标识
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
	[alarm release];
    
    [alarmTitleLabel release];
    [alarmDetailLabel release];
    [isEnabledLabel release];
    [flagImageView release];
    [topShadowView release];
	[bottomShadowView release];
    [super dealloc];
}


@end
