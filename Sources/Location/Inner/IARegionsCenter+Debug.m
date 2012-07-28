//
//  IARegionsCenter+Debug.m
//  iAlarm
//
//  Created by li shiyong on 12-7-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IARegion.h"
#import "YCLog.h"
#import "YCLib.h"
#import "IARegionsCenter+Debug.h"

@implementation IARegionsCenter (Debug)

- (void)debug{
    
    [[YCLog logSingleInstance] addlog:@"***********************************************************"];
    
    //
    NSString *s1 = [NSString stringWithFormat:@"在监控中心的闹钟: %d",[self regions].count];
    [[YCLog logSingleInstance] addlog:s1];
    for (IARegion *aRegion in [self regions].allValues) {
        NSString *ss = [NSString stringWithFormat:@"     %@",aRegion.alarm];
        [[YCLog logSingleInstance] addlog:ss];
        
    }
    
    [[YCLog logSingleInstance] addlog:@"\n"];
    [[YCLog logSingleInstance] addlog:@"\n"];
    
    //
    UIApplication *app = [UIApplication sharedApplication];
    //[app cancelAllLocalNotifications];
    NSString *s2 = [NSString stringWithFormat:@"所有的通知: %d",app.scheduledLocalNotifications.count];
    [[YCLog logSingleInstance] addlog:s2];
    for (UILocalNotification *ln in app.scheduledLocalNotifications) {
        NSString *ss = [NSString stringWithFormat:@"     %@",ln];
        [[YCLog logSingleInstance] addlog:ss];
    }
    
    [[YCLog logSingleInstance] addlog:@"***********************************************************"];
}


@end
