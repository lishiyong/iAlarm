//
//  SettingViewController.m
//  iArrived
//
//  Created by li shiyong on 10-11-1.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IARegion.h"
#import "SettingViewController.h"
#import "YCParam.h"
#import "YCSystemStatus.h"
#import "IARegionsCenter.h"
#import "IAAlarm.h"

@implementation SettingViewController
@synthesize mapOffsetSwitch;
@synthesize signicantSeriveLabel;
@synthesize standardSeriveLabel;
@synthesize lastStandardSpeedLabel;
@synthesize currentSpeedLabel;
@synthesize regionsView;
@synthesize lastRegionsView;
@synthesize radiusForAlarmField;
@synthesize distanceForProAlarmField;

@synthesize mapView;

-(IBAction) radiusChanged:(id)sender
{
	YCParam *param = [YCParam paramSingleInstance];
	param.radiusForAlarm =  [self.radiusForAlarmField.text doubleValue];
	[YCParam updateParam];
}
-(IBAction) distancePreAlarmChanged:(id)sender
{
	YCParam *param = [YCParam paramSingleInstance];
	param.distanceForProAlarm =  [self.distanceForProAlarmField.text doubleValue];
}

-(IBAction) OKButtonPressed:(id)sender
{
	//[self distancePreAlarmChanged:nil];
	//[self radiusChanged:nil];
	
	//大头针
	CLLocationCoordinate2D coordinate = self.mapView.centerCoordinate;
	//[self.mapView removeAnnotations:self.mapView.annotations];
	//MKPointAnnotation *annotation = [[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil] autorelease];
	MKPointAnnotation *annotation = [[[MKPointAnnotation alloc] init] autorelease];
	annotation.coordinate = coordinate;

	[self.mapView addAnnotation:annotation];
}

-(IBAction) refreshButtonPressed:(id)sender
{
	[self.distanceForProAlarmField resignFirstResponder];
	[self.radiusForAlarmField resignFirstResponder];
	
	YCParam *param = [YCParam paramSingleInstance];
	self.mapOffsetSwitch.on = param.enableOffset;
	self.radiusForAlarmField.text = [NSString stringWithFormat:@"%.1f",param.radiusForAlarm];
	self.distanceForProAlarmField.text = [NSString stringWithFormat:@"%.1f",param.distanceForProAlarm];

	
	YCSystemStatus *devs = [YCSystemStatus deviceStatusSingleInstance];


	if (devs.significantService)
		self.signicantSeriveLabel.text = @"Open";
	else 
		self.signicantSeriveLabel.text = @"Close";
	
	if (devs.standardService)
		self.standardSeriveLabel.text = @"Open";
	else 
		self.standardSeriveLabel.text = @"Close";
	
	
	
	NSDictionary *regions = [IARegionsCenter regionCenterSingleInstance].regions;
	NSMutableString *regionsStr = [NSMutableString stringWithString:@""];
	for (id aKey in regions) {
		IARegion *oneRegion = [regions objectForKey:aKey];
		
		NSString *alarmName = oneRegion.alarm.alarmName;
		NSString *inOut = nil;
		switch (oneRegion.userLocationType) {
			case IAUserLocationTypeInner:
				inOut = @"内";
				break;
			case IAUserLocationTypeOuter:
				inOut = @"外";
				break;
			case IAUserLocationTypeEdge:
				inOut = @"边缘";
				break;
			default:
				break;
		}
		[regionsStr appendString:alarmName];
		[regionsStr appendString:@"            "];
		[regionsStr appendString:inOut];
		[regionsStr appendString:@"\n"];
	}
	
	regionsView.text = regionsStr;
	 
	

	
	
	
}



-(IBAction) mapOffsetSwitchChanged:(id)sender
{
	YCParam *param = [YCParam paramSingleInstance];
	param.enableOffset = self.mapOffsetSwitch.on;
}

-(void) viewWillAppear:(BOOL)animated
{
	self.lastRegionsView.font = [UIFont fontWithName:@"Arial" size:12];
	self.regionsView.font = [UIFont fontWithName:@"Arial" size:12];
	
	[self refreshButtonPressed:nil];
	
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
