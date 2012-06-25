//
//  AlarmPositionMapViewController.h
//  iArrived
//
//  Created by li shiyong on 10-10-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AlarmModifyViewController.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@class YCMapPointAnnotation, YCReverseGeocoder;

@interface AlarmPositionMapViewController : AlarmModifyViewController <MKMapViewDelegate,UIAlertViewDelegate>{
    
    BOOL _alreadyAlertForInternet;
    UIAlertView  *_checkNetAlert;
    
    YCMapPointAnnotation *_annotation;
    MKCircle     *_circleOverlay;
    YCReverseGeocoder *_geocoder;
}

@property (nonatomic,retain) IBOutlet MKMapView* mapView;
@property (nonatomic,assign) id<NSObject> delegate;

- (void)beginWork;

/**
 delegate method
 - (void)alarmPositionMapViewControllerDidPressDoneButton:(AlarmPositionMapViewController*)alarmPositionMapViewController;
 **/


@end
