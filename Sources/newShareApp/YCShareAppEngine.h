//
//  YCShareApp.h
//  iAlarm
//
//  Created by li shiyong on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCMessageComposeControllerDelegate.h"
#import "Facebook.h"
#import "SA_OAuthTwitterController.h"
#import "SA_OAuthTwitterEngine.h"
#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>


@protocol FBSessionDelegate, YCMessageComposeControllerDelegate;
@class YCSoundPlayer,YCFacebookGlobalData, YCFacebookFeedViewController, YCTwitterTweetViewController, YCShareContent;
@class SA_OAuthTwitterEngine, SA_OAuthTwitterEngineDelegate;
@interface YCShareAppEngine : NSObject <UIActionSheetDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,SA_OAuthTwitterEngineDelegate,SA_OAuthTwitterControllerDelegate,FBSessionDelegate,FBRequestDelegate,YCMessageComposeControllerDelegate>{
    
    BOOL sendShardFlag; //发送共享的标识；用来区别“认证”和“发共享数据前的认证”
    BOOL twitterAuthviewDidDisappeaFlag; //
    
    //YCSoundPlayer *player;
    UIViewController *superViewController; //引用这个类的view控制器。 循环引用的变量，不能retain
    
    SA_OAuthTwitterEngine *twitterEngine;
    Facebook *facebookEngine;
    YCTwitterTweetViewController *twTweetViewController;
	UINavigationController *twTweetNavController;
	YCFacebookFeedViewController *fbFeedViewController;
	UINavigationController *fbFeedNavController;
    YCShareContent *shareContent;
     
    
}
@property (nonatomic, retain) YCSoundPlayer *player;
@property (nonatomic, readonly) BOOL isTwitterAuthorized;
@property (nonatomic, readonly) BOOL isFacebookAuthorized;
@property (nonatomic, readonly) BOOL isKaixinAuthorized;
@property (nonatomic, readonly) NSString *twitterUserName;
@property (nonatomic, readonly) NSString *facebookUserName;
@property (nonatomic, readonly) NSString *kaixinUserName;
- (void)authorizeTwitter;
- (void)removeAuthorizeTwitter;
- (void)authorizeFacebook;
- (void)removeAuthorizeFacebook;


- (id)initWithSuperViewController:(id)viewController;
- (void)shareAppWithContent:(YCShareContent*)theShareContent; 

@end
