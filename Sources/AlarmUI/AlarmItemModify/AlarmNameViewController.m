//
//  AlarmNameViewController.m
//  iArrived
//
//  Created by li shiyong on 10-10-19.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "YCLib.h"
#import "UIColor+YC.h"
#import "NSString+YC.h"
#import "AlarmModifyTableViewController.h"
#import "IAAlarm.h"
#import "AlarmNameViewController.h"


@implementation AlarmNameViewController

@synthesize alarmNameTextField = _alarmNameTextField, alarmNameTextCell = _alarmNameTextCell;

- (void)saveData{
    
	//闹钟名是否为空
	if ([self.alarmNameTextField.text length] != 0) {
		//手工改动了闹钟的名字
		if (![self.alarm.alarmName isEqualToString:self.alarmNameTextField.text])
		{
			self.alarm.nameChanged = YES;
			self.alarm.alarmName = self.alarmNameTextField.text;
		}
		
	}else {
        self.alarm.alarmName = nil;
        self.alarm.nameChanged = NO;
	} 
	
	
}

-(IBAction) textFieldDoneEditing:(id)sender
{
	[self saveData];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = KViewTitleName;
    self.alarmNameTextField.placeholder = @"如:什么地方就要到了";
    self.alarmNameTextField.textColor = [UIColor tableCellBlueTextYCColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.alarmNameTextField.text = self.alarm.alarmName;
    [self.alarmNameTextField becomeFirstResponder];  //调用键盘
}


- (void)viewDidUnload {
    [super viewDidUnload];
	self.alarmNameTextField = nil;
    self.alarmNameTextCell = nil;
}


- (void)dealloc {
	[_alarmNameTextField release];
    [_alarmNameTextCell release];
    [super dealloc];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.alarmNameTextCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 65.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @" "; //4.2前没这个不行
}

@end
