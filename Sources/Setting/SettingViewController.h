//
//  SettingViewController.h
//  iArrived
//
//  Created by li shiyong on 10-11-1.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SettingViewController : UIViewController<MKMapViewDelegate> {

	UISwitch *mapOffsetSwitch;
	
	UILabel *signicantSeriveLabel;
	UILabel *standardSeriveLabel;
	UILabel *lastStandardSpeedLabel;
	UILabel *currentSpeedLabel;
	
	UITextView *regionsView;
	UITextView *lastRegionsView;
	
	UITextField *radiusForAlarmField;
	UITextField *distanceForProAlarmField;
	
	
	IBOutlet MKMapView* mapView;            


}
@property (nonatomic,retain) IBOutlet UISwitch *mapOffsetSwitch;

@property (nonatomic,retain) IBOutlet UILabel *signicantSeriveLabel;
@property (nonatomic,retain) IBOutlet UILabel *standardSeriveLabel;
@property (nonatomic,retain) IBOutlet UILabel *lastStandardSpeedLabel;
@property (nonatomic,retain) IBOutlet UITextView *regionsView;
@property (nonatomic,retain) IBOutlet UITextView *lastRegionsView;
@property (nonatomic,retain) IBOutlet UILabel *currentSpeedLabel;
@property (nonatomic,retain) IBOutlet UITextField *radiusForAlarmField;
@property (nonatomic,retain) IBOutlet UITextField *distanceForProAlarmField;

@property (nonatomic,retain) IBOutlet MKMapView* mapView;            

-(IBAction) refreshButtonPressed:(id)sender;
-(IBAction) mapOffsetSwitchChanged:(id)sender;
-(IBAction) OKButtonPressed:(id)sender;
//-(IBAction) radiusChanged:(id)sender;
//-(IBAction) distancePreAlarmChanged:(id)sender;

@end
