//
//  YCSearchDisplayController.m
//  iAlarm
//
//  Created by li shiyong on 10-12-1.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "YCSearchDisplayController.h"
#import "YCSearchBar.h"


@implementation YCSearchDisplayController

//@synthesize searchBar;
@synthesize lastSearchString;
@synthesize originalPlaceholderString;


- (void)dealloc
{
	
	[lastSearchString release];
	[originalPlaceholderString release];
	
	[super dealloc];
}

/////////////////////////////////////
//退出搜索时候，保持最后搜索字符串在 bar上
- (void)setActive:(BOOL)visible animated:(BOOL)animated
{
	if (visible) 
	{
		[super setActive:visible animated:animated];
		[self.searchBar becomeFirstResponder];
		((YCSearchBar*)self.searchBar).canResignFirstResponder = NO;
		
		self.searchBar.text = self.lastSearchString;
		self.searchBar.placeholder = self.originalPlaceholderString;
	}else {
		if (self.searchBar.text !=nil && [self.searchBar.text length] >0) 
		{
			self.lastSearchString = self.searchBar.text;
			self.searchBar.placeholder = lastSearchString;
		}else {
			self.lastSearchString = nil;
		}
		self.searchBar.text = nil;

		[super setActive:visible animated:animated];
		((YCSearchBar*)self.searchBar).canResignFirstResponder = YES;
		[self.searchBar resignFirstResponder];
	}

}
//退出搜索时候，保持最后搜索字符串在 bar上
/////////////////////////////////////


/*
-(void)setSearchBar:(id)theSearchBar{
	//[super setSearchBar:theSearchBar];
}
*/


@end
