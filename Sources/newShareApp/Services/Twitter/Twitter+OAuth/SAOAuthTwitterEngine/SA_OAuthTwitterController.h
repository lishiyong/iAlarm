//
//  SA_OAuthTwitterController.h
//
//  Created by Ben Gottlieb on 24 July 2009.
//  Copyright 2009 Stand Alone, Inc.
//
//  Some code and concepts taken from examples provided by 
//  Matt Gemmell, Chris Kimpton, and Isaiah Carew
//  See ReadMe for further attributions, copyrights and license info.
//

#import "YCLib.h"
#import <UIKit/UIKit.h>
#import "SA_OAuthTwitterEngine.h"

@class SA_OAuthTwitterEngine, SA_OAuthTwitterController;


@protocol SA_OAuthTwitterControllerDelegate <YCObject>
@optional
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username;
- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller;
- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller;
//lishiyong 2012-03-26添加 
- (void) OAuthTwitterControllerViewDidDisappear: (SA_OAuthTwitterController *) controller didFinishWithResult: (BOOL)result;

@end

@protocol WebViewOAuthTwitterEngineDelegate;
@interface SA_OAuthTwitterController : UIViewController <UIWebViewDelegate,WebViewOAuthTwitterEngineDelegate> {

	SA_OAuthTwitterEngine						*_engine;
	UIWebView									*_webView;
	UINavigationBar								*_navBar;
	UIImageView									*_backgroundView;
	
	id <SA_OAuthTwitterControllerDelegate>		_delegate;
	UIView										*_blockerView;

	UIInterfaceOrientation                      _orientation;
	BOOL										_loading, _firstLoad;
	UIToolbar									*_pinCopyPromptBar;
    
    UILabel	*oauthResultLabel;
}


@property (nonatomic, readwrite, retain) SA_OAuthTwitterEngine *engine;
@property (nonatomic, readwrite, assign) id <SA_OAuthTwitterControllerDelegate> delegate;
@property (nonatomic, readonly) UINavigationBar *navigationBar;

+ (SA_OAuthTwitterController *) controllerToEnterCredentialsWithTwitterEngine: (SA_OAuthTwitterEngine *) engine delegate: (id <SA_OAuthTwitterControllerDelegate>) delegate forOrientation:(UIInterfaceOrientation)theOrientation;
+ (SA_OAuthTwitterController *) controllerToEnterCredentialsWithTwitterEngine: (SA_OAuthTwitterEngine *) engine delegate: (id <SA_OAuthTwitterControllerDelegate>) delegate;
+ (BOOL) credentialEntryRequiredWithTwitterEngine: (SA_OAuthTwitterEngine *) engine;

@end
