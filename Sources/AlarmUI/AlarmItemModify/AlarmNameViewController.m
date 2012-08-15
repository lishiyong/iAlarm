//
//  AlarmNameViewController.m
//  iArrived
//
//  Created by li shiyong on 10-10-19.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IAParam.h"
#import "YCLib.h"
#import "AlarmModifyTableViewController.h"
#import "IAAlarm.h"
#import "AlarmNameViewController.h"

@interface AlarmNameViewController ()

- (void)handleKeyboardDidShow:(id)aNotification;
- (void)registerNotifications;
- (void)unRegisterNotifications;

@end

@implementation AlarmNameViewController

@synthesize alarmNameTextField = _alarmNameTextField, alarmNameTextCell = _alarmNameTextCell;

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

-(IBAction)textFieldDoneEditing:(id)sender
{
	[self saveData];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = KViewTitleName;
    self.alarmNameTextField.placeholder = KAPTextPlaceholderName;
    self.alarmNameTextField.textColor = [UIColor tableCellBlueTextYCColor];
    //skin Style
    [self setSkinWithType:[IAParam sharedParam].skinType];
    
    //[self registerNotifications];

}

- (void)viewWillAppear:(BOOL)animated
{
    self.alarmNameTextField.text = self.alarm.alarmName;
    [self.alarmNameTextField becomeFirstResponder];  //调用键盘
}


- (void)viewDidUnload {
    [super viewDidUnload];
    //[self unRegisterNotifications];
	self.alarmNameTextField = nil;
    self.alarmNameTextCell = nil;
}


- (void)dealloc {
    //[self unRegisterNotifications];
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
    /*
    CGRect viewFrame = [self.tableView frame];
    return viewFrame.size.height/2 - self.alarmNameTextCell.bounds.size.height/2;
     */
    
    return 65.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @" "; //4.2前没这个不行
}

#pragma mark - Notification

- (void)handleKeyboardDidShow:(NSNotification*)aNotification{	
    
    /*
    NSDictionary* info = [aNotification userInfo];
    
    // Get the size of the keyboard.
    NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    // Resize the scroll view (which is the root view of the window)
    CGRect viewFrame = [self.tableView frame];
    viewFrame.size.height -= keyboardSize.height;
    self.tableView.frame = viewFrame;
    
    [self.tableView reloadData];
     */
    
}

- (void)registerNotifications {
	
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self
                           selector:@selector(handleKeyboardDidShow:)
                               name:UIKeyboardDidShowNotification object:nil];
/*
    [notificationCenter addObserver:self
                           selector:@selector(handleKeyboardDidHidden:)
                               name:UIKeyboardDidHideNotification object:nil];
 */
    
}

- (void)unRegisterNotifications {
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
	[notificationCenter removeObserver:self	name: UIKeyboardDidShowNotification object: nil];
	[notificationCenter removeObserver:self	name: UIKeyboardDidHideNotification object: nil];
}

@end
