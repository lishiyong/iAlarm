//
//  IARegion.h
//  iAlarm
//
//  Created by li shiyong on 11-3-1.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>



enum {
    IAUserLocationTypeInner = 0,       
	IAUserLocationTypeOuter,           
    IAUserLocationTypeEdge           //用户持有的设备在区域边缘，边缘宽度，占区域半径的10％
};
typedef NSUInteger IAUserLocationType;

@class IAAlarm;
@class CLRegion;
@interface IARegion : NSObject {
	IAAlarm *_alarm;
	CLRegion *_region;
	CLRegion *_regionInner;
	CLRegion *_regionOuter;
	CLRegion *_preAlarmRegion;
	CLRegion *_bigPreAlarmRegion; 
}

@property (nonatomic,assign) IAUserLocationType userLocationType;
@property (nonatomic,readonly) IAAlarm *alarm;

- (IAUserLocationType)containsCoordinate:(CLLocationCoordinate2D)coodinate;

- (id)initWithAlarm:(IAAlarm*)theAlarm userLocationType:(IAUserLocationType)userLocationType;
- (id)initWithAlarm:(IAAlarm*)theAlarm currentLocation:(CLLocation*)currentLocation;



@end
