//
//  IAAnnotation.m
//  iArrived
//
//  Created by li shiyong on 10-10-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IAAlarm.h"
#import "YCMapPointAnnotation.h"
#import "IAAnnotation.h"

@implementation IAAnnotation
@synthesize identifier, placemarkForReverse, placeForSearch, annotationType, changedBySearch, alarm;

- (NSString *)identifier{
    return alarm.alarmId;
}

- (id)initWithAlarm:(IAAlarm*)anAlarm{
    self = [super initWithCoordinate:anAlarm.visualCoordinate title:anAlarm.alarmName subTitle:alarm.position addressDictionary:nil];
    if (self) {
        alarm = [anAlarm retain];
        annotationType = alarm.enabled ? IAMapAnnotationTypeStandard:IAMapAnnotationTypeDisabled;
        _realCoordinate = alarm.realCoordinate;
    }
    return self;
}

- (void)dealloc 
{
	[identifier release];
	[placemarkForReverse release];
	[placeForSearch release];
    [alarm release];
	[super dealloc];
}

@end
