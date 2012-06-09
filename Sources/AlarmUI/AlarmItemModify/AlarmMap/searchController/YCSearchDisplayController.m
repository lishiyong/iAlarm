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

/////////////////////////////////////
//退出搜索时候，保持最后搜索字符串在 bar上
- (void)setActive:(BOOL)active animated:(BOOL)animated
{
    if (self.active == active) 
        return;
        
    YCSearchBar *mySearchBar = (YCSearchBar*)self.searchBar;
    if (active) 
	{
		[super setActive:active animated:animated];
		[mySearchBar becomeFirstResponder];
		mySearchBar.canResignFirstResponder = NO;
		
        if (_searchStringBackup && (mySearchBar.text == nil || mySearchBar.text.length == 0)) 
            mySearchBar.text = _searchStringBackup;
        mySearchBar.placeholder = mySearchBar.originalPlaceholderString;
        
	}else {
		if (mySearchBar.text !=nil && [mySearchBar.text length] >0) 
		{
			mySearchBar.placeholder = mySearchBar.text;
		}else {
			mySearchBar.placeholder = mySearchBar.originalPlaceholderString;
		}
        _searchStringBackup = [mySearchBar.text copy];
		mySearchBar.text = nil;
        
		[super setActive:active animated:animated];
		mySearchBar.canResignFirstResponder = YES;
		[mySearchBar resignFirstResponder];
	}

}
//退出搜索时候，保持最后搜索字符串在 bar上
/////////////////////////////////////

- (void)dealloc{
    [_searchStringBackup release];
    [super dealloc];
}


@end
