//
//  IARecentAddressManager.m
//  iAlarm
//
//  Created by li shiyong on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCPlacemark.h"
#import "YCLib.h"
#import "IARecentAddressManager.h"

@implementation IARecentAddressManager

#define kRecentAddressFileName     @"recentAddress.plist"
#define kMaxNumberOfRecentAddress  200

- (void)addObject:(id)anObject forKey:(NSString*)key{
    //判断最大list数量限制
    if (_all.count >= kMaxNumberOfRecentAddress) 
        [_all removeObjectAtIndex:0];
    [_all addObject:[NSDictionary dictionaryWithObject:anObject forKey:key]];
    
    //保存到文件
    NSString *filePathName =  [[UIApplication sharedApplication].libraryDirectory stringByAppendingPathComponent:kRecentAddressFileName];
    [NSKeyedArchiver archiveRootObject:_all toFile:filePathName];
}

- (void)removeAll{
    [_all removeAllObjects];
    
    //保存到文件
    NSString *filePathName =  [[UIApplication sharedApplication].libraryDirectory stringByAppendingPathComponent:kRecentAddressFileName];
    [NSKeyedArchiver archiveRootObject:_all toFile:filePathName];
}

- (NSArray*)all{
    return [_all copy];
}

- (NSUInteger)allCount{
    return [_all count];
}


#pragma mark - mothed for single 

static IARecentAddressManager *single = nil;
+ (IARecentAddressManager*)sharedManager{
    if (single == nil) {
        single = [[super allocWithZone:NULL] init];
    }
    return single;
}

- (id)init{
    self = [super init];
    if (self) {
        //先从文件中读出
		NSString *filePathName =  [[UIApplication sharedApplication].libraryDirectory stringByAppendingPathComponent:kRecentAddressFileName];
        
		_all = [(NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithFile:filePathName] retain];
		//读不到再创建新的
		if (_all == nil)
			_all = [[NSMutableArray array] retain];
    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedManager] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

@end
