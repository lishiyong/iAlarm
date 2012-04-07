//
//  YCRepeatTypes.m
//  iArrived
//
//  Created by li shiyong on 10-10-17.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "YCRepeatType.h"


@implementation YCRepeatType

@synthesize repeatTypeId;
@synthesize repeatTypeName;
@synthesize sortId;

#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder {
	
	[encoder encodeObject:repeatTypeId forKey:krepeatTypeId];
	[encoder encodeObject:repeatTypeName forKey:krepeatTypeName];
	[encoder encodeInteger:sortId forKey:ksortId];
	
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {		
		repeatTypeId = [[decoder decodeObjectForKey:krepeatTypeId] copy];
		repeatTypeName = [[decoder decodeObjectForKey:krepeatTypeName] copy];
		sortId = [decoder decodeIntegerForKey:ksortId];
    }
    return self;
}

#pragma mark -
#pragma mark NSCopying

/*
- (id)copyWithZone:(NSZone *)zone {
    YCRepeatType *copy = [[[self class] allocWithZone: zone] init];

	copy.repeatTypeId = self.repeatTypeId;
    copy.repeatTypeName = self.repeatTypeName;
    copy.sortId= self.sortId;  
    return copy;
}
 */

- (void)dealloc {
	[repeatTypeId release];
	[repeatTypeName release];
    [super dealloc];
}

@end
