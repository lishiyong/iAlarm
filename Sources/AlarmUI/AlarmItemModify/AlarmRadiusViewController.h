//
//  AlarmRadiusViewController.h
//  iAlarm
//
//  Created by li shiyong on 11-1-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "AlarmModifyViewController.h"

//闹钟的警示半径改变了--Done前
extern NSString *IAAlarmRadiusDidChangeNotification;

@class CustomPickerController;
@class IAAnnotation;
@interface AlarmRadiusViewController : AlarmModifyViewController 
<UIPickerViewDelegate, UIPickerViewDataSource,MKMapViewDelegate>{
	IBOutlet MKMapView *mapView;
	IBOutlet UIView *mapViewContainer;
	IAAnnotation *middlePointAnnotion; //线的标签
	MKCircle *lastCircleOverlay;   //为了取消函数调用
	
	IBOutlet UIView *alarmRadiusPickerViewContainer;
	IBOutlet UIPickerView *alarmRadiusPickerView;
	IBOutlet UILabel *alarmRadiusUnitLabel;
	
	IBOutlet UIView *customPickerViewContainer;
	IBOutlet CustomPickerController *customPickerController;
	
	BOOL isFirstShow;
	
	////////////////////
	//延时调用：custom picker改变选择
	NSInteger selectedRowForCustomPicker;
	NSInteger inComponentForCustomPicker;
	BOOL isAnimatedForAlarmRadiusPicker ;
	////////////////////
	
}
@property(nonatomic,retain) IBOutlet MKMapView *mapView;
@property(nonatomic,retain) IBOutlet UIView *mapViewContainer;
@property(nonatomic,retain) MKCircle *lastCircleOverlay;

@property(nonatomic,retain) IBOutlet UIView *alarmRadiusPickerViewContainer;
@property(nonatomic,retain) IBOutlet UIPickerView *alarmRadiusPickerView;
@property(nonatomic,retain) IBOutlet UILabel *alarmRadiusUnitLabel;

@property(nonatomic,retain) IBOutlet UIView *customPickerViewContainer;
@property(nonatomic,retain) IBOutlet CustomPickerController *customPickerController;

-(void)animateSetCustomPickerShowOrHide;

@end
