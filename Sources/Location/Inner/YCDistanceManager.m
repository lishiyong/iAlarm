//
//  YCDistanceManager.m
//  iAlarm
//
//  Created by li shiyong on 11-4-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YCDistanceManager.h"

const NSTimeInterval kDefaultNumItems = 200.0;        

@implementation YCDistanceManager

- (void)addLocation:(CLLocation*)location{
	
    [locations addObject:location];
    
    if (locations.count >= numItems) {
		[locations removeObjectAtIndex:0];
	}

}
- (void)removeAllLocation{
	[locations removeAllObjects];
}

//在时间范围中，移动的距离
- (CLLocationDistance)distanceMovedBeforeTimeInterval:(NSTimeInterval)timeInterval fromLocation:(CLLocation*)location{
	
	if (locations.count < 10) {//总数不够
		return 1000000.0;
	}
	

	CLLocationDistance reVal = 0.0;
	NSDate *now = [NSDate date];
	for (NSInteger i = 0; i < locations.count-1 ;i++) {
		CLLocation *oneObj = [locations objectAtIndex:i];
		CLLocation *twoObj = [locations objectAtIndex:i+1];
		
		NSTimeInterval t1 = [now timeIntervalSinceDate: oneObj.timestamp];
		NSTimeInterval t2 = [now timeIntervalSinceDate: twoObj.timestamp];
		
		if (timeInterval >= t1) { //时间不够
			reVal = 1000000.0;
			break;
		}
		
		if (timeInterval <= t1 &&  timeInterval >= t2) {
			reVal = [oneObj distanceFromLocation:location];
			break;
		}
		
	}
	
	return reVal;
	
}


- (id)initWithCapacity:(NSUInteger)theNumItems{
	self = [super init];
    if (self) {
		theNumItems = (theNumItems != 0)?theNumItems:kDefaultNumItems;
		locations = [[NSMutableArray alloc] initWithCapacity:theNumItems];
		numItems = theNumItems;
	}
	return self;
	
}

- (id)init{
	return [self initWithCapacity:0];
}

- (void) dealloc
{
	[locations release];	
	[super dealloc];
}

@end
