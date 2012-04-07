//
//  YCGFunctions.c
//  iAlarm
//
//  Created by li shiyong on 12-4-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCGFunctions.h"

NSString* YCSerialCode(){
	NSUInteger x = arc4random()/100;
	NSString *s = [NSString stringWithFormat:@"%d", time(NULL)];
	NSString *ss = [NSString stringWithFormat:@"%@%d",s,x];
	
	return ss;
}