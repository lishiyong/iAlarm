//
//  FacebookData.h
//  TestShareApp
//
//  Created by li shiyong on 11-8-4.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YCFacebookPeople;
@interface YCFacebookGlobalData : NSObject {

	NSDictionary *resultMe;
	NSDictionary *resultFriends;
	YCFacebookPeople *me;
	NSMutableArray *friends;
	NSMutableDictionary *checkedPeoples;
	
}


@property(nonatomic,retain) NSDictionary *resultMe;
@property(nonatomic,retain) NSDictionary *resultFriends;
@property(nonatomic,retain,readonly) NSArray *resultFriendArray; //resultFriends包含的数组

@property(nonatomic,retain) YCFacebookPeople *me;
@property(nonatomic,retain) NSMutableArray *friends;
@property(nonatomic,retain,readonly) NSMutableDictionary *checkedPeoples;

@property(nonatomic,retain,readonly) NSArray *checkedPeopleArray;//me,friend排序


- (void)parseMe;
- (void)parseFriends;


+ (YCFacebookGlobalData*)globalData;

	


@end
