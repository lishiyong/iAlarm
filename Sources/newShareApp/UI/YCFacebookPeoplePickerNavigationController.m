//
//  facebookContactsTableViewController.m
//  TestShareApp
//
//  Created by li shiyong on 11-8-2.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WaitingPromptCell.h"
#import "IconDownloader.h"
#import "YCBarButtonItem.h"
#import "YCFacebookGlobalData.h"
#import "YCMaskView.h"
#import "YCFacebookPeople.h"
#import "LocalizedStringShareApp.h"
#import "CheckPeopleCell.h"
#import "YCFacebookPeoplePickerNavigationController.h"

@interface YCFacebookPeoplePickerNavigationController ()

- (void)startIconDownload:(YCFacebookPeople *)people forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation YCFacebookPeoplePickerNavigationController
@synthesize tableView;
@synthesize imageDownloadsInProgress;


- (id)maleImage{
	if (maleImage == nil) {
		maleImage = [[UIImage imageNamed:@"male.gif"] retain];
	}
	return maleImage;
}
- (id)femaleImage{
	if (femaleImage == nil) {
		femaleImage = [[UIImage imageNamed:@"female.gif"] retain];
	}
	return femaleImage;
}

- (id)cancelButtonItem{
	
	if (!self->cancelButtonItem) {
		self->cancelButtonItem = [[UIBarButtonItem alloc]
								initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
								target:self
								action:@selector(cancelButtonItemPressed:)];
	}
	
	return self->cancelButtonItem;
}

- (id)doneButtonItem{
	
	if (!self->doneButtonItem) {
		self->doneButtonItem = [[UIBarButtonItem alloc]
								initWithBarButtonSystemItem:UIBarButtonSystemItemDone
								target:self
								action:@selector(doneButtonItemPressed:)];
	}
	
	return self->doneButtonItem;
}


- (id)checkedPeoples{
	if (checkedPeoples == nil) {
		checkedPeoples = [[NSMutableDictionary dictionary] retain];
	}
	return checkedPeoples;
}

- (id)waitingPromptCell{
	if (waitingPromptCell == nil) {
		waitingPromptCell = [[WaitingPromptCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	}
	return waitingPromptCell;
}

-(IBAction)cancelButtonItemPressed:(id)sender{
	[self dismissModalViewControllerAnimated:YES];
	if ([pickerDelegate respondsToSelector:@selector(peoplePickerNavigationControllerDidCancel:)]) {
		[pickerDelegate peoplePickerNavigationControllerDidCancel:self];
	}
}

-(IBAction)doneButtonItemPressed:(id)sender{
	[self dismissModalViewControllerAnimated:YES];
	
	//
	[[YCFacebookGlobalData globalData].checkedPeoples removeAllObjects];
	[[YCFacebookGlobalData globalData].checkedPeoples addEntriesFromDictionary:self.checkedPeoples];
	
	if ([pickerDelegate respondsToSelector:@selector(peoplePickerNavigationControllerDidDone:checkedPeoples:)]) {
		[pickerDelegate peoplePickerNavigationControllerDidDone:self checkedPeoples:[YCFacebookGlobalData globalData].checkedPeopleArray];
	}
}


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = KViewTitleAllFBFriends;
	self.tableView.rowHeight = 70.0;
	self.tableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)] autorelease]; //为了不出现多余的格线
	self.tableView.tableFooterView.backgroundColor = [UIColor clearColor];
	
	
	self.navigationItem.prompt = KViewPromptCheckContacts;
	self.navigationItem.rightBarButtonItem = self.doneButtonItem;
	self.navigationItem.leftBarButtonItem = self.cancelButtonItem;
	
	self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
	
	self.tableView.scrollsToTop = YES;

}


- (void)viewWillAppear:(BOOL)animated{
	
	[self.checkedPeoples removeAllObjects];
	[self.checkedPeoples addEntriesFromDictionary:[YCFacebookGlobalData globalData].checkedPeoples];
	
	[self.tableView reloadData];
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	//
    //return (([YCFBData shareData].me ? 1 : 0) + ([YCFBData shareData].friends ? 1 : 0)) ;
	return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	switch (section) {
		case 0:
			return [YCFacebookGlobalData globalData].me ? 1 : 0;
			break;
		case 1:
			return [[YCFacebookGlobalData globalData].friends count] + (allFriendDownloaded ? 0 : 1); //没下载完多一个等待cell
			break;
		default:
			return 0; 
			break;
	}
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	NSString *titleForHeader = nil; //各个段的头
	switch (section) {
		case 0:
			titleForHeader = KLabelSectionFBMyWell; 
			break;
		case 1:
			titleForHeader = KLabelSectionFBFriendsWall; 
			break;
		default:
			break;
	}
	
	return titleForHeader;
}



static int kDownloadFBFriendLimit = 50;
- (void)searchFBMeAndFriends{
	
	NSString *limit = [NSString stringWithFormat:@"%d",kDownloadFBFriendLimit];
	NSString *offset = [NSString stringWithFormat:@"%d",[[YCFacebookGlobalData globalData].friends count]];
	NSLog(@"offset = %@",offset);
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   @"id,name,picture,gender", @"fields"
								   ,limit, @"limit"       //一次取friend的数量
								   ,offset,@"offset"
								   ,nil];
	
	
	/*
	 //查询自己
	 if (![YCFBData shareData].me) {
	 
	 [[YCFBData shareData].facebook requestWithGraphPath:@"me" andParams:params andDelegate:self];
	 
	 }
	 */
	
	
	
	//查询friends
	//if ([[YCFBData shareData].friends count] == 0) 
	{
		downloading = YES;
        [facebookEngine requestWithGraphPath:@"me/friends" andParams:params andDelegate:self];
		
	}
	
	
}

/*
- (void)loadImageWithIndexPath:(NSIndexPath*)indexPath{
	NSLog(@"indexPath = %@",indexPath);
	NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows]; 
	if (NSNotFound != [visiblePaths indexOfObject:indexPath]) {
		NSLog(@"indexPath is visible %@",indexPath);

		YCFBPeople *anFriend = [[YCFBData shareData].friends objectAtIndex:indexPath.row];
		
		if (!anFriend.pictureImage) // avoid the app icon download if the app already has an icon
		{
			[self startIconDownload:anFriend forIndexPath:indexPath];
		}
	}

}
*/

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CheckContactsCell";
    
    CheckPeopleCell *cell = (CheckPeopleCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[CheckPeopleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	YCFacebookPeople *theContact = nil;
	switch (indexPath.section) {
		case 0:
			theContact = [YCFacebookGlobalData globalData].me;
			break;
		case 1:
			if (indexPath.row < [[YCFacebookGlobalData globalData].friends count]) {
				theContact = [[YCFacebookGlobalData globalData].friends objectAtIndex:indexPath.row]; 
			}else {
				if (indexPath.row == 0) {//第一次出现时候，不显示next xx friends
					if (!downloading){
						//self.waitingPromptCell.promptLabel.text = nil;
						self.waitingPromptCell.textLabel.text = nil;
						[self.waitingPromptCell.activityIndicatorView startAnimating];
						[self searchFBMeAndFriends];
					}
				}else {
					self.waitingPromptCell.textLabel.text = [NSString stringWithFormat:KTextPromptNextXXFriends,kDownloadFBFriendLimit];
					[self.waitingPromptCell.activityIndicatorView stopAnimating];
				}

				
				return self.waitingPromptCell;
			}

			break;
		default:
			break;
	}
	

    cell.identifier = theContact.identifier;
	cell.textLabel.text = theContact.localizedName;
	if ([self.checkedPeoples objectForKey:theContact.identifier]) {
		cell.checked = YES;		
	}else {
		cell.checked = NO;
	}
	
	
	// Only load cached images; defer new downloads until scrolling ends
	if (!theContact.pictureImage && indexPath.section != 0) //跳过me
	{
		if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
		{
			[self startIconDownload:theContact forIndexPath:indexPath];
		}

		// if a download is deferred or in progress, return a placeholder image
		cell.imageView.image = theContact.gender ? self.maleImage:self.femaleImage;               
	}
	else
	{
		cell.imageView.image = theContact.pictureImage;
	}
	
	
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)addOrRemoveContactFromTableView:(UITableView *)theTableView rowAtIndexPath:(NSIndexPath *)indexPath {
	YCFacebookPeople *theContact = nil;
	switch (indexPath.section) {
		case 0:
			theContact = [YCFacebookGlobalData globalData].me;
			break;
		case 1:
			theContact = [[YCFacebookGlobalData globalData].friends objectAtIndex:indexPath.row]; 
			break;
		default:
			break;
	}
	
	CheckPeopleCell *cell = (CheckPeopleCell*)[theTableView cellForRowAtIndexPath:indexPath];
	cell.checked = !cell.checked;
	if (cell.checked) 
		[self.checkedPeoples setObject:theContact forKey:theContact.identifier];
	else 
		[self.checkedPeoples removeObjectForKey:theContact.identifier];
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section ==1 && indexPath.row == [[YCFacebookGlobalData globalData].friends count]) {
		//跳过waiting cell
		return;
	}
	[self addOrRemoveContactFromTableView:theTableView rowAtIndexPath:indexPath];
	self.navigationItem.rightBarButtonItem.enabled = ([self.checkedPeoples count]==0) ? NO:YES;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
	self.navigationItem.rightBarButtonItem.enabled = ([self.checkedPeoples count]==0) ? NO:YES;
}


#pragma mark -
#pragma mark FBSessionDelegate

/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin {
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
	/*
    if (cancelled) {
		[self.parentViewController dismissModalViewControllerAnimated:YES];
		[self dismissModalViewControllerAnimated:YES];
	}
     */
    
    if (cancelled) {
        if ([self respondsToSelector:@selector(presentingViewController)]) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
        }else{
            [self.parentViewController dismissModalViewControllerAnimated:YES];
        }
	}
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
	
	[YCFacebookGlobalData globalData].me = nil;
	[[YCFacebookGlobalData globalData].friends removeAllObjects];
	[[YCFacebookGlobalData globalData].checkedPeoples removeAllObjects];
	
	[self.tableView reloadData];	
}

#pragma mark -
#pragma mark FBRequestDelegate

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
}

- (void)request:(FBRequest *)request didLoad:(id)result {
	
	downloading = NO;
		
	if (![result isKindOfClass:[NSDictionary class]]) 
		return;
	
	NSDictionary *resultDic = result;
	
	/*
	if ([resultDic count] != 1) {//me
	 
		[YCFBData shareData].resultMe = resultDic;
		[[YCFBData shareData] parseMe];
		
		if ([YCFBData shareData].me) {
			//缺省send to me
			[[YCFBData shareData].checkedPeoples setObject:[YCFBData shareData].me forKey:[YCFBData shareData].me.identifier];
		}
		
		[self.tableView reloadData];
		
	}else */{
			
		[YCFacebookGlobalData globalData].resultFriends = resultDic;
		[[YCFacebookGlobalData globalData] parseFriends];
		
		if ([[YCFacebookGlobalData globalData].resultFriendArray count] < kDownloadFBFriendLimit) { //一次取得的friend数量小于limit，就是取完了
			allFriendDownloaded = YES;
			
			//footer上显示一共有多少位朋友
			UILabel *footerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 70.0)] autorelease];//cell高70
			footerLabel.font = [UIFont systemFontOfSize:20.0];
			footerLabel.textColor = [UIColor grayColor];
			footerLabel.textAlignment = UITextAlignmentCenter;
			footerLabel.text = [NSString stringWithFormat:KTextPromptXXFriends,[[YCFacebookGlobalData globalData].friends count]];
			self.tableView.tableFooterView = footerLabel; 
		}
		

		[self.tableView reloadData];


	}


	
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	downloading = NO;
}


#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(YCFacebookPeople *)anPeople forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil) 
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.people = anPeople;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        [iconDownloader release];   
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
	if ([[YCFacebookGlobalData globalData].friends count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows]; 
        for (NSIndexPath *indexPath in visiblePaths)
        {
			if (0 == indexPath.section) continue; //跳过me
			if (indexPath.row >= [[YCFacebookGlobalData globalData].friends count]) continue; //跳过waitingcell
            YCFacebookPeople *anFriend = [[YCFacebookGlobalData globalData].friends objectAtIndex:indexPath.row];
            
            if (!anFriend.pictureImage) // avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:anFriend forIndexPath:indexPath];
            }
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        cell.imageView.image = iconDownloader.people.pictureImage;
    }
}

//继续下载朋友列表
- (void)continueDownLoadFriends{
	NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows]; 
	for (NSIndexPath *indexPath in visiblePaths)
	{
		if (0 == indexPath.section) continue; //跳过me
		if (indexPath.row == [[YCFacebookGlobalData globalData].friends count]){ //waitingcell
			if (!downloading) 
			{
				[self.waitingPromptCell.activityIndicatorView startAnimating];
				[self searchFBMeAndFriends];
			}
			break;
		}
	}
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
		[self continueDownLoadFriends];
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self continueDownLoadFriends];
    [self loadImagesForOnscreenRows];
}



#pragma mark -
#pragma mark Memory management

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil engine:(Facebook*)theEngine pickerDelegate:(id<YCFacebookPeoplePickerNavigationControllerDelegate>)theDategate;{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        facebookEngine = [theEngine retain];
        pickerDelegate = theDategate;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
}

- (void)viewDidUnload {
	self.tableView = nil;
}

- (void)dealloc {
	//停止下载头像
	NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];

	[cancelButtonItem release];
	[doneButtonItem release];
    [tableView release];
    [waitingPromptCell release];

	[checkedPeoples release];  
	[maleImage release];
	[femaleImage release];
	[imageDownloadsInProgress release];

    [facebookEngine release];
    [super dealloc];
}


@end

