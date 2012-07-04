//
//  facebookFeedViewController.m
//  TestShareApp
//
//  Created by li shiyong on 11-7-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "YCLib.h"
#import "YCShareAppNotifications.h"
#import "NSObject+YC.h"
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
@synthesize tableView ,peopleLabelCell, messageBodyCell, textView, contentImageView, clipImageView;

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

- (void)updatePeopleLabelCell{
    
    _peopleLabelCell.view0.hidden = YES;
	_peopleLabelCell.view1.hidden = YES;
	_peopleLabelCell.view2.hidden = YES;
	_peopleLabelCell.moreLabel.hidden = YES;
    
    NSArray *checkedPeopleArray = [YCFacebookGlobalData globalData].checkedPeopleArray;
	switch ([checkedPeopleArray count]) {
		case 0://0个元素，都隐藏起来
			break;
		case 1:
			_peopleLabelCell.view0.hidden = NO;			
			break;
		case 2:
			_peopleLabelCell.view0.hidden = NO;
			_peopleLabelCell.view1.hidden = NO;
			break;
		default: // >2
			_peopleLabelCell.view0.hidden = NO;
			_peopleLabelCell.view1.hidden = NO;
			_peopleLabelCell.moreLabel.hidden = NO;
			break;
	}
	
	
	for (NSInteger i = 0; i<2; i++) {
		if ((i+1)> [checkedPeopleArray count]) {
			break;
		}
		YCFacebookPeople *anPeople = [checkedPeopleArray objectAtIndex:i];
		
		switch (i) {
			case 0:
				_peopleLabelCell.imageView0.image = anPeople.pictureImage;
				_peopleLabelCell.label0.text = anPeople.localizedName;				
				break;
			case 1:
				_peopleLabelCell.imageView1.image = anPeople.pictureImage;
				_peopleLabelCell.label1.text = anPeople.localizedName;				
				break;
			default: 
				break;
		}
		
	}
	NSInteger moreNumber = [[[YCFacebookGlobalData globalData] checkedPeoples] count] - 2;
	NSString * s = [[[NSString alloc] initWithFormat:KTextPromptFBMore,moreNumber] autorelease];
	_peopleLabelCell.moreLabel.text = s;
    
}

- (id)peopleLabelCell{
    if (!_peopleLabelCell) {
        _peopleLabelCell = [PeoplesLabelCell viewWithXib];
		UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
		[button addTarget:self action:@selector(didSelectPeoplesLabelCell:) forControlEvents:UIControlEventTouchUpInside];
		_peopleLabelCell.accessoryView = button;
		_peopleLabelCell.sendToLabel.text = KLabelCellFBSendTo;
    }
    
    return _peopleLabelCell;
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
        publishParam = [[NSMutableDictionary dictionary] retain];
	}
    
    //先清空
    [publishParam removeAllObjects];
    
    NSString *message = self.textView.text;
    message = message ? message : @"";
    UIImage *picture = shareContent.image1;
    
    [publishParam setObject:message forKey:@"message"];
    if (picture) 
        [publishParam setObject:picture forKey:@"picture"];
    
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
		NSString *ss = [NSString stringWithFormat:@"%@/photos",s];
		if (anPeople == [YCFacebookGlobalData globalData].me) 
			ss = @"me/photos";
			
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
    self.navigationItem.rightBarButtonItem = self.shareButtonItem;
	self.navigationItem.leftBarButtonItem = self.cancelButtonItem;
    
    //tableView的阴影、颜色
    self.tableView.backgroundView.backgroundColor = [UIColor tableViewBackgroundViewBackgroundColor];
    self.tableView.leftShadowView.hidden = YES;
    self.tableView.rightShadowView.hidden = YES;
    self.tableView.topShadowView.bounds = (CGRect){{0,0},{320,20}};
    self.tableView.bottomShadowView.bounds = (CGRect){{0,0},{320,20}};
    
    //cell的颜色、阴影
    self.peopleLabelCell.backgroundView = [[[UIView alloc] initWithFrame:self.peopleLabelCell.bounds] autorelease];
    self.peopleLabelCell.backgroundView.backgroundColor = [UIColor whiteColor];
    self.messageBodyCell.backgroundView = [[[UIView alloc] initWithFrame:self.messageBodyCell.bounds] autorelease];
    self.messageBodyCell.backgroundView.backgroundColor = [UIColor colorWithIntRed:247 intGreen:247 intBlue:247 intAlpha:255];
    
    [self performBlock:^{ //后设置阴影，避免影响显示的时候的动画
        self.peopleLabelCell.layer.shadowOpacity = 0.3;
        self.peopleLabelCell.layer.shadowOffset = CGSizeMake(-4, -4);
        self.peopleLabelCell.layer.shadowColor = [UIColor blackColor].CGColor;
        self.peopleLabelCell.layer.shadowRadius = 3.0;
        
        self.messageBodyCell.layer.shadowOpacity = 0.3;
        self.messageBodyCell.layer.shadowOffset = CGSizeMake(-4, 4);
        self.messageBodyCell.layer.shadowColor = [UIColor blackColor].CGColor;
        self.messageBodyCell.layer.shadowRadius = 3.0;
        
    } afterDelay:0.5];
     
    
    NSArray *cells = [NSArray arrayWithObjects:self.peopleLabelCell, self.messageBodyCell, nil];    
    _sections = [[NSMutableArray arrayWithObjects:cells, nil] retain];
     
    
    //文本
    NSMutableString *text = [NSMutableString string];
    if (shareContent.message) 
        [text appendString:shareContent.message];
    if (shareContent.link1) {
        [text appendString:@"\n"];
        [text appendString:shareContent.link1];
    }
    self.textView.text = text;
    
    //image
    if (shareContent.image1) {
        
        if (shareContent.imageAutoSizeFit) {
            self.contentImageView.image = shareContent.image1;
        }else {
            //截取一部分显示
            CGRect imageRect = (CGRect){{0,0},shareContent.image1.size};
            CGPoint imageCenter = YCRectCenter(imageRect);
            CGRect newImageRect = YCRectMakeWithCenter(imageCenter, self.contentImageView.bounds.size);
            UIImage *newImage = [shareContent.image1 imageWithRect:newImageRect];
            self.contentImageView.image = newImage;
        }
        
        
        [self.contentImageView performBlock:^{
            self.contentImageView.layer.shadowOpacity = 0.4;
            self.contentImageView.layer.shadowOffset = CGSizeMake(1, 1);
            self.contentImageView.layer.shadowColor = [UIColor blackColor].CGColor;
            self.contentImageView.layer.shadowRadius = 2.0;
        } afterDelay:0.5];
        
        //文本让出图片的位置
        CGRect newBounds = CGRectInset(self.textView.bounds, 40, 0);
        self.textView.frame = (CGRect){self.textView.frame.origin,newBounds.size};
        
    }else {
        self.contentImageView.hidden = YES;
        self.clipImageView.hidden = YES;
    }
	

}



- (void)viewWillAppear:(BOOL)animated{
	
	self.navigationItem.titleView = nil;  //去掉进度条
	self.navigationItem.rightBarButtonItem.enabled = YES;	

	
	[self searchFBMe];

    [self updatePeopleLabelCell];
	[self.tableView reloadData];
	
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_sections count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_sections objectAtIndex:section] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[_sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}



#pragma mark -
#pragma mark Table view delegate


- (CGFloat)tableView:(UITableView *)theTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	switch (indexPath.row) {
		case 0:
			return 82.0;
			break;
		case 1:
			return 334.0;
			break;
		default:
			return 0; 
			break;
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

	[self updatePeopleLabelCell];
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
    [self updatePeopleLabelCell];
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
    
    self.fbPeoplePicker = nil;
    self.fbPeoplePickerNavController = nil;
    
    [searchParam release]; 
    searchParam = nil;
	[publishParam release]; 
    publishParam = nil;
    
    [_sections release];
    _sections = nil;
    self.messageBodyCell = nil;
    [_peopleLabelCell release];
    _peopleLabelCell = nil;
    self.textView = nil;
    self.contentImageView = nil;
    self.clipImageView = nil;
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
	 
	[fbPeoplePicker release];
	[fbPeoplePickerNavController release];
	
	[searchParam release]; 
	[publishParam release]; 
    
	[shareContent release]; 
	[facebookEngine release];
    
    [_sections release];
    [messageBodyCell release];
    [_peopleLabelCell release];
    [textView release];
    [contentImageView release];
    [clipImageView release];
    [super dealloc];
}


@end

