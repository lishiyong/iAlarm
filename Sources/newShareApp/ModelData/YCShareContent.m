//
//  YCShareData.m
//  iAlarm
//
//  Created by li shiyong on 11-8-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocalizedStringShareApp.h"
#import "YCShareContent.h"


@implementation YCShareContent

@synthesize message;
@synthesize title;
@synthesize image1;
@synthesize image2;
@synthesize imageLink1;
@synthesize imageLink2;
@synthesize link1;
@synthesize link2;
@synthesize imageAutoSizeFit;

- (void)dealloc {
	[message release];
	[title release];
	[image1 release];
	[image2 release];
	[imageLink1 release];
	[imageLink2 release];  
	[link1 release];
	[link2 release]; 
    [super dealloc];
}

+ (YCShareContent*)facebookShareContentWithMessage:(NSString*)theMessage image:(UIImage*)theImage{
    YCShareContent* obj = [[[YCShareContent alloc] init] autorelease];
    obj.message = KShareContentTwitterMessage;
    obj.title = nil;
    obj.image1 = nil;
    obj.image2 = nil;
    obj.imageLink1 = @"http://i54.tinypic.com/317ff4p.png";
    obj.imageLink2 = nil;
    obj.link1 = nil;
    obj.link2 = nil;
    
    return obj;
}

+ (YCShareContent*)twitterShareContentWithMessage:(NSString*)theMessage image:(UIImage*)theImage{
    
    YCShareContent* obj = [[[YCShareContent alloc] init] autorelease];
    obj.message = KShareContentTwitterMessage;
    obj.title = nil;
    obj.image1 = nil;
    obj.image2 = nil;
    obj.imageLink1 = @"http://i54.tinypic.com/317ff4p.png";
    obj.imageLink2 = nil;
    obj.link1 = nil;
    obj.link2 = nil;
    
    return obj;
    
}

+ (YCShareContent*)mailShareContentWithMessage:(NSString*)theMessage image:(UIImage*)theImage{
    YCShareContent* obj = [[[YCShareContent alloc] init] autorelease];
    obj.message = KShareContentMailMessage;
    obj.title = KShareContentMailTitle;
    obj.image1 = [UIImage imageNamed:@"MailShareImage.jpg"];
    obj.image2 = nil;
    obj.imageLink1 = nil;
    obj.imageLink2 = nil;
    obj.link1 = KLinkCustomAppStore;
    obj.link2 = nil;
    
    return obj;
}

+ (YCShareContent*)messageShareContentWithMessage:(NSString*)theMessage{
    YCShareContent* obj = [[[YCShareContent alloc] init] autorelease];
    obj.message = @"";
    obj.title = nil;
    obj.image1 = nil;
    obj.image2 = nil;
    obj.imageLink1 = nil;
    obj.imageLink2 = nil;
    obj.link1 = KLinkCustomAppStore;
    obj.link2 = nil;
    
    return obj;
}

+ (YCShareContent*)shareContentWithTitle:(NSString *)theTitle message:(NSString*)theMessage image:(UIImage *)theImage{
    YCShareContent* obj = [[[YCShareContent alloc] init] autorelease];
    obj.title = theTitle;
    obj.message = theMessage;
    obj.image1 = theImage;
    
    return obj;
}

@end
