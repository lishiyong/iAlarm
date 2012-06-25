//
//  IAAnnotation.m
//  iArrived
//
//  Created by li shiyong on 10-10-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "YCLib.h"
#import "YCSystemStatus.h"
#import "IANotifications.h"
#import "LocalizedString.h"
#import "IAPerson.h"
#import "YCPlacemark.h"
#import "IAAlarm.h"
#import "YCMapPointAnnotation.h"
#import "IAAnnotation.h"

@interface IAAnnotation (Private) 

- (NSString*)_alarmName;
- (NSString*)_alarmTitle;
- (void)handleStandardLocationDidFinish: (NSNotification*) notification;
- (void)registerNotifications;
- (void)unRegisterNotifications;

@end

@implementation IAAnnotation
@synthesize identifier = _identifier, annotationStatus = _annotationStatus, alarm = _alarm;

- (NSString*)_alarmName{
    NSString *theName = nil;
    theName = self.alarm.alarmName;
    theName = theName ? theName : self.alarm.person.personName;
    theName = theName ? theName : self.alarm.placemark.name;
    theName = [theName stringByTrim];
    theName = (theName.length > 0) ? theName : nil;
    return theName;
}

- (NSString*)_alarmTitle{
    NSString *theTitle = [self _alarmName];
    theTitle = theTitle ? theTitle : self.alarm.person.organization;
    theTitle = theTitle ? theTitle : self.alarm.positionTitle; 
    theTitle = theTitle ? theTitle : KDefaultAlarmName;
    
    return theTitle;
}

- (void)handleStandardLocationDidFinish: (NSNotification*) notification{
    
    CLLocation *curLocation = [[notification userInfo] objectForKey:IAStandardLocationKey];
    BOOL curLocationAndRealCoordinateIsValid = (curLocation && CLLocationCoordinate2DIsValid(self.realCoordinate));

    //设置与当前位置的距离值
    if (curLocationAndRealCoordinateIsValid) {        
        CLLocationDistance distance = [curLocation distanceFromCoordinate:self.realCoordinate];
        _distanceFromCurrentLocation = distance;
        
        NSString *distanceString = [curLocation distanceStringFromCoordinate:self.realCoordinate withFormat1:KTextPromptDistanceCurrentLocation withFormat2:KTextPromptCurrentLocation];
        [_distanceString release];
        _distanceString = [distanceString retain];
        
    }else{
        _distanceFromCurrentLocation = -1;
        [_distanceString release];
        _distanceString = nil;
    }
    
    //设置与当前位置的subtitle的字符串
    if (_subTitleIsDistanceString) {
        [self setAnnotationStatus:_annotationStatus];
    }
    
}

- (void)handleApplicationDidBecomeActive: (NSNotification*) notification{
    //进入前台，模拟发送定位数据。防止真正的定位数据迟迟不发。
    NSDictionary *userInfo = nil;
    CLLocation *curLocation = [YCSystemStatus sharedSystemStatus].lastLocation;
    if (curLocation)
        userInfo = [NSDictionary dictionaryWithObject:curLocation forKey:IAStandardLocationKey];
        
    NSNotification *aNotification = [NSNotification notificationWithName:IAStandardLocationDidFinishNotification 
                                                                  object:self
                                                                userInfo:userInfo];
    [self handleStandardLocationDidFinish:aNotification];
    //[self performSelector:@selector(handleStandardLocationDidFinish:) withObject:aNotification afterDelay:0.0];
}

- (void)handleApplicationWillResignActive: (NSNotification*) notification{
    /*
    //进入后台，把距离赋空
    _distanceString = nil;
    if (_subTitleIsDistanceString) {
        [self setAnnotationStatus:_annotationStatus];
    }
     */
}

- (void)registerNotifications {
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver: self
						   selector: @selector (handleStandardLocationDidFinish:)
							   name: IAStandardLocationDidFinishNotification
							 object: nil];
     
    [notificationCenter addObserver: self
						   selector: @selector (handleApplicationDidBecomeActive:)
							   name: UIApplicationDidBecomeActiveNotification
							 object: nil];
     
     [notificationCenter addObserver: self
                            selector: @selector (handleApplicationWillResignActive:)
                                name: UIApplicationWillResignActiveNotification
                              object: nil];
	
}

- (void)unRegisterNotifications{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self	name: IAStandardLocationDidFinishNotification object: nil];
    [notificationCenter removeObserver:self	name: UIApplicationDidBecomeActiveNotification object: nil];
    [notificationCenter removeObserver:self	name: UIApplicationWillResignActiveNotification object: nil];
}


- (id)initWithAlarm:(IAAlarm*)anAlarm{
    self = [super initWithCoordinate:anAlarm.visualCoordinate title:nil
                            subTitle:nil addressDictionary:nil];
    
    if (self) {
        _alarm = [anAlarm retain];
        _realCoordinate = _alarm.realCoordinate;
                
        CLLocation *curLocation = [YCSystemStatus sharedSystemStatus].lastLocation;
        BOOL curLocationAndRealCoordinateIsValid = (curLocation && CLLocationCoordinate2DIsValid(self.realCoordinate));
        if (curLocationAndRealCoordinateIsValid) {
            _distanceString = [curLocation distanceStringFromCoordinate:self.realCoordinate withFormat1:KTextPromptDistanceCurrentLocation withFormat2:KTextPromptCurrentLocation];
            [_distanceString retain];
        }else{
            _distanceString = nil;
        }
        
        self.annotationStatus = _alarm.enabled ? IAAnnotationStatusNormal:IAAnnotationStatusDisabledNormal;
        [self registerNotifications];
    }
    return self;
}

- (NSString *)identifier{
    return _alarm.alarmId;
}

- (void)setAnnotationStatus:(IAAnnotationStatus)annotationStatus{
    //NSLog(@"annotationStatus = %d",annotationStatus);
    _annotationStatus = annotationStatus;
    switch (_annotationStatus) {
        case IAAnnotationStatusNormal:
        {//正常状态 titel：名称，subtitle：距离
            self.title = [self _alarmTitle];
            
            if (_distanceString) {
                if (![self.subtitle isEqualToString:_distanceString]){
                    self.subtitle = nil;
                    self.subtitle = _distanceString;
                }
            }else{
                self.subtitle = nil;
            }
            _subTitleIsDistanceString = YES;
            
            break;
        }
        case IAAnnotationStatusNormal1:
        {//正常状态1 titel：名称，subtitle：长地址(如果名称是地址，那么subtitle显示距离)
            //如果不等待，calloutView有裂缝
            [self performSelector:@selector(setTitle:) withObject:[self _alarmTitle] afterDelay:0.35];
            
            NSString *postion = self.alarm.position;
            if (postion) {
                if (![self.subtitle isEqualToString:postion]){
                    self.subtitle = nil;
                    self.subtitle = postion;
                }
            }else{
                self.subtitle = nil;
            }
            _subTitleIsDistanceString = NO;
            
            break;
        }
        case IAAnnotationStatusDisabledNormal:
        {//禁用状态 titel：名称，subtitle：nil
            self.title = [self _alarmTitle];
            self.subtitle = nil;            
            _subTitleIsDistanceString = NO;
            break;
        }
        case IAAnnotationStatusDisabledNormal1:
        {//禁用状态1 titel：名称，subtitle：长地址
            self.title = [self _alarmTitle];
            self.subtitle = self.alarm.position;
            _subTitleIsDistanceString = NO;
            break;
        }
        case IAAnnotationStatusEditingBegin:
        {//编辑开始状态 titel："拖动改变目的地"，subtitle：名称
            self.title = KLabelMapNewAnnotationTitle;
            self.subtitle = [self _alarmTitle];
            
            _subTitleIsDistanceString = NO;
            break;
        }
        case IAAnnotationStatusReversing:
        {//反转地址中 titel："..."(或名称)，subtitle：名称(或"...")
            if ([self _alarmName]) {//有名字，在拖拽过程中不显示地点的更换
                self.title = [self _alarmName];
                self.subtitle = @" . . .        ";
            }else{
                self.title = @" . . .          ";
                self.subtitle = nil;
            }
            
            _subTitleIsDistanceString = NO;
            break;
        }
        case IAAnnotationStatusReversFinished:
        {//反转完成 titel：名称，subtitle：长地址(如果名称是地址，那么subtitle显示距离)
            //如果不等待，calloutView有裂缝
            [self performSelector:@selector(setTitle:) withObject:[self _alarmTitle] afterDelay:0.35];
            if ([self _alarmName]) {
                self.subtitle = self.alarm.position;
                _subTitleIsDistanceString = NO;
            }else{
                
                if (_distanceString) {
                    if (![self.subtitle isEqualToString:_distanceString]){
                        self.subtitle = nil;
                        self.subtitle = _distanceString;
                    }
                }else{
                    self.subtitle = nil;
                }
                _subTitleIsDistanceString = YES;
                
            }
            break;
        }
        default:
            break;
    }
}

- (void)dealloc {
    [self unRegisterNotifications];
    [_identifier release];
    [_alarm release];
	[super dealloc];
}

@end
