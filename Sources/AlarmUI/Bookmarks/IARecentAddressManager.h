//
//  IARecentAddressManager.h
//  iAlarm
//
//  Created by li shiyong on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YCPlacemark;
@interface IARecentAddressManager : NSObject{
    NSMutableArray *_all;
}

+ (IARecentAddressManager*)sharedManager;

- (void)addObject:(id)anObject forKey:(NSString*)key;
- (void)removeAll;
- (NSArray*)all;
- (NSUInteger)allCount;

@end
