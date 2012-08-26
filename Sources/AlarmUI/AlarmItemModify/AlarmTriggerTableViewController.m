    //
//  AlarmTriggerTableViewController.m
//  iAlarm
//
//  Created by li shiyong on 11-6-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "UIUtility.h"
#import "YCPositionType.h"
#import "DicManager.h"
#import "AlarmTriggerTableViewController.h"
#import "IAAlarm.h"



@implementation AlarmTriggerTableViewController
@synthesize lastIndexPath;

//在整个tableView中indexPath的row在位置
-(NSInteger)gernarlRowInTableView:(UITableView *)tableView ForIndexPath:(NSIndexPath *)indexPath {
	NSInteger retVal =0;
	NSInteger section =  indexPath.section;
	for (int i =0; i < section; i++) {
		retVal += [tableView numberOfRowsInSection:i];
	}
	retVal += indexPath.row;
	return retVal;
}

//覆盖父类
- (void)saveData{	
	//YCSound *sound = [DicManager soundForSortId:lastIndexPath.row];
	NSInteger soundSortId = [self gernarlRowInTableView:self.tableView ForIndexPath:lastIndexPath];
	YCPositionType *triggerType = [DicManager positionTypeForSortId:soundSortId];
	self.alarm.positionType = triggerType;	
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = KViewTitleTrigger;
	//修改视图背景等
	[self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
	self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
	
}


- (void)viewWillAppear:(BOOL)animated{
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [DicManager positionTypeDictionary].count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	
	YCPositionType *triggerType = [DicManager positionTypeForSortId:indexPath.row];
	if (triggerType) {
		NSString *string = triggerType.positionTypeName;
		cell.textLabel.text = string;
		
		if ([triggerType.positionTypeId isEqualToString:self.alarm.positionType.positionTypeId]) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
			cell.textLabel.textColor = [UIUtility checkedCellTextColor];
			self.lastIndexPath = indexPath;
		}else {
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.textLabel.textColor = [UIUtility defaultCellTextColor];
		}
	}
	
	return cell;
	
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //int newRow = [indexPath row];
    //int oldRow = (lastIndexPath != nil) ? [lastIndexPath row] : -1;
	int newRow = [self gernarlRowInTableView:tableView ForIndexPath:indexPath];
	int oldRow = (lastIndexPath != nil) ? [self gernarlRowInTableView:tableView ForIndexPath:lastIndexPath] : -1;
    
    if (newRow != oldRow)
    {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
		newCell.textLabel.textColor = [UIUtility checkedCellTextColor];
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:lastIndexPath]; 
        oldCell.accessoryType = UITableViewCellAccessoryNone;
		oldCell.textLabel.textColor = [UIUtility defaultCellTextColor];
		self.lastIndexPath = indexPath;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	//done按钮可用
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	
}


- (void)dealloc {
	[lastIndexPath release];
    [super dealloc];
}


@end
