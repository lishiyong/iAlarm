//
//  facebookFeedViewController.m
//  TestShareApp
//
//  Created by li shiyong on 11-7-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YCShareAppNotifications.h"
#import "NSObject-YC.h"
#import "YCShareContent.h"
#import "MessageBodyCell.h"
#import "YCBarButtonItem.h"
#import "YCFacebookPeoplePickerNavigationController.h"
#import "LocalizedString.h"
#import "LocalizedStringAbout.h"
#import "YCFacebookPeople.h"
#import "YCFacebookGlobalData.h"
#import "YCMaskView.h"
#import "PeoplesLabelCell.h"
#import "TableViewCellDescription.h"
#import "YCFacebookFeedViewController.h"


@implementation YCFacebookFeedViewController
@synthesize tableView;

@synthesize fbPeoplePicker;
@synthesize fbPeoplePickerNavController;

- (id)fbPeoplePicker{
	if (fbPeoplePicker == nil) {
		fbPeoplePicker = [[YCFacebookPeoplePickerNavigationController alloc] initWithNibName:@"YCFacebookPeoplePickerNavigationController" bundle:nil engine:facebookEngine pickerDelegate:self];	
	}
	return fbPeoplePicker;
}

- (id)fbPeoplePickerNavController{
	if (fbPeoplePickerNavController == nil) {
		fbPeoplePickerNavController = [[UINavigationController alloc] initWithRootViewController:self.fbPeoplePicker];	
	}
	return fbPeoplePickerNavController;
}

- (id)maskView{
	if (maskView == nil) {
		maskView = [[YCMaskView alloc] init];
	}
	return maskView;
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

- (id)shareButtonItem{
	
	if (!self->shareButtonItem) {
		self->shareButtonItem = [[UIBarButtonItem alloc] initWithTitle:kBtnShare 
																 style:UIBarButtonItemStyleDone
																target:self 
																action:@selector(doneButtonItemPressed:)];
		
	}
	
	return self->shareButtonItem;
}


@synthesize cellDescriptions;   
@synthesize peoplesLabelCellDescription;
@synthesize messageBodyCellDescription;

- (id)cellDescriptions{
	if (!self->cellDescriptions) {
		//第一组
		NSArray *oneArray = [NSArray arrayWithObjects:
							 self.peoplesLabelCellDescription,
							 self.messageBodyCellDescription,
							 nil];
		
		
		self->cellDescriptions = [NSArray arrayWithObjects:oneArray,nil];
		[self->cellDescriptions retain];
	}
	
	return self->cellDescriptions;
}

- (id)peoplesLabelCellDescription{
	
	//static NSString *CellIdentifier = @"messagesCell";
	
	if (!self->peoplesLabelCellDescription) {
		self->peoplesLabelCellDescription = [[TableViewCellDescription alloc] init];
		
		PeoplesLabelCell *cell = [PeoplesLabelCell viewWithXib];
		UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
		[button addTarget:self action:@selector(didSelectPeoplesLabelCell:) forControlEvents:UIControlEventTouchUpInside];
		cell.accessoryView = button;
		cell.sendToLabel.text = KLabelCellFBSendTo;
		
		self->peoplesLabelCellDescription.tableViewCell = cell;
		self->peoplesLabelCellDescription.didSelectCellSelector = @selector(didSelectPeoplesLabelCell:);
		
	}
	
	((PeoplesLabelCell*)self->peoplesLabelCellDescription.tableViewCell).view0.hidden = YES;
	((PeoplesLabelCell*)self->peoplesLabelCellDescription.tableViewCell).view1.hidden = YES;
	((PeoplesLabelCell*)self->peoplesLabelCellDescription.tableViewCell).view2.hidden = YES;
	((PeoplesLabelCell*)self->peoplesLabelCellDescription.tableViewCell).moreLabel.hidden = YES;
	
	/*
	NSArray *checkedPeopleArray = [YCFBData shareData].checkedPeopleArray;
	switch ([checkedPeopleArray count]) {
		case 0://0个元素，都隐藏起来
			break;
		case 1:
			((PeoplesLabelCell*)self->peoplesLabelCellDescription.tableViewCell).view0.hidden = NO;			
			break;
		case 2:
			((PeoplesLabelCell*)self->peoplesLabelCellDescription.tableViewCell).view0.hidden = NO;
			((PeoplesLabelCell*)self->peoplesLabelCellDescription.tableViewCell).view1.hidden = NO;
			break;
		default: // >=3
			((PeoplesLabelCell*)self->peoplesLabelCellDescription.tableViewCell).view0.hidden = NO;
			((PeoplesLabelCell*)self->peoplesLabelCellDescription.tableViewCell).view1.hidden = NO;
			((PeoplesLabelCell*)self->peoplesLabelCellDescription.tableViewCell).view2.hidden = NO;
			((PeoplesLabelCell*)self->peoplesLabelCellDescription.tableViewCell).moreLabel.hidden = NO;
			break;
	}
	
	
	for (NSInteger i = 0; i<3; i++) {
		if ((i+1)> [checkedPeopleArray count]) {
			break;
		}
		YCFBPeople *anPeople = [checkedPeopleArray objectAtIndex:i];
		
		switch (i) {
			case 0:
				((PeoplesLabelCell*)self->peoplesLabelCellDescription.tableViewCell).imageView0.image = anPeople.picture;
				((PeoplesLabelCell*)self->peoplesLabelCellDescription.tableViewCell).label0.text = anPeople.localizedName;				
				break;
			case 1:
				((PeoplesLabelCell*)self->peoplesLabelCellDescription.tableViewCell).imageView1.image = anPeople.picture;
				((PeoplesLabelCell*)self->peoplesLabelCellDescription.tableViewCell).label1.text = anPeople.localizedName;				
				break;
			case 2:
				((PeoplesLabelCell*)self->peoplesLabelCellDescription.tableViewCell).imageView2.image = anPeople.picture;
				((PeoplesLabelCell*)self->peoplesLabelCellDescription.tableViewCell).label2.text = anPeople.localizedName;				
				break;
			default: 
				break;
		}
		
	}
	 */
	
	NSArray *checkedPeopleArray = [YCFacebookGlobalData globalData].checkedPeopleArray;
	switch ([checkedPeopleArray count]) {
		case 0://0个元素，都隐藏起来
			break;
		case 1:
			((PeoplesLabelCell*)self->peoplesLabelCellDescription.tableViewCell).view0.hidden = NO;			
			break;
		case 2:
			((PeoplesLabelCell*)self->peoplesLabelCellDescription.tableViewCell).view0.hidden = NO;
			((PeoplesLabelCell*)self->peoplesLabelCellDescription.tableViewCell).view1.hidden = NO;
			break;
		default: // >2
			((PeoplesLabelCell*)self->peoplesLabelCellDescription.tableViewCell).view0.hidden = NO;
			((PeoplesLabelCell*)self->peoplesLabelCellDescription.tableViewCell).view1.hidden = NO;
			((PeoplesLabelCell*)self->peoplesLabelCellDescription.tableViewCell).moreLabel.hidden = NO;
			break;
	}
	
	
	for (NSInteger i = 0; i<2; i++) {
		if ((i+1)> [checkedPeopleArray count]) {
			break;
		}
		YCFacebookPeople *anPeople = [checkedPeopleArray objectAtIndex:i];
		
		switch (i) {
			case 0:
				((PeoplesLabelCell*)self->peoplesLabelCellDescription.tableViewCell).imageView0.image = anPeople.pictureImage;
				((PeoplesLabelCell*)self->peoplesLabelCellDescription.tableViewCell).label0.text = anPeople.localizedName;				
				break;
			case 1:
				((PeoplesLabelCell*)self->peoplesLabelCellDescription.tableViewCell).imageView1.image = anPeople.pictureImage;
				((PeoplesLabelCell*)self->peoplesLabelCellDescription.tableViewCell).label1.text = anPeople.localizedName;				
				break;
			default: 
				break;
		}
		
	}
	NSInteger moreNumber = [[[YCFacebookGlobalData globalData] checkedPeoples] count] - 2;
	NSString * s = [[[NSString alloc] initWithFormat:KTextPromptFBMore,moreNumber] autorelease];
	((PeoplesLabelCell*)self->peoplesLabelCellDescription.tableViewCell).moreLabel.text = s;
	
	return self->peoplesLabelCellDescription;
}


- (id)messageBodyCellDescription{
	
	if (!self->messageBodyCellDescription) {
		self->messageBodyCellDescription = [[TableViewCellDescription alloc] init];
		MessageBodyCell *cell = [MessageBodyCell viewWithXib];
		self->messageBodyCellDescription.tableViewCell = cell;
	}
	
	
	return self->messageBodyCellDescription;
}


- (id)progressView{
	if (progressView == nil) {
		progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
		CGFloat h = progressView.frame.size.height;
		progressView.frame = CGRectMake(0.0, 24.0, 106.0, h);
	}
	return progressView;
}

- (id)navTitleView{
	if (navTitleView == nil) {
		
		CGRect vframe = CGRectMake(0.0, 0.0, 106.0, 44.0);
		navTitleView = [[UIView alloc] initWithFrame:vframe];
		
		CGRect lframe = CGRectMake(0.0, 0.0, 106.0, 24.0);
		UILabel *lable = [[[UILabel alloc] initWithFrame:lframe] autorelease];
		lable.backgroundColor = [UIColor clearColor];
		lable.textAlignment = UITextAlignmentCenter;
		lable.textColor = [UIColor whiteColor];
		lable.font = [UIFont boldSystemFontOfSize:13.0];
		lable.shadowColor = [UIColor darkGrayColor];
		lable.shadowOffset = CGSizeMake(0.0, -1.0);
		lable.text = KTextPromptSending;
		
		[navTitleView addSubview:lable];
		[navTitleView addSubview:self.progressView];
	}
	return navTitleView;
}


- (id)searchParam{
	if (searchParam == nil) {
		searchParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
		 @"id,name,picture,gender", @"fields",nil];
		[searchParam retain];
	}
	return searchParam;
}

- (id)publishParam{
	if (publishParam == nil) {
		
		NSString *appCustomLink = KLinkCustomAppStore;
		NSString *appLink = KLinkAppStore;
		
		publishParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									   shareContent.mailMessage, @"message",
									   appLink, @"link",
									   KShareContentTextGetTheApp, @"name",
									   appCustomLink,@"caption",
									   shareContent.imageLinkFB,@"picture",
									   nil];
		
		[publishParam retain];
	}
	return publishParam;
}


#pragma mark -
#pragma mark Event

-(IBAction)cancelButtonItemPressed:(id)sender{
	sending = NO;
	[self dismissModalViewControllerAnimated:YES];
}

- (void)publishToWall{
	if (!sending) return; //点了取消按钮
	
	NSInteger count = [[YCFacebookGlobalData globalData].checkedPeoples count];
	CGFloat progressRate = 1.0/count; //每份的进度
	
	self.progressView.progress = publishI*progressRate;
	
	if (publishI < count) {
		
		YCFacebookPeople *anPeople = [[[YCFacebookGlobalData globalData].checkedPeoples allValues] objectAtIndex:publishI];
		NSString *s = anPeople.identifier;
		NSString *ss = [NSString stringWithFormat:@"%@/feed",s];
		if (anPeople == [YCFacebookGlobalData globalData].me) 
			ss = @"me/feed";
			
		//发布到涂鸦墙
		[facebookEngine requestWithGraphPath:ss
												  andParams:self.publishParam
											  andHttpMethod:@"POST"
												andDelegate:self];
		self.progressView.progress = self.progressView.progress + 0.5*progressRate;//进度先走一半
		publishI ++;
		
	}else {
		//发布结束
		sending = NO;
		self.progressView.progress = 1.0;
		if ([messageDelegate respondsToSelector:@selector(messageComposeYCViewController:didFinishWithResult:)]) {
			[messageDelegate messageComposeYCViewController:self didFinishWithResult:YES];
		}
	}


	
}

-(IBAction)doneButtonItemPressed:(id)sender{
	self.navigationItem.rightBarButtonItem.enabled = NO;	
	self.navigationItem.titleView = self.navTitleView;
	publishI = 0;
	sending = YES;
	[self publishToWall];
}


#pragma mark -
#pragma mark Cell Event

- (void)didSelectPeoplesLabelCell:(id)sender{
	[self presentModalViewController:self.fbPeoplePickerNavController animated:YES];
}

#pragma mark -
#pragma mark FB Execute
- (void)searchFBMe{
	//查询自己
	if (![YCFacebookGlobalData globalData].me) {
        [facebookEngine requestWithGraphPath:@"me" andParams: self.searchParam andDelegate:self];
		[self.maskView setHidden:NO];
        [self.maskView performSelector:@selector(setHidden:) withInteger:YES afterDelay:10];  //超时10秒
	}
}



#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = KViewTitleFBNewFeed;

	self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	self.tableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)] autorelease]; //为了不出现多余的格线
	self.tableView.tableFooterView.backgroundColor = [UIColor clearColor];
	self.tableView.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)] autorelease]; //为了不出现多余的格线
	
	self.navigationItem.rightBarButtonItem = self.shareButtonItem;
	self.navigationItem.leftBarButtonItem = self.cancelButtonItem;
	
	
	//分享的消息体
	MessageBodyCell *cell = (MessageBodyCell*)self.messageBodyCellDescription.tableViewCell;
	cell.textView.text = shareContent.mailMessage;
	cell.imageView.image = [UIImage imageNamed:shareContent.imageNameFB];
	

}



- (void)viewWillAppear:(BOOL)animated{
	
	self.navigationItem.titleView = nil;  //去掉进度条
	self.navigationItem.rightBarButtonItem.enabled = YES;	

	
	[self searchFBMe];

	[self.tableView reloadData];
	
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSArray *sectionArray = [self.cellDescriptions objectAtIndex:indexPath.section];
    UITableViewCell *cell = ((TableViewCellDescription*)[sectionArray objectAtIndex:indexPath.row]).tableViewCell;
    return cell;
}



#pragma mark -
#pragma mark Table view delegate


- (CGFloat)tableView:(UITableView *)theTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	switch (indexPath.row) {
		case 0:
			return self.peoplesLabelCellDescription.tableViewCell.frame.size.height;
			break;
		case 1:
			return self.messageBodyCellDescription.tableViewCell.frame.size.height;
			break;
		default:
			return 0; 
			break;
	}
	
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//取消行选中
	[theTableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSArray *sectionArray = [self.cellDescriptions objectAtIndex:indexPath.section];
	TableViewCellDescription *tableViewCellDescription= ((TableViewCellDescription*)[sectionArray objectAtIndex:indexPath.row]);
    SEL selector = tableViewCellDescription.didSelectCellSelector;
	if (selector) {
		[self performSelector:selector withObject:tableViewCellDescription.didSelectCellObject];
	}
	
}

#pragma mark -
#pragma mark FBSessionDelegate

- (void)fbDidLogin {
}

-(void)fbDidNotLogin:(BOOL)cancelled {
	if (cancelled) {
		[self dismissModalViewControllerAnimated:YES];
	}
}

- (void)fbDidLogout {
	
	[YCFacebookGlobalData globalData].me = nil;
	[[YCFacebookGlobalData globalData].friends removeAllObjects];
	[[YCFacebookGlobalData globalData].checkedPeoples removeAllObjects];
	
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark FBRequestDelegate

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
}

- (void)request:(FBRequest *)request didLoad:(id)result {
	
	if (![result isKindOfClass:[NSDictionary class]]) 
		return;
	
	if (self.publishParam == request.params) {//是发布到墙上的情况
		[self publishToWall];
		return;
	}
	
	//先清空
	[YCFacebookGlobalData globalData].me = nil;
	[YCFacebookGlobalData globalData].resultMe = result;
	
	[[YCFacebookGlobalData globalData] parseMe];
	
	if ([YCFacebookGlobalData globalData].me) {
		//缺省send to me
		[[YCFacebookGlobalData globalData].checkedPeoples setObject:[YCFacebookGlobalData globalData].me forKey:[YCFacebookGlobalData globalData].me.identifier];
        
        //存储用户名
        NSString *username = [YCFacebookGlobalData globalData].me.name;
        if ([facebookEngine.sessionDelegate respondsToSelector:@selector(storeAuthDataUsername:)]) {
            [facebookEngine.sessionDelegate storeAuthDataUsername:username];
        }
        
        
		//发送认证改变通知
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        NSNotification *aNotif = [NSNotification notificationWithName:YCShareAppAuthorizeDidChangeNotification object:self userInfo:nil];
        [notificationCenter performSelector:@selector(postNotification:) withObject:aNotif afterDelay:0.0];
	}

	
	[self.tableView reloadData];
	
	//打开fb的mask
	[self.maskView setHidden:YES];
	
	self.progressView.progress = 1.0;

}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	//打开fb的mask
	[self.maskView setHidden:YES];
    
	
	//NSLog(@"fb didFailWithError %@",error);
	
	//发布失败
	if (self.publishParam == request.params) {//是发布到墙上的情况
		sending = NO;
		self.progressView.progress = 0.0;
		if ([messageDelegate respondsToSelector:@selector(messageComposeYCViewController:didFinishWithResult:)]) {
			[messageDelegate messageComposeYCViewController:self didFinishWithResult:NO];
		}
	}
	 

}

#pragma mark -
#pragma mark YCFacebookPeoplePickerNavigationController

- (void)peoplePickerNavigationControllerDidDone:(YCFacebookPeoplePickerNavigationController *)peoplePicker checkedPeoples:(NSArray*)checkedPeoples{
	[self.tableView reloadData]; 
}

#pragma mark -
#pragma mark Memory management

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil engine:(Facebook*)theEngine messageDelegate:(id)theDategate shareData:(YCShareContent*)theShareData{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        facebookEngine = [theEngine retain];
        messageDelegate = theDategate;
        shareContent = [theShareData retain];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [cancelButtonItem release];
    cancelButtonItem = nil;
    [shareButtonItem release];
    shareButtonItem = nil;
    [progressView release];
    progressView = nil;
    [navTitleView release];
    navTitleView = nil;
    self.tableView = nil;
    
    self.cellDescriptions = nil;
    self.peoplesLabelCellDescription = nil;
    self.messageBodyCellDescription = nil;
    self.fbPeoplePicker = nil;
    self.fbPeoplePickerNavController = nil;
    
    [searchParam release]; 
    searchParam = nil;
	[publishParam release]; 
    publishParam = nil;
}


- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self.maskView];
	[self.maskView setHidden:YES]; //maskView释放前，先隐藏了，因为它在mainwindow上
	[maskView release];
	[cancelButtonItem release];
	[shareButtonItem release];
    [tableView release];
	[progressView release];
	[navTitleView release];
	
	[cellDescriptions release];
	[peoplesLabelCellDescription release];                 
	[messageBodyCellDescription release];  
	[fbPeoplePicker release];
	[fbPeoplePickerNavController release];
	
	[searchParam release]; 
	[publishParam release]; 
    
	[shareContent release]; 
	[facebookEngine release];
        
    [super dealloc];
}


@end

