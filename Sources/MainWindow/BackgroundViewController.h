//
//  BackgroundViewController.h
//  TestNewIAlarmUI
//
//  Created by li shiyong on 11-6-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YCAlertTableView.h"
#import "BSForwardGeocoder.h"
#import "YCSearchController.h"
#import <UIKit/UIKit.h>

@protocol YCAlertTableViewDelegete;
@class YCAlertTableView;
@class AlarmsListViewController;
@class AlarmsMapListViewController;
@class YCSearchBar;

@interface BackgroundViewController : UIViewController
<UIAlertViewDelegate,BSForwardGeocoderDelegate,YCSearchControllerDelegete,YCAlertTableViewDelegete> {

	AlarmsListViewController *listViewController;
	AlarmsMapListViewController *mapsViewController;
	UIViewController *curViewController;
	//BOOL *isCurEditing;//当前是否是在编辑状态
	
	UIBarButtonItem *editButtonItem;
	UIBarButtonItem *doneButtonItem;
	UIBarButtonItem *addButtonItem;
	
	IBOutlet YCSearchBar *searchBar;
	BSForwardGeocoder *forwardGeocoder;
	YCSearchController *searchController;
    YCAlertTableView *searchResultsAlert;
    UIAlertView *searchAlert;
    
	UIToolbar *toolbar;
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
@property (nonatomic, retain) UIViewController *curViewController;

@property (nonatomic, retain, readonly) UIBarButtonItem *editButtonItem;
@property (nonatomic, retain, readonly) UIBarButtonItem *doneButtonItem;
@property (nonatomic, retain, readonly) UIBarButtonItem *addButtonItem;

@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) IBOutlet YCSearchBar *searchBar;
@property (nonatomic, retain,readonly) BSForwardGeocoder *forwardGeocoder;
@property (nonatomic, retain) YCSearchController *searchController;


@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain, readonly) UIBarButtonItem *infoBarButtonItem;
@property (nonatomic, retain, readonly) UIBarButtonItem *switchBarButtonItem;
@property (nonatomic, retain, readonly) UIBarButtonItem *currentLocationBarButtonItem;
@property (nonatomic, retain, readonly) UIBarButtonItem *focusBarButtonItem;
@property (nonatomic, retain, readonly) UIBarButtonItem *mapTypeBarButtonItem;
@property (nonatomic, retain, readonly) UIBarButtonItem *locationingBarItem;

@property (nonatomic, retain) IBOutlet UIView *animationBackgroundView;



@end
