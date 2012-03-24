//
//  YCSounds.m
//  iArrived
//
//  Created by li shiyong on 10-10-17.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "YCSound.h"


@implementation YCSound

@synthesize soundId;
@synthesize soundName;
@synthesize soundFileName;
@synthesize soundFileURL;
@synthesize sortId;
@synthesize customSound;

#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder {
	
	[encoder encodeObject:soundId forKey:ksoundId];
	[encoder encodeObject:soundName forKey:ksoundName];
	[encoder encodeObject:soundFileName forKey:ksoundFileName];
	[encoder encodeInteger:sortId forKey:ksoundSortId];

}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {		
		self.soundId = [decoder decodeObjectForKey:ksoundId];
		self.soundName = [decoder decodeObjectForKey:ksoundName];
		self.soundFileName = [decoder decodeObjectForKey:ksoundFileName];
		self.sortId = [decoder decodeIntegerForKey:ksoundSortId];
    }
    return self;
}

#pragma mark -
#pragma mark NSCopying

/*
- (id)copyWithZone:(NSZone *)zone {
    YCSound *copy = [[[self class] allocWithZone: zone] init];
	copy.soundId = self.soundId;
    copy.soundName = self.soundName; 
	copy.soundFileName = self.soundFileName; 
	copy.sortId= self.sortId;  
    return copy;
}
 */

- (void)dealloc {
	[soundId release];
	[soundName release];
	[soundFileName release];
	[soundFileURL release];
    [super dealloc];
}

@end
