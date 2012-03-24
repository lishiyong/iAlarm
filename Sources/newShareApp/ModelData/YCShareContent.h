//
//  YCShareData.h
//  iAlarm
//
//  Created by li shiyong on 11-8-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YCShareContent : NSObject {
	/*
	NSString *title;
	NSString *body;
	NSString *imageLink;  //在图床上的链接
	NSString *imageName;
	*/
	
	NSString *twitterMessage;
	NSString *mailMessage;
	NSString *mailTitle;
	
	NSString *mailImageName;
	NSString *imageNameFB;
	NSString *imageLinkFB;  //在图床上的链接－FB
	NSString *imageNameMB;
	NSString *imageLinkMB;  //在图床上的链接－微薄

}
/*
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *body;
@property(nonatomic, copy) NSString *imageLink;
@property(nonatomic, copy) NSString *imageName;
*/

@property(nonatomic, copy) NSString *twitterMessage;
@property(nonatomic, copy) NSString *mailMessage;
@property(nonatomic, copy) NSString *mailTitle;

@property(nonatomic, copy) NSString *mailImageName;
@property(nonatomic, copy) NSString *imageNameFB;
@property(nonatomic, copy) NSString *imageLinkFB;
@property(nonatomic, copy) NSString *imageNameMB;
@property(nonatomic, copy) NSString *imageLinkMB;  


+ (NSArray*)shareDataArray;
+ (YCShareContent*)randomObject;

+ (YCShareContent*)facebookShareContent;
+ (YCShareContent*)twitterShareContent;
+ (YCShareContent*)mailShareContent;
+ (YCShareContent*)messageShareContent;




@end
