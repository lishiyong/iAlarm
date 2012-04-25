//
//  YCMapPointAnnotation+AlarmUI.m
//  iAlarm
//
//  Created by li shiyong on 12-4-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LocalizedString.h"
#import "YCMapPointAnnotation+AlarmUI.h"

@implementation YCMapPointAnnotation (AlarmUI)

- (void)setDistanceWithCurrentLocation:(CLLocation*)curLocation{ 
    //最后位置过久，不用
    NSTimeInterval ti = [curLocation.timestamp timeIntervalSinceNow];
    if (ti < -120) curLocation = nil; //120秒内的数据可用
    
    if (curLocation && CLLocationCoordinate2DIsValid(self.coordinate)) {
        
        CLLocation *aLocation = [[[CLLocation alloc] initWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude] autorelease];
        CLLocationDistance distance = [curLocation distanceFromLocation:aLocation];
        
        NSString *s = nil;
        if (distance > 100.0) 
            s = [NSString stringWithFormat:KTextPromptDistanceCurrentLocation,[curLocation distanceFromLocation:aLocation]/1000.0];
        else
            s = KTextPromptCurrentLocation;
        
        //未设置过 或 与上次的距离超过100米
        if (self.distanceFromCurrentLocation < 0.0 || fabs(self.distanceFromCurrentLocation - distance) > 100.0) {
            self.distanceFromCurrentLocation = distance;
            self.subtitle = s;
        }
        
    }else{
        self.distanceFromCurrentLocation = -1;
        self.subtitle = nil;
    }
}

@end
