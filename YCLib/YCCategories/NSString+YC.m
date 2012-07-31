//
//  NSString.m
//  iAlarm
//
//  Created by li shiyong on 11-2-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSString+YC.h"


@implementation NSString (YC)


-(NSString*)stringByTrim{

	NSString* des = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	//if([des length] == 0) return nil; 
	return des;
	 
}
 

-(NSString*)nameInFullFileName{
	NSArray *sArray = [self componentsSeparatedByString:@"."];
	
	NSString *name = @"";
	if (sArray.count >= 1) {
		name = [sArray objectAtIndex:0];
	}
	return name;
}

-(NSString*)typeInFullFileName{
	NSArray *sArray = [self componentsSeparatedByString:@"."];
	
	NSString *type = @"";
	if (sArray.count >= 2) {
		type = [sArray lastObject];
	}
	return type;
}

/*
 *🔔
 */
+ (NSString*)stringEmojiBell{
    NSString *string = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) 
        string = @"\U0001F514";
    else 
        string = @"\ue325";
    return string;
}

/*
 *🕘
 */
+ (NSString*)stringEmojiClockFaceNine{
    NSString *string = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) 
        string = @"\U0001F558";
    else 
        string = @"\ue02c";
    return string;
}


@end
