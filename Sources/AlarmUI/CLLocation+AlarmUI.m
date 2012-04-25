//
//  CLLocation+AlarmUI.m
//  iAlarm
//
//  Created by li shiyong on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LocalizedString.h"
#import "CLLocation+AlarmUI.h"

@implementation CLLocation (AlarmUI)

- (NSString*)distanceStringFromCurrentLocation:(CLLocation*)curLocation{
    
    CLLocationDistance distance = [curLocation distanceFromLocation:self];
    
    NSString *s = nil;
    if (distance > 100.0) 
        s = [NSString stringWithFormat:KTextPromptDistanceCurrentLocation,distance/1000.0];
    else
        s = KTextPromptCurrentLocation;
    
    return s;
}



@end
