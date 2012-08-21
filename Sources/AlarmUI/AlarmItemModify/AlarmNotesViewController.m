//
//  AlarmDescriptionViewController.m
//  iAlarm
//
//  Created by li shiyong on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IAParam.h"
#import "YCLib.h"
#import "IAAlarm.h"
#import "AlarmModifyTableViewController.h"
#import "AlarmNotesViewController.h"


@implementation AlarmNotesViewController
@synthesize textView = _textView, textViewCell = _textViewCell;

- (void)setSkinWithType:(IASkinType)type{
    YCBarButtonItemStyle buttonItemStyle = YCBarButtonItemStyleDefault;
    YCTableViewBackgroundStyle tableViewBgStyle = YCTableViewBackgroundStyleDefault;
    YCBarStyle barStyle = YCBarStyleDefault;
    if (IASkinTypeDefault == type) {
        buttonItemStyle = YCBarButtonItemStyleDefault;
        tableViewBgStyle = YCTableViewBackgroundStyleDefault;
        barStyle = YCBarStyleDefault;
    }else {
        buttonItemStyle = YCBarButtonItemStyleSilver;
        tableViewBgStyle = YCTableViewBackgroundStyleSilver;
        barStyle = YCBarStyleSilver;
    }
    [self.tableView setYCBackgroundStyle:tableViewBgStyle];  
    [self.tableView reloadData];
}

- (void)saveData{
    self.alarm.notes = self.textView.text;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.title = KAPTitleNote;
	self.textView.textColor = [UIColor tableCellBlueTextYCColor];
	[self.textView becomeFirstResponder];  //调用键盘
	self.textView.enablesReturnKeyAutomatically = NO; 
	self.textView.font = [UIFont systemFontOfSize:19.0];
    self.textView.placeholder = KAPTextPlaceholderNote;
    
    //skin Style
    [self setSkinWithType:[IAParam sharedParam].skinType];

}

- (void)viewWillAppear:(BOOL)animated
{

	self.textView.text = self.alarm.notes;
	[self.view reloadInputViews];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.textView = nil;
    self.textViewCell = nil;
}


- (void)dealloc {
	[_textView release];
    [_textViewCell release];
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
    if (IASkinTypeDefault == [IAParam sharedParam].skinType) 
        self.textViewCell.backgroundColor = [UIColor iPhoneTableCellGroupedBackgroundColor];
    else 
        self.textViewCell.backgroundColor = [UIColor iPadTableCellGroupedBackgroundColor];
    return self.textViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.textViewCell.bounds.size.height;
}

@end
