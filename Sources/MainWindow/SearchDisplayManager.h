//
//  IASearchDisplayManager.h
//  iAlarm
//
//  Created by li shiyong on 12-8-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCLib.h"
#import <Foundation/Foundation.h>

@class YCSearchDisplayController;
@protocol SearchDisplayManagerDelegate;

@interface SearchDisplayManager : NSObject<YCSearchDisplayDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray	*filteredListContent;
}

@property (nonatomic, assign) YCSearchDisplayController         *searchDisplayController;
@property (nonatomic, assign) id<SearchDisplayManagerDelegate>  delegate;

- (void)clearCaches;
- (void)addListContentWithString:(NSString*)string;

@end


@protocol SearchDisplayManagerDelegate <NSObject>

@optional

- (void)searchWithString:(NSString *)searchString;
- (void)searchWithaddressDictionary:(NSDictionary *)addressDictionary personName:(NSString *) personName personId:(int32_t)personId;
- (void)cancelSearch;
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar;

@end