//
//  AlarmLRepeatTypeViewController.m
//  iArrived
//
//  Created by li shiyong on 10-10-20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AlarmLRepeatTypeViewController.h"
#import "DicManager.h"
#import "YCRepeatType.h"
#import "UIUtility.h"
#import "IAAlarm.h"


@implementation AlarmLRepeatTypeViewController
@synthesize lastIndexPath;

//覆盖父类
-(IBAction)doneButtonPressed:(id)sender
{	
    NSLog(@"lastIndexPath.row = %d",self.lastIndexPath.row);
    
	YCRepeatType *rep = [DicManager repeatTypeForSortId:self.lastIndexPath.row];
	self.alarm.repeatType = rep;
	[self.navigationController popViewControllerAnimated:YES];
	
	[super doneButtonPressed:sender];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = KViewTitleRepeat;
	
	//修改视图背景等
	[self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
	self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [DicManager repeatTypeDictionary].count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
    // Configure the cell...
	YCRepeatType *rep = [DicManager repeatTypeForSortId:indexPath.row];
	if (rep) {
		NSString *repeatString = rep.repeatTypeName;
		cell.textLabel.text = repeatString;
		
		if ([rep.repeatTypeId compare:self.alarm.repeatType.repeatTypeId] == NSOrderedSame) {
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
    int newRow = [indexPath row];
    int oldRow = (lastIndexPath != nil) ? [lastIndexPath row] : -1;
    
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


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[lastIndexPath release];
    [super dealloc];
}


@end

