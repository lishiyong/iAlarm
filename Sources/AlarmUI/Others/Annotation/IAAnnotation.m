//
//  IAAnnotation.m
//  iArrived
//
//  Created by li shiyong on 10-10-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IAPerson.h"
#import "YCPlacemark.h"
#import "IAAlarm.h"
#import "YCMapPointAnnotation.h"
#import "IAAnnotation.h"

@implementation IAAnnotation
@synthesize identifier, placemarkForReverse, placeForSearch, annotationType, changedBySearch, alarm;

- (NSString *)identifier{
    return alarm.alarmId;
}

- (id)initWithAlarm:(IAAlarm*)anAlarm{
    BOOL nameIsNull = anAlarm.alarmName ? NO : YES;
    self = [super initWithCoordinate:anAlarm.visualCoordinate title:nameIsNull?anAlarm.positionTitle:anAlarm.alarmName  subTitle:alarm.positionShort addressDictionary:nil];
    
    if (self) {
        alarm = [anAlarm retain];
        annotationType = alarm.enabled ? IAMapAnnotationTypeStandard:IAMapAnnotationTypeDisabled;
        _realCoordinate = alarm.realCoordinate;
        /*
        NSString *theTitle = nil;
        theTitle = alarm.alarmName;
        theTitle = theTitle ? theTitle : alarm.person.personName;
        theTitle = theTitle ? theTitle : alarm.person.organization;
        theTitle = theTitle ? theTitle : alarm.positionTitle; 
        title = [theTitle retain];
         */
        
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
