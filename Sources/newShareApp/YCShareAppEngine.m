//
//  YCShareApp.m
//  iAlarm
//
//  Created by li shiyong on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "YCShareContent.h"
#import "YCTwitterTweetViewController.h"
#import "YCFacebookFeedViewController.h"
#import "YCShareAppNotifications.h"
#import "NSObject+YC.h"
#import "UIUtility.h"
#import "YCSystemStatus.h"
#import "LocalizedStringAbout.h"
#import "Facebook.h"
#import "YCFacebookPeople.h"
#import "YCFacebookGlobalData.h"
#import "SA_OAuthTwitterController.h"
#import "SA_OAuthTwitterEngine.h"
#import "YCSoundPlayer.h"
#import "YCShareAppEngine.h"

#define kOAuthConsumerKey_TW		@"lUbvIKxdi2c6SleoH3z5Q"		                 
#define kOAuthConsumerSecret_TW		@"wfgabezePb6VEJFcKir63UiH58MaGiS4lwIK48IE"		
static NSString* kFacebookAppId = @"146975985381829";



@interface YCShareAppEngine(private)

- (BOOL)canSendMail;
- (BOOL)canSendText;
- (void)sendEmail;
- (void)sendMessages;
- (void)alertInternetWithTitle:(NSString*)title andBody:(NSString*)body;
- (void)shareAppPrivate;

  
@property (nonatomic, retain, readonly) SA_OAuthTwitterEngine *twitterEngine;
@property (nonatomic, retain, readonly) Facebook *facebookEngine;
@property(nonatomic, retain, readonly) YCTwitterTweetViewController *twTweetViewController;
@property(nonatomic, retain, readonly) UINavigationController *twTweetNavController;
@property(nonatomic, retain, readonly) YCFacebookFeedViewController *fbFeedViewController;
@property(nonatomic, retain, readonly) UINavigationController *fbFeedNavController;

@end



@implementation YCShareAppEngine
@synthesize player;


- (BOOL)isTwitterAuthorized{
    return self.twitterEngine.isAuthorized;
}

- (BOOL)isFacebookAuthorized{
    return self.facebookEngine.isSessionValid;
}

- (BOOL)isKaixinAuthorized{
    return YES;
}

- (NSString*)twitterUserName{
    return self.twitterEngine.username;
}

- (NSString*)facebookUserName{
    NSString *username = [facebookEngine username];
    if (username) {
        return username;
    }else{
       return @"...";
    }
}

- (NSString*)kaixinUserName{
    return @"kaixinUserName";
}


- (void)authorizeTwitter{
    //检查网络
    [self performSelector:@selector(alertInternetWithTitle:andBody:) withObject:kAlertNeedInternetTitleAccessTwitter withObject:kAlertNeedInternetBodyAccessTwitter afterDelay:0.5];
    
    //弹出twitter授权view
    UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: self.twitterEngine delegate: self];
    [superViewController presentModalViewController: controller animated: YES];
    
}


- (void)removeAuthorizeTwitter{
    [self.twitterEngine clearAccessToken];
    [self.twitterEngine clearsCookies];
    [self.twitterEngine closeAllConnections];
    //[self.twitterEngine endUserSession];
    
    //发送认证改变通知
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSNotification *aNotif = [NSNotification notificationWithName:YCShareAppAuthorizeDidChangeNotification object:self userInfo:nil];
    [notificationCenter performSelector:@selector(postNotification:) withObject:aNotif afterDelay:0.0];
}


- (void)authorizeFacebook{
    //检查网络
	[self performSelector:@selector(alertInternetWithTitle:andBody:) withObject:kAlertNeedInternetTitleAccessFacebook withObject:kAlertNeedInternetBodyAccessFacebook afterDelay:0.5];
    
    NSArray *permissions = [NSArray arrayWithObjects:@"read_stream", @"publish_stream", @"offline_access",nil];
    [self.facebookEngine authorize:permissions delegate:self];
	
}

- (void)removeAuthorizeFacebook{
    [self.facebookEngine logout:self];
    if ([self.facebookEngine.sessionDelegate respondsToSelector:@selector(storeAuthData:expiresAt:username:)]) {
        [self.facebookEngine.sessionDelegate storeAuthData:nil expiresAt:nil username:nil];
        [YCFacebookGlobalData globalData].me = nil;
    }
    
    //发送认证改变通知
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSNotification *aNotif = [NSNotification notificationWithName:YCShareAppAuthorizeDidChangeNotification object:self userInfo:nil];
    [notificationCenter performSelector:@selector(postNotification:) withObject:aNotif afterDelay:0.0];
    
}

- (void)shareAppPrivate{
    UIActionSheet *shareAppSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:KLabelCellTwitter,KLabelCellFacebook,nil] autorelease];
    
    if ([self canSendMail]) 
        [shareAppSheet addButtonWithTitle:KLabelCellEmail];
    if ([self canSendText]) 
        [shareAppSheet addButtonWithTitle:KLabelCellMessages];
    
    //cancel按钮放到最后一个
    [shareAppSheet addButtonWithTitle:kBtnCancel];
    NSInteger numberOfButtons = shareAppSheet.numberOfButtons;
    shareAppSheet.cancelButtonIndex = numberOfButtons-1;  
    
    [shareAppSheet showInView:superViewController.view];
}

- (void)shareAppWithContent:(YCShareContent*)theShareContent{
    shareContent = [theShareContent retain];
    [self shareAppPrivate];
}

- (id)twitterEngine{
	if (twitterEngine == nil) {
        twitterEngine = [SA_OAuthTwitterEngine alloc]; //防止与twTweetViewController死循环
        twitterEngine = [twitterEngine initOAuthWithAuthDelegate:self RequestDelegate:self.twTweetViewController];
		twitterEngine.consumerKey = kOAuthConsumerKey_TW;
		twitterEngine.consumerSecret = kOAuthConsumerSecret_TW;
	}
	
	return twitterEngine;
}


- (id)facebookEngine{
	if (facebookEngine == nil) {
        facebookEngine = [[Facebook alloc] initWithAppId:kFacebookAppId andSessionDelegate:self];
	}
	return facebookEngine;
}


- (id)twTweetViewController{
	if (twTweetViewController == nil) {
        
        twTweetViewController = [[YCTwitterTweetViewController alloc] initWithNibName:@"YCTwitterTweetViewController" bundle:nil engine:self.twitterEngine messageDelegate:self shareData:shareContent];
        
	}
	return twTweetViewController;
}
- (id)twTweetNavController{
	if (twTweetNavController == nil) {
		twTweetNavController = [[UINavigationController alloc] initWithRootViewController:self.twTweetViewController];	
	}
	return twTweetNavController;
}


- (id)fbFeedViewController{
	if (fbFeedViewController == nil) {
		fbFeedViewController = [[YCFacebookFeedViewController alloc] initWithNibName:@"YCFacebookFeedViewController" bundle:nil engine:self.facebookEngine messageDelegate:self shareData:shareContent];
	}
	return fbFeedViewController;
}

- (id)fbFeedNavController{
	if (fbFeedNavController == nil) {
		fbFeedNavController = [[UINavigationController alloc] initWithRootViewController:self.fbFeedViewController];	
	}
	return fbFeedNavController;
}




#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:KLabelCellTwitter]) {//Tw

        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) {
            //tw iOS 5.x 支持
            
            TWTweetComposeViewController *tweetViewController = [[[TWTweetComposeViewController alloc] init] autorelease];
            
            [tweetViewController setInitialText:shareContent.message];
            if (shareContent.image1) 
                [tweetViewController addImage:shareContent.image1];
            if (shareContent.link1) 
                [tweetViewController addURL:[NSURL URLWithString:shareContent.link1]];

            
            [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
                //关闭，播放声音
                BOOL done = (TWTweetComposeViewControllerResultDone == result);
                [self messageComposeYCViewController:tweetViewController didFinishWithResult:done];
            }];
            
            [superViewController presentViewController:tweetViewController animated:YES completion:NULL];
            
            
        }else {
            
            if (![self isTwitterAuthorized]){
                [self authorizeTwitter];
                sendShardFlag = YES;
            }else 
                [superViewController presentModalViewController:self.twTweetNavController animated:YES];
            
        }
        
        
        
        
        
    }else if([buttonTitle isEqualToString:KLabelCellFacebook]){//fb
        
        if (![self isFacebookAuthorized]){
            [self authorizeFacebook];
            sendShardFlag = YES;
        }else 
            [superViewController presentModalViewController:self.fbFeedNavController animated:YES];
        
    }else if([buttonTitle isEqualToString:KLabelCellEmail]){
        
        //邮件
        [self sendEmail];
        
    }else if([buttonTitle isEqualToString:KLabelCellMessages]){
        
        //短信
        [self sendMessages];
        
    }
    
}

#pragma mark YCMessageComposeControllerDelegate 

- (void)messageComposeYCViewController:(UIViewController *)controller didFinishWithResult:(BOOL)result{
    
    if (result) {
		self.player = [YCSoundPlayer soundPlayerWithSoundFileName:@"Share-Complete.aif"];
	}else {
		self.player = [YCSoundPlayer soundPlayerWithSoundFileName:@"Share-Error.aif"];
	}
	[self.player play];
     
	[superViewController performSelector:@selector(dismissModalViewControllerAnimated:) withInteger:YES afterDelay:0.75];
}


#pragma mark SA_OAuthTwitterEngineDelegate
- (void)storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
        
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject: data forKey: @"authData_tw"];
	[defaults synchronize];
}

- (NSString *)cachedTwitterOAuthDataForUsername: (NSString *) username {
    return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData_tw"];
}

#pragma mark SA_OAuthTwitterControllerDelegate
- (void)OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username{
    //发送认证改变通知
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSNotification *aNotif = [NSNotification notificationWithName:YCShareAppAuthorizeDidChangeNotification object:self userInfo:nil];
    [notificationCenter performSelector:@selector(postNotification:) withObject:aNotif afterDelay:0.0];
    
    if (superViewController.modalViewController){ //关闭twitter认证view
        [superViewController dismissModalViewControllerAnimated:YES];
    }     
    
}


- (void)OAuthTwitterControllerViewDidDisappear: (SA_OAuthTwitterController *) controller didFinishWithResult: (BOOL)result{
    if (sendShardFlag) {
        sendShardFlag = NO;
        if (result) //弹出twitter发信息
            [superViewController presentModalViewController:self.twTweetNavController  animated:YES];
    }
}



#pragma mark -
#pragma mark FBSessionDelegate

- (NSString *)cachedFacebookExpirationDate{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    
    return [defaults objectForKey:@"FBExpirationDateKey"];
}

- (NSString *)cachedFacebookAccessToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"FBAccessTokenKey"];
}

- (NSString *) cachedFacebookUsername{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"FBExpirationUsernameKey"];
}
- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt username:(NSString *)username{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults setObject:username forKey:@"FBExpirationUsernameKey"];
    [defaults synchronize];
}

- (void)storeAuthDataUsername:(NSString *)username{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:username forKey:@"FBExpirationUsernameKey"];
    [defaults synchronize];
}

- (void)fbDidLogin {
    //发送认证改变通知
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSNotification *aNotif = [NSNotification notificationWithName:YCShareAppAuthorizeDidChangeNotification object:self userInfo:nil];
    [notificationCenter performSelector:@selector(postNotification:) withObject:aNotif afterDelay:0.0];
    
    if (sendShardFlag) {
        sendShardFlag = NO;
        //弹出facebook发信息
        [superViewController presentModalViewController:self.fbFeedNavController animated:YES];
    }else{
        //查询我的名字
        NSMutableDictionary *searchParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                       @"id,name,picture,gender", @"fields",nil];
        [facebookEngine requestWithGraphPath:@"me" andParams: searchParam andDelegate:self];
    }
}

- (void)fbDidNotLogin:(BOOL)cancelled{
    if (sendShardFlag) 
        sendShardFlag = NO;
 
}

#pragma mark -
#pragma mark FBRequestDelegate

- (void)request:(FBRequest *)request didLoad:(id)result {
	
	if (![result isKindOfClass:[NSDictionary class]]) 
		return;
	
    //////////////////////////////////////
    //查询me的返回
    
	//先清空
	[YCFacebookGlobalData globalData].me = nil;
	[YCFacebookGlobalData globalData].resultMe = result;
	
	[[YCFacebookGlobalData globalData] parseMe];
	
	if ([YCFacebookGlobalData globalData].me) {
        //存储用户名
        NSString *username = [YCFacebookGlobalData globalData].me.name;
        if ([facebookEngine.sessionDelegate respondsToSelector:@selector(storeAuthDataUsername:)]) {
            [facebookEngine.sessionDelegate storeAuthDataUsername:username];
        }
        [YCFacebookGlobalData globalData].me = nil; //清空，防止别的地方不查询me了
        
		//发送认证改变通知
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        NSNotification *aNotif = [NSNotification notificationWithName:YCShareAppAuthorizeDidChangeNotification object:self userInfo:nil];
        [notificationCenter performSelector:@selector(postNotification:) withObject:aNotif afterDelay:0.0];
	}
    //////////////////////////////////////
    
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	switch (result)
	{
            /*
             case MFMailComposeResultCancelled:
             break;
             
             case MFMailComposeResultSaved:
             break;
             */
		case MFMailComposeResultSent:
			[superViewController performSelector:@selector(dismissModalViewControllerAnimated:) withInteger:YES afterDelay:1.5];
			self.player = [YCSoundPlayer soundPlayerWithSoundFileName:@"Share-Complete.aif"];
			[self.player performSelector:@selector(play) withObject:nil afterDelay:1.5];
			break;
		case MFMailComposeResultFailed:
			[superViewController performSelector:@selector(dismissModalViewControllerAnimated:) withInteger:YES afterDelay:1.0];
			self.player = [YCSoundPlayer soundPlayerWithSoundFileName:@"Share-Error.aif"];
			[self.player performSelector:@selector(play) withObject:nil afterDelay:1.0];
			break;
		default:
			[superViewController dismissModalViewControllerAnimated:YES];
			break;
	}
	
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
	
    switch (result)
    {
            /*case MessageComposeResultCancelled:
			 [self dismissModalViewControllerAnimated:YES];
			 break;
             */
        case MessageComposeResultSent:
            [superViewController performSelector:@selector(dismissModalViewControllerAnimated:) withInteger:YES afterDelay:1.5];
            self.player = [YCSoundPlayer soundPlayerWithSoundFileName:@"Share-Complete.aif"];
            [self.player performSelector:@selector(play) withObject:nil afterDelay:1.5];
            break;
        case MessageComposeResultFailed:
            [superViewController performSelector:@selector(dismissModalViewControllerAnimated:) withInteger:YES afterDelay:1.0];
            self.player = [YCSoundPlayer soundPlayerWithSoundFileName:@"Share-Error.aif"];
            [self.player performSelector:@selector(play) withObject:nil afterDelay:1.0];
            break;
        default:
            [superViewController dismissModalViewControllerAnimated:YES];
            break;
    }
    
}



#pragma mark Utility

-(void)alertInternetWithTitle:(NSString*)title andBody:(NSString*)body{
	//检查网络
	BOOL connectedToInternet = [[YCSystemStatus sharedSystemStatus] connectedToInternet];
	if (!connectedToInternet) {
		[UIUtility simpleAlertBody:body alertTitle:title cancelButtonTitle:kAlertBtnOK delegate:nil];
	}
}

- (BOOL)canSendMail{
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{   // We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			return YES;
		}
		
	}
	return NO;
}

- (BOOL)canSendText{
	Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
	if (messageClass != nil)
	{
		if ([messageClass canSendText])
		{
			return YES;
		}
	}
	return NO;
}

- (void)sendEmail{
	if (![self canSendMail]) return;
	
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
    //是否使用默认的数据
    NSMutableString *text = [NSMutableString string];
    if (shareContent.message) 
        [text appendString:shareContent.message];
    if (shareContent.link1) {
        [text appendString:@"\n"];
        [text appendString:shareContent.link1];
    }
    
	// Attach an image to the email
    if (shareContent.image1) {
        NSData *myData = UIImageJPEGRepresentation(shareContent.image1, 1.0);
        [picker addAttachmentData:myData mimeType:@"image/jpg" fileName:@"image"];
    }
	
	// 邮件标题
	[picker setSubject:shareContent.title];
	
	// Fill out the email body text
	NSString *emailBody = text;
	[picker setMessageBody:emailBody isHTML:NO];
	
	[superViewController presentModalViewController:picker animated:YES];
    [picker release];
}

- (void)sendMessages{
	if (![self canSendText]) return;
	
	MFMessageComposeViewController*picker = [[MFMessageComposeViewController alloc] init];
	picker.messageComposeDelegate= self;
    
    NSMutableString *text = [NSMutableString string];
    if (shareContent.message) 
        [text appendString:shareContent.message];
    if (shareContent.link1) {
        [text appendString:@"\n"];
        [text appendString:shareContent.link1];
    }
    
    picker.body = text; 
	[superViewController presentModalViewController:picker animated:YES];
    [picker release];
	
}

#pragma mark - Memory management

- (id)initWithSuperViewController:(id)viewController{
    self = [super init];
    if (self) {
        superViewController = viewController;
    }
    return self;
}

- (void)dealloc {
    [player release];
    [twitterEngine release];
    [facebookEngine release];
    [twTweetViewController release];
	[twTweetNavController release];
	[fbFeedViewController release];
    [fbFeedNavController release];
    [shareContent release];
    
    //释放掉全局的FBData
	[YCFacebookGlobalData globalData].resultMe = nil;
	[YCFacebookGlobalData globalData].resultFriends = nil;
	[YCFacebookGlobalData globalData].me = nil;
	[[YCFacebookGlobalData globalData].friends removeAllObjects];
	[[YCFacebookGlobalData globalData].checkedPeoples removeAllObjects];

    [super dealloc];
}

@end
