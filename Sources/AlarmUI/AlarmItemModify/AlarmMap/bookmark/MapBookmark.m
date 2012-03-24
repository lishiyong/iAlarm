//
//  MapBookmark.m
//  iAlarm
//
//  Created by li shiyong on 10-12-5.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapBookmark.h"


@implementation MapBookmark

@synthesize bookmarkName;
@synthesize annotation;


#pragma mark -
#pragma mark Memory management

- (void)dealloc 
{
	[self.bookmarkName release];
	//[self.annotation release];
    [super dealloc];
}

@end
