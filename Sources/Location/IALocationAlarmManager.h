//
//  IALocationManager.h
//  iAlarm
//
//  Created by li shiyong on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IALocationManagerDelegate.h"
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface IALocationAlarmManager : NSObject

@property(nonatomic, readonly) id<IALocationAlarmManagerDelegate> delegate;
@property(nonatomic, readonly) CLLocation *location;

- (id)initWithDelegate:(id)delegate;

@end
