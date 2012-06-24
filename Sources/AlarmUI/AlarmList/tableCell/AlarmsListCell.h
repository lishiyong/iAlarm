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
	CLLocationDistance _distanceFromCurrentLocation;
    NSString  *_distanceString;
    BOOL _subTitleIsDistanceString;
}

@property(nonatomic,retain) IAAlarm *alarm;
@property(nonatomic,retain) IBOutlet UILabel *alarmTitleLabel;
@property(nonatomic,retain) IBOutlet UILabel *alarmDetailLabel;
@property(nonatomic,retain) IBOutlet UILabel *isEnabledLabel;
@property(nonatomic,retain) IBOutlet UIImageView *flagImageView;
@property(nonatomic,retain) IBOutlet UIView *topShadowView;
@property(nonatomic,retain) IBOutlet UIView *bottomShadowView;

+ (id)viewWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle;

- (void)updateCell;

@end
