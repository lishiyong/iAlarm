//
//  AlarmModifyTableViewController.m
//  iArrived
//
//  Created by li shiyong on 10-10-20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AlarmModifyTableViewController.h"
#import "IAAlarm.h"


@implementation AlarmModifyTableViewController

@synthesize alarm = _alarm;

- (void)saveData{
    //
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[self saveData]; //其实会调用到子类的这个方法
}

- (id)initWithStyle:(UITableViewStyle)style alarm:(IAAlarm*)theAlarm{
	if (self = [super initWithStyle:style]) {
		_alarm = theAlarm;
		[_alarm retain];
	}
	return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil alarm:(IAAlarm*)theAlarm{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		_alarm = theAlarm;
		[_alarm retain];
	}
	return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
	return [self initWithStyle:style alarm:nil];
}


- (void)dealloc {
	[_alarm release];
	_alarm = nil;
	
    [super dealloc];
}
 

@end

