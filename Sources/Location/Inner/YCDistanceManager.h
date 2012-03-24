//
//  YCDistanceManager.h
//  iAlarm
//
//  Created by li shiyong on 11-4-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>


@interface YCDistanceManager : NSObject {
	NSUInteger numItems;
	NSMutableArray *locations;
}

- (void)addLocation:(CLLocation*)location;
- (void)removeAllLocation;

//在时间范围中，移动的距离
- (CLLocationDistance)distanceMovedBeforeTimeInterval:(NSTimeInterval)timeInterval fromLocation:(CLLocation*)location;
	
- (id)initWithCapacity:(NSUInteger)theNumItems;

@end
