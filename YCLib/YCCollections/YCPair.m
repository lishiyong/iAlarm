//
//  YCPair.m
//  iAlarm
//
//  Created by li shiyong on 12-6-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCPair.h"

@implementation YCPair

- (id)value{
    return [[_dic objectEnumerator] nextObject];
}

- (id)key{
    return [[_dic keyEnumerator] nextObject];
}

- (id)initWithValue:(id)aValue forKey:(id)aKey{
    self = [super init];
    if (self) {
        _dic = [[NSDictionary dictionaryWithObject:aValue forKey:aKey] retain];
    }
    return self;
}

+ (id)pairWithValue:(id)aValue forKey:(id)aKey{
    return [[[[self class] alloc] initWithValue:aValue forKey:aKey] autorelease];
}

- (void)dealloc{
    [_dic release];
    [super dealloc];
}

#pragma mark - NSCoding and NSCopying

#define kYCPairDic   @"kYCPairDic"
- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:_dic forKey:kYCPairDic];
}

- (id)initWithCoder:(NSCoder *)decoder{
    self = [super init];
    if (self) {
        _dic = [[decoder decodeObjectForKey:kYCPairDic] retain];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    YCPair *copy = [[[self class] allocWithZone: zone] initWithValue:self.value forKey:self.key];
    return copy;
}

@end
