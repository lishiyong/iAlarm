//
//  SA_OAuthTwitterEngine.m
//
//  Created by Ben Gottlieb on 24 July 2009.
//  Copyright 2009 Stand Alone, Inc.
//
//  Some code and concepts taken from examples provided by 
//  Matt Gemmell, Chris Kimpton, and Isaiah Carew
//  See ReadMe for further attributions, copyrights and license info.
//

#import "MGTwitterHTTPURLConnection.h"


#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"

#import "SA_OAuthTwitterEngine.h"

@interface SA_OAuthTwitterEngine (private)

- (void) requestURL:(NSURL *) url token:(OAToken *)token onSuccess:(SEL)success onFail:(SEL)fail;
- (void) outhTicketFailed: (OAServiceTicket *) ticket data: (NSData *) data;

- (void) setRequestToken: (OAServiceTicket *) ticket withData: (NSData *) data;
- (void) setAccessToken: (OAServiceTicket *) ticket withData: (NSData *) data;

- (NSString *) extractUsernameFromHTTPBody:(NSString *)body;

// MGTwitterEngine impliments this
// include it here just so that we
// can use this private method
- (NSString *)_queryStringWithBase:(NSString *)base parameters:(NSDictionary *)params prefixed:(BOOL)prefixed;

@end



@implementation SA_OAuthTwitterEngine

@synthesize pin = _pin, requestTokenURL = _requestTokenURL, accessTokenURL = _accessTokenURL, authorizeURL = _authorizeURL;
@synthesize consumerSecret = _consumerSecret, consumerKey = _consumerKey;
@synthesize authDelegate = _authDelegate;

- (void) dealloc {
	self.pin = nil;
	self.authorizeURL = nil;
	self.requestTokenURL = nil;
	self.accessTokenURL = nil;
	
	[_accessToken release];
	[_requestToken release];
	[_consumer release];
	[super dealloc];
}

//lishiyong 2012-3-18 修改
/*
+ (SA_OAuthTwitterEngine *) OAuthTwitterEngineWithDelegate: (NSObject *) delegate {
    return [[[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: delegate] autorelease];
}


- (SA_OAuthTwitterEngine *) initOAuthWithDelegate: (NSObject *) delegate {
    if (self = (id) [super initWithDelegate: delegate]) {
		
        //self.requestTokenURL = [NSURL URLWithString: @"http://twitter.com/oauth/request_token"];
		//self.accessTokenURL = [NSURL URLWithString: @"http://twitter.com/oauth/access_token"];
		//self.authorizeURL = [NSURL URLWithString: @"http://twitter.com/oauth/authorize"];
        
         
        
        self.requestTokenURL = [NSURL URLWithString: @"https://api.twitter.com/oauth/request_token"];
		self.accessTokenURL = [NSURL URLWithString: @"https://api.twitter.com/oauth/access_token"];
		self.authorizeURL = [NSURL URLWithString: @"https://api.twitter.com/oauth/authorize"];
        
	}
    return self;
}
*/



+ (id)OAuthTwitterEngineWithAuthDelegate:(id<SA_OAuthTwitterEngineDelegate>)authDelegate RequestDelegate: (id<MGTwitterEngineDelegate>)requestDelegate{
    return [[[SA_OAuthTwitterEngine alloc] initOAuthWithAuthDelegate:authDelegate RequestDelegate:requestDelegate] autorelease];
}
- (id)initOAuthWithAuthDelegate:(id<SA_OAuthTwitterEngineDelegate>)authDelegate RequestDelegate:(id<MGTwitterEngineDelegate>)requestDelegate{
    if (self = (id) [super initWithDelegate: requestDelegate]) {
        self.requestTokenURL = [NSURL URLWithString: @"https://api.twitter.com/oauth/request_token"];
		self.accessTokenURL = [NSURL URLWithString: @"https://api.twitter.com/oauth/access_token"];
		self.authorizeURL = [NSURL URLWithString: @"https://api.twitter.com/oauth/authorize"];
        
        _authDelegate = authDelegate;
	}
    return self;
}


//=============================================================================================================================
#pragma mark OAuth Code
- (BOOL) OAuthSetup {
	return _consumer != nil;
}
- (OAConsumer *) consumer {
	if (_consumer) return _consumer;
	
	NSAssert(self.consumerKey.length > 0 && self.consumerSecret.length > 0, @"You must first set your Consumer Key and Consumer Secret properties. Visit http://twitter.com/oauth_clients/new to obtain these.");
	_consumer = [[OAConsumer alloc] initWithKey: self.consumerKey secret: self.consumerSecret];
	return _consumer;
}

- (BOOL) isAuthorized {	
	if (_accessToken.key && _accessToken.secret) return YES;
	
	//first, check for cached creds
	NSString *accessTokenString = [_authDelegate respondsToSelector: @selector(cachedTwitterOAuthDataForUsername:)] ? [(id) _authDelegate cachedTwitterOAuthDataForUsername: self.username] : @"";

	if (accessTokenString.length) {				
		[_accessToken release];
		_accessToken = [[OAToken alloc] initWithHTTPResponseBody: accessTokenString];
		[self setUsername: [self extractUsernameFromHTTPBody: accessTokenString] password: nil];
		if (_accessToken.key && _accessToken.secret) return YES;
	}
	
	[_accessToken release];										// no access token found.  create a new empty one
	_accessToken = [[OAToken alloc] initWithKey: nil secret: nil];
	return NO;
}


//This generates a URL request that can be passed to a UIWebView. It will open a page in which the user must enter their Twitter creds to validate
- (NSURLRequest *) authorizeURLRequest {
	if (!_requestToken.key && _requestToken.secret) return nil;	// we need a valid request token to generate the URL

	OAMutableURLRequest			*request = [[[OAMutableURLRequest alloc] initWithURL: self.authorizeURL consumer: nil token: _requestToken realm: nil signatureProvider: nil] autorelease];	

	[request setParameters: [NSArray arrayWithObject: [[[OARequestParameter alloc] initWithName: @"oauth_token" value: _requestToken.key] autorelease]]];	
	return request;
}


//A request token is used to eventually generate an access token
- (void) requestRequestToken {
	[self requestURL: self.requestTokenURL token: nil onSuccess: @selector(setRequestToken:withData:) onFail: @selector(outhTicketFailed:data:)];
}

//this is what we eventually want
- (void) requestAccessToken {
	[self requestURL: self.accessTokenURL token: _requestToken onSuccess: @selector(setAccessToken:withData:) onFail: @selector(outhTicketFailed:data:)];
}


- (void) clearAccessToken {
	if ([_authDelegate respondsToSelector: @selector(storeCachedTwitterOAuthData:forUsername:)]) [(id) _authDelegate storeCachedTwitterOAuthData: @"" forUsername: self.username];
	[_accessToken release];
	_accessToken = nil;
	[_consumer release];
	_consumer = nil;
	self.pin = nil;
	[_requestToken release];
	_requestToken = nil;
}

- (void) setPin: (NSString *) pin {
	[_pin autorelease];
	_pin = [pin retain];
	
	_accessToken.pin = pin;
	_requestToken.pin = pin;
    
}

//=============================================================================================================================
#pragma mark Private OAuth methods
- (void) requestURL: (NSURL *) url token: (OAToken *) token onSuccess: (SEL) success onFail: (SEL) fail {
    OAMutableURLRequest				*request = [[[OAMutableURLRequest alloc] initWithURL: url consumer: self.consumer token:token realm:nil signatureProvider: nil] autorelease];
	if (!request) return;
	
	if (self.pin.length) token.pin = self.pin;
    [request setHTTPMethod: @"POST"];
	
    OADataFetcher				*fetcher = [[[OADataFetcher alloc] init] autorelease];	
    [fetcher fetchDataWithRequest: request delegate: self didFinishSelector: success didFailSelector: fail];
}


//
// if the fetch fails this is what will happen
// you'll want to add your own error handling here.
//
- (void) outhTicketFailed: (OAServiceTicket *) ticket data: (NSData *) data {
	if ([_authDelegate respondsToSelector: @selector(twitterOAuthConnectionFailedWithData:)]) [(id) _authDelegate twitterOAuthConnectionFailedWithData: data];
}


//
// request token callback
// when twitter sends us a request token this callback will fire
// we can store the request token to be used later for generating
// the authentication URL
//
- (void) setRequestToken: (OAServiceTicket *) ticket withData: (NSData *) data {
	if (!ticket.didSucceed || !data) return;
	
	NSString *dataString = [[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] autorelease];
	if (!dataString) return;
	
	[_requestToken release];
	_requestToken = [[OAToken alloc] initWithHTTPResponseBody:dataString];
	
	if (self.pin.length) _requestToken.pin = self.pin;
}


//
// access token callback
// when twitter sends us an access token this callback will fire
// we store it in our ivar as well as writing it to the keychain
// 
- (void) setAccessToken: (OAServiceTicket *) ticket withData: (NSData *) data {
	if (!ticket.didSucceed || !data) return;
	
	NSString *dataString = [[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] autorelease];
	if (!dataString) return;

	if (self.pin.length && [dataString rangeOfString: @"oauth_verifier"].location == NSNotFound) dataString = [dataString stringByAppendingFormat: @"&oauth_verifier=%@", self.pin];
	
	NSString				*username = [self extractUsernameFromHTTPBody:dataString];

	if (username.length > 0) {
		[self setUsername: username password: nil];
		if ([_authDelegate respondsToSelector: @selector(storeCachedTwitterOAuthData:forUsername:)]) [(id) _authDelegate storeCachedTwitterOAuthData: dataString forUsername: username];
	}
	
	[_accessToken release];
	_accessToken = [[OAToken alloc] initWithHTTPResponseBody:dataString];
}


- (NSString *) extractUsernameFromHTTPBody: (NSString *) body {
	if (!body) return nil;
	
	NSArray					*tuples = [body componentsSeparatedByString: @"&"];
	if (tuples.count < 1) return nil;
	
	for (NSString *tuple in tuples) {
		NSArray *keyValueArray = [tuple componentsSeparatedByString: @"="];
		
		if (keyValueArray.count == 2) {
			NSString				*key = [keyValueArray objectAtIndex: 0];
			NSString				*value = [keyValueArray objectAtIndex: 1];
			
			if ([key isEqualToString:@"screen_name"]) return value;
		}
	}
	
	return nil;
}

//=============================================================================================================================
#pragma mark MGTwitterEngine Changes
//These are all verbatim from Isaiah Carew and Chris Kimpton's code

// --------------------------------------------------------------------------------
//
// these method overrides were created from the work that Chris Kimpton
// did.  i've chosen to subclass instead of directly modifying the
// MGTwitterEngine as it makes integrating MGTwitterEngine changes a bit
// easier.
// 
// the code here is largely unchanged from chris's implimentation.
// i've tried to highlight the areas that differ from 
// the base class implimentation.
//
// --------------------------------------------------------------------------------

#define SET_AUTHORIZATION_IN_HEADER 1

- (NSString *)_sendRequestWithMethod:(NSString *)method 
                                path:(NSString *)path 
                     queryParameters:(NSDictionary *)params 
                                body:(NSString *)body 
                         requestType:(MGTwitterRequestType)requestType 
                        responseType:(MGTwitterResponseType)responseType
{

    NSString *fullPath = path;

	// --------------------------------------------------------------------------------
	// modificaiton from the base clase
	// the base class appends parameters here
	// --------------------------------------------------------------------------------
	//    if (params) {
	//        fullPath = [self _queryStringWithBase:fullPath parameters:params prefixed:YES];
	//    }
	// --------------------------------------------------------------------------------

    NSString *urlString = [NSString stringWithFormat:@"%@://%@/%@", 
                           (_secureConnection) ? @"https" : @"http",
                           _APIDomain, fullPath];
    NSURL *finalURL = [NSURL URLWithString:urlString];
    if (!finalURL) {
        return nil;
    }
	
	// --------------------------------------------------------------------------------
	// modificaiton from the base clase
	// the base class creates a regular url request
	// we're going to create an oauth url request
	// --------------------------------------------------------------------------------
	//    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:finalURL 
	//                                                              cachePolicy:NSURLRequestReloadIgnoringCacheData 
	//                                                          timeoutInterval:URL_REQUEST_TIMEOUT];
	// --------------------------------------------------------------------------------
	
	OAMutableURLRequest *theRequest = [[[OAMutableURLRequest alloc] initWithURL:finalURL
																	   consumer:self.consumer 
																		  token:_accessToken 
																		  realm: nil
															  signatureProvider:nil] autorelease];
    if (method) {
        [theRequest setHTTPMethod:method];
    }
    [theRequest setHTTPShouldHandleCookies:NO];
    
    // Set headers for client information, for tracking purposes at Twitter.
    [theRequest setValue:_clientName    forHTTPHeaderField:@"X-Twitter-Client"];
    [theRequest setValue:_clientVersion forHTTPHeaderField:@"X-Twitter-Client-Version"];
    [theRequest setValue:_clientURL     forHTTPHeaderField:@"X-Twitter-Client-URL"];
    
    // Set the request body if this is a POST request.
    BOOL isPOST = (method && [method isEqualToString:@"POST"]);
    if (isPOST) {
        // Set request body, if specified (hopefully so), with 'source' parameter if appropriate.
        NSString *finalBody = @"";
		if (body) {
			finalBody = [finalBody stringByAppendingString:body];
		}
        /*
        if (_clientSourceToken) {
            finalBody = [finalBody stringByAppendingString:[NSString stringWithFormat:@"%@source=%@", 
                                                            (body) ? @"&" : @"?" , 
                                                            _clientSourceToken]];
        }
         */
        
        if (finalBody) {
            [theRequest setHTTPBody:[finalBody dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }

	// --------------------------------------------------------------------------------
	// modificaiton from the base clase
	// our version "prepares" the oauth url request
	// --------------------------------------------------------------------------------
	[theRequest prepare];
    
    // Create a connection using this request, with the default timeout and caching policy, 
    // and appropriate Twitter request and response types for parsing and error reporting.
    MGTwitterHTTPURLConnection *connection;
    connection = [[MGTwitterHTTPURLConnection alloc] initWithRequest:theRequest 
                                                            delegate:self 
                                                         requestType:requestType 
                                                        responseType:responseType];
    
    if (!connection) {
        return nil;
    } else {
        [_connections setObject:connection forKey:[connection identifier]];
        [connection release];
    }
    
    return [connection identifier];
}

////////////////////////
//lishiyong 2012-4-16 添加
- (NSString *)_generateBoundaryString
{
    CFUUIDRef       uuid;
    CFStringRef     uuidStr;
    NSString *      result;
    
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    
    result = [NSString stringWithFormat:@"Boundary-%@", uuidStr];
    
    CFRelease(uuidStr);
    CFRelease(uuid);
    
    return result;
}

//oauth http request 头和体
/*
 POST http://upload.twitter.com/1/statuses/update_with_media.json?application_id=com.yicheng.iAlarm HTTP/1.1
 Host: upload.twitter.com
 User-Agent: Tweeting/1.0 CFNetwork/548.0.3 Darwin/11.0.0
 Content-Length: 364
 Accept: 
Content-Type: multipart/form-data; boundary=0xN0b0dy_lik3s_a_mim3__AKhSmhMrH
Authorization: OAuth oauth_nonce="91AF93E5-AE96-4851-976C-0A23B006750D", oauth_signature_method="HMAC-SHA1", oauth_timestamp="1334678744", oauth_consumer_key="WXZE9QillkIZpTANgLNT9g", oauth_token="342001418-qZ1Gu1Y22gCQpeA731osqlCOaEYBCf5XABLstKME", oauth_signature="9L18nV85OpNjGfqmRGiYrzkxTh0%3D", oauth_version="1.0"
Accept-Language: zh-cn
Accept-Encoding: gzip, deflate
Cookie: guest_id=v1%3A133462436105286451; k=74.125.158.87.1334624361038989
Connection: keep-alive
Proxy-Connection: keep-alive

--0xN0b0dy_lik3s_a_mim3__AKhSmhMrH
Content-Disposition: form-data; name="status"

just setting up my twttro dd ff #iOS5
--0xN0b0dy_lik3s_a_mim3__AKhSmhMrH
Content-Disposition: form-data; name="media[]"

<imageData>
--0xN0b0dy_lik3s_a_mim3__AKhSmhMrH--

 */


- (NSString *)_sendRequestWithStatus:(NSString *) status
                               image:(UIImage*)image
                         requestType:(MGTwitterRequestType)requestType 
                        responseType:(MGTwitterResponseType)responseType
{
    
    NSString *fullPath = @"https://upload.twitter.com/1/statuses/update_with_media.xml";
    NSURL *finalURL = [NSURL URLWithString:fullPath];
	
	OAMutableURLRequest *theRequest = [[[OAMutableURLRequest alloc] initWithURL:finalURL
																	   consumer:self.consumer 
																		  token:_accessToken 
																		  realm: nil
															  signatureProvider:nil] autorelease];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPShouldHandleCookies:NO];
    
    NSStringEncoding stringEncoding = NSUTF8StringEncoding;
    NSString *boundaryString = @"0xN0b0dy_lik3s_a_mim3__AKhSmhMrH";//[self _generateBoundaryString];
    NSString *returnString = @"\r\n";
    NSString *ggString = @"--";
    
    NSString *contentDisposition1 = @"Content-Disposition: form-data; name=\"status\"";
    NSString *contentDisposition2 = @"Content-Disposition: form-data; name=\"media[]\"";
    
    NSString *statusFormString = status;
    UIImage *mediaFormImage = image;
    
    
    NSMutableData *bodyData = [NSMutableData dataWithLength:0];
    
    [bodyData appendData:[ggString dataUsingEncoding:stringEncoding]];                   /////////////
    [bodyData appendData:[boundaryString dataUsingEncoding:stringEncoding]];             //--第一行分隔
    
    [bodyData appendData:[returnString dataUsingEncoding:stringEncoding]];               ////////////////
    [bodyData appendData:[contentDisposition1 dataUsingEncoding:stringEncoding]];        //
    [bodyData appendData:[returnString dataUsingEncoding:stringEncoding]];               //
    [bodyData appendData:[returnString dataUsingEncoding:stringEncoding]];               //   status
    [bodyData appendData:[statusFormString dataUsingEncoding:stringEncoding]];           //
    [bodyData appendData:[returnString dataUsingEncoding:stringEncoding]];               ////////////////
    
    [bodyData appendData:[ggString dataUsingEncoding:stringEncoding]];                   ////////////
    [bodyData appendData:[boundaryString dataUsingEncoding:stringEncoding]];             ////--分隔 
    
    [bodyData appendData:[returnString dataUsingEncoding:stringEncoding]];                ///////////////////
    [bodyData appendData:[contentDisposition2 dataUsingEncoding:stringEncoding]];         //
    [bodyData appendData:[returnString dataUsingEncoding:stringEncoding]];                //
    [bodyData appendData:[returnString dataUsingEncoding:stringEncoding]];                //  media[]
    [bodyData appendData:UIImagePNGRepresentation(mediaFormImage)];                       //
    [bodyData appendData:[returnString dataUsingEncoding:stringEncoding]];                ////////////////////
    
    [bodyData appendData:[ggString dataUsingEncoding:stringEncoding]];                    /////////////
    [bodyData appendData:[boundaryString dataUsingEncoding:stringEncoding]];              //--最后的分隔--
    [bodyData appendData:[ggString dataUsingEncoding:stringEncoding]];                    /////////////
    
    [theRequest setHTTPBody:bodyData];
     
    [theRequest setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=\"%@\"", boundaryString] forHTTPHeaderField:@"Content-Type"];
    [theRequest setValue:[NSString stringWithFormat:@"%llu", bodyData.length] forHTTPHeaderField:@"Content-Length"];

    
	[theRequest prepare];
    
    
    
    MGTwitterHTTPURLConnection *connection;
    connection = [[MGTwitterHTTPURLConnection alloc] initWithRequest:theRequest 
                                                            delegate:self 
                                                         requestType:requestType 
                                                        responseType:responseType];
    
    if (!connection) {
        return nil;
    } else {
        [_connections setObject:connection forKey:[connection identifier]];
        [connection release];
    }
    
    return [connection identifier];
}
//lishiyong 2012-4-16 添加
////////////////////////

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	
	// --------------------------------------------------------------------------------
	// modificaiton from the base clase
	// instead of answering the authentication challenge, we just ignore it.
	// seems a bit odd to me, but this is what Chris Kimpton did and it seems to work,
	// so i'm rolling with it.
	// --------------------------------------------------------------------------------
	//	if ([challenge previousFailureCount] == 0 && ![challenge proposedCredential]) {
	//		NSURLCredential *credential = [NSURLCredential credentialWithUser:_username password:_password 
	//															  persistence:NSURLCredentialPersistenceForSession];
	//		[[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
	//	} else {
	//		[[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
	//	}
	// --------------------------------------------------------------------------------

	[[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
	return;
	
}

@end
