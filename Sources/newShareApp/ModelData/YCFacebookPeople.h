//
//  Contact.h
//  TestShareApp
//
//  Created by li shiyong on 11-8-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YCFacebookPeople : NSObject {
	NSString *identifier;
	UIImage *pictureImage;
	NSString *name;
	NSString *localizedName;
	NSString *pictureUrl;
	BOOL gender;//性别 YES ＝ male，NO = female
	
	BOOL gettingPicture;

}

@property(copy) NSString *identifier;
@property(retain) UIImage *pictureImage;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *localizedName;
@property(copy) NSString *pictureUrl;
@property(nonatomic, assign) BOOL gender;
@property(assign,readonly) BOOL gettingPicture;


- (void)loadPicture;


@end
