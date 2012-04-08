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
    [encoder encodeObject:soundFileURL forKey:ksoundFileURL];
    [encoder encodeBool:customSound forKey:kcustomSound];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {		
        soundId = [[decoder decodeObjectForKey:ksoundId] copy];
		soundName = [[decoder decodeObjectForKey:ksoundName] copy];
		soundFileName = [[decoder decodeObjectForKey:ksoundFileName] copy];
		sortId = [decoder decodeIntegerForKey:ksoundSortId];
        soundFileURL = [[decoder decodeObjectForKey:ksoundFileURL] retain];
        customSound = [decoder decodeBoolForKey:kcustomSound];
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
