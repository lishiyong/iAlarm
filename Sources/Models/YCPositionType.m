//
//  YCPositionType.m
//  iArrived
//
//  Created by li shiyong on 10-10-21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "YCPositionType.h"


@implementation YCPositionType

@synthesize positionTypeId;
@synthesize positionTypeName;
@synthesize sortId;

#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder {
	
	[encoder encodeObject:positionTypeId forKey:kpositionTypeId];
	[encoder encodeObject:positionTypeName forKey:kpositionTypeName];
	[encoder encodeInteger:sortId forKey:kpositionSortId];
	
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {		
		self.positionTypeId = [decoder decodeObjectForKey:kpositionTypeId];
		self.positionTypeName = [decoder decodeObjectForKey:kpositionTypeName];
		self.sortId = [decoder decodeIntegerForKey:kpositionSortId];
    }
    return self;
}

#pragma mark -
#pragma mark NSCopying

/*
- (id)copyWithZone:(NSZone *)zone {
    YCPositionType *copy = [[[self class] allocWithZone: zone] init];

	copy.positionTypeId = self.positionTypeId;
    copy.positionTypeName = self.positionTypeName; 
	copy.sortId= self.sortId;  
    return copy;
}
 */

- (void)dealloc {
	[positionTypeId release];
	[positionTypeName release];
    [super dealloc];
}

@end
