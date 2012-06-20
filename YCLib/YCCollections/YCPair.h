//
//  YCPair.h
//  iAlarm
//
//  Created by li shiyong on 12-6-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSObject+YC.h"
#import <Foundation/Foundation.h>

@interface YCPair : NSObject<NSCoding, NSCopying>{
    NSDictionary *_dic;
}

- (id<YCObject>)value;
- (id<YCObject>)key;
- (id)initWithValue:(id)aValue forKey:(id)aKey;
+ (id)pairWithValue:(id)aValue forKey:(id)aKey;


@end
