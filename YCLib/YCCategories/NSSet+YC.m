//
//  NSSet+YC.m
//  iAlarm
//
//  Created by li shiyong on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSSet+YC.h"

@implementation NSSet (YC)

- (NSString *)description{
    NSMutableString *string = [NSMutableString stringWithCapacity:100];
    NSInteger count = self.count;
    NSInteger i = 0;
    
    [string appendString:@"\n{("];
    for (id obj in self) {
        [string appendString:@"\n"];
        [string appendString:@"  "];
        [string appendFormat:@"%@",[obj description]];
        
        if (i < (count-1)) 
            [string appendString:@","];
        i++;
    }
    
    [string appendString:@"\n)}"];
    return string;
}

@end
