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
	
	UITextField *searchBarTextField;  //searchbar上的TextField控件
	UITextFieldViewMode originalClearButtonMode;
	UIActivityIndicatorView *searchActivityIndicator;
    BOOL _waiting;
    BOOL _isOriginalShowsBookmarkButton;
}

@property(nonatomic,assign) BOOL canResignFirstResponder;

///////////////////////////////////////////
//设置搜索等待
@property(nonatomic,retain,readonly) UITextField *searchBarTextField;
@property(nonatomic,retain,readonly) UIActivityIndicatorView *searchActivityIndicator;
///////////////////////////////////////////

- (void)setSearchWaiting:(BOOL)Waiting;
@property (nonatomic,readonly,getter = isWaiting) BOOL waiting;

@property(nonatomic,copy) NSString *originalPlaceholderString;


@end
