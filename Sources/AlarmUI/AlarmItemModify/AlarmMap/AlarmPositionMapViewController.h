//
//  AlarmPositionMapViewController.h
//  iArrived
//
//  Created by li shiyong on 10-10-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "YCAlertTableView.h"
#import "AlarmModifyViewController.h"
#import "BSForwardGeocoder.h"
#import "YCSearchController.h"
#import "MapBookmarksListController.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@protocol YCAlertTableViewDelegete;
@class YCBarButtonItem;
@class IAAnnotation;
@class AlarmNameViewController;
@class YCTapHideBarView;
@class YCAlertTableView;
@class YClocationServicesUsableAlert;
@class YCCalloutBar;



@interface AlarmPositionMapViewController : AlarmModifyViewController <MKMapViewDelegate,UIAlertViewDelegate>{
    BOOL _alreadyAlertForInternet;
    UIAlertView  *_checkNetAlert;
    IAAnnotation *_annotation;
    MKCircle     *_circleOverlay;
    
    
}

@property (nonatomic,retain) IBOutlet MKMapView* mapView;
@property (nonatomic,assign) id<NSObject> delegate;

/**
 - (void)alarmPositionMapViewControllerDidPressDoneButton:(AlarmPositionMapViewController*)alarmPositionMapViewController;
 **/


@end
