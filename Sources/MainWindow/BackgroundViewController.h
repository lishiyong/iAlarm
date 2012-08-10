//
//  BackgroundViewController.h
//  TestNewIAlarmUI
//
//  Created by li shiyong on 11-6-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YCLib.h"
#import "YCSearchController.h"
#import <UIKit/UIKit.h>

typedef enum {
    IAMapsViewController,
    IAListViewController
} IASwitchViewControllerType;

@protocol YCAlertTableViewDelegete;
@class YCAlertTableView;
@class AlarmsListViewController;
@class AlarmsMapListViewController;
@class YCSearchBar;
@class YCForwardGeocoderManager;
@class IABookmarkManager;

@interface BackgroundViewController : UIViewController
<UIAlertViewDelegate,YCSearchControllerDelegete,YCAlertTableViewDelegete> {

	AlarmsListViewController *listViewController;
	AlarmsMapListViewController *mapsViewController;
    IASwitchViewControllerType curViewControllerType; //做为标识
	//BOOL *isCurEditing;//当前是否是在编辑状态
	
	UIBarButtonItem *editButtonItem;
	UIBarButtonItem *doneButtonItem;
	UIBarButtonItem *addButtonItem;
	
	IBOutlet YCSearchBar *searchBar;
	YCSearchController *searchController;
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

@property (nonatomic, retain) IBOutlet YCSearchBar *searchBar;
@property (nonatomic, retain) YCSearchController *searchController;
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
