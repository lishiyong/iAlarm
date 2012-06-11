//
//  YCAlarmEntity.h
//  iArrived
//
//  Created by li shiyong on 10-10-15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IAAlarmRadiusType.h"
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>

//闹钟列表改变，包括：增，改，删
extern NSString *IAAlarmsDataListDidChangeNotification;


#define    kalarmId                 @"kalarmId"
#define    kalarmName               @"kalarmName"
#define    knameChanged             @"knameChanged"

#define    kposition                @"kposition"
#define    kpositionShort           @"kpositionShort"
#define    kpositionTitle           @"kpositionTitle"
#define    kusedCoordinateAddress   @"kusedCoordinateAddress"
#define    kcoordinate              @"kcoordinate"
#define    kvisualCoordinate        @"kvisualCoordinate"
#define    klocationAccuracy        @"klocationAccuracy"

#define    kenabling                @"kenabling"
#define    kasoundId                @"kasoundId"
#define    karepeatTypeId           @"karepeatTypeId"
#define    kavehicleTypeId          @"kavehicleTypeId"
#define    kradius                  @"kradius"


#define    ksortId                  @"ksortId"
#define    kvibration               @"kvibration"
#define    kring                    @"kring"
#define    kdescription             @"kdescription"
#define    kpositionTypeId          @"kpositionTypeId"

#define    kreserve1                @"kreserve1"
#define    kreserve2                @"kreserve2"
#define    kreserve3                @"kreserve3"

#define    kplacemark               @"kplacemark"
#define    kPersonId                @"kPersonId"

@class IASaveInfo;
@class YCSound, YCRepeatType, YCPositionType;
@class YCPlacemark;
@interface IAAlarm : NSObject <NSCoding, NSCopying> {
	
	NSString *alarmId;         
	NSString *alarmName;
	BOOL nameChanged;                        //闹钟名字是否被用户自己修改过  

	NSString *position;                      //地点
	NSString *positionShort;                 //短地点
    NSString *positionTitle;                 //地点标题，2012-5-28添加
	BOOL      usedCoordinateAddress;         //使用的是坐标地址：没有反转成功
	CLLocationCoordinate2D realCoordinate;       //坐标
    CLLocationCoordinate2D visualCoordinate;
	CLLocationAccuracy locationAccuracy;     //定位时候的精度
	
	BOOL enabled;                           //启用状态
	YCSound *sound;                          //声音
	YCRepeatType *repeatType;                //重复类型，一次，二次，永远
	IAAlarmRadiusType *alarmRadiusType;      //公交，地铁等等
	NSString *soundId;
	NSString *repeatTypeId;
	NSString *alarmRadiusTypeId;
	CLLocationDistance radius;               //半径

	
	NSUInteger sortId;                       //排序，用于界面显示            --目前未使用
	BOOL vibrate;                            //是否震动                    --目前未使用
	BOOL ring;                               //是否静音                    --目前未使用
	YCPositionType *positionType;            //位置类型 当前位置，地图指定位置。--使用作为“触发警告的类型”
	NSString *positionTypeId;                //                          --目前未使用
	NSString *notes;                         //描述                       --使用2012-2-23
	
	NSString *reserve1;                      //作为addressTitle，为alarmName临时存储
	NSString *reserve2;
	NSString *reserve3;
    
    YCPlacemark *placemark;                  //地点标题，2012-5-28添加
    ABRecordID personId;                     //通讯录中的联系人id，2012-6-11添加

}

@property (nonatomic,copy) NSString *alarmId;
@property (nonatomic,copy) NSString *alarmName;
@property (nonatomic,assign) BOOL nameChanged;

@property (nonatomic,copy) NSString *position;
@property (nonatomic,copy) NSString *positionShort;
@property (nonatomic,copy) NSString *positionTitle;
@property (nonatomic,assign) BOOL      usedCoordinateAddress;
@property (nonatomic,assign) CLLocationCoordinate2D realCoordinate;
@property (nonatomic,assign) CLLocationCoordinate2D visualCoordinate;
@property (nonatomic,assign) CLLocationAccuracy locationAccuracy;

@property (nonatomic,assign) BOOL enabled;
@property (nonatomic,retain) YCSound *sound;
@property (nonatomic,retain) YCRepeatType *repeatType;
@property (nonatomic,retain) IAAlarmRadiusType *alarmRadiusType;
@property (nonatomic,retain) NSString *soundId;
@property (nonatomic,retain) NSString *repeatTypeId;
@property (nonatomic,retain) NSString *alarmRadiusTypeId;
@property (nonatomic,assign) CLLocationDistance radius;


@property (nonatomic,assign) NSUInteger sortId;
@property (nonatomic,assign) BOOL vibrate;
@property (nonatomic,assign) BOOL ring;
@property (nonatomic,retain) YCPositionType *positionType;
@property (nonatomic,copy) NSString *positionTypeId;
@property (nonatomic,copy) NSString *notes;

@property (nonatomic,copy) NSString *reserve1;
@property (nonatomic,copy) NSString *reserve2;
@property (nonatomic,copy) NSString *reserve3;

@property (nonatomic,retain) YCPlacemark *placemark;
@property (nonatomic,assign) ABRecordID personId;


- (void)setRealCoordinateWithVisualCoordinate:(CLLocationCoordinate2D)theVisualCoordinate;
- (void)setVisualCoordinateWithRealCoordinate:(CLLocationCoordinate2D)theCoordinate;


//发送save通知
- (void)sendSaveNotificationWithInfo:(IASaveInfo*)saveInfo fromSender:(id)sender;
//保存闹钟,不发通知
- (IASaveInfo*)save;
//保存闹钟
- (void)saveFromSender:(id)sender;
//删除
- (void)deleteFromSender:(id)sender;
//发送通知更新所有关联视图
- (void)sendNotifyToUpdateAllViewsFromSender:(id)sender;

+(void)saveAlarms;//保存列表


//根据Id找到闹钟
+ (id)findForAlarmId:(NSString*)theAlarmId;
//取得所有闹钟的列表
+ (NSArray*)alarmArray;




@end


