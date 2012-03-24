//
//  FacebookData.m
//  TestShareApp
//
//  Created by li shiyong on 11-8-4.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YCFacebookPeople.h"
#import "YCFacebookGlobalData.h"

@implementation YCFacebookGlobalData

@synthesize resultMe;
@synthesize resultFriends;
@synthesize me;
@synthesize friends;

- (id)resultFriendArray{
	
	//无数据返回
	NSArray *theArray = [(NSDictionary*)self.resultFriends objectForKey:@"data"]; //FB的类约定“data”作为key
	
	if (self.resultFriends == nil || theArray == 0) {
		return [NSArray array];
	}
	
	return theArray;

}

- (id)checkedPeoples{
	if (checkedPeoples == nil) {
		checkedPeoples = [[NSMutableDictionary dictionary] retain];
	}
	return checkedPeoples;
}

- (id)checkedPeopleArray{
	//安装顺序放到放入数组
	NSMutableArray *array = [NSMutableArray array];
	if ([self.checkedPeoples objectForKey:self.me.identifier]) {
		[array addObject:self.me];
	}
	for (YCFacebookPeople* anFriend in self.friends) {
		if ([self.checkedPeoples objectForKey:anFriend.identifier]) {
			[array addObject:anFriend];
		}
	}
	return array;
}



- (id)friends{
	if (friends == nil) {
		friends = [[NSMutableArray array] retain];
	}
	return friends;
}
 

+ (YCFacebookGlobalData*)globalData{
	static YCFacebookGlobalData* obj = nil;
	if (obj == nil) {
		obj = [[YCFacebookGlobalData alloc] init];
		
        //[obj retain];
        //[obj autorelease]; //2012-3-15修改
	}
	
	return obj;
}


- (YCFacebookPeople*)parsePeople:(NSDictionary*)anPeople isGetPicture:(BOOL)isGetPicture{
	
	YCFacebookPeople *thePeople = [[[YCFacebookPeople alloc] init] autorelease];
	@try {
		thePeople.name = [anPeople objectForKey:@"name"];
		thePeople.localizedName = [anPeople objectForKey:@"name"];
		thePeople.identifier = [anPeople objectForKey:@"id"];
		thePeople.pictureUrl = [anPeople objectForKey:@"picture"];
		thePeople.gender = [(NSString*)[anPeople objectForKey:@"gender"] isEqualToString:@"male"] ? YES : NO;
		
		if (isGetPicture) {
			NSString *path = [anPeople objectForKey:@"picture"];
			NSURL *url = [NSURL URLWithString:path];
			NSData *data = [NSData dataWithContentsOfURL:url];
			UIImage *img  = [[[UIImage alloc] initWithData:data] autorelease];
			thePeople.pictureImage = img;
		}
	}
	@catch (NSException * e) {
		
	}
	@finally {
		
	}
	
	return thePeople;
}

- (void)parseMe{
	//先清空
	self.me = nil;

	if (!self.resultMe) 
		return;

	self.me = [self parsePeople:self.resultMe isGetPicture:YES];
}


- (void)parseFriends{
	//先清空
	//[self.friends removeAllObjects];

	if (!self.resultFriends) 
		return;
	
	NSArray *theArray = self.resultFriendArray;
	for (NSDictionary *theResult in theArray) {
		[self.friends addObject:[self parsePeople:theResult isGetPicture:NO]];
	}
	
}



- (void)dealloc {
	[resultMe release];
	[resultFriends release];
	[me release];
	[friends release];
    [super dealloc];
}


@end
