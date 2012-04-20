//
//  AlarmsListCell.m
//  iAlarm
//
//  Created by li shiyong on 11-1-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import "IARegionsCenter.h"
#import "IANotifications.h"
#import "IAAlarm.h"
#import "LocalizedString.h"
#import "AlarmsListCell.h"


@implementation AlarmsListCell

@synthesize alarm;
@synthesize positionLabel;
@synthesize alarmNameLabel;
@synthesize enablingStringLabel;
@synthesize alarmRadiusStringLabel;
@synthesize alarmRadiusTypeImageView;
@synthesize topShadowView;
@synthesize bottomShadowView;
@synthesize containerView;
@synthesize detectingImageView;
@synthesize lastUpdateDistanceTimestamp;

+(id)viewWithXib 
{
	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AlarmsListCell" owner:self options:nil];
	AlarmsListCell *cell =nil;
	for (id oneObject in nib){
		if ([oneObject isKindOfClass:[AlarmsListCell class]]){
			cell = (AlarmsListCell *)oneObject;
		}
	}
	
	NSString *backgroundImagePath = [[NSBundle mainBundle] pathForResource:@"iAlarmList_row" ofType:@"png"];
	
    UIImage *backgroundImage = [[UIImage imageWithContentsOfFile:backgroundImagePath] stretchableImageWithLeftCapWidth:0.0 topCapHeight:1.0];
	cell.backgroundView = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
	cell.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	cell.backgroundView.frame = cell.bounds;
    
    [cell registerNotifications];
	
	return cell; 
}

- (id)scale{
	if (scale == nil) {
		scale =[[ CALayer layer] retain] ;
		UIImage *image1 = [UIImage imageNamed:@"TrackingDotHaloSmall.png"];
		scale.contents = (id)image1.CGImage;
		scale.frame=CGRectMake (0.0,0.0,50.0,50.0);
	}
    
	return scale;
}




- (void)startScaleAnimation{
    CALayer *rootLayer=self.containerView.layer; 
	self.scale.position= self.detectingImageView.center;
	if (self.scale.superlayer == nil) {
        [rootLayer addSublayer :self.scale];
    }
    
    
    //先把动画都删除了
	[self.scale removeAllAnimations];
    
    [CATransaction begin];
    
    //聚焦框动画
	CABasicAnimation *scaleAnimation=[ CABasicAnimation animationWithKeyPath: @"transform.scale" ];  
	scaleAnimation.delegate = self;
	scaleAnimation.timingFunction= [ CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];  
    scaleAnimation.fromValue= [NSNumber numberWithFloat:0.1];
	scaleAnimation.toValue= [NSNumber numberWithFloat:1.0];   
	scaleAnimation.duration=1.5 ;  
	scaleAnimation.fillMode=kCAFillModeForwards;  
	scaleAnimation.removedOnCompletion=YES;
    scaleAnimation.cumulative = YES;
	[self.scale addAnimation :scaleAnimation forKey :@"scale" ];
    
    [CATransaction commit];
    
}

- (void)removeAllAnimations{
    [self.scale removeAllAnimations];
    CALayer *rootLayer=self.containerView.layer;
    [rootLayer removeAllAnimations];
}

- (void)animationDidStart:(CAAnimation *)theAnimation{
    CALayer *rootLayer=self.containerView.layer;
    [rootLayer removeAllAnimations];
    
    [CATransaction begin];
    
    //淡入淡出动画
    CATransition *fadeAnimation = [CATransition animation];  
    [fadeAnimation setDuration:1.0]; //比scale动画快
    fadeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; 
    [fadeAnimation setType:kCATransitionFade];
    [fadeAnimation setFillMode:kCAFillModeForwards];
    [fadeAnimation setRemovedOnCompletion:YES];
    self.scale.hidden = YES;
    [rootLayer addAnimation:fadeAnimation forKey:@"fade"];
    
    [CATransaction commit];
    
}



- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
	self.scale.hidden = NO;
    [self.scale removeFromSuperlayer];
    if (flag == YES) { //反复显示动画
        if (detecting) 
            [self performSelector:@selector(startScaleAnimation) withObject:nil afterDelay:1.0];//动画的时间间隔 //[self startScaleAnimation];
    }else
        detecting = NO; //停止雷达扫描
}

- (void)setDetecting:(BOOL)theDetecting{
    /*
    if (disabled) {
        self.detectingImageView.image = [UIImage imageNamed:@"TrackingDotGrey.png"]; //灰色的圆点
        detecting = theDetecting;
        [self removeAllAnimations];
        return;
    }
    
    if (theDetecting == NO){
        self.detectingImageView.image = [UIImage imageNamed:@"TrackingDotYellow.png"];
        [self removeAllAnimations];
    }else{
        self.detectingImageView.image = [UIImage imageNamed:@"TrackingDot.png"];
        if (self.isDetecting == NO) //避免重复开启
            [self startScaleAnimation];
    }
    
    
    detecting = theDetecting;
     */
    detecting = theDetecting;
    if (disabled) {
        self.detectingImageView.image = [UIImage imageNamed:@"YCRing.png"];
    }else{
        self.detectingImageView.image = [UIImage imageNamed:@"YCRing.png"];
    }
}

- (BOOL)isDetecting{
    return detecting;
}

- (void)setDisabled:(BOOL)theDisabled{
    /*
    disabled = theDisabled;
    if (disabled) {
        detecting = NO; //停止雷达扫描
        [self removeAllAnimations];
        
        self.alarmRadiusTypeImageView.image = [UIImage imageNamed:@"IAFlagGray.png"];//灰色的旗帜
        self.detectingImageView.image = [UIImage imageNamed:@"TrackingDotGrey.png"]; //灰色的圆点
        self.enablingStringLabel.text = KDicOff; //文字:关闭
        self.enablingStringLabel.alpha = 0.8;
        self.positionLabel.alpha = 0.8;
        self.alarmNameLabel.textColor = [UIColor darkGrayColor];
    }else{
        //self.detectingImageView.image = [UIImage imageNamed:@"TrackingDot.png"];
        self.enablingStringLabel.text = KDicOn; 
        self.enablingStringLabel.alpha = 1.0;
        self.positionLabel.alpha = 1.0;
        self.alarmNameLabel.textColor = [UIColor blackColor];
    }
     */
    disabled = theDisabled;
    if (disabled) {
        self.enablingStringLabel.text = KDicOff; //文字:关闭
        self.enablingStringLabel.alpha = 0.8;
        self.positionLabel.alpha = 0.8;
        self.alarmNameLabel.textColor = [UIColor darkGrayColor];
    }else{
        self.enablingStringLabel.text = KDicOn; 
        self.enablingStringLabel.alpha = 1.0;
        self.positionLabel.alpha = 1.0;
        self.alarmNameLabel.textColor = [UIColor blackColor];
    }
}

//显示距离当前位置XX公里
- (NSString*)distanceStringFromDestionationToCurrentLocation:(CLLocation*)location{
	//设置距离文本
    NSString * s = nil;
    CLLocation *aLocation = [[[CLLocation alloc] initWithLatitude:self.alarm.coordinate.latitude longitude:self.alarm.coordinate.longitude] autorelease];
    CLLocationDistance distance = [location distanceFromLocation:aLocation];
    
    if (distance > 100.0) 
        s = [NSString stringWithFormat:KTextPromptDistanceCurrentLocation,[location distanceFromLocation:aLocation]/1000.0];
    else
        s = KTextPromptCurrentLocation;
	
	return s;
}

//更新界面上的内容
- (void)refresh:(CLLocation*)currentLocation{
    BOOL isEnabling = alarm.enabling;
    
    self.alarmNameLabel.text = self.alarm.alarmName;
    if (isEnabling) {
        NSString *imageName = self.alarm.alarmRadiusType.alarmRadiusTypeImageName;
        self.alarmRadiusTypeImageView.image = [UIImage imageNamed:imageName];
    }
    [self setDisabled:!isEnabling];
    
    //最后位置过久，不用
    NSTimeInterval ti = [currentLocation.timestamp timeIntervalSinceNow];
    if (ti < -120) currentLocation = nil; //120秒内的数据可用
    
    if (currentLocation) {
        self.positionLabel.text = [self distanceStringFromDestionationToCurrentLocation:currentLocation];
        self.lastUpdateDistanceTimestamp = [NSDate date]; //更新时间戳
    }else{
        self.positionLabel.text = self.alarm.positionShort;
    }
    
    //雷达扫描
    BOOL isDetecting = [[IARegionsCenter regionCenterSingleInstance] isDetectingWithAlarm:alarm];
	[self setDetecting:isDetecting];

}

- (void) handle_standardLocationDidFinish: (NSNotification*) notification{
    //间隔10秒以上才更新
    if (self.lastUpdateDistanceTimestamp == nil || [self.lastUpdateDistanceTimestamp timeIntervalSinceNow] < -10) {
        CLLocation *location = [[notification userInfo] objectForKey:IAStandardLocationKey];
        [self refresh:location];
    }
}

- (void) handle_applicationWillEnterForeground: (id) notification{
    //为了雷达扫描
    self.lastUpdateDistanceTimestamp = nil;
}


- (void)registerNotifications{
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	//有新的定位数据产生
	[notificationCenter addObserver: self
						   selector: @selector (handle_standardLocationDidFinish:)
							   name: IAStandardLocationDidFinishNotification
							 object: nil];
    
    [notificationCenter addObserver: self
						   selector: @selector (handle_applicationWillEnterForeground:)
							   name: UIApplicationWillEnterForegroundNotification
							 object: nil];
    
    
}

- (void)unRegisterNotifications{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter removeObserver:self	name: IAStandardLocationDidFinishNotification object: nil];
    [notificationCenter removeObserver:self	name: UIApplicationWillEnterForegroundNotification object: nil];
}


- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self unRegisterNotifications];
	[alarm release];
    [positionLabel release];
    [alarmNameLabel release];
    [enablingStringLabel release];
	[alarmRadiusStringLabel release];
	[alarmRadiusTypeImageView release];
	[topShadowView release];
	[bottomShadowView release];
    [containerView release];
    [detectingImageView release];
    [scale release];
    [lastUpdateDistanceTimestamp release];
	
    [super dealloc];
}


@end
