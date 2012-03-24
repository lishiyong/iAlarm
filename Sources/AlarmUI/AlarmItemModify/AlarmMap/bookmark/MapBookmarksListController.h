//
//  MapBookmarkListViewController.h
//  iAlarm
//
//  Created by li shiyong on 10-12-5.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>

@class MapBookmark;
@protocol MapBookmarksListControllerDelegate;

@interface MapBookmarksListController : UITableViewController <NSFetchedResultsControllerDelegate>
{
	NSMutableArray* bookmarksList;
	id <MapBookmarksListControllerDelegate> delegate;
	
	UIBarButtonItem *cancelButton;
}

@property (nonatomic,retain,readonly) NSMutableArray* bookmarksList;
@property (nonatomic,assign) id <MapBookmarksListControllerDelegate> delegate; //为何使用assign？
@property (nonatomic,retain,readonly)  UIBarButtonItem *cancelButton;

@end

@protocol MapBookmarksListControllerDelegate

- (void)mapBookmarksListController:(MapBookmarksListController *)controller didChooseMapBookmark:(MapBookmark *)aBookmark;

@end