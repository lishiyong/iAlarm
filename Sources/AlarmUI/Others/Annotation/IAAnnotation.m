//
//  IAAnnotation.m
//  iArrived
//
//  Created by li shiyong on 10-10-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "YCLib.h"
#import "IANotifications.h"
#import "LocalizedString.h"
#import "IAPerson.h"
#import "YCPlacemark.h"
#import "IAAlarm.h"
#import "YCMapPointAnnotation.h"
#import "IAAnnotation.h"

@interface IAAnnotation (Private) 

- (NSString*)_alarmName;
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
    theName = theName ? theName : self.alarm.person.organization;
    theName = theName ? theName : self.alarm.positionTitle; 
    
    return theName;
}

- (void)handleStandardLocationDidFinish: (NSNotification*) notification{
    
    CLLocation *curLocation = [[notification userInfo] objectForKey:IAStandardLocationKey];
    BOOL curLocationAndRealCoordinateIsValid = (curLocation && CLLocationCoordinate2DIsValid(self.realCoordinate));

    //设置与当前位置的距离值
    if (curLocationAndRealCoordinateIsValid) {        
        CLLocationDistance distance = [curLocation distanceFromCoordinate:self.realCoordinate];
        distanceFromCurrentLocation = distance;
    }else{
        distanceFromCurrentLocation = -1;
    }
    
    //设置与当前位置的subtitle的字符串
    if (IAAnnotationStatusNormal == _annotationStatus) {
        if (curLocationAndRealCoordinateIsValid) {
            
            NSString *distanceString = [curLocation distanceStringFromCoordinate:self.realCoordinate withFormat1:KTextPromptDistanceCurrentLocation withFormat2:KTextPromptCurrentLocation];
            if (![self.subtitle isEqualToString:distanceString])
                self.subtitle = distanceString;
        }
            
    }
    
}

- (void)registerNotifications {
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver: self
						   selector: @selector (handle_standardLocationDidFinish:)
							   name: IAStandardLocationDidFinishNotification
							 object: nil];
	
}

- (void)unRegisterNotifications{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self	name: IAStandardLocationDidFinishNotification object: nil];
}


- (id)initWithAlarm:(IAAlarm*)anAlarm{
    BOOL nameIsNull = anAlarm.alarmName ? NO : YES;
    self = [super initWithCoordinate:anAlarm.visualCoordinate title:nameIsNull?anAlarm.positionTitle:anAlarm.alarmName  subTitle:_alarm.positionShort addressDictionary:nil];
    
    if (self) {
        _alarm = [anAlarm retain];
        _annotationStatus = _alarm.enabled ? IAAnnotationStatusNormal:IAAnnotationStatusDisabled;
        _realCoordinate = _alarm.realCoordinate;
        [self unRegisterNotifications];
    }
    return self;
}

- (NSString *)identifier{
    return _alarm.alarmId;
}

- (void)setAnnotationStatus:(IAAnnotationStatus)annotationStatus{
    _annotationStatus = annotationStatus;
    switch (_annotationStatus) {
        case IAAnnotationStatusNormal:
        {//正常状态 titel：名称，subtitle：距离
            self.title = [self _alarmName];
            self.subtitle = nil; //在通知中设置
            break;
        }
        case IAAnnotationStatusNormal1:
        {//正常状态1 titel：名称，subtitle：长地址
            self.title = [self _alarmName];
            self.subtitle = self.alarm.position;
            break;
        }
        case IAAnnotationStatusDisabled:
        {//禁用状态 titel：名称，subtitle：长地址
            self.title = [self _alarmName];
            self.subtitle = self.alarm.position;
            break;
        }
        case IAAnnotationStatusEditingBegin:
        {//编辑开始状态 titel："拖动改变目的地"，subtitle：名称
            self.title = KLabelMapNewAnnotationTitle;
            self.subtitle = [self _alarmName];
            break;
        }
        case IAAnnotationStatusReversing:
        {//反转地址中 titel："..."，subtitle：名称
            self.title = @" . . .                         ";
            self.subtitle = [self _alarmName];
            break;
        }
        case IAMapAnnotationTypeReversFinished:
        {//反转地址完成 titel：名称，subtitle：长地址
            self.title = [self _alarmName];
            self.subtitle = self.alarm.position;
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
