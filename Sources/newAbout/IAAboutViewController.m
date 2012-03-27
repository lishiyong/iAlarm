//
//  IAAboutViewcontroller.m
//  iAlarm
//
//  Created by li shiyong on 12-3-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "IAShareSettingViewController.h"
#import "IAFeedbackViewController.h"
#import "YCShareAppNotifications.h"
#import "NSObject-YC.h"
#import "SA_OAuthTwitterController.h"
#import "YCShareAppEngine.h"
#import "ShareAppConfig.h"
#import "YCSystemStatus.h"
#import "UIUtility.h"
#import "NSString-YC.h"
#import "TableViewCellDescription.h"
#import "LocalizedStringAbout.h"
#import "IAAboutViewController.h"

@interface IAAboutViewController(private) 

- (void)addFiveStar;
- (void)registerNotifications;
- (void)unRegisterNotifications;
- (void)didSelectPullNavCell:(id)sender; //通用的cell选择
- (void) didSelectNavCell:(id)sender;//通用的cell选择

@end


@implementation IAAboutViewController

#pragma mark - property
@synthesize cellDescriptions;   
@synthesize rateAndReviewCellDescription;

@synthesize versionCellDescription;
@synthesize buyFullVersionCellDescription;
@synthesize feedbackCellDescription;
@synthesize shareAppCellDescription;
@synthesize shareSettingCellDescription; 
@synthesize followTwitterCellDescription; 
@synthesize followFacebookCellDescription; 

- (id)cancelButtonItem{
	
	if (!self->cancelButtonItem) {
		self->cancelButtonItem = [[UIBarButtonItem alloc]
								  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
								  target:self
								  action:@selector(cancelButtonItemPressed:)];
	}
	
	return self->cancelButtonItem;
}

- (id)shareAppEngine{
	
	if (!self->shareAppEngine) {
		self->shareAppEngine = [[YCShareAppEngine alloc] initWithSuperViewController:self];
	}
	
	return self->shareAppEngine;
}

- (NSArray*)sectionHeaders{
	NSArray *array = nil;
	
    array = [NSArray arrayWithObjects:
             KLabelSectionHeaderRateAndReview
             ,[NSNull null]
             ,[NSNull null]
             ,KLabelSectionHeaderShare
             ,KLabelSectionHeaderVersion
             ,nil];
	
	return array;
}

- (NSArray*)sectionFooters{
	NSArray *array = nil;
	
    NSString *copyright = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"NSHumanReadableCopyright"];
    
    array = [NSArray arrayWithObjects:
             [NSNull null]
             //,[NSNull null]
             //,[NSNull null]
             ,[NSNull null]
             ,copyright
             ,nil];
	
	return array;
}

- (id)cellDescriptions{
	if (!self->cellDescriptions) {
		
        /*
        NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
        NSArray* languages = [defs objectForKey:@"AppleLanguages"];
        NSString* preferredLang = [languages objectAtIndex:0];
        preferredLang = [preferredLang trim];
        BOOL isChina = NO;
        
        
        if ([preferredLang isEqualToString:@"zh-Hans"] || [preferredLang isEqualToString:@"zh-Hant"]) {
            isChina = YES;
        }
         */
        
        /*
		//第一组
		NSArray *oneArray = [NSArray arrayWithObjects:
							 self.rateAndReviewCellDescription
							 ,nil];
        
        NSArray *oneArray1 = [NSArray arrayWithObjects:
							 self.shareAppCellDescription
							 ,nil];
        NSArray *oneArray2 = [NSArray arrayWithObjects:
							 self.feedbackCellDescription
							 ,nil];
        
		//第二组
		NSMutableArray *twoArray = nil;	
        if (isChina) {
            twoArray = [NSMutableArray arrayWithObjects:
                        self.facebookCellDescription,
                        self.twitterCellDescription,
                        self.kxCellDescription,
                        nil];	
        }else{
            twoArray = [NSMutableArray arrayWithObjects:
                        self.facebookCellDescription,
                        self.twitterCellDescription,
                        nil];
        }
        
        
		//第三组
		NSArray *threeArray = [NSArray arrayWithObjects:
                               self.versionCellDescription
                               ,nil];
#ifndef FULL_VERSION
		
		YCParam *param = [YCParam paramSingleInstance];
		if (!param.isProUpgradePurchased) {
			threeArray = [NSArray arrayWithObjects:
						  self.versionCellDescription
						  ,self.buyFullVersionCellDescription
						  ,nil];
		}
		
#endif
         */
        
        NSArray *oneArray = [NSArray arrayWithObjects:
							 self.rateAndReviewCellDescription
							 ,nil];
        
        
        
        NSMutableArray *twoArray  = [NSArray arrayWithObjects:
                                    self.followTwitterCellDescription
                                    ,self.followFacebookCellDescription
                                    ,nil];
        
        NSMutableArray *threeArray = [NSArray arrayWithObjects:
                                      self.shareAppCellDescription
                                      ,self.feedbackCellDescription
                                      ,self.shareSettingCellDescription
                                      ,self.versionCellDescription
                                      ,nil];
        
        
        
		self->cellDescriptions = [NSArray arrayWithObjects:oneArray,twoArray,threeArray,nil];
		[self->cellDescriptions retain];
	}
         
    
	
	return self->cellDescriptions;
}

- (id)rateAndReviewCellDescription{
	
	static NSString *CellIdentifier = @"rateAndReviewCell";
	
	if (!self->rateAndReviewCellDescription) {
		self->rateAndReviewCellDescription = [[TableViewCellDescription alloc] init];
		
		UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.textLabel.text = KLabelCellRateAndReview;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		self->rateAndReviewCellDescription.tableViewCell = cell;
		self->rateAndReviewCellDescription.didSelectCellSelector = @selector(didSelectRateAndReviewCell:);
		
		//安上5颗星星，cell.textLabel.frame在下次才变化		
		[self performSelector:@selector(addFiveStar) withObject:nil afterDelay:0.25];
	}
	
	return self->rateAndReviewCellDescription;
}

- (id)versionCellDescription{
	
	static NSString *CellIdentifier = @"versionCell";
	
	if (!self->versionCellDescription) {
		self->versionCellDescription = [[TableViewCellDescription alloc] init];
		
		UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;    //被选择后，无变化
        cell.textLabel.text = KLabelCellVersion;
		NSString *appversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
		cell.detailTextLabel.text = appversion;
        cell.imageView.image = [UIImage imageNamed:@"version-Icon-Small.png"];
		self->versionCellDescription.tableViewCell = cell;
		
		self->versionCellDescription.didSelectCellSelector = NULL;
		
	}
	
	return self->versionCellDescription;
}

- (id)buyFullVersionCellDescription{
	
	static NSString *CellIdentifier = @"versionCell";
	
	if (!self->buyFullVersionCellDescription) {
		self->buyFullVersionCellDescription = [[TableViewCellDescription alloc] init];
		
		UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.textLabel.text = KLabelCellBuyFullVersion;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		self->buyFullVersionCellDescription.tableViewCell = cell;
		
		self->buyFullVersionCellDescription.didSelectCellSelector = @selector(didSelectBuyFullVersionCell:);
		
	}
	
	return self->buyFullVersionCellDescription;
}

- (id)feedbackCellDescription{
	
	static NSString *CellIdentifier = @"backfeedCell";
	
	if (!self->feedbackCellDescription) {
		self->feedbackCellDescription = [[TableViewCellDescription alloc] init];
		
		UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.textLabel.text = @"反馈";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"feedback-Icon-Small.png"];
		self->feedbackCellDescription.tableViewCell = cell;
		
		self->feedbackCellDescription.didSelectCellSelector = @selector(didSelectPullNavCell:);        
        IAFeedbackViewController *viewCtler = [[[IAFeedbackViewController alloc] initWithStyle:UITableViewStyleGrouped messageDelegate:self] autorelease];
		self->feedbackCellDescription.didSelectCellObject = viewCtler;
		
	}
	
	return self->feedbackCellDescription;
}

- (id)shareAppCellDescription{
	
	static NSString *CellIdentifier = @"shareAppCell";
	
	if (!self->shareAppCellDescription) {
		self->shareAppCellDescription = [[TableViewCellDescription alloc] init];
		
		UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.textLabel.text = @"告诉朋友";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"tellFriends-Icon-Small.png"];
		self->shareAppCellDescription.tableViewCell = cell;
		
		self->shareAppCellDescription.didSelectCellSelector = @selector(didSelectShareAppCell:);
		
	}
	
	return self->shareAppCellDescription;
}

- (id)shareSettingCellDescription{
	
	static NSString *CellIdentifier = @"shareSettingCell";
	
	if (!self->shareSettingCellDescription) {
		self->shareSettingCellDescription = [[TableViewCellDescription alloc] init];
		
		UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.textLabel.text = @"共享设置";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"setting-Icon-Small.png"];
		self->shareSettingCellDescription.tableViewCell = cell;
		
		self->shareSettingCellDescription.didSelectCellSelector = @selector(didSelectNavCell:);
        
		IAShareSettingViewController *viewCtler = [[[IAShareSettingViewController alloc] initWithStyle:UITableViewStyleGrouped shareAppEngine:self.shareAppEngine] autorelease];
		self->shareSettingCellDescription.didSelectCellObject = viewCtler;
         
	}
	
	return self->shareSettingCellDescription;
}

- (id)followTwitterCellDescription{
	
	static NSString *CellIdentifier = @"followTwitterCell";
	
	if (!self->followTwitterCellDescription) {
		self->followTwitterCellDescription = [[TableViewCellDescription alloc] init];
		
		UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.textLabel.text = @"在Twitter上关注";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"twitter-Icon-Small.png"];
		self->followTwitterCellDescription.tableViewCell = cell;
        //self->followTwitterCellDescription.didSelectCellSelector = @selector(didSelectNavCell:);
	}
	
	return self->followTwitterCellDescription;
}

- (id)followFacebookCellDescription{
	
	static NSString *CellIdentifier = @"followFacebookCell";
	
	if (!self->followFacebookCellDescription) {
		self->followFacebookCellDescription = [[TableViewCellDescription alloc] init];
		
		UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.textLabel.text = @"在Facebook上关注";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"facebook-Icon-Small.png"];
		self->followFacebookCellDescription.tableViewCell = cell;
        //self->followFacebookCellDescription.didSelectCellSelector = @selector(didSelectNavCell:);
	}
	
	return self->followFacebookCellDescription;
}

#pragma mark - Utility

- (void)addFiveStar{
	UIImageView *starImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fiveStar.png"]] autorelease];//84*30;
	
	UITableViewCell *cell = self->rateAndReviewCellDescription.tableViewCell;
	UILabel *textLabel = cell.textLabel; 
	CGRect textRect = [textLabel textRectForBounds:textLabel.frame limitedToNumberOfLines:1];
	
	CGFloat x = textLabel.frame.origin.x + textRect.size.width + 23.0 + starImageView.frame.size.width/2;
	starImageView.center = CGPointMake(x, 26.0);
	
	[cell addSubview:starImageView];
}


-(void)alertInternetWithTitle:(NSString*)title andBody:(NSString*)body{
	//检查网络
	BOOL connectedToInternet = [[YCSystemStatus deviceStatusSingleInstance] connectedToInternet];
	if (!connectedToInternet) {
		[UIUtility simpleAlertBody:body alertTitle:title cancelButtonTitle:kAlertBtnOK delegate:nil];
	}
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



#pragma mark - ViewControl Event Action

-(IBAction)cancelButtonItemPressed:(id)sender{
	[self dismissModalViewControllerAnimated:YES];
}


- (void)didSelectRateAndReviewCell:(id)sender{
	[YCSystemStatus deviceStatusSingleInstance].alreadyRate = YES;
    
	NSString *str = [NSString stringWithFormat: 
					 @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",kAppStoreAppID]; 
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
	
}

- (void) didSelectPullNavCell:(id)sender{
	UIViewController *detailController1 = (UIViewController*)sender;
    UINavigationController *detailNavigationController1 = [[[UINavigationController alloc] initWithRootViewController:detailController1] autorelease];
	[self presentModalViewController:detailNavigationController1 animated:YES];
}

- (void) didSelectNavCell:(id)sender{
	UIViewController *navToViewController = (UIViewController*)sender;	
	[self.navigationController pushViewController:navToViewController animated:YES];
}

- (void)didSelectShareAppCell:(id)sender{
	[self.shareAppEngine shareApp];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.navigationItem.leftBarButtonItem = self.cancelButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellDescriptions.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	NSArray *sectionArray = [self.cellDescriptions objectAtIndex:section];
	return sectionArray.count;	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSArray *sectionArray = [self.cellDescriptions objectAtIndex:indexPath.section];
    UITableViewCell *cell = ((TableViewCellDescription*)[sectionArray objectAtIndex:indexPath.row]).tableViewCell;
    cell.backgroundColor = [UIColor whiteColor]; //SDK5.0 cell默认竟然是浅灰
    return cell;
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return ([[self sectionHeaders] objectAtIndex:section] != [NSNull null]) ? [[self sectionHeaders] objectAtIndex:section] : nil;
    
}
*/
 
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
	
	return ([[self sectionFooters] objectAtIndex:section] != [NSNull null]) ? [[self sectionFooters] objectAtIndex:section] : nil;
    
}
 

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//取消行选中
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSArray *sectionArray = [self.cellDescriptions objectAtIndex:indexPath.section];
	TableViewCellDescription *tableViewCellDescription= ((TableViewCellDescription*)[sectionArray objectAtIndex:indexPath.row]);
    SEL selector = tableViewCellDescription.didSelectCellSelector;
	if (selector) {
		[self performSelector:selector withObject:tableViewCellDescription.didSelectCellObject];
	}
	
}

#pragma mark YCMessageComposeControllerDelegate 

- (void)messageComposeYCViewController:(UIViewController *)controller didFinishWithResult:(BOOL)result{
    if ([self respondsToSelector:@selector(presentedViewController)]) { //5.0后才有这个 presentedViewController
        if (self.presentedViewController) {
            [self performSelector:@selector(dismissModalViewControllerAnimated:) withInteger:YES afterDelay:0.75];
        }
    }else{
        if (self.modalViewController) {
            [self performSelector:@selector(dismissModalViewControllerAnimated:) withInteger:YES afterDelay:0.75];
        }
    }
}


#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];    
    [cancelButtonItem release];
    cancelButtonItem = nil;
    [shareAppEngine release];
    shareAppEngine = nil;
    
    self.cellDescriptions = nil;
    self.rateAndReviewCellDescription = nil;
    self.versionCellDescription = nil;
    self.buyFullVersionCellDescription = nil;
    self.feedbackCellDescription = nil;
    self.shareAppCellDescription = nil;
    self.shareSettingCellDescription = nil;
    self.followTwitterCellDescription = nil;
    self.followFacebookCellDescription = nil;
}

- (void)dealloc {
    [cancelButtonItem release];
    [shareAppEngine release];
    
    [cellDescriptions release];
    [rateAndReviewCellDescription release];
    [versionCellDescription release];
    [buyFullVersionCellDescription release];
    [feedbackCellDescription release];
    [shareAppCellDescription release];
    [shareSettingCellDescription release];
    [followTwitterCellDescription release];
    [followFacebookCellDescription release];
    
    [super dealloc];
}

@end
