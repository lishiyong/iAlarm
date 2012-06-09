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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [IARecentAddressManager sharedManager].allCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSDictionary *dic = [[IARecentAddressManager sharedManager].all objectAtIndex:0];
    NSString *key = [[dic allKeys] objectAtIndex:0];
    id value = [[dic allValues] objectAtIndex:0];
    
    NSString *titleString = nil;
    NSString *addressString = nil;
    if ([value isKindOfClass: [NSString class]]) {
        titleString = @"搜索：";
        addressString = [key stringByAppendingFormat:@"(%@)",value];
    }else{
        titleString = @"联系人：";
        NSString *stringValue = [ABCreateStringWithAddressDictionary(value,NO) stringByTrim];
        addressString = [key stringByAppendingFormat:@"(%@)",stringValue];
    }
    
    cell.textLabel.text = titleString;
    cell.detailTextLabel.text = addressString;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
