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
    BOOL _isPush;
    
    ABUnknownPersonViewController *_unknownPersonVC;
    ABPersonViewController *_personVC;
    
    //弄个地图，为了截取image
    MKMapView *_mapView;
    BOOL _mapViewDidFinish;
    UIImage *_imageTook;
    
    AlarmPositionMapViewController *_alarmPositionVC;
}

@property (nonatomic, assign) IBOutlet UIViewController *currentViewController; //相当于delegate,要用assign

//- (void)presentContactViewControllerWithAlarm:(IAAlarm*)theAlarm newPerson:(IAPerson*)newPerson;
- (void)pushContactViewControllerWithAlarm:(IAAlarm*)theAlarm;

@end
