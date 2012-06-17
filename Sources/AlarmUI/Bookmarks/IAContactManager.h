//
//  IAContactManager.h
//  iAlarm
//
//  Created by li shiyong on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Foundation/Foundation.h>

@class IAAlarm, IAPerson, AlarmPositionMapViewController;
@interface IAContactManager : NSObject<MKMapViewDelegate, ABUnknownPersonViewControllerDelegate, ABPersonViewControllerDelegate>{
    //不能用于多线程和并发
    
    IAAlarm *_alarm; 
    UIBarButtonItem *_cancelButtonItem;
    
    ABUnknownPersonViewController *_unknownPersonVC;
    ABPersonViewController *_personVC;
    
    //弄个地图，为了截取image
    MKMapView *_mapView;
    BOOL _mapViewDidStartLoadingMap;
    BOOL _mapViewDidFinishLoadingMap;
    NSTimeInterval _delayForWaitingStartLoadingMap; //等待地图开始加载数据的时间
    UIImage *_imageTook;
    
    AlarmPositionMapViewController *_alarmPositionVC;
    
    
    CALayer *_containerLayer;
    CALayer *_mapLayerSuperLayer;
    CALayer *_mapLayer;
    CGPoint _mapLayerPosition;
    CGRect _mapLayerBounds;
    
    
    
}

@property (nonatomic, assign) IBOutlet UIViewController *currentViewController; //相当于delegate,要用assign

- (void)pushContactViewControllerWithAlarm:(IAAlarm*)theAlarm;

@property (nonatomic, readonly) NSInteger animationKind; //1:地图放大。2.地图缩小

@end
