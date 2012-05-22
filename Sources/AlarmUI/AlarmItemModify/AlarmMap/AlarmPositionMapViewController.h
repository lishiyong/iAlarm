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

@interface AlarmPositionMapViewController : AlarmModifyViewController 
<MKMapViewDelegate,MKReverseGeocoderDelegate,BSForwardGeocoderDelegate,UIAlertViewDelegate,YCSearchControllerDelegete,YCAlertTableViewDelegete>
{
	IBOutlet YClocationServicesUsableAlert *locationServicesUsableAlert;  //测定位服务用
	
	/////////////////////////////////////
	//地址反转
	MKReverseGeocoder *reverseGeocoder;
	MKPlacemark *placemarkForUserLocation; 
	MKPlacemark *placemarkForPin;
	/////////////////////////////////////
	
	BSForwardGeocoder *forwardGeocoder;
	YCSearchController *searchController;
    NSArray *searchResults;

	
	IBOutlet MKMapView* mapView;            
	IBOutlet UIControl *maskView;                           //覆盖View
	IBOutlet UIControl *curlView;                           //地图卷起后，显示的view
	IBOutlet YCTapHideBarView *curlbackgroundView;                 //maskView,curlView的背景view。做卷起动画时候需要;隐藏toolbar用
	IBOutlet UIImageView *curlImageView;                    //地图卷起后,curlView的背景,设这个变量为了autosize用
	IBOutlet UISearchBar *searchBar;
	IBOutlet UIToolbar *toolbar;
	IBOutlet UISegmentedControl *mapTypeSegmented;          //curlView上的按钮控件
	IBOutlet UIBarButtonItem *currentLocationBarItem;       //地图转到－>当前位置
	IBOutlet UIBarButtonItem *currentPinBarItem;            //地图转到－>当前图钉
	IBOutlet UIBarButtonItem *searchBarItem;                //显示搜索bar
	IBOutlet UIBarButtonItem *resetPinBarItem;              //重放当前图钉
	IBOutlet YCBarButtonItem *pageCurlBarItem;              //卷起地图
	UIBarButtonItem *locationingBarItem;                    //显示正在定位的指示器的barItem

	
	BOOL newAlarmAnnotation;    //显示时候，新创建AlarmAnnotation标识
	BOOL isFirstShow;             //第一次显示
	//BOOL isAlreadyCenterCoord;    //中心坐标是否准备好
	BOOL isCurl;                  //是否已经半卷
	BOOL isNotificationsRegistered; //通知是否已经注册
    BOOL isAlreadyAlertForInternet;

	
	IAAnnotation *annotationAlarmEditing;     //编辑中的Alarm的annotation

	
	//BOOL isRegionWithUserLocation ; //是否用设备位置作为中心;变量用于等待地图定位异步处理
	//id annotationSelecting;         //将要被选中的annotion;用在第一次显示,不用释放！
	
	MKCircle *circleOverlay;
	
	IBOutlet UIBarButtonItem *openToolbarBarItem;            //显示浮动工具条按钮
	IBOutlet YCCalloutBar *toolbarFloatingView;              //浮动工具条
	IBOutlet UIButton *mapsTypeButton;                
	IBOutlet UIButton *satelliteTypeButton;                   
	IBOutlet UIButton *hybridTypeButton;
	
    
    NSDate *lastUpdateDistanceTimestamp; //最后更新距离时间
    ////////////////////////////////////
    //
    UIAlertView *checkNetAlert;
    YCAlertTableView *searchResultsAlert;
    UIAlertView *searchAlert;


}
@property (nonatomic,retain) IBOutlet YClocationServicesUsableAlert *locationServicesUsableAlert;

@property (nonatomic,retain) IBOutlet MKMapView* mapView;
@property (nonatomic,retain) IBOutlet UIControl *maskView;
@property (nonatomic,retain) IBOutlet UIControl *curlView;
@property (nonatomic,retain) IBOutlet YCTapHideBarView *curlbackgroundView;
@property (nonatomic,retain) IBOutlet UIImageView *curlImageView;
@property (nonatomic,retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic,retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic,retain) IBOutlet UISegmentedControl *mapTypeSegmented;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *currentLocationBarItem;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *currentPinBarItem;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *searchBarItem;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *resetPinBarItem;
@property (nonatomic,retain) IBOutlet YCBarButtonItem *pageCurlBarItem;
@property (nonatomic,retain,readonly) UIBarButtonItem *locationingBarItem;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *openToolbarBarItem;
               

/////////////////////////////////////
//地址反转
@property (nonatomic,retain) MKPlacemark *placemarkForUserLocation;
@property (nonatomic,retain) MKPlacemark *placemarkForPin;
/////////////////////////////////////

@property (nonatomic,retain,readonly) BSForwardGeocoder *forwardGeocoder;
@property (nonatomic,retain) YCSearchController *searchController;
@property (nonatomic,assign) BOOL newAlarmAnnotation;
@property (nonatomic,retain) IAAnnotation *annotationAlarmEditing;

@property (nonatomic,retain) MKCircle *circleOverlay;

@property (nonatomic,retain)            IBOutlet YCCalloutBar *toolbarFloatingView;
@property (nonatomic,retain)            IBOutlet UIButton *mapsTypeButton;                
@property (nonatomic,retain)            IBOutlet UIButton *satelliteTypeButton;                   
@property (nonatomic,retain)            IBOutlet UIButton *hybridTypeButton;
@property(nonatomic, retain) NSDate *lastUpdateDistanceTimestamp;



-(IBAction)currentLocationButtonPressed:(id)sender;
-(IBAction)resetPinButtonPressed:(id)sender;
-(IBAction)currentPinButtonPressed:(id)sender;
-(IBAction)searchButtonPressed:(id)sender;
-(IBAction)pageCurlButtonPressed:(id)sender;
-(IBAction)mapTypeSegmentedChanged:(id)sender;
-(IBAction)openToolbarBarItemPressed:(id)sender;


/////////////////////////////////////////////
//private函数
////显示覆盖视图
-(void)showMaskView;
////关掉覆盖视图
-(void)animateCloseMaskView;

-(void)beginReverseWithAnnotation:(id<MKAnnotation>)annotation;
-(void)endReverseWithAnnotation:(id<MKAnnotation>)annotation;

-(void)endUpdateUserLocation;

-(void)updateAnnotationAlarmEditing;

/////////////////////////////////////////////


@end
