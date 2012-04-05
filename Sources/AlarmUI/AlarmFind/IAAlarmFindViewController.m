//
//  IAAlarmFindViewController.m
//  iAlarm
//
//  Created by li shiyong on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSString-YC.h"
#import "IAAlarm.h"
#import "IAAlarmNotification.h"
#import "UIColor+YC.h"
#import <QuartzCore/QuartzCore.h>
#import "IAAlarmFindViewController.h"
#import <MapKit/MapKit.h>


@interface MapPoint : NSObject<MKAnnotation> {
    NSString *title;
    NSString *subTitle;
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subTitle;

-(id) initWithCoordinate:(CLLocationCoordinate2D) coord title:(NSString *) theTitle subTitle:(NSString *) theSubTitle;

@end

@implementation MapPoint
@synthesize coordinate, title, subTitle;

-(id) initWithCoordinate:(CLLocationCoordinate2D) coord title:(NSString *) theTitle subTitle:(NSString *) theSubTitle{
    self = [super init];
    if (self) {
        coordinate = coord;
        title = [theTitle copy];
        theSubTitle = [theSubTitle copy];
    }
    return self;
}

@end



@interface IAAlarmFindViewController(private)

- (UIImage*)takePhotoFromTheMapView;

@end


@implementation IAAlarmFindViewController
@synthesize tableView;
@synthesize mapViewCell, containerView, mapView, imageView, timeStampLabel, timeStampBackgroundView;
@synthesize buttonCell, button1, button2, button3;
@synthesize notesCell;

- (id)doneButtonItem{
	
	if (!self->doneButtonItem) {
		self->doneButtonItem = [[UIBarButtonItem alloc]
								initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
								target:self
								action:@selector(doneButtonItemPressed:)];
	}
	
	return self->doneButtonItem;
}

- (id)upDownBarItem{
    if (!upDownBarItem) {
        UISegmentedControl *segmentedControl = [[[UISegmentedControl alloc] initWithItems:
                                                [NSArray arrayWithObjects:
                                                 [UIImage imageNamed:@"UIButtonBarArrowUpSmall.png"],
                                                 [UIImage imageNamed:@"UIButtonBarArrowDownSmall.png"],
                                                 nil]] autorelease];
        
        [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        segmentedControl.frame = CGRectMake(0, 0, 90, 30);
        segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        segmentedControl.momentary = YES;
        
        upDownBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
        
    }
    
    return upDownBarItem;
}


- (void)doneButtonItemPressed:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)segmentAction:(id)sender
{
	// The segmented control was clicked, handle it here 
	//UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	//NSLog(@"Segment clicked: %d", segmentedControl.selectedSegmentIndex);
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Utility

- (UIImage*)takePhotoFromTheMapView{
    /*
    UIGraphicsBeginImageContext(self.mapView.frame.size);
    [self.mapView.layer renderInContext:UIGraphicsGetCurrentContext()]; 
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();     
    return viewImage;
     */
    return nil;
}


- (MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id <MKAnnotation>)annotation{
    
    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;

    NSString *annotationIdentifier = @"PinViewAnnotation";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    
    if (!pinView){
        
        IAAlarm *alarm = viewedAlarmNotification.alarm;
        NSString *imageName = alarm.alarmRadiusType.alarmRadiusTypeImageName;
        imageName = [NSString stringWithFormat:@"20_%@",imageName]; //使用20像素的图标
        UIImageView *sfIconView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)] autorelease];
        sfIconView.image = [UIImage imageNamed:imageName];
        
        
        pinView = [[[MKPinAnnotationView alloc]
                                      initWithAnnotation:annotation
                                         reuseIdentifier:annotationIdentifier] autorelease];
        
        [pinView setPinColor:MKPinAnnotationColorGreen];
        pinView.canShowCallout = YES;
         
        pinView.leftCalloutAccessoryView = sfIconView;
        
    }else{
        pinView.annotation = annotation;
    }
    
    return pinView;
   
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay{    
	
    if ([overlay isKindOfClass:[MKCircle class]]) {
		MKCircleView *cirecleView = nil;
		cirecleView = [[[MKCircleView alloc] initWithCircle:overlay] autorelease];
		cirecleView.fillColor = [UIColor colorWithRed:160.0/255.0 green:127.0/255.0 blue:255.0/255.0 alpha:0.4]; //淡紫几乎透明
		cirecleView.strokeColor = [UIColor whiteColor];   //白
		cirecleView.lineWidth = 2.0;
		return cirecleView;
	}
	
	return nil;
}

- (void)mapView:(MKMapView *)theMapView didAddAnnotationViews:(NSArray *)views{
	for (id oneObj in views) {
		id annotation = ((MKAnnotationView*)oneObj).annotation;
		if ([ annotation isKindOfClass:[MapPoint class]]) {
            [self.mapView selectAnnotation:annotation animated:NO];
		}
	}
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.doneButtonItem;
    self.navigationItem.rightBarButtonItem = self.upDownBarItem;

    self.mapView.layer.cornerRadius = 6;
    self.imageView.layer.cornerRadius = 6;
    self.imageView.layer.masksToBounds = YES;
    
    self.containerView.layer.cornerRadius = 6;
    self.containerView.layer.borderColor = [UIColor grayColor].CGColor;
    self.containerView.layer.borderWidth = 1.0;
    self.containerView.layer.shadowRadius = 1.0;
    self.containerView.layer.shadowOpacity = 0.5;
    self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.containerView.layer.shadowOffset = CGSizeMake(0, 1.0);

 
    if ([alarmNotifitions count] >0) {
        [viewedAlarmNotification release];
        viewedAlarmNotification = [(IAAlarmNotification*)[alarmNotifitions objectAtIndex:0] retain];
        IAAlarm *alarm = viewedAlarmNotification.alarm;
        
        CLLocationCoordinate2D coord = alarm.coordinate;
        CLLocationDistance radius = alarm.radius;
        
        //大头针
        MapPoint *mp = [[[MapPoint alloc] initWithCoordinate:alarm.coordinate title:alarm.alarmName subTitle:@"距离当前位置:1.5公里"] autorelease];    
        [self.mapView addAnnotation:mp];
        
        //地图的显示region
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, radius*2.5, radius*2.5);
        MKCoordinateRegion regionFited =  [self.mapView regionThatFits:region];
        [self.mapView setRegion:regionFited animated:NO];
        
        //圈
        MKCircle *circleOverlay = [MKCircle circleWithCenterCoordinate:coord radius:radius];
		[self.mapView addOverlay:circleOverlay];
        
        //选中
        [self.mapView selectAnnotation:mp animated:NO];
         
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	UITableViewCell *cell  = nil;
    switch (indexPath.section) {
        case 0:
            cell = self.mapViewCell;
            break;
        case 1:
            cell = self.notesCell;
            break;
        case 2:
            cell = self.buttonCell;
            break;
        default:
            break;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return @"备注：";
    }
	
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
	
    if (section == 1) {
        NSString *s = [viewedAlarmNotification.alarm.description trim];
        if ([s length] == 0) s = @"\n";//备注为空，1空行占空间
        return s;
    }
	
    return nil;
}


#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return self.mapViewCell.bounds.size.height;
            break;
        case 1:
            return self.notesCell.bounds.size.height;
            break;
        case 2:
            return self.buttonCell.bounds.size.height;
            break;
        default:
            return 0.0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 23.0; //备注 上下空太大了，缩小点
    }
    return 0.0;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil alarmNotifitions:(NSArray *)theAlarmNotifitions{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        alarmNotifitions = [theAlarmNotifitions retain];
    }
    return self;
}


@end
