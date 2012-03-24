//
//  AlarmsListCell.h
//  iAlarm
//
//  Created by li shiyong on 11-1-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class IAAlarm;
@interface AlarmsListCell : UITableViewCell {
	
    IAAlarm *alarm;
    
    BOOL disabled;
    
    IBOutlet UILabel *positionLabel;
    IBOutlet UILabel *alarmNameLabel;
    IBOutlet UILabel *enablingStringLabel;
	IBOutlet UILabel *alarmRadiusStringLabel;
	IBOutlet UIImageView *alarmRadiusTypeImageView;
	IBOutlet UIView *topShadowView;
	IBOutlet UIView *bottomShadowView;
    
    BOOL detecting;
    IBOutlet UIView *containerView;
    IBOutlet UIImageView *detectingImageView;
    CALayer *scale;
    NSDate *lastUpdateDistanceTimestamp; //最后更新距离时间
}

@property(nonatomic,retain) IBOutlet IAAlarm *alarm;

@property(nonatomic,retain) IBOutlet UILabel *positionLabel;
@property(nonatomic,retain) IBOutlet UILabel *alarmNameLabel;
@property(nonatomic,retain) IBOutlet UILabel *enablingStringLabel;
@property(nonatomic,retain) IBOutlet UILabel *alarmRadiusStringLabel;
@property(nonatomic,retain) IBOutlet UIImageView *alarmRadiusTypeImageView;
@property(nonatomic,retain) IBOutlet UIView *topShadowView;
@property(nonatomic,retain) IBOutlet UIView *bottomShadowView;

@property(nonatomic,retain) IBOutlet UIView *containerView;
@property(nonatomic,retain) IBOutlet UIImageView *detectingImageView;
@property(nonatomic, retain, readonly) CALayer *scale;
@property(nonatomic, retain) NSDate *lastUpdateDistanceTimestamp;


//雷达扫描
- (void)setDetecting:(BOOL)detecting;
- (BOOL)isDetecting;

- (void)setDisabled:(BOOL)disabled;
- (void)refresh:(CLLocation*)currentLocation; //更新界面上的内容


+(id)viewWithXib;

- (void)registerNotifications;

@end
