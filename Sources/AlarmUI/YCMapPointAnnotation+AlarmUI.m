//
//  YCMapPointAnnotation+AlarmUI.m
//  iAlarm
//
//  Created by li shiyong on 12-4-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LocalizedString.h"
#import "CLLocation+AlarmUI.h"
#import "YCMapPointAnnotation+AlarmUI.h"

@implementation YCMapPointAnnotation (AlarmUI)

- (void)setDistanceSubtitleWithCurrentLocation:(CLLocation*)curLocation{ 
    
    if (curLocation && CLLocationCoordinate2DIsValid(self.coordinate)) {
        
        CLLocation *aLocation = [[[CLLocation alloc] initWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude] autorelease];
        
        CLLocationDistance distance = [curLocation distanceFromLocation:aLocation];
        NSString *distanceString = [aLocation distanceStringFromCurrentLocation:curLocation];
        
        //未设置过 或 与上次的距离超过100米
        //if (distanceFromCurrentLocation < 0.0 || fabs(distanceFromCurrentLocation - distance) > 100.0) 
        if (![self.subtitle isEqualToString:distanceString]) 
        {
            distanceFromCurrentLocation = distance;
            self.subtitle = distanceString;
        }
        
    }else{
        distanceFromCurrentLocation = -1;
        self.subtitle = nil;
    }
    
}




@end
