//
//  YCSearchBar.h
//  TestSearchBar
//
//  Created by li shiyong on 10-12-1.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YCSearchBar : UISearchBar 
{
	BOOL canResignFirstResponder;
	
	
	#pragma mark -
	#pragma mark  设置搜索等待
	UITextField *searchBarTextField;  //searchbar上的TextField控件
	UITextFieldViewMode originalClearButtonMode;
	UIActivityIndicatorView *searchActivityIndicator;
	
	//NSString *placeholderBackup;
}

@property(nonatomic,assign) BOOL canResignFirstResponder;

///////////////////////////////////////////
#pragma mark -
#pragma mark  设置搜索等待
@property(nonatomic,retain,readonly) UITextField *searchBarTextField;
- (void)setSearchWaiting:(BOOL)Waiting;
@property(nonatomic,retain,readonly) UIActivityIndicatorView *searchActivityIndicator;
///////////////////////////////////////////

//@property(nonatomic, copy) NSString *placeholderBackup;


@end
