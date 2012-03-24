//
//  TableViewCellDescription.m
//  iAlarm
//
//  Created by li shiyong on 10-12-20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TableViewCellDescription.h"


@implementation TableViewCellDescription
@synthesize tableViewCell;
@synthesize didSelectCellSelector;
@synthesize didSelectCellObject;
@synthesize accessoryButtonTappedSelector;
@synthesize accessoryButtonTappedObject;

- (void)dealloc {
	[didSelectCellObject release];
	[accessoryButtonTappedObject release];
	[tableViewCell release];
    [super dealloc];
}

@end
