//
//  IARecentAddressManager.m
//  iAlarm
//
//  Created by li shiyong on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCPlacemark.h"
#import "YCLib.h"
#import "IARecentAddressDataManager.h"

@implementation IARecentAddressDataManager

#define kRecentAddressFileName     @"recentAddress.plist"
#define kMaxNumberOfRecentAddress  200
/*
- (void)addObject:(id)object forKey:(NSString*)key{
    
    //删除重复的
    NSIndexSet *indexSetDuplicate = nil;
    indexSetDuplicate = [_all indexesOfObjectsPassingTest:^BOOL(NSDictionary *anDic, NSUInteger idx, BOOL *stop) {
        
        NSString *anKey = [[anDic allKeys] objectAtIndex:0];
        id anValue = [[anDic allValues] objectAtIndex:0];
        
        BOOL keyEqual = [anKey isEqualToString:key];
        BOOL valueEqual = NO; 
        
        //value是NSString和NSDictionary的情况要分开比较
        if ([object isKindOfClass:[NSString class]] && [anValue isKindOfClass:[NSString class]]) 
            valueEqual = [object isEqualToString:anValue];
        else if ([object isKindOfClass:[NSDictionary class]] && [anValue isKindOfClass:[NSDictionary class]]) 
            valueEqual = [object isEqualToDictionary:anValue];
        else 
            valueEqual = NO;
        
        if (keyEqual && valueEqual) 
            return YES;
        
        return NO;
    }];
    
    if (indexSetDuplicate && indexSetDuplicate.firstIndex != NSNotFound) 
        [_all removeObjectsAtIndexes:indexSetDuplicate];    
    
    //判断最大list数量限制
    if (_all.count >= kMaxNumberOfRecentAddress) 
        [_all removeLastObject];
    
    //加到列表
    NSDictionary *dic = [NSDictionary dictionaryWithObject:object forKey:key];
    [_all insertObject:dic atIndex:0];
    
    //保存到文件
    NSString *filePathName =  [[UIApplication sharedApplication].libraryDirectory stringByAppendingPathComponent:kRecentAddressFileName];
    [NSKeyedArchiver archiveRootObject:_all toFile:filePathName];
}
 */

- (void)addObject:(id)object forKey:(NSString*)key{
    
    @try {
        
        //删除重复的
        NSIndexSet *indexSetDuplicate = nil;
        indexSetDuplicate = [_all indexesOfObjectsPassingTest:^BOOL(YCPair *aPair, NSUInteger idx, BOOL *stop) {
            
            NSString *aKey = aPair.key;
            id aValue = aPair.value;
            
            BOOL keyEqual = [aKey isEqualToString:key];
            BOOL valueEqual = NO; 
            
            //value是NSString和NSDictionary的情况要分开比较
            if ([object isKindOfClass:[NSString class]] && [aValue isKindOfClass:[NSString class]]) 
                valueEqual = [object isEqualToString:aValue];
            else if ([object isKindOfClass:[NSDictionary class]] && [aValue isKindOfClass:[NSDictionary class]]) 
                valueEqual = [object isEqualToDictionary:aValue];
            else 
                valueEqual = NO;
            
            if (keyEqual && valueEqual) 
                return YES;
            
            return NO;
        }];
        
        if (indexSetDuplicate && indexSetDuplicate.firstIndex != NSNotFound) 
            [_all removeObjectsAtIndexes:indexSetDuplicate];    
        
        //判断最大list数量限制
        if (_all.count >= kMaxNumberOfRecentAddress) 
            [_all removeLastObject];
        
        //加到列表
        YCPair *pair = [YCPair pairWithValue:object forKey:key];
        [_all insertObject:pair atIndex:0];
        
        //保存到文件
        NSString *filePathName =  [[UIApplication sharedApplication].libraryDirectory stringByAppendingPathComponent:kRecentAddressFileName];
        [NSKeyedArchiver archiveRootObject:_all toFile:filePathName];
        
    }@catch (NSException *exception) {
        
        //如果出错了，重新做数据。原来的数据不要了。
        [_all release];
        _all = [[NSMutableArray array] retain];
        
    }
    
}

- (void)addPair:(YCPair*)aPair{
    id aValue = aPair.value;
    id aKey = aPair.key;
    [self addObject:aValue forKey:aKey];
}

- (void)removeAll{
    [_all removeAllObjects];
    
    @try {
        
        //保存到文件
        NSString *filePathName =  [[UIApplication sharedApplication].libraryDirectory stringByAppendingPathComponent:kRecentAddressFileName];
        [NSKeyedArchiver archiveRootObject:_all toFile:filePathName];
        
    }@catch (NSException *exception) {
        
    }
    
    
}

- (NSArray*)all{
    return [_all copy];
}

- (NSUInteger)allCount{
    return [_all count];
}


#pragma mark - mothed for single 

static IARecentAddressDataManager *single = nil;
+ (IARecentAddressDataManager*)sharedManager{
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
