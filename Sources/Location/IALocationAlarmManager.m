//
//  IALocationManager.m
//  iAlarm
//
//  Created by li shiyong on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IAPlaceholderLocationAlarmManager.h"
#import "IALocationAlarmManager.h"

@implementation IALocationAlarmManager

@synthesize delegate = _delegate;

+ (id)allocWithZone:(NSZone *)zone{
    return [IAPlaceholderLocationAlarmManager allocWithZone:zone];
}

- (id)initWithDelegate:(id)delegate{
    self = [self init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (id)location{
    return nil;
}


@end
