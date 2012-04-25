//
//  CLLocation+AlarmUI.h
//  iAlarm
//
//  Created by li shiyong on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (AlarmUI)

- (NSString*)distanceStringFromCurrentLocation:(CLLocation*)aLocation;

@end
