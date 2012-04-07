//
//  YCVehicleType.m
//  iArrived
//
//  Created by li shiyong on 10-10-17.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IAAlarmRadiusType.h"


@implementation IAAlarmRadiusType

@synthesize alarmRadiusTypeId;
@synthesize alarmRadiusName;
@synthesize alarmRadiusValue;
@synthesize alarmRadiusTypeImageName;

#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder {
	
	[encoder encodeObject:alarmRadiusTypeId forKey:kvehicleTypeId];
	[encoder encodeObject:alarmRadiusName forKey:kvehicleTypeName];
	[encoder encodeDouble:alarmRadiusValue forKey:kalarmRadiusValue];
	[encoder encodeObject:alarmRadiusTypeImageName forKey:kalarmRadiusTypeImageName];
		
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {		
		alarmRadiusTypeId = [[decoder decodeObjectForKey:kvehicleTypeId] copy];
		alarmRadiusName = [[decoder decodeObjectForKey:kvehicleTypeName] copy];
		alarmRadiusValue = [decoder decodeDoubleForKey:kalarmRadiusValue];
		alarmRadiusTypeImageName = [[decoder decodeObjectForKey:kalarmRadiusTypeImageName] copy];
    }
    return self;
}

#pragma mark -
#pragma mark NSCopying
/*
- (id)copyWithZone:(NSZone *)zone {
    IAAlarmRadiusType *copy = [[[self class] allocWithZone: zone] init];

	copy.alarmRadiusTypeId = self.alarmRadiusTypeId;
    copy.alarmRadiusName = self.alarmRadiusName;
	copy.alarmRadiusValue = self.alarmRadiusValue;
	copy.alarmRadiusTypeImageName = self.alarmRadiusTypeImageName;
    return copy;
}
 */

- (void)dealloc {
	[alarmRadiusTypeId release];
	[alarmRadiusName release];
	[alarmRadiusTypeImageName release];
    [super dealloc];
}

@end
