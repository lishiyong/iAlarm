//
//  IAAlarmSaveType.m
//  iAlarm
//
//  Created by li shiyong on 11-2-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IASaveInfo.h"

//
NSString *IASaveInfoKey = @"IASaveInfoKey";



@implementation IASaveInfo

@synthesize objId;
@synthesize saveType;


- (void)dealloc 
{
	[objId release];
	[super dealloc];
}

@end
