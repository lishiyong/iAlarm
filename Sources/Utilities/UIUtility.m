//
//  UIUtility.m
//  iArrived
//
//  Created by li shiyong on 10-10-16.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "YCSound.h"
#import "IAAlarm.h"
#import "LocalizedString.h"
#import "UIUtility.h"
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>


NSString *IANotificationUserInfoKeyAlarmId = @"IANotificationUserInfoKeyAlarmId";
NSString *IANotificationUserInfoKeyArrived = @"IANotificationUserInfoKeyArrived";
NSString *IANotificationUserInfoKeyCurrentLocationLatitude = @"IANotificationUserInfoKeyCurrentLocationLatitude";
NSString *IANotificationUserInfoKeyCurrentLocationLongitude = @"IANotificationUserInfoKeyCurrentLocationLongitude";

@implementation UIUtility

+(void) navigationController:(UINavigationController*) navigationController 
			  viewController:(UIViewController*) viewController
					  isPush:(BOOL) isPush
		durationForAnimation:(CFTimeInterval)duration
		   TransitionForType:(NSString*)type
		TransitionForSubtype:(NSString*)subtype
{
	CATransition *transition = [CATransition animation];
	transition.duration = duration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	//transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	transition.type = type; 
    transition.subtype = subtype;
	

    [navigationController.view.layer addAnimation:transition forKey:nil];
	navigationController.navigationBarHidden = NO; 
	
	if (isPush) {
		[navigationController pushViewController:viewController animated:NO];
	}else{
		[navigationController popViewControllerAnimated:NO];
	}
	
}


static void addRoundedRectToPath(CGContextRef context, 
                                 CGRect rect, 
                                 float ovalWidth,
                                 float ovalHeight) {
    
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
#pragma mark change the corner size below...
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}


+ (UIImage *) roundCorners: (UIImage*) img
{
    int w = img.size.width;
    int h = img.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextBeginPath(context);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    addRoundedRectToPath(context, rect, 5, 5);
    CGContextClosePath(context);
    CGContextClip(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    [img release];
    
	UIImage *image = [UIImage imageWithCGImage:imageMasked];
	CGImageRelease(imageMasked);//修改 2011-09-05
    return image;
}


/* 
 static void addRoundedRectToPath(CGContextRef context, 
 CGRect rect, 
 float ovalWidth,
 float ovalHeight) {
 
 float fw, fh;
 if (ovalWidth == 0 || ovalHeight == 0) {
 CGContextAddRect(context, rect);
 return;
 }
 
 CGContextSaveGState(context);
 CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
 CGContextScaleCTM(context, ovalWidth, ovalHeight);
 fw = CGRectGetWidth(rect) / ovalWidth;
 fh = CGRectGetHeight(rect) / ovalHeight;
 
 CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
 #pragma mark change the corner size below...
 CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
 CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
 CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
 CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
 
 CGContextClosePath(context);
 CGContextRestoreGState(context);
 }
 
 
 + (id) createRoundedRectImage:(UIImage*)image size:(CGSize)size {
 // the size of CGContextRef
 int w = size.width;
 int h = size.height;
 
 CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
 CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
 CGRect rect = CGRectMake(0, 0, w, h);
 
 CGContextBeginPath(context);
 addRoundedRectToPath(context, rect, 10, 10);
 CGContextClosePath(context);
 CGContextClip(context);
 CGContextDrawImage(context, CGRectMake(0, 0, w, h), image.CGImage);
 CGImageRef imageMasked = CGBitmapContextCreateImage(context);
 CGContextRelease(context);
 CGColorSpaceRelease(colorSpace);
 return [UIImage imageWithCGImage:imageMasked];
 }
 */

void MyDrawWithShadows (CGContextRef myContext, // 1
						float wd, float ht)
{
    CGSize          myShadowOffset = CGSizeMake (-15,  20);// 2
    float           myColorValues[] = {1, 0, 0, .6};// 3
    CGColorRef      myColor;// 4
    CGColorSpaceRef myColorSpace;// 5
	
    CGContextSaveGState(myContext);// 6
	
    CGContextSetShadow (myContext, myShadowOffset, 5); // 7
    // Your drawing code here// 8
    CGContextSetRGBFillColor (myContext, 0, 1, 0, 1);
    CGContextFillRect (myContext, CGRectMake (wd/3 + 75, ht/2 , wd/4, ht/4));
	
    myColorSpace = CGColorSpaceCreateDeviceRGB ();// 9
    myColor = CGColorCreate (myColorSpace, myColorValues);// 10
    CGContextSetShadowWithColor (myContext, myShadowOffset, 5, myColor);// 11
    // Your drawing code here// 12
    CGContextSetRGBFillColor (myContext, 0, 0, 1, 1);
    CGContextFillRect (myContext, CGRectMake (wd/3-75,ht/2-100,wd/4,ht/4));
	
    CGColorRelease (myColor);// 13
    CGColorSpaceRelease (myColorSpace); // 14
	
    CGContextRestoreGState(myContext);// 15
}

/*
+(UIColor*)defaultCellDetailTextColor
{
	UIColor* defaultDetailTextColor = nil;
	if (defaultDetailTextColor ==nil) {
		CGColorRef color = CreateDeviceRGBColor(0.22,0.33,0.53,1);
		defaultDetailTextColor = [[[UIColor alloc] initWithCGColor:color] autorelease];
	}
	return defaultDetailTextColor;
}

+(UIColor*)defaultCellTextColor
{
	UIColor* defaultTextColor = nil;
	if (defaultTextColor ==nil) {
		CGColorRef color = CreateDeviceGrayColor(0.0,1.0);
		defaultTextColor = [[[UIColor alloc] initWithCGColor:color] autorelease];
	}
	return defaultTextColor;
}

+(UIColor*)checkedCellTextColor
{
	UIColor* checkedTextColor = nil;
	if (checkedTextColor ==nil) {
		CGColorRef color = CreateDeviceRGBColor(0.22,0.33,0.53,1);
		checkedTextColor = [[[UIColor alloc] initWithCGColor:color] autorelease];
	}
	return checkedTextColor;
}
 */

+(UIColor*)defaultCellDetailTextColor
{
	return [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
}

+(UIColor*)defaultCellTextColor
{
	return [UIColor colorWithWhite:0.0 alpha:1.0];
}

+(UIColor*)checkedCellTextColor
{
	return [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
}


//发送闹钟已经更新消息
+(void)sendAlarmUpdateNotification
{
	UIApplication *app = [UIApplication sharedApplication];
	
	
	// Create a new notification
	UILocalNotification *notification = [[UILocalNotification alloc] init];
	notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
	notification.timeZone = [NSTimeZone defaultTimeZone];
	notification.repeatInterval = 0;
	notification.soundName = @"ping.caf";//@"default";
	notification.alertBody = @"闹钟数据更新";
	notification.userInfo = [NSDictionary dictionaryWithObject:@"updateAlarm"forKey:@"name"];
	
	
	[app scheduleLocalNotification:notification];
	[notification release];
}

/*
+(NSString*)convertgen:(double)latitude decimal:(NSUInteger)decimal name:(NSString*)name
{
	double lTemp =  fabs(latitude);
	
	NSInteger a= (NSInteger)lTemp;
	double af = lTemp - a;
	
	NSInteger b= (NSInteger)(af*60);
	double bf = af * 60 -b;
	
	NSInteger c= (NSInteger)(bf*60);
	NSInteger cf = (NSInteger)((bf*60 - c) * pow(10,decimal)) ;
	
	
	NSString *s = nil;
	NSString *f = nil;
	if (decimal >0) 
		f = [name stringByAppendingString:@" %d°%d′%d.%d″"];
	else 
		f = [name stringByAppendingString:@" %d°%d′%d″"];
	
	s = [[[NSString alloc] initWithFormat:f,a,b,c,cf] autorelease];
	return s;
}
 */

//转换经纬度
+(NSString*)convertgen:(double)latitude decimal:(NSUInteger)decimal formateString:(NSString*)formateString
{
	double lTemp =  fabs(latitude);
	
	NSInteger a= (NSInteger)lTemp;
	double af = lTemp - a;
	
	NSInteger b= (NSInteger)(af*60);
	double bf = af * 60 -b;
	
	NSInteger c= (NSInteger)(bf*60);
	NSInteger cf = (NSInteger)((bf*60 - c) * pow(10,decimal)) ;
	
	
	NSString *s = [[[NSString alloc] initWithFormat:formateString,a,b,c,cf] autorelease];
	return s;
}



+(NSString*)convertLatitude:(double)latitude decimal:(NSUInteger)decimal
{
	NSString *formateString = nil;

	if (latitude>0){
		if (decimal >0) 
			formateString = kCoordinateFrmStringNorthLatitudeDecimal; //北纬,带小数
		else 
			formateString = kCoordinateFrmStringNorthLatitude; //北纬
	}else {
		if (decimal >0) 
			formateString = kCoordinateFrmStringSouthLatitudeDecimal; //南纬,带小数
		else 
			formateString = kCoordinateFrmStringSouthLatitude; //南纬
	}
	
	return [UIUtility convertgen:latitude decimal:decimal formateString:formateString];
}

+(NSString*)convertLongitude:(double)longitude decimal:(NSUInteger)decimal
{
	
	NSString *formateString = nil;
	
	if (longitude>0){
		if (decimal >0) 
			formateString = kCoordinateFrmStringEastLongitudeDecimal; //东经,带小数
		else 
			formateString = kCoordinateFrmStringEastLongitude; //东经
	}else {
		if (decimal >0) 
			formateString = kCoordinateFrmStringWestLongitudeDecimal; //西经,带小数
		else 
			formateString = kCoordinateFrmStringWestLongitude; //西经
	}
	  
	return [UIUtility convertgen:longitude decimal:decimal formateString:formateString];
}

+(NSString*)convertCoordinate:(CLLocationCoordinate2D)coordinate{
	double lat = coordinate.latitude;
	double lon = coordinate.longitude;
	NSString *latstr = [UIUtility convertLatitude:lat decimal:0];
	NSString *lonstr = [UIUtility convertLongitude:lon decimal:0];
	NSString *position = [[[NSString alloc] initWithFormat:@"%@,%@",latstr,lonstr] autorelease];
	return position;
}

+ (void)sendNotifyWithAlertBody:(NSString*)alertBody soundName:(NSString*)soundName{
	
	UIApplication *app = [UIApplication sharedApplication];
	
	UILocalNotification *notification = [[UILocalNotification alloc] init];
	notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
	notification.timeZone = [NSTimeZone defaultTimeZone];
	notification.repeatInterval = 0;
	notification.soundName = soundName;
	notification.alertBody = alertBody;
		
	[app scheduleLocalNotification:notification];
	[notification release];
}

+ (void)sendNotifyWithAlertBody:(NSString*)alertBody soundName:(NSString*)soundName applicationIconBadgeNumber:(NSInteger)number{
    UIApplication *app = [UIApplication sharedApplication];
	
	UILocalNotification *notification = [[UILocalNotification alloc] init];
	notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
	notification.timeZone = [NSTimeZone defaultTimeZone];
	notification.repeatInterval = 0;
	notification.soundName = soundName;
	notification.alertBody = alertBody;
    notification.applicationIconBadgeNumber = number;
    
    //notification.userInfo = [NSDictionary dictionaryWithObject:@"aObject" forKey:@"aKey"];
    
	[app scheduleLocalNotification:notification];
	[notification release];
}


+ (void)sendNotifyWithAlarm:(IAAlarm*)alarm alertBody:(NSString*)alertBody soundName:(NSString*)soundName{
	UIApplication *app = [UIApplication sharedApplication];
	
	UILocalNotification *notification = [[UILocalNotification alloc] init];
	notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
	notification.timeZone = [NSTimeZone defaultTimeZone];
	notification.repeatInterval = 0;
	notification.soundName = soundName;
	notification.alertBody = alertBody;
	notification.userInfo = [NSDictionary dictionaryWithObject:alarm.alarmId forKey:@"IAAlarm"];
	
	
	[app scheduleLocalNotification:notification];
	[notification release];
}


+ (void)sendNotifyWithAlarm:(IAAlarm*)alarm arrived:(BOOL)arrived currentLocation:(CLLocation*)currentLocation{
	
	UIApplication *app = [UIApplication sharedApplication];
	
	UILocalNotification *notification = [[UILocalNotification alloc] init];
	notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
	notification.timeZone = [NSTimeZone defaultTimeZone];
	notification.repeatInterval = 0;
	notification.soundName = alarm.sound.soundFileName;
	notification.alertBody = alarm.alarmName;
	
	CLLocationCoordinate2D coodinate = currentLocation.coordinate;
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						alarm.alarmId,IANotificationUserInfoKeyAlarmId
						,[NSNumber numberWithBool:arrived],IANotificationUserInfoKeyArrived
						,[NSNumber numberWithDouble:coodinate.latitude],IANotificationUserInfoKeyCurrentLocationLatitude
						,[NSNumber numberWithDouble:coodinate.longitude],IANotificationUserInfoKeyCurrentLocationLongitude
						,nil];
	notification.userInfo = dic;
	
	[app scheduleLocalNotification:notification];
	[notification release];
}


//发送个简单的通知 弹出警告筐－－debug
+(void)sendSimpleNotifyForAlart:(NSString*)alertBody
{
	// Create a new notification
	UILocalNotification *notification = [[UILocalNotification alloc] init];
	notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
	notification.timeZone = [NSTimeZone defaultTimeZone];
	notification.repeatInterval = 0;
	//notification.soundName = @"ping.caf";//@"default";
	notification.alertBody = alertBody;
	notification.userInfo = [NSDictionary dictionaryWithObject:@"sendSimpleNotifyForAlart"forKey:@"name"];
	
	UIApplication *app = [UIApplication sharedApplication];
	[app scheduleLocalNotification:notification];
	[notification release];
}

+(void)sendNotifyForAlart:(NSString*)alertBody notifyName:(NSString*)notifyName
{
	// Create a new notification
	UILocalNotification *notification = [[UILocalNotification alloc] init];
	notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
	notification.timeZone = [NSTimeZone defaultTimeZone];
	notification.repeatInterval = 0;
	//notification.soundName = @"ping.caf";//@"default";
	notification.alertBody = alertBody;
	notification.userInfo = [NSDictionary dictionaryWithObject:notifyName forKey:@"name"];
	
	UIApplication *app = [UIApplication sharedApplication];
	[app scheduleLocalNotification:notification];
	[notification release];
}

+(void)sendNotify:(NSString*)alertBody 
		notifyName:(NSString*)notifyName 
		 fireDate:(NSDate*)fireDate 
   repeatInterval:(NSCalendarUnit)repeatInterval 
		soundName:(NSString*)soundName
{
	// Create a new notification
	UILocalNotification *notification = [[UILocalNotification alloc] init];
	notification.alertBody = alertBody;
	notification.userInfo = [NSDictionary dictionaryWithObject:notifyName forKey:@"name"];
	
	notification.timeZone = [NSTimeZone defaultTimeZone];
	if(fireDate == nil)
		notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
	else 
		notification.fireDate = fireDate;
	notification.repeatInterval = repeatInterval;
	
	if(soundName == nil)
		notification.soundName = @"ping.caf";
	else 
		notification.soundName = soundName;
	
	UIApplication *app = [UIApplication sharedApplication];
	[app scheduleLocalNotification:notification];
	[notification release];
}

+(void)simpleAlertMessage:(NSString*)alertMessage
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertMessage
													message:@"" 
												   delegate:nil
										  cancelButtonTitle:kAlertBtnOK 
										  otherButtonTitles:nil];
	
	[alert show];
	[alert release];
}

+(void)simpleAlertBody:(NSString*)alertBody 
				alertTitle:(NSString*)alertTitle
		 cancelButtonTitle:(NSString*)cancelButtonTitle
				  delegate:(id)delegate
{
	/*
	if(alertTitle ==nil)
	{
		alertTitle = @"iAlarm";
	}
	 */
	
	if(cancelButtonTitle ==nil)
		cancelButtonTitle = @"OK";
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle
													message:alertBody 
												   delegate:delegate
										  cancelButtonTitle:cancelButtonTitle 
										  otherButtonTitles:nil];
	
	[alert show];
	[alert release];
}

+(void)simpleAlertBody:(NSString*)alertBody 
			alertTitle:(NSString*)alertTitle
	 cancelButtonTitle:(NSString*)cancelButtonTitle
		 OKButtonTitle:(NSString*)OKButtonTitle
			  delegate:(id)delegate
{
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle
													message:alertBody 
												   delegate:delegate
										  cancelButtonTitle:cancelButtonTitle 
										  otherButtonTitles:OKButtonTitle,nil];
	                                       
	
	//保持cancel按钮在右侧
	
	[alert show];
	[alert release];
}

+(NSString*)positionShortStringFromPlacemark:(MKPlacemark*)placemark
{
	NSString * thoroughfare = placemark.thoroughfare; //街道
	NSString * subthoroughfare = placemark.subThoroughfare;//街道号
	NSString * locality = placemark.locality; //城市
	
	///////////////
	//去空格
	thoroughfare = [thoroughfare stringByTrimmingCharactersInSet: 
					[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if([thoroughfare length] == 0) thoroughfare = nil;
	
	subthoroughfare = [subthoroughfare stringByTrimmingCharactersInSet: 
					[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if([subthoroughfare length] == 0) subthoroughfare = nil;
	
	locality = [locality stringByTrimmingCharactersInSet: 
					[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if([locality length] == 0) locality = nil;
	///////////////
	
	
	if(thoroughfare == nil && subthoroughfare == nil && locality) return nil;
	
	if (thoroughfare ==nil) thoroughfare=@"";
	if (subthoroughfare ==nil) subthoroughfare=@"";
	if (locality ==nil) locality=@"";
	
	NSString *string = [[[NSString alloc] initWithFormat:@"%@ %@ %@",thoroughfare,subthoroughfare,locality] autorelease];
	
	return string;
}

+(NSString*)positionStringFromPlacemark:(MKPlacemark*)placemark
{
	NSString * thoroughfare = placemark.thoroughfare; //街道
	NSString * subthoroughfare = placemark.subThoroughfare;//街道号
	NSString * locality = placemark.locality; //城市
	NSString * administrativeArea = placemark.administrativeArea;//省
	NSString * country = placemark.country;//国
	
	///////////////
	//去空格
	thoroughfare = [thoroughfare stringByTrimmingCharactersInSet: 
					[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if([thoroughfare length] == 0) thoroughfare = nil;
	
	subthoroughfare = [subthoroughfare stringByTrimmingCharactersInSet: 
					   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if([subthoroughfare length] == 0) subthoroughfare = nil;
	
	locality = [locality stringByTrimmingCharactersInSet: 
				[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if([locality length] == 0) locality = nil;
	
	administrativeArea = [administrativeArea stringByTrimmingCharactersInSet: 
				[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if([administrativeArea length] == 0) administrativeArea = nil;
	
	country = [country stringByTrimmingCharactersInSet: 
				[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if([country length] == 0) country = nil;
	///////////////
	
	if(locality == nil && thoroughfare == nil && subthoroughfare == nil  
	   && administrativeArea == nil && country == nil) 
		return nil;
	
	if (locality ==nil) locality=@"";
	if (thoroughfare ==nil) thoroughfare=@"";
	if (subthoroughfare ==nil) subthoroughfare=@"";
	if (administrativeArea ==nil) administrativeArea=@"";
	if (country ==nil) country=@"";
	
	NSString *string = [[[NSString alloc] initWithFormat:@"%@ %@ %@ %@ %@",thoroughfare,subthoroughfare,locality,administrativeArea,country] autorelease];
	
	return string;
}

+(NSString*)titleStringFromPlacemark:(MKPlacemark*)placemark
{
	/*
	NSString * retVal = placemark.subLocality; 
	if (retVal==nil)
		retVal = placemark.thoroughfare; //街道
	return retVal;
	*/
	NSString * thoroughfare = placemark.thoroughfare; //街道
	thoroughfare = [thoroughfare stringByTrimmingCharactersInSet: 
							   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if([thoroughfare length] == 0) thoroughfare = nil;
	
	

	return thoroughfare;
}

+(void)setBar:(UIView*)theBar
	   topBar:(BOOL)topBar
	  visible:(BOOL)visible 
	 animated:(BOOL)animated
animateDuration:(CFTimeInterval)animateDuration 
  animateName:(NSString*)animateName;
{
	if (animated) 
	{
		CATransition *animation = [CATransition animation];  
		//[animation setDelegate:self];  
		[animation setDuration:animateDuration];
		animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; 
		[animation setType:kCATransitionPush];
		[animation setFillMode:kCAFillModeForwards];
		[animation setRemovedOnCompletion:YES];
		
		NSString *subtype = nil;
		if (topBar)
			subtype = visible ? kCATransitionFromBottom:kCATransitionFromTop;
		else
			subtype = visible ? kCATransitionFromTop:kCATransitionFromBottom;
		[animation setSubtype:subtype];
		
		theBar.hidden = !visible;  
		[[theBar layer] addAnimation:animation forKey:animateName];
	}else {
		theBar.hidden = !visible; 
	}
}


//把米为单位的距离转换成合适的单位的字符串
+(NSString*)convertDistance:(CLLocationDistance)distance{
	NSString *s = nil;

	//round()
	//RoundEx
	//ceil() 向上取整
	//floor() 向下取整
	double d = distance/1000.0;
	//NSInteger n = ceil(d);
	NSString *temple= kUnitKilometre;
	/*
	if (n > 1) //复数
		temple= kAlarmRadiusUnitKilometres;
	 */
	
	s = [NSString stringWithFormat:@"%.1f %@",d,temple];

	
	return s;
}







@end


CGColorRef CreateDeviceGrayColor(CGFloat w, CGFloat a)
{
	CGColorSpaceRef gray = CGColorSpaceCreateDeviceGray();
	CGFloat comps[] = {w, a};
	CGColorRef color = CGColorCreate(gray, comps);
	CGColorSpaceRelease(gray);
	return color;
}

CGColorRef CreateDeviceRGBColor(CGFloat r, CGFloat g, CGFloat b, CGFloat a)
{
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	CGFloat comps[] = {r, g, b, a};
	CGColorRef color = CGColorCreate(rgb, comps);
	CGColorSpaceRelease(rgb);
	return color;
}
