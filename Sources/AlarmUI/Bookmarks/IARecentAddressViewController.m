//
//  IARecentAddressViewController.m
//  TestABController
//
//  Created by li shiyong on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCLib.h"
#import <AddressBookUI/AddressBookUI.h>
#import "IARecentAddressManager.h"
#import "IARecentAddressViewController.h"

@implementation IARecentAddressViewController
@synthesize delegate = _delegate;

- (void)cancelButtonItemPressed:(id)sender{
    if ([_delegate respondsToSelector:@selector(recentAddressPickerNavigationControllerDidCancel:)]) {
        [_delegate recentAddressPickerNavigationControllerDidCancel:self];
    }
}

- (void)clearButtonItemPressed:(id)sender{
    UIActionSheet *sheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"清除所有最近搜索" otherButtonTitles:nil] autorelease];
    [sheet showInView:self.tableView];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if ([actionSheet cancelButtonIndex] == buttonIndex) {
        return;
    }
    
    [[IARecentAddressManager sharedManager] removeAll];
    [self.tableView reloadData];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"最近搜索";
    UIBarButtonItem *cancelButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonItemPressed:)] autorelease];
    
    UIBarButtonItem *clearButtonItem =  [[[UIBarButtonItem alloc] initWithTitle:@"清除" style:UIBarButtonItemStyleBordered target:self action:@selector(clearButtonItemPressed:)] autorelease];
    
    self.navigationItem.rightBarButtonItem = cancelButtonItem;
    self.navigationItem.leftBarButtonItem = clearButtonItem;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger rowCount = [IARecentAddressManager sharedManager].allCount;
    if (rowCount > 0) {
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }else{
        self.navigationItem.leftBarButtonItem.enabled = NO;
    }
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSDictionary *dic = [[IARecentAddressManager sharedManager].all objectAtIndex:indexPath.row];
    NSString *key = [[dic allKeys] objectAtIndex:0]; //查询串或人名
    id value = [[dic allValues] objectAtIndex:0]; //查询结果，字符串或dic
    
    NSString *titleString = nil;
    NSString *addressString = nil;
    if ([value isKindOfClass: [NSString class]]) {
        titleString = @"搜索：";
        addressString = [key stringByAppendingFormat:@" (%@)",value];
    }else{
        titleString = @"联系人：";
        NSString *stringValue = [ABCreateStringWithAddressDictionary(value,NO) stringByTrim];
        addressString = [key stringByAppendingFormat:@" (%@)",stringValue];
    }
    
    cell.textLabel.textColor = [UIColor tableCellGrayTextYCColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    cell.textLabel.text = titleString;
    
    cell.detailTextLabel.text = addressString;
    cell.detailTextLabel.textColor = [UIColor darkTextColor];
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:15];
    cell.detailTextLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([_delegate respondsToSelector:@selector(recentAddressPickerNavigationController:shouldContinueAfterSelectingRecentAddressData:)]) {
        NSDictionary *dic = [[IARecentAddressManager sharedManager].all objectAtIndex:indexPath.row];
        [_delegate recentAddressPickerNavigationController:self shouldContinueAfterSelectingRecentAddressData:dic];
    }
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return -3;
}

@end
