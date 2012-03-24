//
//  UIUtility.h
//  iArrived
//
//  Created by li shiyong on 10-10-16.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LocalizedString.h"
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>

extern NSString *IANotificationUserInfoKeyAlarmId;
extern NSString *IANotificationUserInfoKeyArrived;
extern NSString *IANotificationUserInfoKeyCurrentLocationLatitude;
extern NSString *IANotificationUserInfoKeyCurrentLocationLongitude ;

@class IAAlarm;
@class MKPlacemark;
@interface UIUtility : NSObject {
	
}

//UINavigationController 的动画转换效果
+(void) navigationController:(UINavigationController*) navigationController 
			  viewController:(UIViewController*) viewController
					  isPush:(BOOL) isPush
		durationForAnimation:(CFTimeInterval)duration
		   TransitionForType:(NSString*)type
		TransitionForSubtype:(NSString*)subtype;

//把图片切成圆角
+ (UIImage *) roundCorners: (UIImage*) img;

//默认cell的text颜色
+(UIColor*)defaultCellDetailTextColor;
//默认cell的detailtext颜色
+(UIColor*)defaultCellTextColor;
//选中的cell的text颜色
+(UIColor*)checkedCellTextColor;
//发送闹钟已经更新消息
+(void)sendAlarmUpdateNotification;


//发送个简单的通知 －－debug
+(void)sendSimpleNotifyForAlart:(NSString*)alertBody;
+(void)sendNotifyForAlart:(NSString*)alertBody notifyName:(NSString*)notifyName;
+(void)sendNotify:(NSString*)alertBody 
		notifyName:(NSString*)notifyName 
		 fireDate:(NSDate*)fireDate 
   repeatInterval:(NSCalendarUnit)repeatInterval 
		soundName:(NSString*)soundName;

//+ (void)sendNotifyWithAlarm:(IAAlarm*)alarm alertBody:(NSString*)alertBody soundName:(NSString*)soundName;
//+ (void)sendNotifyWithAlarm:(IAAlarm*)alarm arrived:(BOOL)arrived;
+ (void)sendNotifyWithAlarm:(IAAlarm*)alarm arrived:(BOOL)arrived currentLocation:(CLLocation*)currentLocation;
+ (void)sendNotifyWithAlertBody:(NSString*)alertBody soundName:(NSString*)soundName;
+ (void)sendNotifyWithAlertBody:(NSString*)alertBody soundName:(NSString*)soundName applicationIconBadgeNumber:(NSInteger)number;



+(void)simpleAlertMessage:(NSString*)alertMessage;


+(void)simpleAlertBody:(NSString*)alertBody 
				alertTitle:(NSString*)alertTitle
		 cancelButtonTitle:(NSString*)cancelButtonTitle
				  delegate:(id)delegate;

+(void)simpleAlertBody:(NSString*)alertBody 
			alertTitle:(NSString*)alertTitle
	 cancelButtonTitle:(NSString*)cancelButtonTitle
	OKButtonTitle:(NSString*)OKButtonTitle
			  delegate:(id)delegate;

//转换经纬度
+(NSString*)convertLatitude:(double)latitude   decimal:(NSUInteger)decimal;
+(NSString*)convertLongitude:(double)longitude decimal:(NSUInteger)decimal;
//转换经+纬度
+(NSString*)convertCoordinate:(CLLocationCoordinate2D)coordinate;


//从地址信息提取地址字符串
+(NSString*)positionStringFromPlacemark:(MKPlacemark*)placemark;
+(NSString*)titleStringFromPlacemark:(MKPlacemark*)placemark;
+(NSString*)positionShortStringFromPlacemark:(MKPlacemark*)placemark;
 


//设置bar的可视状态
+(void)setBar:(UIView*)theBar
	  topBar:(BOOL)topBar
	  visible:(BOOL)visible 
		 animated:(BOOL)animated
  animateDuration:(CFTimeInterval)animateDuration 
	  animateName:(NSString*)animateName;


//把米为单位的距离转换成合适的单位的字符串
+(NSString*)convertDistance:(CLLocationDistance)distance;


@end


CGColorRef CreateDeviceGrayColor(CGFloat w, CGFloat a);
CGColorRef CreateDeviceRGBColor(CGFloat r, CGFloat g, CGFloat b, CGFloat a);

