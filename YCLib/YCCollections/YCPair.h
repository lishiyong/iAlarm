//
//  YCPair.h
//  iAlarm
//
//  Created by li shiyong on 12-6-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCPair : NSObject<NSCoding, NSCopying>{
    NSDictionary *_dic;
}

- (id)value;
- (id)key;
- (id)initWithValue:(id)aValue forKey:(id)aKey;
+ (id)pairWithValue:(id)aValue forKey:(id)aKey;


@end
