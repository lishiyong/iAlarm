//
//  IAAlarmFindViewController.h
//  iAlarm
//
//  Created by li shiyong on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@class MKMapView;
@protocol MKMapViewDelegate;
@class IAAlarmNotification;
@interface IAAlarmFindViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate>{
    
    UIBarButtonItem *doneButtonItem;
    UIBarButtonItem *upDownBarItem;
    
    NSArray *alarmNotifitions;
    IAAlarmNotification *viewedAlarmNotification;
    
}
@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property(nonatomic,retain,readonly) UIBarButtonItem *doneButtonItem;
@property(nonatomic,retain,readonly) UIBarButtonItem *upDownBarItem;

@property (nonatomic,retain) IBOutlet UITableViewCell *mapViewCell;
@property (nonatomic,retain) IBOutlet UIView *containerView;
@property (nonatomic,retain) IBOutlet MKMapView *mapView;
@property (nonatomic,retain) IBOutlet UIImageView *imageView;
@property (nonatomic,retain) IBOutlet UILabel *timeStampLabel;
@property (nonatomic,retain) IBOutlet UIView *timeStampBackgroundView;

@property (nonatomic,retain) IBOutlet UITableViewCell *buttonCell;
@property (nonatomic,retain) IBOutlet UIButton *button1;
@property (nonatomic,retain) IBOutlet UIButton *button2;
@property (nonatomic,retain) IBOutlet UIButton *button3;

@property (nonatomic,retain) IBOutlet UITableViewCell *notesCell;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil alarmNotifitions:(NSArray *)theAlarmNotifitions;


@end
