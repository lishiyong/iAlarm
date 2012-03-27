//
//  IAShareSettingViewController.m
//  iAlarm
//
//  Created by li shiyong on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCShareAppNotifications.h"
#import "UIUtility.h"
#import "YCSystemStatus.h"
#import "YCShareAppEngine.h"
#import "LocalizedStringAbout.h"
#import "TableViewCellDescription.h"
#import "IAShareSettingViewController.h"

@interface IAShareSettingViewController(private) 

- (UIButton*)makeSignButton; //产生一个登录登出按钮的实例。
- (void)setSignButton:(UIButton*)signButton forSignIn:(BOOL)isSignIn; //设置按钮为登录或为登出
- (void)registerNotifications;
- (void)unRegisterNotifications;

@end

@implementation IAShareSettingViewController
@synthesize cellDescriptions;
@synthesize facebookCellDescription;
@synthesize twitterCellDescription;
@synthesize kxCellDescription;


- (id)cellDescriptions{
	if (!self->cellDescriptions) {
        NSArray *oneArray = [NSArray arrayWithObjects:
							 self.twitterCellDescription
                             ,self.facebookCellDescription
							 ,nil];
        
		self->cellDescriptions = [NSArray arrayWithObjects:oneArray,nil];
		[self->cellDescriptions retain];
	}
    
    
	
	return self->cellDescriptions;
}


- (id)facebookCellDescription{
	
	static NSString *CellIdentifier = @"facebookCell";
	
	if (!self->facebookCellDescription) {
		self->facebookCellDescription = [[TableViewCellDescription alloc] init];
		
		//UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        cell.textLabel.text = KLabelCellFacebook;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"facebook-Icon-Small.png"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
		self->facebookCellDescription.tableViewCell = cell;
		
		cell.accessoryView = [self makeSignButton];
		
	}
    
    UIButton *button = (UIButton*)self->facebookCellDescription.tableViewCell.accessoryView;
    [self setSignButton:button forSignIn:!shareAppEngine.isFacebookAuthorized];
    self->facebookCellDescription.tableViewCell.detailTextLabel.text = shareAppEngine.isFacebookAuthorized ? shareAppEngine.facebookUserName : nil;
	
	return self->facebookCellDescription;
}




- (id)twitterCellDescription{
	
	static NSString *CellIdentifier = @"twitterCell";
	
	if (!self->twitterCellDescription) {
		self->twitterCellDescription = [[TableViewCellDescription alloc] init];
		
		//UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        cell.textLabel.text = KLabelCellTwitter;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"twitter-Icon-Small.png"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
		self->twitterCellDescription.tableViewCell = cell;
        
        cell.accessoryView = [self makeSignButton];
	}
    
    UIButton *button = (UIButton*)self->twitterCellDescription.tableViewCell.accessoryView;
    [self setSignButton:button forSignIn:!shareAppEngine.isTwitterAuthorized];
    self->twitterCellDescription.tableViewCell.detailTextLabel.text = shareAppEngine.isTwitterAuthorized ? shareAppEngine.twitterUserName : nil;
	
	return self->twitterCellDescription;
}

- (id)kxCellDescription{
	
	static NSString *CellIdentifier = @"kxCell";
	
	if (!self->kxCellDescription) {
		self->kxCellDescription = [[TableViewCellDescription alloc] init];
		
		//UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        cell.textLabel.text = @"开心网";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"kaixin-Icon-Small.png"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
		self->kxCellDescription.tableViewCell = cell;
		
		cell.accessoryView = [self makeSignButton];
		
	}
    
    UIButton *button = (UIButton*)self->kxCellDescription.tableViewCell.accessoryView;
    [self setSignButton:button forSignIn:!shareAppEngine.isKaixinAuthorized];
    self->kxCellDescription.tableViewCell.detailTextLabel.text = shareAppEngine.isKaixinAuthorized ? shareAppEngine.kaixinUserName : nil;
	
	return self->kxCellDescription;
}


#pragma mark - Utility

-(void)alertInternetWithTitle:(NSString*)title andBody:(NSString*)body{
	//检查网络
	BOOL connectedToInternet = [[YCSystemStatus deviceStatusSingleInstance] connectedToInternet];
	if (!connectedToInternet) {
		[UIUtility simpleAlertBody:body alertTitle:title cancelButtonTitle:kAlertBtnOK delegate:nil];
	}
}

- (void)signButtonPressed:(id)obj{
    
    UITableViewCell *theCell = (UITableViewCell*)[(UIView*)obj superview];
    UIButton *theButton = (UIButton*)theCell.accessoryView;
    BOOL isSigned = YES;
    
    if (theCell == self.twitterCellDescription.tableViewCell) {
        
        //检查是否登录过
        isSigned = shareAppEngine.isTwitterAuthorized;
        if (isSigned) {
            //登出
            [shareAppEngine removeAuthorizeTwitter];
        }else{
            //登录
            [shareAppEngine authorizeTwitter];
        }
        
    }else if(theCell == self.facebookCellDescription.tableViewCell){
        //检查是否登录过
        isSigned = shareAppEngine.isFacebookAuthorized;
        if (isSigned) {
            //登出
            [shareAppEngine removeAuthorizeFacebook];
        }else{
            //登录
            [shareAppEngine authorizeFacebook];
        }
        
        
    }else if(theCell == self.kxCellDescription.tableViewCell){
        
        
    }

    
    //////////////////////////
	//动画按钮转换
	[UIView beginAnimations:@"Button Change" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	UIViewAnimationTransition trType;
	if (isSigned) {
		trType = UIViewAnimationTransitionFlipFromRight;
	}else {
		trType = UIViewAnimationTransitionFlipFromLeft;
	}
	
	[UIView setAnimationTransition:trType forView:theButton cache:YES];
	[UIView commitAnimations];
    
}

- (UIButton*)makeSignButton{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 67, 32);
    
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button setTitle:@"Sign In" forState:UIControlStateNormal];
    button.titleLabel.font            = [UIFont boldSystemFontOfSize: 13];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.minimumFontSize = 10.0;
    button.titleLabel.shadowOffset    = CGSizeMake (0, -1);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIImage *imageNormal = [UIImage imageNamed:@"UINavigationBarDoneButton.png"];
    UIImage *newImageNormal = [imageNormal stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [button setBackgroundImage:newImageNormal forState:UIControlStateNormal];
    
    [button setBackgroundColor:[UIColor clearColor]];
    
    [button addTarget:self action:@selector(signButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}


- (void)setSignButton:(UIButton*)signButton forSignIn:(BOOL)isSignIn{
    
    UIImage *imageNormal = nil; 
    UIImage *imagePressed = nil;
    if (isSignIn){
        imageNormal = [UIImage imageNamed:@"UINavigationBarDoneButton.png"];
        imagePressed = [UIImage imageNamed:@"UINavigationBarDoneButtonPressed.png"];
        [signButton setTitle:@"Sign in" forState:UIControlStateNormal];
    }else{
        imageNormal = [UIImage imageNamed:@"UINavigationBarDefaultButton.png"];
        imagePressed = [UIImage imageNamed:@"UINavigationBarDefaultButtonPressed.png"];
        [signButton setTitle:@"Sign out" forState:UIControlStateNormal];
    }
    
    UIImage *newImageNormal = [imageNormal stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    UIImage *newImagePressed = [imageNormal stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [signButton setBackgroundImage:newImageNormal forState:UIControlStateNormal];
    [signButton setBackgroundImage:newImagePressed forState:UIControlStateHighlighted];
    
}

#pragma mark -
#pragma mark Notification

- (void) handle_shareAppAuthorizeDidChange:(id)notification{
    [self twitterCellDescription]; //访问一次更新数据
    [self facebookCellDescription];
    [self kxCellDescription];
    
    [self.tableView reloadData];
}



- (void)registerNotifications 
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver: self
                           selector: @selector (handle_shareAppAuthorizeDidChange:)
                               name: YCShareAppAuthorizeDidChangeNotification
                             object: nil];
}


- (void)unRegisterNotifications{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self	name: YCShareAppAuthorizeDidChangeNotification object: nil];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"共享设置";
    [self registerNotifications];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionArray = [self.cellDescriptions objectAtIndex:indexPath.section];
    UITableViewCell *cell = ((TableViewCellDescription*)[sectionArray objectAtIndex:indexPath.row]).tableViewCell;
    cell.backgroundColor = [UIColor whiteColor]; //SDK5.0 cell默认竟然是浅灰
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     return 50.0;
}
 
#pragma mark - memory manager

- (id)initWithStyle:(UITableViewStyle)style shareAppEngine:(YCShareAppEngine *)theShareAppEngine{
    self = [super initWithStyle:style];
    if(self){
        shareAppEngine = [theShareAppEngine retain];
    }
    return self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self unRegisterNotifications];
    self.cellDescriptions = nil;
    self.facebookCellDescription = nil;
    self.twitterCellDescription = nil;
    self.kxCellDescription = nil;
}

- (void)dealloc {
    [self unRegisterNotifications];
    [shareAppEngine release];
    
    [cellDescriptions release];
    [facebookCellDescription release];
    [twitterCellDescription release];
    [kxCellDescription release];
    [super dealloc];
}

@end
