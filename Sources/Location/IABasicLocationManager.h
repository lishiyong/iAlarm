//
//  IARegionMonitoringLocationManager.h
//  iAlarm
//
//  Created by li shiyong on 12-1-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IALocationManagerInterface.h"
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface IABasicLocationManager : NSObject <CLLocationManagerDelegate,IALocationManagerInterface>{
    id<IALocationManagerDelegate> delegate;
    
	CLLocationManager *standardLocationManager;
    
    BOOL running;
    
}


@property(nonatomic,assign) id<IALocationManagerDelegate> delegate;

@property(nonatomic,readonly) CLLocationManager *standardLocationManager;

- (void)start;
- (void)stop;




@end
