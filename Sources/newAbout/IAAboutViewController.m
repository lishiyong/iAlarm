//
//  IAAboutViewcontroller.m
//  iAlarm
//
//  Created by li shiyong on 12-3-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IANotifications.h"
#import "IAParam.h"
#import "YCLib.h"
#import "YCShareContent.h"
#import "IAGlobal.h"
#import "IAShareSettingViewController.h"
#import "IAFeedbackViewController.h"
#import "YCShareAppNotifications.h"
#import "SA_OAuthTwitterController.h"
#import "YCShareAppEngine.h"
#import "ShareAppConfig.h"
#import "YCSystemStatus.h"
#import "UIUtility.h"
#import "TableViewCellDescription.h"
#import "LocalizedStringAbout.h"
#import "LocalizedStringShareApp.h"
#import "IAAboutViewController.h"
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>

@interface IAAboutViewController(private) 

- (void)followOnTwitterByAfterIOS5ForUserName:(NSString*)userName;
- (void)followOnTwitterByAfterIOS5ForUserName:(NSString*)userName;

- (IBAction)cancelButtonItemPressed:(id)sender;
- (void)didSelectRateAndReviewCell:(id)sender; 
- (void)didSelectFollowUsOnTwitterCell:(id)sender; 
- (void)didSelectVisitUsOnFacebookCell:(id)sender;
- (void)didSelectShareAppCell:(id)sender;
- (void)didSelectFoundABugCell:(id)sender;
- (void)didSelectHasACoolIdeaCell:(id)sender;
- (void)didSelectSayHiCell:(id)sender;
- (void)didSelectSettingCell:(id)sender;
- (void)didSelectVersionCell:(id)sender;
- (void)didSelectBuyFullVersionCell:(id)sender;

- (id)cancelButtonItem;
- (id)shareAppEngine;
- (NSArray*)sectionHeaders;
- (NSArray*)sectionFooters;

- (id)rateAndReviewCell;
- (id)followUsOnTwitterCell;
- (id)visitUsOnFacebookCell;
- (id)shareAppCell;
- (id)foundABugCell;
- (id)hasACoolIdeaCell;
- (id)sayHiCell;
- (id)settingCell;
- (id)versionCell;
- (id)buyFullVersionCell;

- (void)registerNotifications;
- (void)unRegisterNotifications;

- (void)setSkinWithType:(IASkinType)type;

@end


@implementation IAAboutViewController

- (void)setSkinWithType:(IASkinType)type{
    
    YCBarButtonItemStyle buttonItemStyle = YCBarButtonItemStyleDefault;
    YCTableViewBackgroundStyle tableViewBgStyle = YCTableViewBackgroundStyleDefault;
    YCBarStyle barStyle = YCBarStyleDefault;
    UIColor *cellBackgroundColor = nil;
    if (IASkinTypeDefault == type) {
        buttonItemStyle = YCBarButtonItemStyleDefault;
        tableViewBgStyle = YCTableViewBackgroundStyleDefault;
        barStyle = YCBarStyleDefault;
        cellBackgroundColor = [UIColor iPhoneTableCellGroupedBackgroundColor];
    }else {
        buttonItemStyle = YCBarButtonItemStyleSilver;
        tableViewBgStyle = YCTableViewBackgroundStyleSilver;
        barStyle = YCBarStyleSilver;
        cellBackgroundColor = [UIColor iPadTableCellGroupedBackgroundColor];
    }
    [self.navigationController.navigationBar setYCBarStyle:barStyle];
    [self.tableView setYCBackgroundStyle:tableViewBgStyle];
    [self.cancelButtonItem setYCStyle:buttonItemStyle];
    [[self.tableView visibleCells] makeObjectsPerformSelector:@selector(setBackgroundColor:) withObject:cellBackgroundColor];
    [self.tableView reloadData];
}

#pragma mark - property

- (id)cancelButtonItem{
	
	if (!_cancelButtonItem) {
		_cancelButtonItem = [[UIBarButtonItem alloc]
								  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
								  target:self
								  action:@selector(cancelButtonItemPressed:)];
        _cancelButtonItem.style = UIBarButtonItemStyleBordered;
	}
	
	return _cancelButtonItem;
}

- (id)shareAppEngine{
	
	if (!_shareAppEngine) {
		_shareAppEngine = [[YCShareAppEngine alloc] initWithSuperViewController:self];
	}
	
	return _shareAppEngine;
}

- (id)rateAndReviewCell{
    if (_rateAndReviewCell == nil) {
		_rateAndReviewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rateAndReviewCell"];
		_rateAndReviewCell.textLabel.text = KLabelCellRateAndReview;
		_rateAndReviewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        //安上5颗星星	
        CGSize realTextSize = [KLabelCellRateAndReview sizeWithFont:[UIFont boldSystemFontOfSize:17.0]];
        
        UIImageView *starImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fiveStar.png"]] autorelease];//84*30;
        CGFloat x = 10.0 + realTextSize.width + 23.0 + starImageView.frame.size.width/2; //间隔23,Text从10开始
        starImageView.center = CGPointMake(x, 26.0);  //
        [_rateAndReviewCell addSubview:starImageView];
        
    }
    return _rateAndReviewCell;
}

- (id)followUsOnTwitterCell{
    if (_followUsOnTwitterCell == nil) {
        _followUsOnTwitterCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"followUsOnTwitterCell"];
        
        _followUsOnTwitterCell.textLabel.text = KLabelCellFollowUsOnTwitter;
		_followUsOnTwitterCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _followUsOnTwitterCell.imageView.image = [UIImage imageNamed:@"twitter-Icon-Small.png"];
    }
    return _followUsOnTwitterCell;
}

- (id)visitUsOnFacebookCell{
    if (_visitUsOnFacebookCell == nil) {
        _visitUsOnFacebookCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"visitUsOnFacebookCell"];
        
        _visitUsOnFacebookCell.textLabel.text = KLabelCellVisitUsOnFacebook;
		_visitUsOnFacebookCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _visitUsOnFacebookCell.imageView.image = [UIImage imageNamed:@"facebook-Icon-Small.png"];
    }
    return _visitUsOnFacebookCell;
}

- (id)shareAppCell{
    if (_shareAppCell == nil) {
        _shareAppCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shareAppCell"];
        
        _shareAppCell.textLabel.text = KLabelCellShareApp;
		_shareAppCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _shareAppCell.imageView.image = [UIImage imageNamed:@"tellFriends-Icon-Small.png"];
    }
    return _shareAppCell;
}

- (id)foundABugCell{
    if (_foundABugCell == nil) {
        _foundABugCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"foundABugCell"];
        
        _foundABugCell.textLabel.text = KLabelCellFoundABug;
		_foundABugCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _foundABugCell.imageView.image = [UIImage imageNamed:@"foundABug-Icon-Small.png"];
    }
    return _foundABugCell;
}

- (id)hasACoolIdeaCell{
    if (_hasACoolIdeaCell == nil) {
        _hasACoolIdeaCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hasACoolIdeaCell"];
        
        _hasACoolIdeaCell.textLabel.text = KLabelCellHasACoolIdea;
		_hasACoolIdeaCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _hasACoolIdeaCell.imageView.image = [UIImage imageNamed:@"hasACoolIdea-Icon-Small.png"];
    }
    return _hasACoolIdeaCell;
}

- (id)sayHiCell{
    if (_sayHiCell == nil) {
        _sayHiCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sayHiCell"];
        
        _sayHiCell.textLabel.text = KLabelCellSayHi;
		_sayHiCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _sayHiCell.imageView.image = [UIImage imageNamed:@"email-Icon-Small.png"];
    }
    return _sayHiCell;
}

- (id)settingCell{
    if (_settingCell == nil) {
        _settingCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingCell"];
        
        _settingCell.textLabel.text = KLabelCellSetting;
		_settingCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _settingCell.imageView.image = [UIImage imageNamed:@"setting-Icon-Small.png"];
    }
    return _settingCell;
}

- (id)versionCell{
    if (_versionCell == nil) {
        _versionCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"versionCell"];
        
        _versionCell.selectionStyle = UITableViewCellSelectionStyleNone;    //被选择后，无变化
        _versionCell.textLabel.text = KLabelCellVersion;
        _versionCell.imageView.image = [UIImage imageNamed:@"version-Icon-Small.png"];
        
        _versionCell.imageView.layer.cornerRadius = 5;
        _versionCell.imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _versionCell.imageView.layer.borderWidth = 1;
        
        NSString *appversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
		_versionCell.detailTextLabel.text = appversion;
    }
    return _versionCell;
}


- (id)buyFullVersionCell{
    if (_buyFullVersionCell == nil) {
        _buyFullVersionCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"buyFullVersionCell"];
        
        _buyFullVersionCell.textLabel.text = KLabelCellBuyFullVersion;
		_buyFullVersionCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _buyFullVersionCell.imageView.image = [UIImage imageNamed:@"setting-Icon-Small.png"];
    }
    return _buyFullVersionCell;
}

#pragma mark -

//下面的block需要回到主线程改变_promptView
- (void)promptViewOKAndCloseWithError:(NSError*)error{
    if (!error) 
        _promptView.promptViewStatus = YCPromptViewStatusOK;
    else 
        _promptView.promptViewStatus = YCPromptViewStatusFailture;
    
    [NSObject cancelPreviousPerformBlockRequestsWithTarget:_promptView];
    [_promptView performSelector:@selector(dismissAnimated:) withObject:(id)kCFBooleanTrue afterDelay:1.0];
}

- (void)followOnTwitterByAfterIOS5ForUserName:(NSString*)userName{
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    if (_promptView == nil) 
        _promptView = [[YCPromptView alloc] init];
    _promptView.promptViewStatus = YCPromptViewStatusWaiting;
    [_promptView show];
    [_promptView performSelector:@selector(dismissAnimated:) withObject:(id)kCFBooleanTrue afterDelay:10.0];//超时
    
    
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if(granted) {

            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
              
            if ([accountsArray count] > 0) {
                ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                
                NSMutableDictionary *tempDict = [[[NSMutableDictionary alloc] init] autorelease];
                [tempDict setValue:@"sortitapps" forKey:@"screen_name"];
                [tempDict setValue:@"true" forKey:@"follow"];
                
                TWRequest *postRequest = [[[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/friendships/create.format"] 
                                                             parameters:tempDict 
                                                          requestMethod:TWRequestMethodPOST] autorelease];
                
                
                [postRequest setAccount:twitterAccount];
                
                [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    [self performSelectorOnMainThread:@selector(promptViewOKAndCloseWithError:) withObject:error waitUntilDone:NO];
                }];
                
            }
        }else {
            [_promptView performSelectorOnMainThread:@selector(dismissAnimated:) withObject:(id)kCFBooleanTrue waitUntilDone:NO];
        }
    }];
    
}

- (void)followOnTwitterByBeforeIOS5ForUserName:(NSString*)userName{
    NSArray *urls = [NSArray arrayWithObjects:
                     @"twitter:@{username}", // Twitter
                     @"tweetbot:///user_profile/{username}", // TweetBot
                     @"echofon:///user_timeline?{username}", // Echofon              
                     @"twit:///user?screen_name={username}", // Twittelator Pro
                     @"x-seesmic://twitter_profile?twitter_screen_name={username}", // Seesmic
                     @"x-birdfeed://user?screen_name={username}", // Birdfeed
                     @"tweetings:///user?screen_name={username}", // Tweetings
                     @"simplytweet:?link=http://twitter.com/{username}", // SimplyTweet
                     @"icebird://user?screen_name={username}", // IceBird
                     @"fluttr://user/{username}", // Fluttr
                     /** uncomment if you don't have a special handling for no registered twitter clients */
                     //@"http://twitter.com/{username}", // Web fallback, 
                     nil];
    
    BOOL didOpenOtherApp = NO; 
    UIApplication *application = [UIApplication sharedApplication];
    for (NSString *candidate in urls) {
        candidate = [candidate stringByReplacingOccurrencesOfString:@"{username}" withString:userName];
        NSURL *url = [NSURL URLWithString:candidate];
        if ([application canOpenURL:url]) {
            [application openURL:url];
            didOpenOtherApp = YES;
            break;
        }
    }
    
    //没有客户端
    if (!didOpenOtherApp) {
        NSString *urlString  = [NSString stringWithFormat:@"https://twitter.com/%@", userName]; 
        [application openURL:[NSURL URLWithString:urlString]];
    }
}

#pragma mark - ViewControl Event Action

- (IBAction)cancelButtonItemPressed:(id)sender{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)didSelectRateAndReviewCell:(id)sender{
	[YCSystemStatus sharedSystemStatus].alreadyRate = YES;
    
	NSString *str = [NSString stringWithFormat: 
					 @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",kAppStoreAppID]; 
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
	
}

- (void)didSelectFollowUsOnTwitterCell:(id)sender{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) {        
        [self followOnTwitterByAfterIOS5ForUserName:kTwitterUserNameFollowed];
    }else {
        [self followOnTwitterByBeforeIOS5ForUserName:kTwitterUserNameFollowed];
    }
}

- (void)didSelectVisitUsOnFacebookCell:(id)sender{
    UIApplication *application = [UIApplication sharedApplication];
    NSString *urlString  = [NSString stringWithFormat:@"fb://page/%@",kFacebookIdFollowed];
    NSURL *url = [NSURL URLWithString:urlString];
    if ([application canOpenURL:url]) {
        [application openURL:url];
    }else{
        urlString  = [NSString stringWithFormat:@"http://www.facebook.com/profile.php?id=%@", kFacebookIdFollowed];
        url = [NSURL URLWithString:urlString];
        [application openURL:url];
    }
}

- (void)didSelectShareAppCell:(id)sender{
    NSString *title = KShareContentMailTitle;
    NSString *message = KShareContentMailMessage;
    NSString *messageTw = KShareContentTwitterMessage;
    NSString *link = KLinkCustomAppStore;
    UIImage *image = nil;
    
    YCShareContent *shareContent = [YCShareContent shareContentWithTitle:title message:message image:image];
    shareContent.link1 = link;
    shareContent.message1 = messageTw;
    
    [self.shareAppEngine shareAppWithContent:shareContent];
}

- (void)didSelectFoundABugCell:(id)sender{
    MFMailComposeViewController *picker = [[[MFMailComposeViewController alloc] init] autorelease];
	picker.mailComposeDelegate = self;
    
    //标题等
    [picker setToRecipients:[NSArray arrayWithObject:@"iAlarmABC@gmail.com"]];
	[picker setSubject:KLabelCellFoundABug];
    
    //内容
    NSString *deviceInfo=[[[NSString alloc]
                       initWithFormat:
                       @"localized model: %@ \nsystem version: %@ \nsystem name: %@ \nmodel: %@",
                       [[UIDevice currentDevice] localizedModel],
                       [[UIDevice currentDevice] systemVersion],
                       [[UIDevice currentDevice] systemName],
                       [[UIDevice currentDevice] model]] autorelease];
    
    NSString *messageBody = [NSString stringWithFormat:@"\n\n\n%@",deviceInfo];
    [picker setMessageBody:messageBody isHTML:NO];
    
    //附件
    NSString *path = [[[UIApplication sharedApplication] documentsDirectory] stringByAppendingPathComponent:@"alarms.plist"];
    NSData *attachData = [NSData dataWithContentsOfFile:path];
    if (attachData) 
        [picker addAttachmentData:attachData mimeType:@"xml/text" fileName:@""];
    
    
    
    if ([self.navigationController respondsToSelector:@selector(presentViewController:animated:completion:)]) 
        [self.navigationController presentViewController:picker animated:YES completion:NO];
    else 
        [self.navigationController presentModalViewController:picker animated:YES];
}

- (void)didSelectHasACoolIdeaCell:(id)sender{
    MFMailComposeViewController *picker = [[[MFMailComposeViewController alloc] init] autorelease];
	picker.mailComposeDelegate = self;

    [picker setToRecipients:[NSArray arrayWithObject:@"iAlarmABC@gmail.com"]];
	[picker setSubject:KLabelCellHasACoolIdea];
    
    if ([self.navigationController respondsToSelector:@selector(presentViewController:animated:completion:)]) 
        [self.navigationController presentViewController:picker animated:YES completion:NO];
    else 
        [self.navigationController presentModalViewController:picker animated:YES];
}

- (void)didSelectSayHiCell:(id)sender{
    MFMailComposeViewController *picker = [[[MFMailComposeViewController alloc] init] autorelease];
	picker.mailComposeDelegate = self;
    
    [picker setToRecipients:[NSArray arrayWithObject:@"iAlarmABC@gmail.com"]];
	[picker setSubject:@"Hi!"];
    
    if ([self.navigationController respondsToSelector:@selector(presentViewController:animated:completion:)]) 
        [self.navigationController presentViewController:picker animated:YES completion:NO];
    else 
        [self.navigationController presentModalViewController:picker animated:YES];
}

- (void)didSelectSettingCell:(id)sender{
    IAShareSettingViewController *viewCtler = [[[IAShareSettingViewController alloc] initWithStyle:UITableViewStyleGrouped shareAppEngine:self.shareAppEngine] autorelease];
    
	[self.navigationController pushViewController:viewCtler animated:YES];
}

- (void)didSelectBuyFullVersionCell:(id)sender{
    
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = KViewTitleAbout;
    self.navigationItem.leftBarButtonItem = self.cancelButtonItem;
    
    
    ///评分
    NSArray *rateAndReviewSection = [NSArray arrayWithObjects:self.rateAndReviewCell, nil];
    //tw跟随,fb关注,shareApp
    NSArray *followSection = [NSArray arrayWithObjects:self.followUsOnTwitterCell, self.visitUsOnFacebookCell, self.shareAppCell, nil];    
    //反馈
    NSArray *feedbackSection = [NSArray arrayWithObjects:self.foundABugCell, self.hasACoolIdeaCell, self.sayHiCell, nil]; 
    //其他
    NSArray *otherSection = [NSArray arrayWithObjects:self.settingCell, self.versionCell, nil];
    _sections = [[NSMutableArray arrayWithObjects:rateAndReviewSection, followSection, feedbackSection, otherSection, nil] retain];
    
    
    //cell响应的事件
    NSArray *rateAndReviewSelectors = [NSArray arrayWithObjects:[NSValue valueWithSelector:@selector(didSelectRateAndReviewCell:)], nil];
    NSArray *followSelectors = [NSArray arrayWithObjects:
                                  [NSValue valueWithSelector:@selector(didSelectFollowUsOnTwitterCell:)]
                                , [NSValue valueWithSelector:@selector(didSelectVisitUsOnFacebookCell:)]
                                , [NSValue valueWithSelector:@selector(didSelectShareAppCell:)]
                                , nil];
    NSArray *feedbackSelectors = [NSArray arrayWithObjects:
                                  [NSValue valueWithSelector:@selector(didSelectFoundABugCell:)]
                                , [NSValue valueWithSelector:@selector(didSelectHasACoolIdeaCell:)]
                                , [NSValue valueWithSelector:@selector(didSelectSayHiCell:)]
                                , nil];
    NSArray *otherSelectors = [NSArray arrayWithObjects:
                                 [NSValue valueWithSelector:@selector(didSelectSettingCell:)]
                               , [NSNull null]
                               , nil];
    _selectors = [[NSMutableArray arrayWithObjects:rateAndReviewSelectors, followSelectors, feedbackSelectors, otherSelectors, nil] retain];
    
    
    //section脚
    NSString *copyright = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"NSHumanReadableCopyright"];
    _sectionFooters = [[NSArray arrayWithObjects:
                       [NSNull null]
                       ,[NSNull null]
                       ,[NSNull null]
                       ,copyright
                       ,nil] retain];
    
    //skin Style
    [self setSkinWithType:[IAParam sharedParam].skinType];
    
    [self registerNotifications];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = KViewTitleAbout; 
    self.navigationController.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
    self.title = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_sections count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_sections objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[_sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if (IASkinTypeDefault == [IAParam sharedParam].skinType) 
        cell.backgroundColor = [UIColor iPhoneTableCellGroupedBackgroundColor];
    else 
        cell.backgroundColor = [UIColor iPadTableCellGroupedBackgroundColor];
    
    return cell;
}
 
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
	
	return ([_sectionFooters objectAtIndex:section] != [NSNull null]) ? [_sectionFooters objectAtIndex:section] : nil;
    
}
 
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//取消行选中
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSArray *sectionArray = [_selectors objectAtIndex:indexPath.section];
    NSValue *selObject = [sectionArray objectAtIndex:indexPath.row];
    
    if ([selObject isKindOfClass:[NSValue class]]) {
        SEL selector = [selObject selectorValue];
        [self performSelector:selector];
    }
}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
    NSString *soundFileName = nil;
	switch (result)
	{
		case MFMailComposeResultSent:
            soundFileName = @"Share-Complete.aif";
			break;
		case MFMailComposeResultFailed:
            soundFileName = @"Share-Error.aif";
			break;
		default:
			break;
	}
    
    if (soundFileName) {
        YCSoundPlayer *player = [[YCSoundPlayer soundPlayerWithSoundFileName:soundFileName] retain];
        [player performSelector:@selector(play) withObject:nil afterDelay:1.0];
        [player performSelector:@selector(release) withObject:nil afterDelay:5.0];//YCSoundPlayer播放完才能释放
    }
    
    if ([self.navigationController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    }else{
        [self.navigationController dismissModalViewControllerAnimated:YES];
    }
	
}

#pragma mark - Notification

- (void)IASkinStyleDidChange:(NSNotification*)notification{	
    //skin Style
    NSNumber *styleObj = [notification.userInfo objectForKey:IASkinStyleKey];
    [self setSkinWithType:[styleObj integerValue]];
}

- (void)registerNotifications{
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver: self
						   selector: @selector (IASkinStyleDidChange:)
							   name: IASkinStyleDidChange
							 object: nil];
}

- (void)unRegisterNotifications{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self	name: IASkinStyleDidChange object: nil];
}

#pragma mark - UINavigationControllerDelegate

- (void)navBarBackButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (viewController != self && viewController.navigationItem.leftBarButtonItem == nil) {
        YCBarButtonItemStyle barButtonItemStyle = YCBarButtonItemStyleDefault;
        if ([IAParam sharedParam].skinType == IASkinTypeDefault) {
            barButtonItemStyle = YCBarButtonItemStyleDefault;
        }else {
            barButtonItemStyle = YCBarButtonItemStyleSilver;
        }
        
        viewController.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initCustomBackButtonWithTitle:nil style:barButtonItemStyle target:self action:@selector(navBarBackButtonPressed:)] autorelease];
    }
}

#pragma mark - Memory management

- (void)viewDidUnload
{
    [super viewDidUnload]; 
    [self unRegisterNotifications];
    [_cancelButtonItem release]; _cancelButtonItem = nil;
    [_shareAppEngine release]; _shareAppEngine = nil;
    [_promptView release]; _promptView = nil;
    
    [_sections release]; _sections = nil;
    [_selectors release]; _selectors = nil;
    [_sectionFooters release]; _sectionFooters = nil;
    
    [_rateAndReviewCell release]; _rateAndReviewCell = nil;
    [_followUsOnTwitterCell release]; _followUsOnTwitterCell = nil;
    [_visitUsOnFacebookCell release]; _visitUsOnFacebookCell = nil;
    [_foundABugCell release]; _foundABugCell = nil;
    [_hasACoolIdeaCell release]; _hasACoolIdeaCell = nil;
    [_sayHiCell release]; _sayHiCell = nil;
    [_shareAppCell release]; _shareAppCell = nil;
    [_settingCell release]; _settingCell = nil;
    [_versionCell release]; _versionCell = nil;
    [_buyFullVersionCell release]; _buyFullVersionCell = nil;
}

- (void)dealloc {
    [self unRegisterNotifications];
    [_cancelButtonItem release];
    [_shareAppEngine release];
    [_promptView release];
    
    [_sections release];
    [_selectors release];
    [_sectionFooters release];
    
    [_rateAndReviewCell release];
    [_followUsOnTwitterCell release];
    [_visitUsOnFacebookCell release];
    [_foundABugCell release];
    [_hasACoolIdeaCell release];
    [_sayHiCell release];
    [_shareAppCell release];
    [_settingCell release];
    [_versionCell release];
    [_buyFullVersionCell release];
    [super dealloc];
}

@end
