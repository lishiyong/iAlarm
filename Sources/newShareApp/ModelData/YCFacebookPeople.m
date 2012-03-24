//
//  Contact.m
//  TestShareApp
//
//  Created by li shiyong on 11-8-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YCFacebookPeople.h"


@implementation YCFacebookPeople
@synthesize identifier;
@synthesize pictureImage;
@synthesize name;
@synthesize localizedName;
@synthesize pictureUrl;
@synthesize gender;
@synthesize gettingPicture;

- (void)dealloc {
	[identifier release];
	[pictureImage release];
	[name release];
	[localizedName release];
	[pictureUrl release];
    [super dealloc];
}


- (void)loadPicture{
	gettingPicture = YES;
	@try {
			
		NSURL *url = [NSURL URLWithString:self.pictureUrl];
		NSData *data = [NSData dataWithContentsOfURL:url];
		UIImage *img  = [[[UIImage alloc] initWithData:data] autorelease];
		self.pictureImage = img;
		
		//NSLog(@"    成功！：%@",self.name);

		
	}
	@catch (NSException * e) {
		//NSLog(@"    失败！：%@ ",self.name);
		
	}
	gettingPicture = NO;
}

@end
