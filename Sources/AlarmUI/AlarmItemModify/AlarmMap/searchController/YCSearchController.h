//
//  UISearchUtility.h
//  TestSearchBar
//
//  Created by li shiyong on 10-11-30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YCSearchDisplayController;
@class YCSearchController;
@protocol YCSearchControllerDelegete <NSObject>

@required
 
- (void)searchController:(YCSearchController *)controller searchString:(NSString *)searchString;
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar;

@optional
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar;
- (void)searchController:(YCSearchController *)controller addressDictionary:(NSDictionary *)addressDictionary addressTitle:(NSString *) addressTitle;

@end

@interface YCSearchController : UIViewController 
<UISearchDisplayDelegate, UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
	id<YCSearchControllerDelegete> delegate;
	YCSearchDisplayController *searchDisplayController;  //重新设置父类的这个属性
	
	NSMutableArray	*filteredListContent;	// The content filtered as a result of a search.

	UIView *searchMaskView;
	UITableView *searchTableView;
	BOOL originalSearchBarHidden;
	
	BOOL listContentCleared;  //收到内存警告，清空过

}

@property(nonatomic,assign) id<YCSearchControllerDelegete> delegate;
@property(nonatomic,retain) YCSearchDisplayController *searchDisplayController;

@property(nonatomic,retain,readonly) NSMutableArray *listContent;
@property(nonatomic,retain,readonly) NSMutableArray *filteredListContent;

@property(nonatomic,retain) UIView *searchMaskView;
@property(nonatomic,retain) UITableView *searchTableView;
@property(nonatomic,assign) BOOL originalSearchBarHidden;


- (id) initWithDelegate:(id<YCSearchControllerDelegete>)theDelegate 
searchDisplayController:(UISearchDisplayController*) theSearchDisplayController;

//激活或退出搜索
- (void)setActive:(BOOL)visible animated:(BOOL)animated;

- (void)addListContentWithString:(NSString*)string;

//设置搜索等待
- (void)setSearchWaiting:(BOOL)Waiting;
@property (nonatomic,readonly,getter = isWaiting) BOOL waiting;





@end
