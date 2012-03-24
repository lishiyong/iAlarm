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
	
	IBOutlet YClocationServicesUsableAlert *locationServicesUsableAlert;  //测定位服务是否可用使用
	
	NSMutableArray *mapAnnotations;                         //地图标签集合
	NSMutableDictionary *mapAnnotationViews;                //地图标签集合
	NSMutableDictionary *circleOverlays;                     //警示圈集合


	IBOutlet MKMapView* mapView;            
	IBOutlet UIView  *maskView;                              //覆盖View
	IBOutlet UILabel *maskLabel;
	IBOutlet UIActivityIndicatorView *maskActivityIndicator;
	
	
	BOOL isFirstShow;                                       //第一次显示
	NSInteger lastSelectedAnnotionIndex;                    //最后选中的pin，alarms更新后，重新设定选中。－1没有被选中的
	BOOL pinsEditing;                                       //编辑状态,对应tableView的editing
	BOOL isApparing;                                        //本视图正在显示
	//BOOL isLocationWaiting;                                 //正在定位等待
	
	/////////////////////////////////////
	//地址反转
	MKReverseGeocoder *reverseGeocoderForUserLocation;
	NSMutableDictionary *reverseGeocodersForPin;
	MKPlacemark *placemarkForUserLocation;
	MKPlacemark *placemarkForPin;
	/////////////////////////////////////
	
	

	YCCalloutBar *toolbarFloatingView;                      //浮动工具条
	UIButton *mapsTypeButton;                
	UIButton *satelliteTypeButton;                   
	UIButton *hybridTypeButton;



	YCAnimateRemoveFileView *animateRemoveFileView;
    
    NSTimer *shineAnnotationTimer;   //闪烁图标
	id shineAnnotation;              //正在闪烁的annotation,为判断是否停止闪烁用
	
	BOOL isAlreadyAlertForInternet;      //第一次加载地图数据失败
	
	
	CALayer *focusBox;
	//CALayer *focusPoint;
	//MKPolygon *foucusOverlay;
	//MKPolygonView *foucusOverlay
	YCOverlayImage* foucusOverlay;

	
	NSTimer	*refreshPinLoopTimer;//刷新pin的refreshPinLoopTimer

    NSDate *lastUpdateDistanceTimestamp; //最后更新距离时间
	
}

@property (nonatomic,retain) IBOutlet YClocationServicesUsableAlert *locationServicesUsableAlert;
@property (nonatomic,retain,readonly) NSArray *alarms;

@property (nonatomic,retain,readonly) NSMutableArray *mapAnnotations;
@property (nonatomic,retain,readonly) NSMutableDictionary *mapAnnotationViews;
@property (nonatomic,retain,readonly) NSMutableDictionary *circleOverlays;

@property (nonatomic,retain)            IBOutlet MKMapView* mapView;
@property (nonatomic,retain)            IBOutlet UIView *maskView;
@property (nonatomic,retain)            IBOutlet UILabel *maskLabel;
@property (nonatomic,retain)            IBOutlet UIActivityIndicatorView *maskActivityIndicator;



/////////////////////////////////////
//地址反转
@property (nonatomic,retain)            MKPlacemark *placemarkForUserLocation;
@property (nonatomic,retain)            MKPlacemark *placemarkForPin;
@property (nonatomic,retain,readonly) NSMutableDictionary *reverseGeocodersForPin;
/////////////////////////////////////

@property (nonatomic,assign)            BOOL pinsEditing;


@property (nonatomic, retain,readonly) YCAnimateRemoveFileView *animateRemoveFileView;



//找到alarm的pin，使之居中
-(void)findAlarm:(IAAlarm*)alarm;


@property (nonatomic,retain)            IBOutlet YCCalloutBar *toolbarFloatingView;
@property (nonatomic,retain)            IBOutlet UIButton *mapsTypeButton;                
@property (nonatomic,retain)            IBOutlet UIButton *satelliteTypeButton;                   
@property (nonatomic,retain)            IBOutlet UIButton *hybridTypeButton;


@property (nonatomic,retain,readonly) NSTimer *shineAnnotationTimer;

@property(nonatomic, readonly)  CALayer *focusBox;
//@property(nonatomic, readonly)  CALayer *focusPoint;
//@property(nonatomic, readonly)  MKPolygon *foucusOverlay;
//@property(nonatomic, readonly)  YCOverlayImage* foucusOverlay;

@property(nonatomic, retain) NSDate *lastUpdateDistanceTimestamp;


//private
//恢复闪动的图标，进入后台时候调用
- (void)resetShinedIcon;
        

	
@end


