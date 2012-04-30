//
//  StatusBarWindow.h
//  TestKeyFrameAnimation
//
//  Created by li shiyong on 12-4-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCAlarmStatusBar : UIWindow{
    CALayer *backgroundLayer;
    CALayer *alarmIconLayer;
    UIView *xContainerView;
    UILabel *oneLabel;
    //UILabel *twoLabel;
    //UILabel *threeLabel;
}

@property (nonatomic, getter = isAutoHide) BOOL autoHide;
@property (nonatomic) NSTimeInterval autoHideInterval; 
@property (nonatomic) NSInteger alarmCount;

+ (YCAlarmStatusBar *)shareStatusBar;
- (void)setHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)setAlarmIconHidden:(BOOL)hidden animated:(BOOL)animated;
- (CGPoint)alarmIconCenter;
- (void)increaseAlarmCount;
- (void)decreaseAlarmCount;




@end
