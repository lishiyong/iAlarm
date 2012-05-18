//
//  AlarmsListCell.m
//  iAlarm
//
//  Created by li shiyong on 11-1-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import "CLLocation+YC.h"
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

- (void)setDistanceLabelWithCurrentLocation:(CLLocation*)curLocation animated:(BOOL)animated{ 
    
    if (curLocation && alarm) {
        
        CLLocationDistance distance = [curLocation distanceFromCoordinate:alarm.coordinate];
        NSString *distanceString = [curLocation distanceStringFromCoordinate:alarm.coordinate withFormat1:KTextPromptDistanceCurrentLocation withFormat2:KTextPromptCurrentLocation];
        
        //未设置过 或 与上次的距离超过100米
        //if (distanceFromCurrentLocation < 0.0 || fabs(distanceFromCurrentLocation - distance) > 100.0) 
        {
            distanceFromCurrentLocation = distance;

            if (![self.alarmDetailLabel.text isEqualToString:distanceString]) {
                
                //转换动画
                if (animated) {
                    self.userInteractionEnabled = NO;
                    [UIView transitionWithView:self.alarmDetailLabel duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^()
                     {
                         self.alarmDetailLabel.text = distanceString;
                     } completion:^(BOOL finished)
                     {
                         self.userInteractionEnabled = YES;
                     }]; 
                    
                }else{
                    self.alarmDetailLabel.text = distanceString;
                }
                
                
            }
            
        }
        
    }else{
        distanceFromCurrentLocation = -1;
        if (![self.alarmDetailLabel.text isEqualToString:self.alarm.positionShort]) {
            
            //转换动画
            if (animated) {
                self.userInteractionEnabled = NO;
                [UIView transitionWithView:self.alarmDetailLabel duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^()
                 {
                     self.alarmDetailLabel.text = self.alarm.positionShort;
                 } completion:^(BOOL finished)
                 {
                     self.userInteractionEnabled = YES;
                 }];
            }else{
               self.alarmDetailLabel.text = self.alarm.positionShort; 
            }

        }
        
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
        distanceFromCurrentLocation = -1;//未设置过的标识
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
