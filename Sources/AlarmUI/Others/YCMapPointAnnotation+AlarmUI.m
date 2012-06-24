//
//  YCMapPointAnnotation+AlarmUI.m
//  iAlarm
//
//  Created by li shiyong on 12-4-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCLocationManager.h"
#import "LocalizedString.h"
#import "CLLocation+YC.h"
#import "YCMapPointAnnotation+AlarmUI.h"

@implementation YCMapPointAnnotation (AlarmUI)

- (void)setDistanceSubtitleWithCurrentLocation:(CLLocation*)curLocation{ 
    
    if (curLocation && CLLocationCoordinate2DIsValid(self.realCoordinate)) {
        
        CLLocationCoordinate2D theRealCoordinate = self.realCoordinate;        
        CLLocationDistance distance = [curLocation distanceFromCoordinate:theRealCoordinate];
        NSString *distanceString = [curLocation distanceStringFromCoordinate:theRealCoordinate withFormat1:KTextPromptDistanceCurrentLocation withFormat2:KTextPromptCurrentLocation];
        
        //未设置过 或 与上次的距离超过100米
        //if (distanceFromCurrentLocation < 0.0 || fabs(distanceFromCurrentLocation - distance) > 100.0) 
        if (![self.subtitle isEqualToString:distanceString])
        {
            _distanceFromCurrentLocation = distance;
            self.subtitle = distanceString;
        }
        
    }else{
        _distanceFromCurrentLocation = -1;
        self.subtitle = nil;
    }
    
}




@end
