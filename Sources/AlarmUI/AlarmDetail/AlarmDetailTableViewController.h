//
//  DetailTableViewController.h
//  TestLocationTableCell1
//
//  Created by li shiyong on 10-12-16.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

typedef enum {
	IALocatingAndReversingStatusNone,      //无操作
	IALocatingAndReversingStatusLocating,  //正在定位
	IALocatingAndReversingStatusReversing  //正在反转
} IALocatingAndReversingStatus;

@class YCSoundPlayer;
@class AlarmDetailFooterView;
@class IAAlarm;
@class TableViewCellDescription;
@class CellHeaderView;
@class YClocationServicesUsableAlert;
@interface AlarmDetailTableViewController : UITableViewController
<CLLocationManagerDelegate,MKReverseGeocoderDelegate,AVAudioPlayerDelegate,UIAlertViewDelegate>
{
	YClocationServicesUsableAlert *locationServicesUsableAlert;  //测定位服务用
	
	BOOL newAlarm;
	IAAlarm *alarm;
	IAAlarm *alarmTemp;
	
	UIBarButtonItem *cancelButtonItem;
	UIBarButtonItem *saveButtonItem;
    UIButton *testAlarmButton;
	
	NSArray *cellDescriptions;

	TableViewCellDescription *enabledCellDescription;            //启用状态;
	TableViewCellDescription *repeatCellDescription;              //重复;
	TableViewCellDescription *soundCellDescription;               //声音;
	TableViewCellDescription *vibrateCellDescription;             //振动;
	TableViewCellDescription *nameCellDescription;                //名字;
	TableViewCellDescription *radiusCellDescription;              //警示半径
	TableViewCellDescription *triggerCellDescription;             //警示触发条件
	TableViewCellDescription *destionationCellDescription;        //目的地
    TableViewCellDescription *notesCellDescription;               //备注
	

	CLLocationManager *locationManager;
	MKReverseGeocoder *reverseGeocoder;
	CLLocation *bestEffortAtLocation;
	MKPlacemark *placemarkForReverse;
	CLLocationCoordinate2D coordinateForReverse;                  //
	
	IALocatingAndReversingStatus locatingAndReversingStatus;    
	
	NSString  *titleForFooter;  //页脚，用于界面提示
    AlarmDetailFooterView *footerView;
    
	BOOL endingManual;          //手动结束定位或反转的标志
	
	BOOL isFirstShow;

    NSDate *lastUpdateDistanceTimestamp; //最后更新距离时间
    
    YCSoundPlayer *vibratePlayer;
	AVAudioPlayer *ringplayer;

}
@property (nonatomic,retain) YClocationServicesUsableAlert *locationServicesUsableAlert;

@property(nonatomic,retain) IAAlarm *alarm;
@property(nonatomic,retain) IAAlarm *alarmTemp;
@property(nonatomic,assign) BOOL newAlarm;

@property(nonatomic,retain,readonly) UIBarButtonItem *cancelButtonItem;
@property(nonatomic,retain,readonly) UIBarButtonItem *saveButtonItem;
@property(nonatomic,retain,readonly) UIButton *testAlarmButton;

@property(nonatomic,retain) NSArray *cellDescriptions;   
@property(nonatomic,retain) TableViewCellDescription *enabledCellDescription;
@property(nonatomic,retain) TableViewCellDescription *repeatCellDescription;
@property(nonatomic,retain) TableViewCellDescription *soundCellDescription;
@property(nonatomic,retain) TableViewCellDescription *vibrateCellDescription;
@property(nonatomic,retain) TableViewCellDescription *nameCellDescription;
@property(nonatomic,retain) TableViewCellDescription *radiusCellDescription; 
@property(nonatomic,retain) TableViewCellDescription *triggerCellDescription;
@property(nonatomic,retain) TableViewCellDescription *destionationCellDescription;
@property(nonatomic,retain) TableViewCellDescription *notesCellDescription;

@property (nonatomic,retain,readonly) CLLocationManager *locationManager;
@property (nonatomic,retain) CLLocation *bestEffortAtLocation;
@property (nonatomic,retain) MKPlacemark *placemarkForReverse;

@property (nonatomic,retain) NSString  *titleForFooter;
@property (nonatomic,retain) AlarmDetailFooterView *footerView;

@property(nonatomic, retain) NSDate *lastUpdateDistanceTimestamp;


@property (nonatomic,retain,readonly) YCSoundPlayer *vibratePlayer;
@property (nonatomic,retain) AVAudioPlayer *ringplayer;


-(IBAction)cancelButtonItemPressed:(id)sender;
-(IBAction)saveButtonItemPressed:(id)sender;

-(void)beginReverse;
-(void)endReverse;
-(void)beginLocation;
-(void)endLocation;

@end
