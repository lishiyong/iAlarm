//
//  YCAnnotationView.h
//  iArrived
//
//  Created by li shiyong on 10-10-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "YCButton.h"
#import "YCRemoveMinusButton.h"
#import "YCMoveInButton.h"


@class YCPinAnnotationView;
@protocol YCPinAnnotationViewDelegete 

@optional

//按下了删除按钮
- (void)annotationView:(YCPinAnnotationView *)annotationView didPressDeleteButton:(UIButton*)button;
//改变了calloutview的状态
- (void)annotationView:(YCPinAnnotationView *)annotationView didChangeEditingStatus:(BOOL)isEditing;
//结束了Title的编辑
- (void)annotationView:(YCPinAnnotationView *)annotationView didEndTitleEditing:(BOOL) isChanged;
//view收到消息
//- (void)annotationView:(YCPinAnnotationView *)annotationView hitTestWithEven:(UIEvent *)event;

@end

enum {
	YCPinAnnotationColorNone = 0,
	YCPinAnnotationColorGray
};
typedef NSUInteger YCPinAnnotationColor;

@interface YCPinAnnotationView : MKPinAnnotationView {
	
	id delegate;

	YCPinAnnotationColor ycPinColor;

	BOOL calloutViewEditing;                         //指示整个calloutView是否在编辑模式
	UIView *leftNormalCalloutAccessoryView;          //临时存储
	YCButton *rightNormalCalloutAccessoryView;       //临时存储
	YCRemoveMinusButton *leftMinusAndVerticalLineCalloutAccessoryView;
	YCMoveInButton *rightDeleteCalloutAccessoryView;
	
	
	//////////////////////////////
	//编辑title使用
	BOOL canEditCalloutTitle;                  //在编辑模式下，calloutView的title是否可以更改
	UITextField *titleCalloutTextField;        //编辑title
	UIView *calloutView;  //不用释放
	UILabel *titleLabel;  //不用释放
	//////////////////////////////

}

@property (nonatomic,assign) id delegate;
@property (nonatomic,assign) BOOL calloutViewEditing;
@property (nonatomic,assign,readonly) YCPinAnnotationColor ycPinColor;
- (void)updatePinColor;   //为了对付GrayPin长按颜色转不过来


//////////////////////////////
//编辑title使用
@property (nonatomic,assign) BOOL canEditCalloutTitle;
- (BOOL)titleEditing;//指示title的编辑框是否在编辑中（拥有焦点）
//////////////////////////////

@end
