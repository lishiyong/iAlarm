//
//  BackgroundViewController.h
//  TestNewIAlarmUI
//
//  Created by li shiyong on 11-6-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchDisplayManager.h"
#import "YCLib.h"
#import <UIKit/UIKit.h>

typedef enum {
    IAMapsViewController,
    IAListViewController
} IASwitchViewControllerType;

@protocol YCAlertTableViewDelegete, SearchDisplayManagerDelegate;
@class YCAlertTableView;
@class AlarmsListViewController;
@class AlarmsMapListViewController;
@class YCSearchBar;
@class YCForwardGeocoderManager;
@class IABookmarkManager;
@class YCSearchDisplayController;
@class SearchDisplayManager;

@interface BackgroundViewController : UIViewController
<UIAlertViewDelegate,SearchDisplayManagerDelegate,YCAlertTableViewDelegete> {

	AlarmsListViewController *listViewController;
	AlarmsMapListViewController *mapsViewController;
    IASwitchViewControllerType curViewControllerType; //做为标识
	//BOOL *isCurEditing;//当前是否是在编辑状态
	
	UIBarButtonItem *editButtonItem;
	UIBarButtonItem *doneButtonItem;
	UIBarButtonItem *addButtonItem;
	
	IBOutlet UISearchBar *searchBar;
    YCSearchDisplayController *ycSearchDisplayController;
    SearchDisplayManager *searchDisplayManager;
    YCAlertTableView *searchResultsAlert;
    UIAlertView *searchAlert;
    NSArray *searchResults;
    YCForwardGeocoderManager *forwardGeocoderManager;

    
	UIBarButtonItem *infoBarButtonItem;
	UIBarButtonItem *switchBarButtonItem;
	UIBarButtonItem *currentLocationBarButtonItem;
	UIBarButtonItem *focusBarButtonItem;
	UIBarButtonItem *mapTypeBarButtonItem;
	UIBarButtonItem *locationingBarItem;                    //显示正在定位的指示器的barItem

	UIView *animationBackgroundView;//地图、list都加到这个view上    
}


@property (nonatomic, retain) IBOutlet AlarmsListViewController *listViewController;
@property (nonatomic, retain) IBOutlet AlarmsMapListViewController *mapsViewController;

@property (nonatomic, retain, readonly) UIBarButtonItem *editButtonItem;
@property (nonatomic, retain, readonly) UIBarButtonItem *doneButtonItem;
@property (nonatomic, retain, readonly) UIBarButtonItem *addButtonItem;

@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet IABookmarkManager *bookmarkManager;

@property (nonatomic, retain, readonly) UIBarButtonItem *infoBarButtonItem;
@property (nonatomic, retain, readonly) UIBarButtonItem *switchBarButtonItem;
@property (nonatomic, retain, readonly) UIBarButtonItem *currentLocationBarButtonItem;
@property (nonatomic, retain, readonly) UIBarButtonItem *focusBarButtonItem;
@property (nonatomic, retain, readonly) UIBarButtonItem *mapTypeBarButtonItem;
@property (nonatomic, retain, readonly) UIBarButtonItem *locationingBarItem;

@property (nonatomic, retain) IBOutlet UIView *animationBackgroundView;

/**
 IABookmarkManager的delegate方法
 **/
-(void)resetAnnotationWithPlacemark:(YCPlacemark*)placemark;


@end
