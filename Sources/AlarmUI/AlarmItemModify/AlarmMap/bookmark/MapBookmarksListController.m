//
//  MapBookmarkListViewController.m
//  iAlarm
//
//  Created by li shiyong on 10-12-5.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapBookmarksListController.h"
#import "LocalizedString.h"
#import "MapBookmark.h"
#import <MapKit/MapKit.h>


@implementation MapBookmarksListController

@synthesize bookmarksList;
@synthesize delegate;

-(id)bookmarksList
{
	if (self->bookmarksList == nil) 
	{
		self->bookmarksList = [[NSMutableArray alloc] init];
	}
	return self->bookmarksList;
}

-(id)cancelButton
{
	if(cancelButton ==nil)
	{
		cancelButton = [[UIBarButtonItem alloc]
						  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
						  target:self 
						  action:@selector(doneButtonPressed:)];
		cancelButton.style = UIBarButtonItemStyleBordered;
	}
	return cancelButton;
}

-(IBAction)doneButtonPressed:(id)sender
{
	[delegate mapBookmarksListController:self didChooseMapBookmark:nil];
	[self.navigationController popViewControllerAnimated:YES];
}




#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad 
{
    [super viewDidLoad];
	self.navigationItem.leftBarButtonItem = self.cancelButton;
	self.title = KViewTitleMapBookmarks;
	self.navigationItem.prompt = KLabelMapBookmarksView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    return self.bookmarksList.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	MapBookmark *bookmark = (MapBookmark*)[self.bookmarksList objectAtIndex:indexPath.row];
	cell.textLabel.text = bookmark.bookmarkName;
	
	if ([bookmark.annotation isKindOfClass:[MKUserLocation class]]) 
	{ //当前位置
		cell.textLabel.textColor = [UIColor blueColor];
	}else {
		cell.textLabel.textColor = [UIColor blackColor];
	}

	
    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [delegate mapBookmarksListController:self didChooseMapBookmark:[self.bookmarksList objectAtIndex:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[self.cancelButton release];
	[self.bookmarksList release];
    [super dealloc];
}


@end

