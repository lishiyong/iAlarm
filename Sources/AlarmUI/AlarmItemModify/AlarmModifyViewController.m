    //
//  AlarmModifyViewController.m
//  iArrived
//
//  Created by li shiyong on 10-10-20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AlarmModifyViewController.h"
#import "IAAlarm.h"



@implementation AlarmModifyViewController
@synthesize alarm = _alarm;

-(void)saveData{
    //
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil alarm:(IAAlarm*)theAlarm{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		_alarm = theAlarm;
		[_alarm retain];
	}
	return self;
}

-(id)initWithAlarm:(IAAlarm*)theAlarm{
	return [self initWithNibName:nil bundle:nil alarm:theAlarm];
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
	return [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil alarm:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[self saveData]; //其实会调用到子类的这个方法
}

- (void)dealloc {
	[_alarm release];
	_alarm = nil;
    [super dealloc];
}


@end
