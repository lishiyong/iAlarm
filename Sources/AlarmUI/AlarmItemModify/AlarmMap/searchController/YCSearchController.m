//
//  UISearchUtility.m
//  TestSearchBar
//
//  Created by li shiyong on 10-11-30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "YCLib.h"
#import "YCParam.h"
#import "YCSearchController.h"
#import "YCSearchBar.h"
#import "YCSearchDisplayController.h"
#import "UIUtility.h"
#import <QuartzCore/QuartzCore.h>


@implementation YCSearchController

@synthesize delegate;
@synthesize searchDisplayController;
@synthesize searchMaskView;
@synthesize searchTableView;
@synthesize originalSearchBarHidden;

#define kListContentFileName     @"listContent.plist"
#define kMaxNumberOfListContent  200

- (id)listContent
{
	static NSMutableArray	*listContent = nil; //所有实例，共用
	
	if (self->listContentCleared) { //如果清空过就重新读过
		self->listContentCleared = NO;
		[listContent release];
		listContent = nil;
	}
	
	if (listContent == nil) 
	{
		//先从文件中读出
		NSString *filePathName =  [[UIApplication sharedApplication].libraryDirectory stringByAppendingPathComponent:kListContentFileName];

		listContent = [(NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithFile:filePathName] retain];
		
		//读不到再创建新的
		if (listContent == nil)
			listContent = [[NSMutableArray alloc] init];
	}
	return listContent;
}


- (void)addListContentWithString:(NSString*)string
{
	BOOL result = NO;
	for (NSString *product in self.listContent)
	{
        result = [product isEqualToString:string];
		if (result)
		{
			break;
		}
	}
	if (!result) 
	{
		//判断最大list数量限制
		if (self.listContent.count >= kMaxNumberOfListContent) {
			//[self.listContent removeLastObject];
			[self.listContent removeObjectAtIndex:0];
		}
		[self.listContent addObject:string];
		
		
		//保存到文件
		NSString *filePathName =  [[UIApplication sharedApplication].libraryDirectory stringByAppendingPathComponent:kListContentFileName];

		[NSKeyedArchiver archiveRootObject:self.listContent toFile:filePathName];
	}
}

- (id)filteredListContent
{
	if (self->filteredListContent == nil) 
	{
		self->filteredListContent = [[NSMutableArray alloc] init];
	}
	return self->filteredListContent;
}

- (id) initWithDelegate:(id<YCSearchControllerDelegete>)theDelegate 
searchDisplayController:(UISearchDisplayController*) theSearchDisplayController
{
	if (self = [super init]) 
	{
		self.delegate = theDelegate;
		self.searchDisplayController = (YCSearchDisplayController*)theSearchDisplayController;
		theSearchDisplayController.searchBar.delegate = self;
		theSearchDisplayController.delegate = self;
		theSearchDisplayController.searchResultsDataSource = self;
		theSearchDisplayController.searchResultsDelegate = self;
		
		((YCSearchBar*)self.searchDisplayController.searchBar).originalPlaceholderString = theSearchDisplayController.searchBar.placeholder;
		self->originalSearchBarHidden = theSearchDisplayController.searchBar.hidden;
	}
	return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
	//[self.filteredListContent removeAllObjects];清除了，同时正在提示就会有麻烦
	
    [self.listContent removeAllObjects];
	self->listContentCleared = YES;  //置清空标识,不能放到removeAllObjects前面
}

- (void)dealloc
{

	[filteredListContent release];
	[searchMaskView release];
	[searchTableView release];

	
	[super dealloc];
}

-(void)setSearchBar:(UISearchBar*)searchBar visible:(BOOL)visible animated:(BOOL)animated
{
	[UIUtility setBar:searchBar topBar:YES visible:visible animated:animated animateDuration:0.3 animateName:@"showOrHideSearchBar"];
}


- (void)setActive:(BOOL)active animated:(BOOL)animated
{
	if (active) 
	{
		[self.searchDisplayController setActive:active animated:animated];
		
        /*
        if (self->originalSearchBarHidden) //显示或隐藏searchBar
		{
			[self setSearchBar:self.searchDisplayController.searchBar visible:active animated:NO]; 
			                                                   //animated:NO 
			                                                   //显示时候不用动画，maskView遮盖不了searchBar的背后区域
		}
         */
	}else {
        [self.searchDisplayController setActive:active animated:animated];
		
        /*
		if (self->originalSearchBarHidden) //显示或隐藏searchBar
		{
			[self setSearchBar:self.searchDisplayController.searchBar visible:active animated:animated]; 
		}
         */
		
		[self.filteredListContent removeAllObjects];
		
	}

}

- (void)setSearchWaiting:(BOOL)Waiting{
    [(YCSearchBar*)self.searchDisplayController.searchBar setSearchWaiting:Waiting];
}

- (BOOL)isWaiting{
    return [(YCSearchBar*)self.searchDisplayController.searchBar isWaiting];
}

#pragma mark -
#pragma mark UITableView data source and delegate methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger n = 0;
	if (self.searchDisplayController.active)
	{
		if (tableView == self.searchDisplayController.searchResultsTableView)
		{
			n = [self.filteredListContent count];
		}
		else
		{
			n = [self.listContent count];
		}
	}else {
		n = 0;
	}

	
	
	if (self.searchTableView) 
	{
		[self searchDisplayController:self.searchDisplayController willShowSearchResultsTableView:self.searchTableView];
		[self searchDisplayController:self.searchDisplayController didShowSearchResultsTableView:self.searchTableView];
	}

	
	return n;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID] autorelease];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
	}
	
	/*
	 If the requesting table view is the search display controller's table view, configure the cell using the filtered content, otherwise use the main list.
	 */

	NSString *searchString = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        searchString = [self.filteredListContent objectAtIndex:indexPath.row];
    }
	else
	{
        searchString = [self.listContent objectAtIndex:indexPath.row];
    }
	
	cell.textLabel.text = searchString;
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

	NSString *searchString = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        searchString = [self.filteredListContent objectAtIndex:indexPath.row];
    }
	else
	{
        searchString = [self.listContent objectAtIndex:indexPath.row];
    }
	
	//相同，直接搜索
	if ([searchString isEqualToString:self.searchDisplayController.searchBar.text]) {
		//结束搜索状态
		[self setActive:YES animated:YES];		
		
		//反选
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		
		[self setSearchWaiting:YES]; //搜索状态-激活等待指示

		//执行搜索
		[self.delegate searchController:self searchString:searchString];
		//[self.delegate performSelector:@selector(searchController:searchString:) withObject:self withObject:searchString];

	}else {//不相同，把选中的“提示字符串”显示到searchBar的文本框中
		self.searchDisplayController.searchBar.text = searchString;
	}

}


#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{

	[self.filteredListContent removeAllObjects]; // First clear the filtered array.
	
	for (NSString *product in self.listContent)
	{
		NSComparisonResult result = [product compare:searchText 
											 options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) 
											   range:NSMakeRange(0, [searchText length])];
		if (result == NSOrderedSame)
		{
			[self.filteredListContent addObject:product];
		}
	}
}




#pragma mark -
#pragma mark UISearchBarDelegate Delegate Methods



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	NSString *searchString = [self.searchDisplayController.searchBar.text copy]; 
	                                 //结束搜索状态,改变searchBar.text,所以copy

	//开始搜索状态
	[self setActive:YES animated:YES];

	//执行搜索
	[self.delegate searchController:self searchString:searchString];
	[searchString release];
	
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
	if ([self.delegate respondsToSelector:@selector(searchBarBookmarkButtonClicked:)]) 
	{
		[self.delegate searchBarBookmarkButtonClicked:searchBar];
	}
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	if ([self.delegate respondsToSelector:@selector(searchBarCancelButtonClicked:)]) 
	{
		[self.delegate searchBarCancelButtonClicked:searchBar];
	}
}



#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

/*
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{

}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{

}
*/


/*
- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{

	
}
 */

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{	
	[self setActive:NO animated:YES]; 
}



/////////////////////////////////////
//没有提示数据时候，隐藏搜索结果tableview
- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
	NSArray *array= self.searchDisplayController.searchContentsController.view.subviews;
	
	/////////////////////////////
	/////判断是否是maskview
	UIView * maskTmp =[array objectAtIndex:array.count-1];
	if ([maskTmp respondsToSelector:@selector(allControlEvents)]) 
	{
		UIControlEvents allEvents = [(UIControl*)maskTmp allControlEvents];
		if ((allEvents & UIControlEventTouchUpInside) == UIControlEventTouchUpInside) 
		{
			self.searchMaskView = maskTmp;
		}
	}
	/////////////////////////////
	
	self.searchTableView = tableView;
	tableView.separatorStyle =  UITableViewCellSeparatorStyleSingleLine;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
	if (!self.searchDisplayController.active)
	{
		tableView.hidden = YES ;
		//[self.searbarMaskView removeFromSuperview];
	}else {
		if (self.filteredListContent.count !=0 && self.searchDisplayController.searchBar.text.length > 0) 
		{
			tableView.hidden = NO ;
			if (self.searchDisplayController.searchContentsController.view == self.searchMaskView.superview)
				[self.searchMaskView removeFromSuperview];
		}else {
			tableView.hidden = YES;
			if (self.searchDisplayController.searchContentsController.view != self.searchMaskView.superview)
				[self.searchDisplayController.searchContentsController.view addSubview:self.searchMaskView];
		}
	}

}
//没有提示数据时候，隐藏搜索结果view
/////////////////////////////////////





@end
