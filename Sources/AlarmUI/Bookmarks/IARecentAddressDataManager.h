//
//  IARecentAddressManager.h
//  iAlarm
//
//  Created by li shiyong on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YCPair;
@interface IARecentAddressDataManager : NSObject{
    /**
     一个记录的内容是：YCPair.
     key有两种情况：     1，联系人的姓名(联系人姓名不存在，用@""代替)；2，搜索字符串。
     value对应两种情况： 1，联系人(IAPerson)；2，搜索后得到的格式化地址（多条结果，用@"..."）。
     **/
    NSMutableArray *_all;
}

+ (IARecentAddressDataManager*)sharedManager;

- (void)addPair:(YCPair*)aPair;
- (void)addObject:(id)object forKey:(NSString*)key;
- (void)removeAll;
- (NSArray*)all;
- (NSUInteger)allCount;

@end
