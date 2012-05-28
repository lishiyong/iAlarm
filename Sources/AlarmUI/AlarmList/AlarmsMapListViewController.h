//
//  AlarmsMapListViewController.h
//  iAlarm
//
//  Created by li shiyong on 11-2-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "IAPinAnnotationView.h"

@class YCOverlayImage;
@class IAAnnotation;
@class YCPageCurlButtonItem;
@class AlarmDetailTableViewController;
@class YCBarButtonItem;
@class YCTapHideBarView;
@class YClocationServicesUsableAlert;
@class YCCalloutBar;
@class YCAnimateRemoveFileView;
@class IAAlarm;
@interface AlarmsMapListViewController : UIViewController
<MKMapViewDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate,IAAnnotationViewDelegete>{
	

    /////////////////////////////////////
    //
	IBOutlet MKMapView* mapView;            
	IBOutlet UIView  *maskView;                                  //覆盖View
	IBOutlet UILabel *maskLabel;
	IBOutlet UIActivityIndicatorView *maskActivityIndicator;
    /////////////////////////////////////
    //
	NSMutableArray *mapPointAnnotations;                         //地图标签集合
	NSMutableDictionary *mapPointAnnotationViews;                //地图标签集合
	NSMutableDictionary *circleOverlays;                         //警示圈集合
	/////////////////////////////////////
    //浮动工具条
	YCCalloutBar *toolbarFloatingView;                      
	UIButton *mapsTypeButton;                
	UIButton *satelliteTypeButton;                   
	UIButton *hybridTypeButton;
    ////////////////////////////////////
    //动画聚焦
	CALayer *focusBox;
	YCOverlayImage* foucusOverlay;
    ////////////////////////////////////
    //删除时候显示的动画
	YCAnimateRemoveFileView *animateRemoveFileView;
    ////////////////////////////////////
    //标识变量
	BOOL pinsEditing;                                       //编辑状态,对应tableView的editing
    BOOL isAlreadyAlertForInternet;                         //第一次加载地图数据失败
    NSDate *viewLoadedDate;                                  //做为打开mask的标识
    ////////////////////////////////////
    //为了区别UIMapView固有的UITapGestureRecognizer
    UITapGestureRecognizer *tapMapViewGesture;
    UITapGestureRecognizer *tapCalloutViewGesture;          //为了点地图的标签，而不取消选中
    UILongPressGestureRecognizer *longPressGesture;
    ////////////////////////////////////
    //检测网络
    UIAlertView *checkNetAlert;
	
}

@property (nonatomic,retain) IBOutlet MKMapView* mapView;
@property (nonatomic,retain) IBOutlet UIView *maskView;
@property (nonatomic,retain) IBOutlet UILabel *maskLabel;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *maskActivityIndicator;

@property (nonatomic,retain,readonly) NSMutableArray *mapPointAnnotations;
@property (nonatomic,retain,readonly) NSMutableDictionary *mapPointAnnotationViews;
@property (nonatomic,retain,readonly) NSMutableDictionary *circleOverlays;

@property (nonatomic,retain)            IBOutlet YCCalloutBar *toolbarFloatingView;
@property (nonatomic,retain)            IBOutlet UIButton *mapsTypeButton;                
@property (nonatomic,retain)            IBOutlet UIButton *satelliteTypeButton;                   
@property (nonatomic,retain)            IBOutlet UIButton *hybridTypeButton;

@property(nonatomic, readonly)  CALayer *focusBox;

@property (nonatomic, retain,readonly) YCAnimateRemoveFileView *animateRemoveFileView;


@end


