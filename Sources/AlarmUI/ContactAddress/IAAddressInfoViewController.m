//
//  IAAddressInfoViewController.m
//  iAlarm
//
//  Created by li shiyong on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LocalizedString.h"
#import "YCLib.h"
#import "IAAlarm.h"
#import "IAPerson.h"
#import "IAAddressInfoViewController.h"

@implementation IAAddressInfoViewController
@synthesize saveAsPersonCell ;//= _saveAsPersonCell;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [self initWithStyle:style person:nil];
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style person:(IAPerson*)person{
    self = [super initWithStyle:style];
    if (self) {
        _person = [person retain]; 
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil person:(IAPerson*)person{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _person = [person retain]; 
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil alarm:(IAAlarm*)alarm{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _alarm = [alarm retain]; 
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
    
    self.title = @"";
    UIBarButtonItem *cancelButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonItemPressed:)] autorelease];
    self.navigationItem.rightBarButtonItem = cancelButtonItem;
    
    NSArray *cellsSaveAsPerson = [NSArray arrayWithObjects:self.saveAsPersonCell, nil];
    _sections = [[NSArray arrayWithObjects:cellsSaveAsPerson, nil] retain];

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
    return [_sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_sections objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UITableViewCell *cell = [[_sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
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

- (void)cancelButtonItemPressed:(id)sender{
    
    if ([self respondsToSelector:@selector(presentingViewController)]) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    }else{
        [self.parentViewController dismissModalViewControllerAnimated:YES];
    }
}

- (IBAction)saveAsPersonButtonPressed:(id)sender{
    UIActionSheet *sheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:KTitleCancel destructiveButtonTitle:nil otherButtonTitles:@"创建新联系人",@"添加到现有联系人",nil] autorelease];
    
    [sheet showInView:self.tableView];
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if ([actionSheet cancelButtonIndex] == buttonIndex) {
        return;
    }
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"创建新联系人"]) {
        
               
    }else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"添加到现有联系人"]) {
        
    }
    
}

@end
