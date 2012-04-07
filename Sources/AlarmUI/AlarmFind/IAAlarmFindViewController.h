//
//  IAAlarmFindViewController.h
//  iAlarm
//
//  Created by li shiyong on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@class IAAlarmNotification, MapPointAnnotation, YCShareAppEngine;
@interface IAAlarmFindViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, UIActionSheetDelegate>{
    
    UIBarButtonItem *doneButtonItem;
    UIBarButtonItem *upDownBarItem;

    NSArray *alarmNotifitions;
    NSUInteger indexForView;
    IAAlarmNotification *viewedAlarmNotification;
    MapPointAnnotation *pointAnnotation;
    MKCircle *circleOverlay;
    YCShareAppEngine *engine;
    UIActionSheet *actionSheet1;
    UIActionSheet *actionSheet2;
    NSTimer *timer;
    
}
@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property(nonatomic,retain,readonly) UIBarButtonItem *doneButtonItem;
@property(nonatomic,retain,readonly) UIBarButtonItem *upDownBarItem;

@property (nonatomic,retain) IBOutlet UITableViewCell *mapViewCell;
@property (nonatomic,retain) IBOutlet UIView *containerView;
@property (nonatomic,retain) IBOutlet MKMapView *mapView;
@property (nonatomic,retain) IBOutlet UIImageView *imageView;
@property (nonatomic,retain) IBOutlet UILabel *timeIntervalLabel;

@property (nonatomic,retain) IBOutlet UITableViewCell *buttonCell;
@property (nonatomic,retain) IBOutlet UIButton *button1;
@property (nonatomic,retain) IBOutlet UIButton *button2;
@property (nonatomic,retain) IBOutlet UIButton *button3;

@property (nonatomic,retain) IBOutlet UITableViewCell *notesCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil alarmNotifitions:(NSArray *)theAlarmNotifitions;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil alarmNotifitions:(NSArray *)theAlarmNotifitions indexForView:(NSUInteger)theIndexForView;

- (IBAction)tellFriendsButtonPressed:(id)sender;
- (IBAction)delayAlarm1ButtonPressed:(id)sender;
- (IBAction)delayAlarm2ButtonPressed:(id)sender;


@end
