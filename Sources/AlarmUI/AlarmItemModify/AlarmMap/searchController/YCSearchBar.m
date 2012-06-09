//
//  YCSearchBar.m
//  TestSearchBar
//
//  Created by li shiyong on 10-12-1.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "YCSearchBarNotification.h"
#import "YCSearchBar.h"


@implementation YCSearchBar

@synthesize canResignFirstResponder, waiting = _waiting, originalPlaceholderString = _originalPlaceholderString;

//覆盖super
- (BOOL)resignFirstResponder
{
	if (self.canResignFirstResponder) 
	{
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        NSNotification *aNotif = [NSNotification 
                                  notificationWithName:YCSearchBarDidResignFirstResponderNotification
                                  object:self
                                  userInfo:[NSDictionary dictionaryWithObject:self forKey:YCSearchBarKey] ];
        [notificationCenter postNotification:aNotif];
        
		[self setSearchWaiting:NO]; //搜索状态-等待指示
		[self.delegate searchBarCancelButtonClicked:self];  //取消搜索
		[self.searchBarTextField resignFirstResponder];
		return [super resignFirstResponder];
	}
	
	return NO;
}

//覆盖super
- (BOOL)becomeFirstResponder{
	//if (self.hidden) 
    { //如果被被隐藏
		NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        NSNotification *aNotif = [NSNotification 
                                  notificationWithName:YCSearchBarDidBecomeFirstResponderNotification
                                  object:self
                                  userInfo:[NSDictionary dictionaryWithObject:self forKey:YCSearchBarKey] ];
        [notificationCenter postNotification:aNotif];
        
	}
	return [super becomeFirstResponder];
}


#pragma mark -
#pragma mark  设置搜索等待

-(id)searchBarTextField{
	if (searchBarTextField == nil ) {
		NSArray *subViews = [self subviews];
		for (NSInteger i=0; i<subViews.count; i++) {
			UIView *subView = [subViews objectAtIndex:i];
			if ([subView isKindOfClass:[UITextField class]]) {
				searchBarTextField = (UITextField *)subView;
				break;
			}
		}
	}
	[searchBarTextField retain];
	return searchBarTextField;
}


-(id) searchActivityIndicator{
	if (searchActivityIndicator == nil) {
		searchActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		searchActivityIndicator.hidesWhenStopped = YES;
		
		//CGSize textFieldSize = self.searchBarTextField.frame.size;
		//searchActivityIndicator.frame = CGRectMake(textFieldSize.width-19-6,6,19,19);
		//[self.searchBarTextField addSubview:self.searchActivityIndicator];
	}
    CGSize textFieldSize = self.searchBarTextField.frame.size;
    searchActivityIndicator.frame = CGRectMake(textFieldSize.width-19-6,6,19,19); //父view的大小有变化

	return searchActivityIndicator;
}

- (void)setSearchWaiting:(BOOL)Waiting{
    
    if (_waiting == Waiting) 
        return;
    
    if (Waiting) {
		self.searchBarTextField.clearButtonMode = UITextFieldViewModeNever;
		[self.searchBarTextField addSubview:self.searchActivityIndicator];
        self.searchActivityIndicator.hidden = NO;
        [self.searchActivityIndicator startAnimating];
        self.showsBookmarkButton = NO;
	}else {
		self.searchBarTextField.clearButtonMode = self->originalClearButtonMode;
        self.searchActivityIndicator.hidden = YES;
        [self.searchActivityIndicator stopAnimating];
        [self.searchActivityIndicator removeFromSuperview];
        self.showsBookmarkButton = _isOriginalShowsBookmarkButton;
    }
    
    _waiting = Waiting;
	
}


- (void)searchFieldReturnPressed{
	[self setSearchWaiting:YES]; //搜索状态-激活等待指示
	[self.delegate searchBarSearchButtonClicked:self];
}


-(void) awakeFromNib{

	//保留原始清除模式
	self->originalClearButtonMode = self.searchBarTextField.clearButtonMode;
	
	//缺省查询按钮事件绑定（点击后失去第一响应者）－删除
	NSArray *array = [self.searchBarTextField actionsForTarget:self forControlEvent:UIControlEventEditingDidEndOnExit];
	for (NSInteger i =0; i<array.count; i++) {
		void* action = [array objectAtIndex:i];
		[self.searchBarTextField removeTarget:self action:action forControlEvents:UIControlEventEditingDidEndOnExit];
	}
	
	//自定义绑定－加入
	[self.searchBarTextField addTarget:self action:@selector(searchFieldReturnPressed) forControlEvents:UIControlEventEditingDidEndOnExit];
	
	//保留原来的bookmark是否显示
    _isOriginalShowsBookmarkButton = self.showsBookmarkButton;
    
    _originalPlaceholderString = [self.placeholder copy];
}

- (void)dealloc 
{
	[searchBarTextField release];
	[searchActivityIndicator release];
    [_originalPlaceholderString release];
	[super dealloc];
}




@end
