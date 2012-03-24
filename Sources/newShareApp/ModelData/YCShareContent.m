//
//  YCShareData.m
//  iAlarm
//
//  Created by li shiyong on 11-8-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocalizedStringAbout.h"
#import "YCShareContent.h"


@implementation YCShareContent

/*
@synthesize title;
@synthesize body;
@synthesize imageLink;
@synthesize imageName;
*/

@synthesize twitterMessage;
@synthesize mailMessage;
@synthesize mailTitle; 

@synthesize mailImageName;
@synthesize imageNameFB;
@synthesize imageLinkFB;  
@synthesize imageNameMB;
@synthesize imageLinkMB;

- (void)dealloc {
	/*
	[title release];
	[body release];
	[imageLink release];
	[imageName release];
	*/
	
	[twitterMessage release];
	[mailMessage release];
	[mailTitle release];
	
	[mailImageName release];
	[imageNameFB release];
	[imageLinkFB release];  
	[imageNameMB release];
	[imageLinkMB release]; 
	
    [super dealloc];
}


#define kShareDataCount 1
+ (NSArray*)shareDataArray
{
	static NSMutableArray* array = nil;
	if (!array) 
	{
		/*
		NSString* titles[kShareDataCount] = 
		{
			KShareContentTitle000
		};
		
		NSString* bodys[kShareDataCount] = 
		{
			KShareContentBody000
		};
		
		NSString* imageLinks[kShareDataCount] = 
		{
			KShareContentImageLink000
		};
		
		
		NSString* imageNames[kShareDataCount] = 
		{
			KShareContentImageName000
		};
		 */
		
		NSString* twitterMessages[kShareDataCount] = 
		{
			KShareContentTwitterMessage
		};
		
		NSString* mailMessages[kShareDataCount] = 
		{
			KShareContentMailMessage
		};
		
		NSString* mailTitles[kShareDataCount] = 
		{
			KShareContentMailTitle
		};
		
		NSString* mailImageNames[kShareDataCount] = 
		{
			@"MailShareImage.jpg"
		};
		
		NSString* imageNameFBs[kShareDataCount] = 
		{
			@"MailShareImage.jpg"
		};
		
		NSString* imageLinkFBs[kShareDataCount] = 
		{
			@"http://i54.tinypic.com/317ff4p.png"
		};
		
		NSString* imageNameMBs[kShareDataCount] = 
		{
			@"MailShareImage.jpg"
		};
		
		NSString* imageLinkMBs[kShareDataCount] = 
		{
			@"http://i54.tinypic.com/317ff4p.png"
		};
		
		array = [[NSMutableArray array] retain];
		for (int i=0; i<kShareDataCount; i++) 
		{
			YCShareContent *obj = [[YCShareContent alloc] init];
			/*
			obj.title = titles[i];
			obj.body = bodys[i];
			obj.imageLink = imageLinks[i];
			obj.imageName = imageNames[i];
			*/
			
			obj.mailMessage = mailMessages[i];
			obj.mailTitle = mailTitles[i];
			
			obj.twitterMessage = twitterMessages[i];
			obj.mailImageName = mailImageNames[i];
			obj.imageNameFB = imageNameFBs[i];
			obj.imageLinkFB = imageLinkFBs[i];
			obj.imageNameMB = imageNameMBs[i];
			obj.imageLinkMB = imageLinkMBs[i];
			
			[array addObject:obj];
			[obj release];
		}
		
	}
	
	return array;
}

+ (YCShareContent*)randomObject{
	int x = arc4random() % kShareDataCount;
	return [[YCShareContent shareDataArray] objectAtIndex:x];
}

+ (YCShareContent*)facebookShareContent{
    return [YCShareContent randomObject];
}

+ (YCShareContent*)twitterShareContent{
    return [YCShareContent randomObject];
}
+ (YCShareContent*)mailShareContent{
    return [YCShareContent randomObject];
}
+ (YCShareContent*)messageShareContent{
    return [YCShareContent randomObject];
}

//kk aa


@end
