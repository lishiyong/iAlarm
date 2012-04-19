//
//  SA_OAuthTwitterEngine.h
//
//  Created by Ben Gottlieb on 24 July 2009.
//  Copyright 2009 Stand Alone, Inc.
//
//  Some code and concepts taken from examples provided by 
//  Matt Gemmell, Chris Kimpton, and Isaiah Carew
//  See ReadMe for further attributions, copyrights and license info.
//

#import "MGTwitterEngine.h"

@protocol SA_OAuthTwitterEngineDelegate <NSObject>
@optional
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username;					//implement these methods to store off the creds returned by Twitter
- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username;										//if you don't do this, the user will have to re-authenticate every time they run
- (void) twitterOAuthConnectionFailedWithData: (NSData *) data; 
@end

//lishiyong 2012-4-19 添加
@protocol WebViewOAuthTwitterEngineDelegate <NSObject>
@optional
- (void)requestRequestTokenSucceeded: (BOOL)flag;
- (void)requestAccessTokenSucceeded: (BOOL)flag;

@end


@class OAToken;
@class OAConsumer;

@interface SA_OAuthTwitterEngine : MGTwitterEngine {
	NSString	*_consumerSecret;
	NSString	*_consumerKey;
	NSURL		*_requestTokenURL;
	NSURL		*_accessTokenURL;
	NSURL		*_authorizeURL;


	NSString	*_pin;

@private
	OAConsumer	*_consumer;
	OAToken		*_requestToken;
	OAToken		*_accessToken; 
    id<SA_OAuthTwitterEngineDelegate> _authDelegate; //lishiyong 2012-3-18 添加
    
    id<WebViewOAuthTwitterEngineDelegate> _webViewDelegate;//lishiyong 2012-4-19 添加
}

@property (nonatomic, readwrite, retain) NSString *consumerSecret, *consumerKey;
@property (nonatomic, readwrite, retain) NSURL *requestTokenURL, *accessTokenURL, *authorizeURL;				//you shouldn't need to touch these. Just in case...
@property (nonatomic, readonly) BOOL OAuthSetup;

@property (nonatomic, assign) id<SA_OAuthTwitterEngineDelegate> authDelegate; //lishiyong 2012-3-18 添加
@property (nonatomic, assign) id<WebViewOAuthTwitterEngineDelegate> webViewDelegate; //lishiyong 2012-3-18 添加

- (BOOL) isAuthorized;

//lishiyong 2012-3-18 修改
//+ (SA_OAuthTwitterEngine *) OAuthTwitterEngineWithDelegate: (NSObject *) delegate;
//- (SA_OAuthTwitterEngine *) initOAuthWithDelegate: (NSObject *) delegate;

+ (id)OAuthTwitterEngineWithAuthDelegate:(id<SA_OAuthTwitterEngineDelegate>)authDelegate RequestDelegate: (id<MGTwitterEngineDelegate>)requestDelegate;
- (id)initOAuthWithAuthDelegate:(id<SA_OAuthTwitterEngineDelegate>)authDelegate RequestDelegate:(id<MGTwitterEngineDelegate>)requestDelegate;






- (void) requestAccessToken;
- (void) requestRequestToken;
- (void) clearAccessToken;

@property (nonatomic, readwrite, retain)  NSString	*pin;
@property (nonatomic, readonly) NSURLRequest *authorizeURLRequest;
@property (nonatomic, readonly) OAConsumer *consumer;

@end
