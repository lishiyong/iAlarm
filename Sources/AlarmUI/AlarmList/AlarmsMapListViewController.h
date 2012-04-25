//
//  AlarmsMapListViewController.h
//  iAlarm
//
//  Created by li shiyong on 11-2-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "YCPinAnnotationView.h"

@class YCOverlayImage;
@class YCAnnotation;
@class YCPageCurlButtonItem;
@class AlarmDetailTableViewController;
@class YCBarButtonItem;
@class YCTapHideBarView;
@class YClocationServicesUsableAlert;
@class YCCalloutBar;
@class YCAnimateRemoveFileView;
@class IAAlarm;
@interface AlarmsMapListViewController : UIViewController
<MKMapViewDelegate,MKReverseGeocoderDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate,YCPinAnnotationViewDelegete>{
	

    /////////////////////////////////////
    //
    IBOutlet YClocationServicesUsableAlert *locationServicesUsableAlert;  //测定位服务是否可用使用
	IBOutlet MKMapView* mapView;            
	IBOutlet UIView  *maskView;                              //覆盖View
	IBOutlet UILabel *maskLabel;
	IBOutlet UIActivityIndicatorView *maskActivityIndicator;
    /////////////////////////////////////
    //
	NSMutableArray *mapAnnotations;                         //地图标签集合
	NSMutableDictionary *mapAnnotationViews;                //地图标签集合
	NSMutableDictionary *circleOverlays;                     //警示圈集合
	/////////////////////////////////////
	//地址反转
	MKReverseGeocoder *reverseGeocoderForUserLocation;
	NSMutableDictionary *reverseGeocodersForPin;
	MKPlacemark *placemarkForUserLocation;
	MKPlacemark *placemarkForPin;
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
    BOOL isFirstShow;                                       //第一次显示
	NSInteger lastSelectedAnnotionIndex;                    //最后选中的pin，alarms更新后，重新设定选中。－1没有被选中的
	BOOL pinsEditing;                                       //编辑状态,对应tableView的editing
	BOOL isApparing;                                        //本视图正在显示
    BOOL isAlreadyAlertForInternet;                         //第一次加载地图数据失败
	////////////////////////////////////
    //刷新pin
	NSTimer	*refreshPinLoopTimer;
    ////////////////////////////////////
    //为了区别UIMapView固有的UITapGestureRecognizer
    UITapGestureRecognizer *tapMapViewGesture;
    UITapGestureRecognizer *tapCalloutViewGesture;          //为了点地图的标签，而不取消选中
    UILongPressGestureRecognizer *longPressGesture;
    ////////////////////////////////////
    //
    UIAlertView *checkNetAlert;
	
}

@property (nonatomic,retain) IBOutlet YClocationServicesUsableAlert *locationServicesUsableAlert;
@property (nonatomic,retain) IBOutlet MKMapView* mapView;
@property (nonatomic,retain) IBOutlet UIView *maskView;
@property (nonatomic,retain) IBOutlet UILabel *maskLabel;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *maskActivityIndicator;

@property (nonatomic,retain,readonly) NSMutableArray *mapAnnotations;
@property (nonatomic,retain,readonly) NSMutableDictionary *mapAnnotationViews;
@property (nonatomic,retain,readonly) NSMutableDictionary *circleOverlays;

@property (nonatomic,retain)            MKPlacemark *placemarkForUserLocation;
@property (nonatomic,retain)            MKPlacemark *placemarkForPin;
@property (nonatomic,retain,readonly) NSMutableDictionary *reverseGeocodersForPin;

@property (nonatomic,retain)            IBOutlet YCCalloutBar *toolbarFloatingView;
@property (nonatomic,retain)            IBOutlet UIButton *mapsTypeButton;                
@property (nonatomic,retain)            IBOutlet UIButton *satelliteTypeButton;                   
@property (nonatomic,retain)            IBOutlet UIButton *hybridTypeButton;

@property(nonatomic, readonly)  CALayer *focusBox;

@property (nonatomic, retain,readonly) YCAnimateRemoveFileView *animateRemoveFileView;


@end


