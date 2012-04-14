//
//  DetailTableViewController.m
//  TestLocationTableCell1
//
//  Created by li shiyong on 10-12-16.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IAAlarmNotificationCenter.h"
#import "UIColor+YC.h"
#import "IAAlarmFindViewController.h"
#import "IAAlarmNotification.h"
#import "AlarmNotesViewController.h"
#import "NSString-YC.h"
#import "YCSoundPlayer.h"
#import "IADestinationCell.h"
#import "AlarmTriggerTableViewController.h"
#import "YCPositionType.h"
#import "IAGlobal.h"
#import "NSObject-YC.h"
#import "UIViewController-YC.h"
#import "IANotifications.h"
#import "AlarmDetailFooterView.h"
#import "YCSystemStatus.h"
#import "YClocationServicesUsableAlert.h"
#import "YCMapsUtility.h"
#import "IAAlarmRadiusType.h"
#import "AlarmRadiusViewController.h"
#import "YCParam.h"
#import "AlarmLRepeatTypeViewController.h"
#import "AlarmLSoundViewController.h"
#import "AlarmNameViewController.h"
#import "YCRepeatType.h"
#import "YCSound.h"
#import "CellHeaderView.h"
#import "AlarmPositionMapViewController.h"
#import "CheckmarkDisclosureIndicatorCell.h"
#import "WaitingCell.h"
#import "BoolCell.h"
#import "TableViewCellDescription.h"
#import "IAAlarm.h"
#import "UIUtility.h"
#import "AlarmDetailTableViewController.h"
#include <AudioToolbox/AudioToolbox.h>



@implementation AlarmDetailTableViewController

#pragma mark -
#pragma mark property

@synthesize lastUpdateDistanceTimestamp;
@synthesize locationServicesUsableAlert;
@synthesize newAlarm;
@synthesize alarm;
@synthesize alarmTemp;
@synthesize bestEffortAtLocation;
@synthesize placemarkForReverse;

@synthesize cellDescriptions;   
@synthesize enablingCellDescription;
@synthesize repeatCellDescription;
@synthesize soundCellDescription;
@synthesize vibrateCellDescription;
@synthesize nameCellDescription;
@synthesize addressCellDescription;
@synthesize radiusCellDescription;
@synthesize triggerCellDescription; 
@synthesize destionationCellDescription;
@synthesize notesCellDescription;
@synthesize titleForFooter;
@synthesize footerView;

- (id)footerView{
    if (footerView == nil) {
        footerView = [[AlarmDetailFooterView viewWithXib] retain];
        footerView.waitingAIView.hidden = YES;
        footerView.distanceLabel.hidden = YES;
        footerView.promptLabel.hidden = NO;
        
        self.footerView.waitingAIView.frame = CGRectMake(20.0,8.0,20.0,20.0);
        self.footerView.distanceLabel.frame = CGRectMake(22.0,0.0,284.0,33.0);
        self.footerView.promptLabel.frame = CGRectMake(19.0,5.0,284.0,170.0);//缺省在高位置
        
        self.footerView.distanceLabel.text = nil;
        self.footerView.promptLabel.text = nil;
    }
    return footerView;
}

/*
- (void)setAlarmTemp:(IAAlarm*)obj{
	if (alarmTemp) {
		[alarmTemp removeObserver:self forKeyPath:@"alarmName"];
		[alarmTemp removeObserver:self forKeyPath:@"position"];
		[alarmTemp removeObserver:self forKeyPath:@"positionShort"];
		[alarmTemp removeObserver:self forKeyPath:@"description"];
		[alarmTemp removeObserver:self forKeyPath:@"enabling"];
		[alarmTemp removeObserver:self forKeyPath:@"coordinate"];
		[alarmTemp removeObserver:self forKeyPath:@"vibrate"];
		[alarmTemp removeObserver:self forKeyPath:@"sound"];
		[alarmTemp removeObserver:self forKeyPath:@"repeatType"];
		[alarmTemp removeObserver:self forKeyPath:@"alarmRadiusType"];
		[alarmTemp removeObserver:self forKeyPath:@"radius"];	
	}
	
	
	[obj retain];
	[alarmTemp release];
	alarmTemp = obj;
	
	if (alarmTemp) {
		[alarmTemp addObserver:self forKeyPath:@"alarmName" options:0 context:nil];
		[alarmTemp addObserver:self forKeyPath:@"position" options:0 context:nil];
		[alarmTemp addObserver:self forKeyPath:@"positionShort" options:0 context:nil];
		[alarmTemp addObserver:self forKeyPath:@"description" options:0 context:nil];
		[alarmTemp addObserver:self forKeyPath:@"enabling" options:0 context:nil];
		[alarmTemp addObserver:self forKeyPath:@"coordinate" options:0 context:nil];
		[alarmTemp addObserver:self forKeyPath:@"vibrate" options:0 context:nil];
		[alarmTemp addObserver:self forKeyPath:@"sound" options:0 context:nil];
		[alarmTemp addObserver:self forKeyPath:@"repeatType" options:0 context:nil];
		[alarmTemp addObserver:self forKeyPath:@"alarmRadiusType" options:0 context:nil];
		[alarmTemp addObserver:self forKeyPath:@"radius" options:0 context:nil];
	}
}
 */
 
- (void)setAlarmTemp:(IAAlarm*)obj{
	[obj retain];
	[alarmTemp release];
	alarmTemp = obj;
}

- (id)alarmTemp{
	
	if (alarmTemp == nil) {
		alarmTemp = [self.alarm copy];
		//if (!self.newAlarm) {
			[alarmTemp addObserver:self forKeyPath:@"alarmName" options:0 context:nil];
			[alarmTemp addObserver:self forKeyPath:@"position" options:0 context:nil];
			[alarmTemp addObserver:self forKeyPath:@"positionShort" options:0 context:nil];
			//[alarmTemp addObserver:self forKeyPath:@"notes" options:0 context:nil];
			[alarmTemp addObserver:self forKeyPath:@"enabling" options:0 context:nil];
			[alarmTemp addObserver:self forKeyPath:@"coordinate" options:0 context:nil];
			[alarmTemp addObserver:self forKeyPath:@"vibrate" options:0 context:nil];
			[alarmTemp addObserver:self forKeyPath:@"sound" options:0 context:nil];
			[alarmTemp addObserver:self forKeyPath:@"repeatType" options:0 context:nil];
			[alarmTemp addObserver:self forKeyPath:@"alarmRadiusType" options:0 context:nil];
			[alarmTemp addObserver:self forKeyPath:@"radius" options:0 context:nil];
			[alarmTemp addObserver:self forKeyPath:@"positionType" options:0 context:nil];
            [alarmTemp addObserver:self forKeyPath:@"notes" options:0 context:nil];
		//}
		
	}
	
	return alarmTemp;
	
}
 


- (id)locationServicesUsableAlert{
	if (!locationServicesUsableAlert) {
		locationServicesUsableAlert = [[YClocationServicesUsableAlert alloc] init];
	}
	
	return locationServicesUsableAlert;
}

- (CLLocationManager *)locationManager 
{
    if (locationManager != nil) {
		return locationManager;
	}
	
	locationManager = [[CLLocationManager alloc] init];
	[locationManager setDesiredAccuracy:kCLLocationAccuracyBest]; //精度不能设成别的，否则打开地图后就不定位了。
	locationManager.distanceFilter = kCLDistanceFilterNone;
	[locationManager setDelegate:self];
	
	return locationManager;
}

- (MKReverseGeocoder *)reverseGeocoder:(CLLocationCoordinate2D)coordinate
{
    if (reverseGeocoder) {
		[reverseGeocoder release];
	}
	reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:coordinate];
	
	return reverseGeocoder;
}

- (id)cancelButtonItem{
	
	if (!self->cancelButtonItem) {
		self->cancelButtonItem = [[UIBarButtonItem alloc]
								initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
								target:self
								action:@selector(cancelButtonItemPressed:)];
	}
	
	return self->cancelButtonItem;
}



- (id)saveButtonItem{
	
	if (!self->saveButtonItem) {
		self->saveButtonItem = [[UIBarButtonItem alloc]
								initWithBarButtonSystemItem:UIBarButtonSystemItemSave
								target:self
								action:@selector(saveButtonItemPressed:)];
	}
	
	return self->saveButtonItem;
}

- (id)testAlarmButton{
	
	if (!self->testAlarmButton) {
		
        CGRect frame = CGRectMake(10, 5, 300, 44);
        self->testAlarmButton = [[UIButton alloc] initWithFrame:frame];
        
        self->testAlarmButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self->testAlarmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self->testAlarmButton setTitle:@"测试" forState:UIControlStateNormal & UIControlStateHighlighted];
        self->testAlarmButton.titleLabel.font            = [UIFont boldSystemFontOfSize: 19];
        self->testAlarmButton.titleLabel.lineBreakMode   = UILineBreakModeTailTruncation;
        self->testAlarmButton.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self->testAlarmButton.titleLabel.shadowOffset    = CGSizeMake (0.0, -1.0);
        
        [self->testAlarmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self->testAlarmButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];


        UIImage *image = [UIImage imageNamed:@"UIPopoverButton.png"];
        UIImage *newImage = [image stretchableImageWithLeftCapWidth:6 topCapHeight:6];
        [self->testAlarmButton setBackgroundImage:newImage forState:UIControlStateNormal];
        UIImage *imagePressed = [UIImage imageNamed:@"UIPopoverButtonPressed.png"];
        UIImage *newImagePressed = [imagePressed stretchableImageWithLeftCapWidth:6 topCapHeight:6];
        [self->testAlarmButton setBackgroundImage:newImagePressed forState: UIControlStateHighlighted];
        
        [self->testAlarmButton addTarget:self action:@selector(testAlarmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        self->testAlarmButton.adjustsImageWhenDisabled = YES;
        self->testAlarmButton.adjustsImageWhenHighlighted = YES;
        [self->testAlarmButton setBackgroundColor:[UIColor clearColor]];	
        
	}
	
	return self->testAlarmButton;
}


- (id)cellDescriptions{
	if (!self->cellDescriptions) {
		//第一组
		NSArray *oneArray = [NSArray arrayWithObjects:
							  self.enablingCellDescription
							 ,nil];
		
		NSArray *twoArray = nil;
		
        if ([YCParam paramSingleInstance].leaveAlarmEnabled) { //启用离开闹钟
		
            twoArray = [NSArray arrayWithObjects:
                        self.repeatCellDescription
                        ,self.soundCellDescription
                        ,self.triggerCellDescription
                        ,self.radiusCellDescription
                        ,self.notesCellDescription
                        ,self.nameCellDescription
                        ,self.destionationCellDescription
                        ,nil];
        }else{
            twoArray = [NSArray arrayWithObjects:
                        self.repeatCellDescription
                        ,self.soundCellDescription
                        //,self.triggerCellDescription
                        ,self.radiusCellDescription
                        ,self.notesCellDescription
                        ,self.nameCellDescription
                        ,self.destionationCellDescription
                        ,nil];
        }

		
		self->cellDescriptions = [NSArray arrayWithObjects:oneArray,twoArray,nil];
		[self->cellDescriptions retain];
	}
	
	return self->cellDescriptions;
}


//////////////////////////////////
//enablingCellDescription

- (void) didChangedSwitchCtlInEnablingCell:(id)sender{
	self.alarmTemp.enabling = ((UISwitch *)sender).on;
	/*
	//改变了，发送通知
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter postNotificationName:IAAlarmItemsDidChangeNotification object:self];
	 */
}

- (id)enablingCellDescription{
	
	static NSString *CellIdentifier = @"enablingCell";
	
	if (!self->enablingCellDescription) {
		self->enablingCellDescription = [[TableViewCellDescription alloc] init];
		
		BoolCell *cell = [[BoolCell alloc] initWithReuseIdentifier:CellIdentifier];
		cell.textLabel.text = KLabelAlarmEnable;
		[cell.switchCtl addTarget:self action: @selector(didChangedSwitchCtlInEnablingCell:) forControlEvents:UIControlEventValueChanged];

		self->enablingCellDescription.tableViewCell = cell;
		
		self->enablingCellDescription.didSelectCellSelector = NULL; //无选中事件
	}
	
	//置开关状态
	UISwitch *switchCtl = ((BoolCell *)self->enablingCellDescription.tableViewCell).switchCtl;
	switchCtl.on = self.alarmTemp.enabling;
	
	return self->enablingCellDescription;
}

//////////////////////////////////

//////////////////////////////////
//vibrateCellDescription

- (void) didChangedSwitchCtlInVibrateCell:(id)sender{
	self.alarmTemp.vibrate = ((UISwitch *)sender).on;
	/*
	//改变了，发送通知
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter postNotificationName:IAAlarmItemsDidChangeNotification object:self];
	 */
	
	if (((UISwitch *)sender).on)
		AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (id)vibrateCellDescription{
	
	static NSString *CellIdentifier = @"vibrateCellDescription";
	
	if (!self->vibrateCellDescription) {
		self->vibrateCellDescription = [[TableViewCellDescription alloc] init];
		
		BoolCell *cell = [[BoolCell alloc] initWithReuseIdentifier:CellIdentifier];
		cell.textLabel.text = KLabelAlarmVibrate;
		[cell.switchCtl addTarget:self action: @selector(didChangedSwitchCtlInVibrateCell:) forControlEvents:UIControlEventValueChanged];
		
		self->vibrateCellDescription.tableViewCell = cell;
		
		self->vibrateCellDescription.didSelectCellSelector = NULL; //无选中事件
	}
	
	//置开关状态
	UISwitch *switchCtl = ((BoolCell *)self->vibrateCellDescription.tableViewCell).switchCtl;
	switchCtl.on = self.alarmTemp.vibrate;
	
	return self->vibrateCellDescription;
}

//////////////////////////////////

- (void) didSelectNavCell:(id)sender{
	//back按钮
	self.title = nil;
	
	/*
	TableViewCellDescription *tableViewCellDescription = (TableViewCellDescription*)sender;
	if ([tableViewCellDescription.didSelectCellObject isKindOfClass:[AlarmPositionMapViewController class]]) {
		//显示 打开网络服务的提示框	TODO
	}
	
	
	[self.navigationController pushViewController:(UIViewController*)tableViewCellDescription.didSelectCellObject animated:YES];
	*/
	
	UIViewController *navToViewController = (UIViewController*)sender;
	//if ([navToViewController isKindOfClass:[AlarmPositionMapViewController class]]) {
		//显示 打开网络服务的提示框	TODO
	//}
	
	[self.navigationController pushViewController:navToViewController animated:YES];
	
}

- (id)repeatCellDescription{
	
	static NSString *CellIdentifier = @"repeatCellDescription";
	
	if (!self->repeatCellDescription) {
		self->repeatCellDescription = [[TableViewCellDescription alloc] init];
		UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
		cell.textLabel.text = KLabelAlarmRepeat;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		self->repeatCellDescription.tableViewCell = cell;
		self->repeatCellDescription.didSelectCellSelector = @selector(didSelectNavCell:);
		AlarmLRepeatTypeViewController *viewCtler = [[[AlarmLRepeatTypeViewController alloc] initWithStyle:UITableViewStyleGrouped alarm:self.alarmTemp] autorelease];
		self->repeatCellDescription.didSelectCellObject = viewCtler;
	}
	self->repeatCellDescription.tableViewCell.detailTextLabel.text = self.alarmTemp.repeatType.repeatTypeName;
    
	
	/*
	NSLog(@"textLabel:%@",self->repeatCellDescription.tableViewCell.textLabel.font);
	NSLog(@"textLabel:%@",self->repeatCellDescription.tableViewCell.textLabel.textColor);
	
	UIFont *f = self->repeatCellDescription.tableViewCell.detailTextLabel.font;
	NSLog(@"detailTextLabel:%f",[self->repeatCellDescription.tableViewCell.detailTextLabel.font fontSize]);
	NSLog(@"detailTextLabel:%@",self->repeatCellDescription.tableViewCell.detailTextLabel.textColor);
	*/
	
	return self->repeatCellDescription;
}

- (id)soundCellDescription{
	
	static NSString *CellIdentifier = @"soundCellDescription";
	
	if (!self->soundCellDescription) {
		self->soundCellDescription = [[TableViewCellDescription alloc] init];
		UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
		cell.textLabel.text = KLabelAlarmSound;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		self->soundCellDescription.tableViewCell = cell;
		self->soundCellDescription.didSelectCellSelector = @selector(didSelectNavCell:);
		AlarmLSoundViewController *viewCtler = [[[AlarmLSoundViewController alloc] initWithStyle:UITableViewStyleGrouped alarm:self.alarmTemp] autorelease];
		self->soundCellDescription.didSelectCellObject = viewCtler;
		
	}
	self->soundCellDescription.tableViewCell.detailTextLabel.text = self.alarmTemp.sound.soundName;
	
	return self->soundCellDescription;
}

- (id)nameCellDescription{
	
	static NSString *CellIdentifier = @"nameCellDescription";
	
	if (!self->nameCellDescription) {
		self->nameCellDescription = [[TableViewCellDescription alloc] init];
		UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
		cell.textLabel.text = KLabelAlarmName;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		self->nameCellDescription.tableViewCell = cell;
		self->nameCellDescription.didSelectCellSelector = @selector(didSelectNavCell:);
		AlarmNameViewController *viewCtler = [[[AlarmNameViewController alloc] initWithNibName:@"AlarmNameViewController" bundle:nil alarm:self.alarmTemp] autorelease];
		self->nameCellDescription.didSelectCellObject = viewCtler;
		
	}
    
    
    if (self.alarmTemp.nameChanged) {
        self->nameCellDescription.tableViewCell.detailTextLabel.textColor = [UIColor colorWithRed:56.0/255.0 green:84.0/255.0 blue:135.0/255.0 alpha:1.0];
        self->nameCellDescription.tableViewCell.detailTextLabel.text = self.alarmTemp.alarmName;
    }else{
        self->nameCellDescription.tableViewCell.detailTextLabel.textColor = [UIColor lightGrayColor];
        self->nameCellDescription.tableViewCell.detailTextLabel.text = @"例如：什么地方就要到了";
    }
     
    
	//self->nameCellDescription.tableViewCell.detailTextLabel.text = self.alarmTemp.alarmName;
	return self->nameCellDescription;
}

- (id)notesCellDescription{
	
	static NSString *CellIdentifier = @"notesCellDescription";
	
	if (!self->notesCellDescription) {
		self->notesCellDescription = [[TableViewCellDescription alloc] init];
		UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
		cell.textLabel.text = @"备注";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		self->notesCellDescription.tableViewCell = cell;
		self->notesCellDescription.didSelectCellSelector = @selector(didSelectNavCell:);
		AlarmNotesViewController *viewCtler = [[[AlarmNotesViewController alloc] initWithNibName:@"AlarmNotesViewController" bundle:nil alarm:self.alarmTemp] autorelease];
		self->notesCellDescription.didSelectCellObject = viewCtler;
		
	}
    
    if (self.alarmTemp.notes && [[self.alarmTemp.notes trim] length] >0) {
        self->notesCellDescription.tableViewCell.detailTextLabel.textColor = [UIColor textColor];
        self->notesCellDescription.tableViewCell.detailTextLabel.text = self.alarmTemp.notes;
    }else{
        self->notesCellDescription.tableViewCell.detailTextLabel.textColor = [UIColor lightGrayColor];
        self->notesCellDescription.tableViewCell.detailTextLabel.text = @"例如：到达后要做什么";
    }
	
	
	return self->notesCellDescription;
}



- (void) accessoryButtonTappedAddressCell:(id)sender{
	[self didSelectNavCell:self.addressCellDescription.accessoryButtonTappedObject]; //导航到地图
}
 

-(void)stopLocationAndReverseRestart:(BOOL)restart{	
	
	self->endingManual = YES;
	
	//开始定位或停止定位
	switch (self->locatingAndReversingStatus) {
		case IALocatingAndReversingStatusNone:
			if (restart)
				[self beginLocation];
			break;
		case IALocatingAndReversingStatusLocating:
			self.bestEffortAtLocation = nil;
			[self endLocation];
			//界面提示 : 定位失败
			if (!CLLocationCoordinate2DIsValid(self.alarmTemp.coordinate)) {
				self.titleForFooter = KTextPromptNeedSetLocationByMaps;
                [(IADestinationCell*)(self.destionationCellDescription.tableViewCell) setMoveArrow:YES]; //显示箭头动画
            }

			break;
		case IALocatingAndReversingStatusReversing:
			self.placemarkForReverse = nil;
			[self endReverse];
			//界面提示 : 定位失败
			if (!CLLocationCoordinate2DIsValid(self.alarmTemp.coordinate)) //在这里 不用也可以吧
            {
				self.titleForFooter = KTextPromptNeedSetLocationByMaps;
                [(IADestinationCell*)self.destionationCellDescription.tableViewCell setMoveArrow:YES]; //显示箭头动画
            }
			break;
		default:
			break;
	}
}

- (void) didSelectAddressCell:(id)sender{
	[self stopLocationAndReverseRestart:YES];
}



- (id)addressCellDescription{
	
	static NSString *CellIdentifier = @"WaitingCell";
	
	if (!self->addressCellDescription) {
		self->addressCellDescription = [[TableViewCellDescription alloc] init];
		UITableViewCell *cell = [[WaitingCell alloc] initWithReuseIdentifier:CellIdentifier];
		[(WaitingCell*)cell accessoryImageView1].image = [UIImage imageNamed:@"IAPinPurple.png"];
		[(WaitingCell*)cell accessoryImageView1].highlightedImage = [UIImage imageNamed:@"IAPinPressedPurple.png"];
		cell.textLabel.text = KLabelAlarmPostion;

		self->addressCellDescription.tableViewCell = cell;
		self->addressCellDescription.didSelectCellSelector = @selector(didSelectAddressCell:);
		
		self->addressCellDescription.accessoryButtonTappedSelector = @selector(didSelectNavCell:);
		AlarmPositionMapViewController *mapViewCtler = [[[AlarmPositionMapViewController alloc] initWithNibName:@"AlarmPositionMapViewController" bundle:nil alarm:self.alarmTemp] autorelease];
		self->addressCellDescription.accessoryButtonTappedObject = mapViewCtler;
		
		
		self->addressCellDescription.tableViewCell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
		self->addressCellDescription.tableViewCell.detailTextLabel.minimumFontSize = 12.0;
		
		[(WaitingCell*)cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
		//[(WaitingCell*)cell setAccessoryButtonTarget:self action:@selector(accessoryButtonTappedAddressCell:) forControlEvents:UIControlEventTouchUpInside];
		
	}
	
	//新创建AlarmAnnotation标识
	[(AlarmPositionMapViewController*)self->addressCellDescription.accessoryButtonTappedObject setNewAlarmAnnotation:YES];
	
	self->addressCellDescription.tableViewCell.detailTextLabel.text = self.alarmTemp.positionShort;
	[(WaitingCell*)self->addressCellDescription.tableViewCell setAccessoryButtonTarget:self action:@selector(accessoryButtonTappedAddressCell:) forControlEvents:UIControlEventTouchUpInside];
	
	//self->addressCellDescription.tableViewCell.detailTextLabel.text = @"123°59‘59″N,123°59‘59″E";
	//self->addressCellDescription.tableViewCell.detailTextLabel.text = @"北纬 123°59‘59″,东经 123°59‘59″";
	
	if (alarmTemp.usedCoordinateAddress) //字小一点，也把坐标显示全
		self->addressCellDescription.tableViewCell.detailTextLabel.minimumFontSize = 10.0;
	else 
		self->addressCellDescription.tableViewCell.detailTextLabel.minimumFontSize = 12.0;

	
	return self->addressCellDescription;
}

- (id)radiusCellDescription{
	
	static NSString *CellIdentifier = @"WaitingCell";
	
	if (!self->radiusCellDescription) {
		self->radiusCellDescription = [[TableViewCellDescription alloc] init];
		UITableViewCell *cell = [[WaitingCell alloc] initWithReuseIdentifier:CellIdentifier];
		[(WaitingCell*)cell accessoryImageView1].image = [UIImage imageNamed:@"IAPinGreen.png"];
		[(WaitingCell*)cell accessoryImageView1].highlightedImage = [UIImage imageNamed:@"IAPinPressedGreen.png"];
		((WaitingCell*)cell).accessoryImageView1Disabled = [UIImage imageNamed:@"IAPinGray.png"];
		
		((WaitingCell*)cell).accessoryImageView0Disabled = [UIImage imageNamed:@"IAFlagGray.png"];
		
		cell.textLabel.text = KLabelAlarmRadius;
		
		self->radiusCellDescription.tableViewCell = cell;
		
		
		self->radiusCellDescription.didSelectCellSelector = @selector(didSelectNavCell:);
        AlarmRadiusViewController *viewCtler = [[[AlarmRadiusViewController alloc] initWithNibName:@"AlarmRadiusViewController" bundle:nil alarm:self.alarmTemp] autorelease];
		self->radiusCellDescription.didSelectCellObject = viewCtler;
		 
		self->radiusCellDescription.tableViewCell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
		self->radiusCellDescription.tableViewCell.detailTextLabel.minimumFontSize = 12.0;
	}
	
	NSString *radiusName = self.alarmTemp.alarmRadiusType.alarmRadiusName;
	NSString *radiusValueString = [UIUtility convertDistance:self.alarmTemp.radius];
	NSString *radiusString = radiusName;
	if ( [self.alarmTemp.alarmRadiusType.alarmRadiusTypeId isEqualToString:@"ar004"]) //定制custom
		radiusString = [NSString stringWithFormat:@"%@ %@",radiusName,radiusValueString];
	self->radiusCellDescription.tableViewCell.detailTextLabel.text = radiusString;
	
	NSString *imageName = self.alarmTemp.alarmRadiusType.alarmRadiusTypeImageName;
	[(WaitingCell*)self->radiusCellDescription.tableViewCell accessoryImageView0].image = [UIImage imageNamed:imageName];
	
	
	self->radiusCellDescription.tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;	
	return self->radiusCellDescription;
}

- (id)triggerCellDescription{
	
	static NSString *CellIdentifier = @"triggerCellDescription";
	
	if (!self->triggerCellDescription) {
		self->triggerCellDescription = [[TableViewCellDescription alloc] init];
		UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
		cell.textLabel.text = KLabelAlarmTrigger;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		self->triggerCellDescription.tableViewCell = cell;
		self->triggerCellDescription.didSelectCellSelector = @selector(didSelectNavCell:);
		AlarmTriggerTableViewController *viewCtler = [[[AlarmTriggerTableViewController alloc] initWithStyle:UITableViewStyleGrouped alarm:self.alarmTemp] autorelease];
		self->triggerCellDescription.didSelectCellObject = viewCtler;
		
	}
	if (self.alarmTemp.positionType) {
		self->triggerCellDescription.tableViewCell.detailTextLabel.text = self.alarmTemp.positionType.positionTypeName;
	}else {
		self->triggerCellDescription.tableViewCell.detailTextLabel.text = kDicTriggerTypeNameWhenArrive; //兼容1.3版本前
	}

	
	return self->triggerCellDescription;
}


- (void) didSelectNavDestionationCell:(id)sender{
	
	UIViewController *detailController1 = (UIViewController*)sender;
    UINavigationController *detailNavigationController1 = [[[UINavigationController alloc] initWithRootViewController:detailController1] autorelease];
	[self presentModalViewController:detailNavigationController1 animated:YES];
	
}
- (id)destionationCellDescription{
		
	if (!self->destionationCellDescription) {
		self->destionationCellDescription = [[TableViewCellDescription alloc] init];
		
		IADestinationCell *cell = [IADestinationCell viewWithXib];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.titleLabel.text = KLabelAlarmPostion;
		self->destionationCellDescription.tableViewCell = cell;
		
		self->destionationCellDescription.didSelectCellSelector = @selector(didSelectNavDestionationCell:); //向上动画，与其他的左右动画cell有区别
		AlarmPositionMapViewController *mapViewCtler = [[[AlarmPositionMapViewController alloc] initWithNibName:@"AlarmPositionMapViewController" bundle:nil alarm:self.alarmTemp] autorelease];
		//新创建AlarmAnnotation标识
		[mapViewCtler setNewAlarmAnnotation:YES];
		self->destionationCellDescription.didSelectCellObject = mapViewCtler;

	}
	
	IADestinationCell *theCell = (IADestinationCell*)self->destionationCellDescription.tableViewCell;
	theCell.addressLabel.text = self.alarmTemp.positionShort;

	if (CLLocationCoordinate2DIsValid(self.alarmTemp.coordinate) && [YCSystemStatus deviceStatusSingleInstance].lastLocation) {
		[theCell setAddressLabelWithLarge:NO];
		NSString *distanceString = [self distanceStringFromDestionationToCurrentLocation:[YCSystemStatus deviceStatusSingleInstance].lastLocation];
		[theCell setDistanceWaiting:NO andDistanceText:distanceString];
	}else {
		[theCell setAddressLabelWithLarge:YES];
	}

	
	return self->destionationCellDescription;
}


@synthesize ringplayer;
- (YCSoundPlayer*)vibratePlayer{
	if (vibratePlayer == nil) {
		vibratePlayer = [[YCSoundPlayer alloc] initWithVibrate];
	}
	return vibratePlayer;
}


#pragma mark - 
#pragma mark Utility 


-(void)setTableCellsUserInteractionEnabled:(BOOL)enabled{
    
	self.enablingCellDescription.tableViewCell.userInteractionEnabled = enabled;
	self.enablingCellDescription.tableViewCell.textLabel.enabled = enabled;
	self.enablingCellDescription.tableViewCell.detailTextLabel.enabled = enabled;
	[(BoolCell*)self.enablingCellDescription.tableViewCell switchCtl].enabled = enabled;
	
    
	self.repeatCellDescription.tableViewCell.userInteractionEnabled = enabled;
	self.repeatCellDescription.tableViewCell.textLabel.enabled = enabled;
	self.repeatCellDescription.tableViewCell.detailTextLabel.enabled = enabled;
	
	self.soundCellDescription.tableViewCell.userInteractionEnabled = enabled;
	self.soundCellDescription.tableViewCell.textLabel.enabled = enabled;
	self.soundCellDescription.tableViewCell.detailTextLabel.enabled = enabled;
	
	self.vibrateCellDescription.tableViewCell.userInteractionEnabled = enabled;
	self.vibrateCellDescription.tableViewCell.textLabel.enabled = enabled;
	self.vibrateCellDescription.tableViewCell.detailTextLabel.enabled = enabled;
	[(BoolCell*)self.vibrateCellDescription.tableViewCell switchCtl].enabled = enabled;
	
	self.radiusCellDescription.tableViewCell.userInteractionEnabled = enabled;
	self.radiusCellDescription.tableViewCell.textLabel.enabled = enabled;
	self.radiusCellDescription.tableViewCell.detailTextLabel.enabled = enabled;
	[(WaitingCell*)self.radiusCellDescription.tableViewCell setAccessoryViewEnabled:enabled];
	
	self.nameCellDescription.tableViewCell.userInteractionEnabled = enabled;
	self.nameCellDescription.tableViewCell.textLabel.enabled = enabled;
	self.nameCellDescription.tableViewCell.detailTextLabel.enabled = enabled;
	
	self.triggerCellDescription.tableViewCell.userInteractionEnabled = enabled;
	self.triggerCellDescription.tableViewCell.textLabel.enabled = enabled;
	self.triggerCellDescription.tableViewCell.detailTextLabel.enabled = enabled;
	
	self.destionationCellDescription.tableViewCell.userInteractionEnabled = enabled;
    
	//self.navigationController.navigationBar.userInteractionEnabled = enabled;
	/*
     //addressCellDescription 不变灰，所以只userInteractionEnabled
     //self.addressCellDescription.tableViewCell.userInteractionEnabled = enabled;
	 */
    
	self.notesCellDescription.tableViewCell.userInteractionEnabled = enabled;
	self.notesCellDescription.tableViewCell.textLabel.enabled = enabled;
	self.notesCellDescription.tableViewCell.detailTextLabel.enabled = enabled;
    
    self.testAlarmButton.enabled = enabled;
    
}


//显示距离当前位置XX公里
- (NSString*)distanceStringFromDestionationToCurrentLocation:(CLLocation*)location{
	//设置距离文本
    NSString * s = nil;
    CLLocation *aLocation = [[[CLLocation alloc] initWithLatitude:self.alarmTemp.coordinate.latitude longitude:self.alarmTemp.coordinate.longitude] autorelease];
    CLLocationDistance distance = [location distanceFromLocation:aLocation];
    
    if (distance > 100.0) 
        s = [NSString stringWithFormat:KTextPromptDistanceCurrentLocation,[location distanceFromLocation:aLocation]/1000.0];
    else
        s = KTextPromptCurrentLocation;
	
	return s;
}

//等待结束，显示距离当前位置XX公里
- (void)setDistanceLabelVisibleInFooterViewWithCurrentLocation:(CLLocation*)location{
    //结束等待
    self.footerView.waitingAIView.hidden = YES; 
    self.footerView.distanceLabel.hidden = NO;
    
    //设置距离文本
    NSString * s = nil;
    CLLocation *aLocation = [[[CLLocation alloc] initWithLatitude:self.alarmTemp.coordinate.latitude longitude:self.alarmTemp.coordinate.longitude] autorelease];
    CLLocationDistance distance = [location distanceFromLocation:aLocation];
    
    if (distance > 100.0) 
        s = [NSString stringWithFormat:KTextPromptDistanceCurrentLocation,[location distanceFromLocation:aLocation]/1000.0];
    else
        s = KTextPromptItIsCurrentLocation;
    self.footerView.distanceLabel.text = s;
    
    //下面的提示文体向下推
    self.footerView.promptLabel.frame = CGRectMake(19.0,32.0,284.0,170.0);
    
    
    [self.tableView reloadData];
}

//等待结束，没有定位数据。把下面的提示文体向上提
- (void)setDistanceLabelHiddenInFooterView{
    //结束等待
    self.footerView.waitingAIView.hidden = YES; 
    self.footerView.distanceLabel.hidden = YES;
    
    //下面的提示文体向上提
    self.footerView.promptLabel.frame = CGRectMake(19.0,5.0,284.0,170.0);
    
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark Notification

/*
-(BOOL) isValidCoordinate:(CLLocationCoordinate2D)coordinate
{
	
	int la = (int)coordinate.latitude;
	int lo = (int)coordinate.longitude;
	if (la == 0 && lo == 0 ) 
		return NO;

	
	return CLLocationCoordinate2DIsValid(coordinate);
}
 */

/*
//闹钟的地址通过地图改变了
- (void) handle_alarmItemsDidChange: (id) notification {
	
	[self.cellDescriptions release];
	self->cellDescriptions = nil;
	[self.tableView reloadData];  //重新加载
	
	if ([self isValidCoordinate:self.alarmTemp.coordinate]) { //有效坐标才允许保存
		self.saveButtonItem.enabled = YES;
	}
	
}
 */


- (void)setCellDistanceString:(NSString*)distanceString{
	IADestinationCell* desCell = (IADestinationCell*)self.destionationCellDescription.tableViewCell;
	[desCell setDistanceWaiting:NO andDistanceText:distanceString];//出现等待圈
}

- (void) handle_standardLocationDidFinish: (NSNotification*) notification{
    //还没加载
	if (![self isViewLoaded]) return;
    
    //自己定位的不处理第二遍
    if ([notification object] == self ) return;
    
    //正在定位
    if (locatingAndReversingStatus != IALocatingAndReversingStatusNone) return;
    
    //间隔20秒以上才更新
    if (!(self.lastUpdateDistanceTimestamp == nil || [self.lastUpdateDistanceTimestamp timeIntervalSinceNow] < -20)) 
        return;
    self.lastUpdateDistanceTimestamp = [NSDate date]; //更新时间戳
    

    
    //让用户看到等待
    self.footerView.waitingAIView.frame = CGRectMake(20.0,8.0,20.0,20.0);
    self.footerView.distanceLabel.frame = CGRectMake(22.0,0.0,284.0,33.0);
    self.footerView.promptLabel.frame = CGRectMake(19.0,32.0,284.0,170.0);
    self.footerView.waitingAIView.hidden = NO;
    [self.footerView.waitingAIView startAnimating];
    self.footerView.distanceLabel.hidden = YES;
    
    CLLocation *location = [[notification userInfo] objectForKey:IAStandardLocationKey];
    if (location) {
        
        if (CLLocationCoordinate2DIsValid(self.alarmTemp.coordinate)) {

            [self performSelector:@selector(setDistanceLabelVisibleInFooterViewWithCurrentLocation:) withObject:location afterDelay:1.5];//有距离数据， 看x秒等待圈
            
        }else{
            [self performSelector:@selector(setDistanceLabelHiddenInFooterView) withObject:nil afterDelay:2.0];//没有距离数据， 也看x秒等待圈
        }
        
    }else{

        [self performSelector:@selector(setDistanceLabelHiddenInFooterView) withObject:nil afterDelay:2.0];//没有距离数据， 也看x秒等待圈
    }
    
	//新的cell
	if (location) {
        
        if (CLLocationCoordinate2DIsValid(self.alarmTemp.coordinate)) {
			IADestinationCell* desCell = (IADestinationCell*)self.destionationCellDescription.tableViewCell;
			[desCell setDistanceWaiting:YES andDistanceText:nil];//出现等待圈
			NSString *distanceString = [self distanceStringFromDestionationToCurrentLocation:location];
            [self performSelector:@selector(setCellDistanceString:) withObject:distanceString afterDelay:1.5];//有距离数据，看x秒等待圈
        }
        
    }
	

    [self.tableView reloadData];

    
}
 

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
	self.cellDescriptions = nil;
	[self.tableView reloadData];  //重新加载
	
	if (CLLocationCoordinate2DIsValid(self.alarmTemp.coordinate)) { //有效坐标才允许保存
		self.saveButtonItem.enabled = YES;
        self.testAlarmButton.enabled = YES;
	}else {
		self.saveButtonItem.enabled = NO;
        self.testAlarmButton.enabled = NO;
	}

}

- (void) handle_applicationDidEnterBackground:(id)notification{	

}

/*
- (void) handle_applicationWillResignActive:(id)notification{	
	//恢复navbar 标题
	self.navigationItem.titleView = nil;
}
*/

- (void) registerNotifications {
	/*
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	[notificationCenter addObserver: self
						   selector: @selector (handle_alarmItemsDidChange:)
							   name: IAAlarmItemsDidChangeNotification
							 object: nil];
	 */
	
	/*
	[self.alarmTemp addObserver:self forKeyPath:@"alarmName" options:0 context:nil];
	[self.alarmTemp addObserver:self forKeyPath:@"position" options:0 context:nil];
	[self.alarmTemp addObserver:self forKeyPath:@"positionShort" options:0 context:nil];
	[self.alarmTemp addObserver:self forKeyPath:@"description" options:0 context:nil];
	[self.alarmTemp addObserver:self forKeyPath:@"enabling" options:0 context:nil];
	[self.alarmTemp addObserver:self forKeyPath:@"coordinate" options:0 context:nil];
	[self.alarmTemp addObserver:self forKeyPath:@"vibrate" options:0 context:nil];
	[self.alarmTemp addObserver:self forKeyPath:@"sound" options:0 context:nil];
	[self.alarmTemp addObserver:self forKeyPath:@"repeatType" options:0 context:nil];
	[self.alarmTemp addObserver:self forKeyPath:@"alarmRadiusType" options:0 context:nil];
	[self.alarmTemp addObserver:self forKeyPath:@"radius" options:0 context:nil];
	 */
	
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

	
	[notificationCenter addObserver: self
						   selector: @selector (handle_applicationDidEnterBackground:)
							   name: UIApplicationDidEnterBackgroundNotification
							 object: nil];
	
	//有新的定位数据产生
	 [notificationCenter addObserver: self
							 selector: @selector (handle_standardLocationDidFinish:)
							 name: IAStandardLocationDidFinishNotification
							 object: nil];
	/*
	[notificationCenter addObserver: self
						   selector: @selector (handle_applicationWillResignActive:)
							   name: UIApplicationWillResignActiveNotification
							 object: nil];
	 */
	
	
}

- (void) unRegisterNotifications {
	
	/*
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	[notificationCenter removeObserver: self
								  name: IAAlarmItemsDidChangeNotification
							    object: nil];
	 */
	/*
	[self.alarmTemp removeObserver:self forKeyPath:@"alarmName"];
	[self.alarmTemp removeObserver:self forKeyPath:@"position"];
	[self.alarmTemp removeObserver:self forKeyPath:@"positionShort"];
	[self.alarmTemp removeObserver:self forKeyPath:@"description"];
	[self.alarmTemp removeObserver:self forKeyPath:@"enabling"];
	[self.alarmTemp removeObserver:self forKeyPath:@"coordinate"];
	[self.alarmTemp removeObserver:self forKeyPath:@"vibrate"];
	[self.alarmTemp removeObserver:self forKeyPath:@"sound"];
	[self.alarmTemp removeObserver:self forKeyPath:@"repeatType"];
	[self.alarmTemp removeObserver:self forKeyPath:@"alarmRadiusType"];
	[self.alarmTemp removeObserver:self forKeyPath:@"radius"];
	 */
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
	[notificationCenter removeObserver:self	name: UIApplicationDidEnterBackgroundNotification object: nil];
	[notificationCenter removeObserver:self	name: IAStandardLocationDidFinishNotification object: nil];
	//[notificationCenter removeObserver:self	name: UIApplicationWillResignActiveNotification object: nil];
}




#pragma mark -
#pragma mark Events Handle

-(IBAction)cancelButtonItemPressed:(id)sender{
	
	[self.navigationController dismissModalViewControllerAnimated:YES];
}


-(IBAction)saveButtonItemPressed:(id)sender{
	
	///////////////////////
	//保存闹钟
	self.alarm.enabling = self.alarmTemp.enabling;
	self.alarm.coordinate = self.alarmTemp.coordinate;
	self.alarm.alarmName = self.alarmTemp.alarmName;
	self.alarm.position = self.alarmTemp.position;
	self.alarm.positionShort = self.alarmTemp.positionShort;
	self.alarm.usedCoordinateAddress = self.alarmTemp.usedCoordinateAddress;
	self.alarm.nameChanged = self.alarmTemp.nameChanged;
	self.alarm.sound = self.alarmTemp.sound;
	self.alarm.repeatType = self.alarmTemp.repeatType;
	self.alarm.vibrate = self.alarmTemp.vibrate;
	self.alarm.alarmRadiusType = self.alarmTemp.alarmRadiusType;
	self.alarm.radius = self.alarmTemp.radius;
	self.alarm.positionType = self.alarmTemp.positionType;
    self.alarm.notes = self.alarmTemp.notes;
    
    self.alarm.reserve1 = self.alarmTemp.reserve1;
    self.alarm.reserve2 = self.alarmTemp.reserve2;
    self.alarm.reserve3 = self.alarmTemp.reserve3;
	
	[self.alarm saveFromSender:self];
	//[self.alarm sendNotifyToUpdateAllViewsFromSender:self];
	///////////////////////

	
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

-(IBAction)testAlarmButtonPressed:(id)sender{
    
    //保存到文件
    IAAlarmNotification *alarmNotification = [[[IAAlarmNotification alloc] initWithAlarm:self.alarmTemp] autorelease];
    [[IAAlarmNotificationCenter defaultCenter] addNotification:alarmNotification];
    
    //发本地通知
    BOOL arrived = [self.alarmTemp.positionType.positionTypeId isEqualToString:@"p002"];//是 “到达时候”提醒
    NSString *promptTemple = arrived?kAlertFrmStringArrived:kAlertFrmStringLeaved;
    NSString *alertBody = [[[NSString alloc] initWithFormat:promptTemple,self.alarmTemp.alarmName,0.0] autorelease];
    NSString *alarmNotes = [self.alarmTemp.notes trim];
    if (alarmNotes && alarmNotes.length > 0) {
        alertBody = [NSString stringWithFormat:@"%@: %@",alertBody,alarmNotes];
    }
    
    UIApplication *app = [UIApplication sharedApplication];
    NSInteger badgeNumber = app.applicationIconBadgeNumber + 1; //角标数
    UILocalNotification *notification = [[[UILocalNotification alloc] init] autorelease];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.repeatInterval = 0;
    notification.soundName = self.alarmTemp.sound.soundFileName;
    notification.alertBody = alertBody;
    notification.applicationIconBadgeNumber = badgeNumber;
    notification.userInfo = [NSDictionary dictionaryWithObject:alarmNotification.notificationId forKey:@"knotificationId"];
    [app scheduleLocalNotification:notification];
}

#pragma mark -
#pragma mark AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
	[self.vibratePlayer stop];
}


#pragma mark - 
#pragma mark Utility for ReverseGeocoder Location

#define kTimeOutForReverse 8.0

-(void)beginReverse
{	
	self->endingManual = NO;
	self->locatingAndReversingStatus = IALocatingAndReversingStatusReversing;
	
	
	// 显示等待指示控件
	WaitingCell* cell = (WaitingCell*)self.addressCellDescription.tableViewCell;
	if (!cell.waiting) {
		[self setTableCellsUserInteractionEnabled:NO]; //定位结束前不允许操作其他
		cell.activityLabel.text = KTextPromptWhenReversing;
		cell.activityImageView.image = [UIImage imageNamed:@"IALocationArrow.png"];
		[cell setWaiting:YES];
		[self.tableView reloadData]; //刷新界面
	}
	//新的cell
	IADestinationCell* desCell = (IADestinationCell*)self.destionationCellDescription.tableViewCell;
	[desCell setWaiting:YES andWaitText:KTextPromptWhenReversing];
	
	//初始化，reverseGeocoder对象必须根据特定坐标init。
	reverseGeocoder = [self reverseGeocoder:self->coordinateForReverse];
	reverseGeocoder.delegate = self;
	
	//界面提示 :
	self.titleForFooter = nil;
    self.footerView = nil;
	
	//反转坐标
	self.placemarkForReverse = nil; //先赋空相关数据
	[reverseGeocoder start];
	[self performSelector:@selector(endReverse) withObject:nil afterDelay:kTimeOutForReverse];
}
 



-(void)endReverse
{
	///////////////////////////////////
	//已经被释放了
	if (![self isKindOfClass:[AlarmDetailTableViewController class]])
		return;
	if (![reverseGeocoder respondsToSelector:@selector(cancel)])
		return;
	///////////////////////////////////
	
	//如果超时了，反转还没结束，结束它
	[reverseGeocoder cancel];
	//取消掉另一个调用
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endReverse) object:nil];
	
	
	if (self->endingManual) {//手工结束，不处理数据
		self.cellDescriptions = nil;
		[self setTableCellsUserInteractionEnabled:YES]; 
		[(WaitingCell*)self.addressCellDescription.tableViewCell setWaiting:NO];
		
		[self.tableView reloadData]; //刷新界面，使用原来的数据
		self->locatingAndReversingStatus = IALocatingAndReversingStatusNone;
		return;
	}
	

	//闹钟坐标赋值
	if (CLLocationCoordinate2DIsValid(self->coordinateForReverse)) {
		self.alarmTemp.coordinate = self->coordinateForReverse;
		if (self.bestEffortAtLocation) //如果是通过定位
			self.alarmTemp.locationAccuracy = self.bestEffortAtLocation.horizontalAccuracy;
	}
	
	CLLocationCoordinate2D coordinate = self->coordinateForReverse;
	self.alarmTemp.usedCoordinateAddress = NO;  
	//闹钟位置、名称赋值
	if (self.placemarkForReverse == nil) {
		//反转坐标 失败，使用坐标作为地址；名称不改变
		if (CLLocationCoordinate2DIsValid(self->coordinateForReverse)) {
			self.alarmTemp.position = [UIUtility convertCoordinate:coordinate];
			self.alarmTemp.positionShort = [UIUtility convertCoordinate:coordinate];
            self.alarmTemp.reserve1 = self.alarmTemp.positionShort;  //做为addressTitle
		}
		self.alarmTemp.usedCoordinateAddress = YES; 
		
		//界面提示 : 反转地址失败
		self.titleForFooter = KTextPromptNeedInternetToReversing;

	}else {

		MKPlacemark *placemark = self.placemarkForReverse;
		NSString *addressTitle = nil;
		NSString *addressShort = nil;
		NSString *address = nil;
		
		address = YCGetAddressString(placemark);
		
		addressShort = YCGetAddressShortString(placemark);
		addressShort = (addressShort != nil) ? addressShort : address;
		
		addressTitle = YCGetAddressTitleString(placemark);
		addressTitle = (addressTitle != nil) ? addressTitle : addressShort;
		
		//最后的判空
		addressTitle = (addressTitle != nil) ? addressTitle:KDefaultAlarmName;
		if (addressShort == nil) {
			self.alarmTemp.usedCoordinateAddress = YES;
			addressShort = (addressShort != nil) ? addressShort : [UIUtility convertCoordinate:coordinate];
		}
		address = (address != nil) ? address : [UIUtility convertCoordinate:coordinate];
		
		
		self.alarmTemp.position = address;
		self.alarmTemp.positionShort = addressShort;
        self.alarmTemp.reserve1 = addressTitle;  //做为addressTitle
		if (!self.alarmTemp.nameChanged) 
			self.alarmTemp.alarmName = addressTitle;
		
	}
	
	self.cellDescriptions = nil;
	
	[self setTableCellsUserInteractionEnabled:YES]; //可以用了

	[(WaitingCell*)self.addressCellDescription.tableViewCell setWaiting:NO];
	//新的cell
	IADestinationCell* desCell = (IADestinationCell*)self.destionationCellDescription.tableViewCell;
	[desCell setWaiting:NO andWaitText:NO];
	
	[self.tableView reloadData]; //最后，刷新界面
    

    //重新生成footer中的距离label
    self.footerView = nil;
    if (CLLocationCoordinate2DIsValid(self.alarmTemp.coordinate) && [YCSystemStatus deviceStatusSingleInstance].lastLocation) {
        [self setDistanceLabelVisibleInFooterViewWithCurrentLocation:[YCSystemStatus deviceStatusSingleInstance].lastLocation];
    }
    

	self->locatingAndReversingStatus = IALocatingAndReversingStatusNone;
}


#define kTimeOutForLocation 12.0
-(void)beginLocation
{
	self->endingManual = NO;
	self->locatingAndReversingStatus = IALocatingAndReversingStatusLocating;
	
	//检测定位服务状态。如果不可用或未授权，弹出对话框
	[self.locationServicesUsableAlert locationServicesUsable];
    
    //定位服务没有开启，或没有授权时候：收到失败数据就直接结束定位
	BOOL enabledLocation = [[YCSystemStatus deviceStatusSingleInstance] enabledLocation];
	if (!enabledLocation) {
		self.bestEffortAtLocation = nil;
		[self performSelector:@selector(endLocation) withObject:nil afterDelay:0.1];  //数据更新后，等待x秒
	}
	
	//self.cancelButtonItem.enabled = NO;   //定位结束前不允许回退
	[self setTableCellsUserInteractionEnabled:NO]; //定位结束前不允许操作其他
	
	// 显示等待指示控件
	WaitingCell* cell = (WaitingCell*)self.addressCellDescription.tableViewCell;
	cell.activityLabel.text = KTextPromptWhenLocating;
	cell.activityImageView.image = [UIImage imageNamed:@"IALocationArrow.png"];
	[cell setWaiting:YES];
	
	//新的cell
	IADestinationCell* desCell = (IADestinationCell*)self.destionationCellDescription.tableViewCell;
	[desCell setWaiting:YES andWaitText:KTextPromptWhenLocating];
	
	[self.tableView reloadData]; //刷新界面
	
	//界面提示 :
	self.titleForFooter = nil;
    self.footerView = nil;
	
	// Start the location manager.
	self.bestEffortAtLocation = nil; //先赋空相关数据
	[[self locationManager] startUpdatingLocation];
	[self performSelector:@selector(endLocation) withObject:nil afterDelay:kTimeOutForLocation];
}

-(void)endLocation
{
	///////////////////////////////////
	//已经被释放了
	if (![self isKindOfClass:[AlarmDetailTableViewController class]])
		return;
	///////////////////////////////////
	
	//如果超时了，反转还没结束，结束它
	[[self locationManager] stopUpdatingLocation];
	//取消掉另一个调用
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endLocation) object:nil];
	
	if (self->endingManual) {//手工结束，不处理数据
		self.cellDescriptions = nil;
		[self setTableCellsUserInteractionEnabled:YES]; 
		[(WaitingCell*)self.addressCellDescription.tableViewCell setWaiting:NO];
	
		[self.tableView reloadData]; //刷新界面，使用原来的数据
		self->locatingAndReversingStatus = IALocatingAndReversingStatusNone;
		return;
	}
		
		
	if(self.bestEffortAtLocation==nil)
	{
		self.cellDescriptions = nil;

		[self setTableCellsUserInteractionEnabled:YES]; //定位失败、不用反转地址，可以了
		
		//界面提示 : 定位失败
		self.titleForFooter = KTextPromptNeedSetLocationByMaps;
		
		[(WaitingCell*)self.addressCellDescription.tableViewCell setWaiting:NO];
		
		//新的cell
		IADestinationCell* desCell = (IADestinationCell*)self.destionationCellDescription.tableViewCell;
		[desCell setWaiting:NO andWaitText:nil];
        [(IADestinationCell*)(self.destionationCellDescription.tableViewCell) setMoveArrow:YES]; //显示箭头动画

		
		self.alarmTemp.coordinate = CLLocationCoordinate2DMake(-1000.0, -1000.0);
		self.alarmTemp.position = nil;
		self.alarmTemp.positionShort = nil;
		[self.tableView reloadData]; //失败了，刷新界面，赋空数据
		
		
		self->locatingAndReversingStatus = IALocatingAndReversingStatusNone;
	}else {
        
        //发送定位结束通知
        [YCSystemStatus deviceStatusSingleInstance].lastLocation = self.bestEffortAtLocation;
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.bestEffortAtLocation forKey:IAStandardLocationKey];
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        NSNotification *aNotification = [NSNotification notificationWithName:IAStandardLocationDidFinishNotification 
                                                                      object:self 
                                                                    userInfo:userInfo];
        [notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
        
		//开始 反转坐标
		self->coordinateForReverse = self.bestEffortAtLocation.coordinate;
		[self beginReverse]; 
        

        
	}
	
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	isFirstShow = YES;
	//self.alarmTemp = [[self.alarm copy] autorelease];  //为了给enable使用
	
	[self registerNotifications];
	
	//重新loadview
	
	//取消所有定时执行的函数
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	self.cellDescriptions = nil;  
	self.enablingCellDescription = nil;
	self.repeatCellDescription = nil;
	self.soundCellDescription = nil;
	self.vibrateCellDescription = nil;
	self.nameCellDescription = nil;
	self.addressCellDescription = nil;
	self.radiusCellDescription = nil; 
	
	
	self.navigationItem.leftBarButtonItem = self.cancelButtonItem;
	self.navigationItem.rightBarButtonItem = self.saveButtonItem;
	
	if (self.newAlarm) //新增加的闹钟，当前位置作为默认的闹钟地址
	{
		if(CLLocationCoordinate2DIsValid(self.alarmTemp.coordinate)){
			if (self.alarmTemp.usedCoordinateAddress){ //使用的是坐标地址
				self->coordinateForReverse = self.alarmTemp.coordinate;
				[self performSelector:@selector(beginReverse) withObject:nil afterDelay:0.1];
			}
		}else 
			[self performSelector:@selector(beginLocation) withObject:nil afterDelay:0.5];
	
	}else if (self.alarmTemp.usedCoordinateAddress){ //使用的是坐标地址
		if(CLLocationCoordinate2DIsValid(self.alarmTemp.coordinate)){
			self->coordinateForReverse = self.alarmTemp.coordinate;
			[self performSelector:@selector(beginReverse) withObject:nil afterDelay:0.1];
		}
	}

	
	if (self.newAlarm && CLLocationCoordinate2DIsValid(self.alarmTemp.coordinate) && !self.alarmTemp.usedCoordinateAddress) //新alarm而且不用反转地址
		self.saveButtonItem.enabled = YES;
	else 
		self.saveButtonItem.enabled = NO;
	
	//测试按钮
    UIView *viewp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];    
    [viewp addSubview:self.testAlarmButton];
    self.tableView.tableFooterView = viewp;    
    [viewp release];

		
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if (self.newAlarm) 
		self.title = KViewTitleAddAlarms;
	else
		self.title = KViewTitleEditAlarms;
	
	if (NO == isFirstShow) {
		//设置页脚
		if (!CLLocationCoordinate2DIsValid(self.alarmTemp.coordinate)) {
			self.titleForFooter = KTextPromptNeedSetLocationByMaps;
            [(IADestinationCell*)(self.destionationCellDescription.tableViewCell) setMoveArrow:YES]; //显示箭头动画
		}else if (self.alarmTemp.usedCoordinateAddress) {
			self.titleForFooter = KTextPromptNeedInternetToReversing;
            [(IADestinationCell*)(self.destionationCellDescription.tableViewCell) setMoveArrow:NO]; //不显示箭头动画
		}else {
			self.titleForFooter = nil;
            [(IADestinationCell*)(self.destionationCellDescription.tableViewCell) setMoveArrow:NO]; //不显示箭头动画
		}
    
	}
    
    //重新生成footer中的距离label
    self.footerView = nil;
    if (CLLocationCoordinate2DIsValid(self.alarmTemp.coordinate) && [YCSystemStatus deviceStatusSingleInstance].lastLocation) {
        [self setDistanceLabelVisibleInFooterViewWithCurrentLocation:[YCSystemStatus deviceStatusSingleInstance].lastLocation];
    }

	[self.tableView reloadData];
	


	/*
	//防止因annotation的延时显示或选择，出现crash
	UIViewController *rediusViewController = (UIViewController*)self.radiusCellDescription.didSelectCellObject;
	UIViewController *addressViewController = (UIViewController*)self.addressCellDescription.accessoryButtonTappedObject;
	if ([rediusViewController isViewLoaded] || [addressViewController isViewLoaded]) {
		self.navigationItem.leftBarButtonItem.enabled = NO;
		[self.navigationItem.leftBarButtonItem performSelector:@selector(setEnabled:) withInteger:YES afterDelay:0.75];
	}
	 */
	
    
	isFirstShow = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	
	//停止定位
	[self stopLocationAndReverseRestart:NO];
	//[self.locationManager stopUpdatingLocation]; //防止定位不结束，加一道保险
	
	//页脚的提示－赋空
	self.titleForFooter = nil;
    self.footerView = nil;
    
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellDescriptions.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	NSArray *sectionArray = [self.cellDescriptions objectAtIndex:section];
	return sectionArray.count;	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSArray *sectionArray = [self.cellDescriptions objectAtIndex:indexPath.section];
    UITableViewCell *cell = ((TableViewCellDescription*)[sectionArray objectAtIndex:indexPath.row]).tableViewCell;
    cell.backgroundColor = [UIColor whiteColor]; //SDK5.0 cell默认竟然是浅灰
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
	if (1 == section) {
		return self.titleForFooter;
	}
	return nil;
}
 


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//取消行选中
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSArray *sectionArray = [self.cellDescriptions objectAtIndex:indexPath.section];
	TableViewCellDescription *tableViewCellDescription= ((TableViewCellDescription*)[sectionArray objectAtIndex:indexPath.row]);
    SEL selector = tableViewCellDescription.didSelectCellSelector;
	if (selector) {
		[self performSelector:selector withObject:tableViewCellDescription.didSelectCellObject];
	}
	
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (1 == section) {
        self.footerView.promptLabel.text = self.titleForFooter;
        
        if (self.titleForFooter) {
            //根据文本的多少，计算高度
            CGRect labelTextRect = [self.footerView.promptLabel textRectForBounds:self.footerView.promptLabel.frame limitedToNumberOfLines:0];
            self.footerView.promptLabel.frame = labelTextRect;
             
        }
        
		return self.footerView;
	}
	return nil;
}
 */



/*
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
	
	NSArray *sectionArray = [self.cellDescriptions objectAtIndex:indexPath.section];
	TableViewCellDescription *tableViewCellDescription= ((TableViewCellDescription*)[sectionArray objectAtIndex:indexPath.row]);
    SEL selector = tableViewCellDescription.accessoryButtonTappedSelector;
	if (selector) {
		[self performSelector:selector withObject:tableViewCellDescription];
	}
}
 */



#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	
	NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
	
    if (abs(howRecent) > 5.0) return;
	
	
	if (newLocation.horizontalAccuracy > kMiddleAccuracyThreshold)
	{
		return;
	}
	
	if (bestEffortAtLocation == nil || bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy) 
	{
        self.bestEffortAtLocation = newLocation;
		
		if (newLocation.horizontalAccuracy <= kCLLocationAccuracyHundredMeters) //百米精度足以，不用浪费时间
		{
			[[self locationManager] stopUpdatingLocation];
			[self performSelector:@selector(endLocation) withObject:nil afterDelay:0.0];  
			
			return;
		}
		
		if (newLocation.horizontalAccuracy <= 251.0) //中等精度，多开x秒
		{
			[[self locationManager] stopUpdatingLocation];
			[self performSelector:@selector(endLocation) withObject:nil afterDelay:5.0];  //数据更新后，等待x秒
			
			return;
		}
    }
	
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{	
	//定位服务没有开启，或没有授权时候：收到失败数据就直接结束定位
	BOOL enabledLocation = [[YCSystemStatus deviceStatusSingleInstance] enabledLocation];
	if (!enabledLocation) {
		self.bestEffortAtLocation = nil;
		[self performSelector:@selector(endLocation) withObject:nil afterDelay:0.1];  //数据更新后，等待x秒
	}
}




#pragma mark -
#pragma mark MKReverseGeocoderDelegate
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
	self.placemarkForReverse = placemark;
	[self performSelector:@selector(endReverse) withObject:nil afterDelay:0.1];  //数据更新后，等待x秒
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{	
	//无网络连接时候，收到失败数据，就结束反转
	BOOL connectedToInternet = [[YCSystemStatus deviceStatusSingleInstance] connectedToInternet];
	if (!connectedToInternet) {
		self.placemarkForReverse = nil;
		[self performSelector:@selector(endReverse) withObject:nil afterDelay:0.1];  //等待x秒，结束
	}
}



#pragma mark -
#pragma mark Memory management

//释放资源，在viewDidLoad或能按要求重新创建的
-(void)freeResouceRecreated{

	[self unRegisterNotifications];
	
	[locationManager stopUpdatingLocation];
	[locationManager release]; locationManager = nil;
	[reverseGeocoder release]; reverseGeocoder = nil;
	[bestEffortAtLocation release]; bestEffortAtLocation = nil;
	[placemarkForReverse release]; placemarkForReverse = nil;
}

- (void)viewDidUnload {
	[super viewDidUnload];
	[self freeResouceRecreated];
}


- (void)dealloc {
	
	[self freeResouceRecreated];

	
	//取消所有定时执行的函数
	[reverseGeocoder cancel];
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	
    [lastUpdateDistanceTimestamp release];
	[locationManager release];
	[reverseGeocoder release];
	[bestEffortAtLocation release];
	[placemarkForReverse release];
	
	[locationServicesUsableAlert release];
	[cancelButtonItem release];
	[saveButtonItem release];
    [testAlarmButton release];
	
	[cellDescriptions release];
	[enablingCellDescription release];            
	[repeatCellDescription release];             
	[soundCellDescription release];              
	[vibrateCellDescription release];            
	[nameCellDescription release];    
	[notesCellDescription release];
	
	[addressCellDescription release];
	[radiusCellDescription release];
	[triggerCellDescription release];
	[destionationCellDescription release];
	
	[titleForFooter release];
    [footerView release];
	
	[alarm release];
	
	//////////////////////////////////
	if (alarmTemp) {
		//if (!self.newAlarm) {
			[alarmTemp removeObserver:self forKeyPath:@"alarmName"];
			[alarmTemp removeObserver:self forKeyPath:@"position"];
			[alarmTemp removeObserver:self forKeyPath:@"positionShort"];
			//[alarmTemp removeObserver:self forKeyPath:@"notes"];
			[alarmTemp removeObserver:self forKeyPath:@"enabling"];
			[alarmTemp removeObserver:self forKeyPath:@"coordinate"];
			[alarmTemp removeObserver:self forKeyPath:@"vibrate"];
			[alarmTemp removeObserver:self forKeyPath:@"sound"];
			[alarmTemp removeObserver:self forKeyPath:@"repeatType"];
			[alarmTemp removeObserver:self forKeyPath:@"alarmRadiusType"];
			[alarmTemp removeObserver:self forKeyPath:@"radius"];
			[alarmTemp removeObserver:self forKeyPath:@"positionType"];
            [alarmTemp removeObserver:self forKeyPath:@"notes"];
		//}
	}
	[alarmTemp release];
	//////////////////////////////////
    
    [vibratePlayer release];
    [ringplayer release];
	
    [super dealloc];
}


@end

