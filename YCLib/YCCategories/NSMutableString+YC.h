//
//  NSMutableString+YC.h
//  iAlarm
//
//  Created by li shiyong on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (YC)

/**
 anAddress是西文(单字节)，而且self又不是以“空格”或“,”结束的，那么anAddress前加 separater
 **/
- (void)appendAddress:(NSString *)anAddress separater:(NSString*)separater;
- (void)appendAddress:(NSString *)anAddress;


@end
