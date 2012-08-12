//
//  IASearchDisplayManager.m
//  iAlarm
//
//  Created by li shiyong on 12-8-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCLib.h"
#import "SearchDisplayManager.h"

@implementation SearchDisplayManager
@synthesize searchDisplayController, delegate;

#pragma mark - listContent

#define kListContentFileName     @"listContent.plist"
#define kMaxNumberOfListContent  200

static NSMutableArray	*listContent = nil; //所有实例，共用

- (void)clearCaches{
    [listContent release];
    listContent = nil;
}

- (NSMutableArray*)listContent
{	
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

- (NSMutableArray*)filteredListContent
{
	if (self->filteredListContent == nil) 
	{
		self->filteredListContent = [[NSMutableArray alloc] init];
	}
	return self->filteredListContent;
}

#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText
{
	[self.filteredListContent removeAllObjects]; // First clear the filtered array.
	
    if (searchText) {
        for (NSString *aContent in self.listContent)
        {
            NSComparisonResult result = [aContent compare:searchText 
                                                 options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) 
                                                   range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame){
                [self.filteredListContent addObject:aContent];
            }
        }
    }
}

#pragma mark -
#pragma mark UITableView data source and delegate methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 	return [self.filteredListContent count];
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
	
	cell.textLabel.text = [self.filteredListContent objectAtIndex:indexPath.row];
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	NSString *searchString = [self.filteredListContent objectAtIndex:indexPath.row];
	
	//相同，直接搜索
	if ([searchString isEqualToString:self.searchDisplayController.searchBar.text]) {
		//搜索状态
		//[self.searchDisplayController setActive:YES animated:YES];		
		
		//反选
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		
        //搜索状态-激活等待指示
		[self.searchDisplayController.searchBar setShowsSearchingView:YES];
        
		//执行搜索
        if ([delegate respondsToSelector:@selector(searchWithString:)]) 
            [delegate searchWithString:searchString];
		
        
	}else {//不相同，把选中的“提示字符串”显示到searchBar的文本框中
		self.searchDisplayController.searchBar.text = searchString;
	}
    
}

#pragma mark - UISearchBarDelegate Delegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	NSString *searchString = self.searchDisplayController.searchBar.text;
    if (searchString && [searchString stringByTrim].length > 0) {
        //搜索状态-激活等待指示
        [self.searchDisplayController.searchBar setShowsSearchingView:YES];
        
        //执行搜索
        if ([delegate respondsToSelector:@selector(searchWithString:)]) 
            [delegate searchWithString:searchString];
    }
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
	if ([self.delegate respondsToSelector:@selector(searchBarBookmarkButtonClicked:)]) {
		[self.delegate searchBarBookmarkButtonClicked:searchBar];
	}
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //搜索状态-激活等待指示
    [self.searchDisplayController setActive:NO animated:YES];
    [self.searchDisplayController.searchBar setShowsSearchingView:NO];
    
	if ([self.delegate respondsToSelector:@selector(cancelSearch)]) {
		[self.delegate cancelSearch];
	}
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self filterContentForSearchText:searchText];
}

#pragma mark - YCSearchDisplayDelegate

- (void)searchDisplayControllerDidEndSearch:(YCSearchDisplayController *)controller{
    //搜索状态-激活等待指示
    [self.searchDisplayController.searchBar setShowsSearchingView:NO];
    
    if ([self.delegate respondsToSelector:@selector(cancelSearch)]) {
		[self.delegate cancelSearch];
	}
}

#pragma mark -

- (void)dealloc{
    [self clearCaches];
    [filteredListContent release];
    [super dealloc];
}


@end
