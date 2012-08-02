//
//  DetailTableViewController.m
//  TestLocationTableCell1
//
//  Created by li shiyong on 10-12-16.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IAAlarmSchedule.h"
#import "YCLib.h"
#import "IAContactManager.h"
#import "IAPerson.h"
#import "YCLocationManager.h"
#import "CLLocation+YC.h"
#import "IAAlarmNotificationCenter.h"
#import "UIColor+YC.h"
#import "IAAlarmFindViewController.h"
#import "IAAlarmNotification.h"
#import "AlarmNotesViewController.h"
#import "NSString+YC.h"
#import "YCSoundPlayer.h"
#import "IADestinationCell.h"
#import "AlarmTriggerTableViewController.h"
#import "YCPositionType.h"
#import "IAGlobal.h"
#import "NSObject+YC.h"
#import "UIViewController+YC.h"
#import "IANotifications.h"
#import "AlarmDetailFooterView.h"
#import "YCSystemStatus.h"
#import "YClocationServicesUsableAlert.h"
#import "YCMaps.h"
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
#import "AlarmsMapListViewController.h"
#import "BackgroundViewController.h"


@implementation AlarmDetailTableViewController

#pragma mark -
#pragma mark property

@synthesize locationServicesUsableAlert;
@synthesize newAlarm;
@synthesize alarm;
@synthesize alarmTemp;
@synthesize bestEffortAtLocation;

@synthesize cellDescriptions;   
@synthesize enabledCellDescription;
@synthesize repeatCellDescription;
@synthesize soundCellDescription;
@synthesize vibrateCellDescription;
@synthesize nameCellDescription;
@synthesize radiusCellDescription;
@synthesize destionationCellDescription;
@synthesize notesCellDescription;

- (void)setAlarmTemp:(IAAlarm*)obj{
	[obj retain];
	[alarmTemp release];
	alarmTemp = obj;
}

- (id)alarmTemp{

	if (alarmTemp == nil) {
		alarmTemp = [self.alarm copy];
        
        [alarmTemp addObserver:self forKeyPath:@"alarmName" options:0 context:nil];
        [alarmTemp addObserver:self forKeyPath:@"positionTitle" options:0 context:nil];
        [alarmTemp addObserver:self forKeyPath:@"positionShort" options:0 context:nil];
        [alarmTemp addObserver:self forKeyPath:@"position" options:0 context:nil];
        [alarmTemp addObserver:self forKeyPath:@"placemark" options:0 context:nil];
        [alarmTemp addObserver:self forKeyPath:@"enabled" options:0 context:nil];
        [alarmTemp addObserver:self forKeyPath:@"realCoordinate" options:0 context:nil];
        [alarmTemp addObserver:self forKeyPath:@"visualCoordinate" options:0 context:nil];
        [alarmTemp addObserver:self forKeyPath:@"vibrate" options:0 context:nil];
        [alarmTemp addObserver:self forKeyPath:@"sound" options:0 context:nil];
        [alarmTemp addObserver:self forKeyPath:@"repeatType" options:0 context:nil];
        [alarmTemp addObserver:self forKeyPath:@"alarmRadiusType" options:0 context:nil];
        [alarmTemp addObserver:self forKeyPath:@"radius" options:0 context:nil];
        [alarmTemp addObserver:self forKeyPath:@"positionType" options:0 context:nil];
        [alarmTemp addObserver:self forKeyPath:@"notes" options:0 context:nil];
        [alarmTemp addObserver:self forKeyPath:@"person" options:0 context:nil];
        [alarmTemp addObserver:self forKeyPath:@"indexOfPersonAddresses" options:0 context:nil];
        [alarmTemp addObserver:self forKeyPath:@"usedAlarmSchedule" options:0 context:nil];
        [alarmTemp addObserver:self forKeyPath:@"alarmSchedules" options:0 context:nil];
        [alarmTemp addObserver:self forKeyPath:@"sameBeginEndTime" options:0 context:nil];
         
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
        [self->testAlarmButton setTitle:KTitleTest forState:UIControlStateNormal & UIControlStateHighlighted];
        self->testAlarmButton.titleLabel.font            = [UIFont boldSystemFontOfSize: 19];
        self->testAlarmButton.titleLabel.lineBreakMode   = UILineBreakModeTailTruncation;
        self->testAlarmButton.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self->testAlarmButton.titleLabel.shadowOffset    = CGSizeMake (0.0, -1.0);
        
        [self->testAlarmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self->testAlarmButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];


        UIImage *image = [UIImage imageNamed:@"UIPopoverButton.png"];
        UIImage *newImage = [image stretchableImageWithLeftCapWidth:8 topCapHeight:8];
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
							  self.enabledCellDescription
							 ,nil];
		
		NSArray *twoArray = nil;
		
        if ([YCParam paramSingleInstance].leaveAlarmEnabled) { //启用离开闹钟
		
            twoArray = [NSArray arrayWithObjects:
                        self.repeatCellDescription
                        ,self.soundCellDescription
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
//enabledCellDescription

- (void)didChangedSwitchCtlInEnabledCell:(id)sender{
	self.alarmTemp.enabled = ((UISwitch *)sender).on;
	/*
	//改变了，发送通知
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter postNotificationName:IAAlarmItemsDidChangeNotification object:self];
	 */
}

- (id)enabledCellDescription{
	
	static NSString *CellIdentifier = @"enabledCell";
	
	if (!self->enabledCellDescription) {
		self->enabledCellDescription = [[TableViewCellDescription alloc] init];
		
		BoolCell *cell = [[[BoolCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
		cell.textLabel.text = KLabelAlarmEnable;
		[cell.switchCtl addTarget:self action: @selector(didChangedSwitchCtlInEnabledCell:) forControlEvents:UIControlEventValueChanged];

		self->enabledCellDescription.tableViewCell = cell;
		
		self->enabledCellDescription.didSelectCellSelector = NULL; //无选中事件
	}
	
	//置开关状态
	UISwitch *switchCtl = ((BoolCell *)self->enabledCellDescription.tableViewCell).switchCtl;
	switchCtl.on = self.alarmTemp.enabled;
	
	return self->enabledCellDescription;
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
		
		BoolCell *cell = [[[BoolCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
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
		UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		cell.textLabel.text = KLabelAlarmRepeat;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		self->repeatCellDescription.tableViewCell = cell;
		self->repeatCellDescription.didSelectCellSelector = @selector(didSelectNavCell:);
		//AlarmLRepeatTypeViewController *viewCtler = [[[AlarmLRepeatTypeViewController alloc] initWithStyle:UITableViewStyleGrouped alarm:self.alarmTemp] autorelease];
        AlarmLRepeatTypeViewController *viewCtler = [[[AlarmLRepeatTypeViewController alloc] initWithNibName:@"AlarmLRepeatTypeViewController" bundle:nil alarm:self.alarmTemp] autorelease];
        
		self->repeatCellDescription.didSelectCellObject = viewCtler;
        
        //截断方式:中间截断
        cell.detailTextLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
	}
    
    NSString *detailText = nil;
    if (self.alarmTemp.usedAlarmSchedule 
        && self.alarmTemp.alarmSchedules.count == 7) {
        
        BOOL w1 = [(IAAlarmSchedule*)[self.alarmTemp.alarmSchedules objectAtIndex:0] vaild];
        BOOL w2 = [(IAAlarmSchedule*)[self.alarmTemp.alarmSchedules objectAtIndex:1] vaild];
        BOOL w3 = [(IAAlarmSchedule*)[self.alarmTemp.alarmSchedules objectAtIndex:2] vaild];
        BOOL w4 = [(IAAlarmSchedule*)[self.alarmTemp.alarmSchedules objectAtIndex:3] vaild];
        BOOL w5 = [(IAAlarmSchedule*)[self.alarmTemp.alarmSchedules objectAtIndex:4] vaild];
        BOOL w6 = [(IAAlarmSchedule*)[self.alarmTemp.alarmSchedules objectAtIndex:5] vaild];
        BOOL w7 = [(IAAlarmSchedule*)[self.alarmTemp.alarmSchedules objectAtIndex:6] vaild];
        
        if (w1 && w2 && w3 && w4 && w5 && !w6 && !w7) {
            detailText = KWDSTitleWeekdays;
        }else if (!w1 && !w2 && !w3 && !w4 && !w5 && w6 && w7) {
            detailText = KWDSTitleWeekends;
        }else if (w1 && w2 && w3 && w4 && w5 && w6 && w7) {
            detailText = KWDSTitleEveryDay;
        }else {
            NSMutableString *tempS = [NSMutableString string];
            [self.alarmTemp.alarmSchedules enumerateObjectsUsingBlock:^(IAAlarmSchedule *obj, NSUInteger idx, BOOL *stop) {
                if (obj.vaild) 
                    [tempS appendFormat:@" %@",[obj.beginTime stringOfTimeOnlyWeekDayStyle]];
            }];
            detailText = [tempS stringByTrim];
            
        }
        
    }else {
        detailText = self.alarmTemp.repeatType.repeatTypeName;//仅闹一次,连续闹钟
    }
    
    if (self.alarmTemp.usedAlarmSchedule) {
        NSString *iconString = nil;//这是钟表🕘
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) 
            iconString = @"\U0001F558";
        else 
            iconString = @"\ue02c";
        
        detailText = [NSString stringWithFormat:@"%@ %@",detailText,iconString];
    }
	self->repeatCellDescription.tableViewCell.detailTextLabel.text = detailText;
	return self->repeatCellDescription;
}

- (id)soundCellDescription{
	
	static NSString *CellIdentifier = @"soundCellDescription";
	
	if (!self->soundCellDescription) {
		self->soundCellDescription = [[TableViewCellDescription alloc] init];
		UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
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
		UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		cell.textLabel.text = KLabelAlarmName;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		self->nameCellDescription.tableViewCell = cell;
		self->nameCellDescription.didSelectCellSelector = @selector(didSelectNavCell:);
		AlarmNameViewController *viewCtler = [[[AlarmNameViewController alloc] initWithNibName:@"AlarmNameViewController" bundle:nil alarm:self.alarmTemp] autorelease];
		self->nameCellDescription.didSelectCellObject = viewCtler;
		
	}
    
    
    if (self.alarmTemp.alarmName) {
        self->nameCellDescription.tableViewCell.detailTextLabel.textColor = [UIColor colorWithRed:56.0/255.0 green:84.0/255.0 blue:135.0/255.0 alpha:1.0];
        self->nameCellDescription.tableViewCell.detailTextLabel.text = self.alarmTemp.alarmName;
    }else{
        self->nameCellDescription.tableViewCell.detailTextLabel.textColor = [UIColor lightGrayColor];
        self->nameCellDescription.tableViewCell.detailTextLabel.text = KAPTextPlaceholderName;
    }
     
    
	//self->nameCellDescription.tableViewCell.detailTextLabel.text = self.alarmTemp.alarmName;
	return self->nameCellDescription;
}

- (id)notesCellDescription{
	
	static NSString *CellIdentifier = @"notesCellDescription";
	
	if (!self->notesCellDescription) {
		self->notesCellDescription = [[TableViewCellDescription alloc] init];
		UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		cell.textLabel.text = KAPTitleNote;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		self->notesCellDescription.tableViewCell = cell;
		self->notesCellDescription.didSelectCellSelector = @selector(didSelectNavCell:);
		AlarmNotesViewController *viewCtler = [[[AlarmNotesViewController alloc] initWithNibName:@"AlarmNotesViewController" bundle:nil alarm:self.alarmTemp] autorelease];
		self->notesCellDescription.didSelectCellObject = viewCtler;
		
	}
    
    if (self.alarmTemp.notes && [[self.alarmTemp.notes stringByTrim] length] >0) {
        self->notesCellDescription.tableViewCell.detailTextLabel.textColor = [UIColor tableCellBlueTextYCColor];
        self->notesCellDescription.tableViewCell.detailTextLabel.text = self.alarmTemp.notes;
    }else{
        self->notesCellDescription.tableViewCell.detailTextLabel.textColor = [UIColor lightGrayColor];
        self->notesCellDescription.tableViewCell.detailTextLabel.text = KAPTextPlaceholderNote;
    }
	
	return self->notesCellDescription;
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
			if (!CLLocationCoordinate2DIsValid(self.alarmTemp.realCoordinate)) {
                
                IADestinationCell* desCell = (IADestinationCell*)self.destionationCellDescription.tableViewCell;
                desCell.cellStatus = IADestinationCellStatusNormalWithoutDistanceAndAddress; //显示箭头动画
            }

			break;
		case IALocatingAndReversingStatusReversing:
			//self.placemarkForReverse = nil;
			//[self endReverse]; 有没有必要改进
			//界面提示 : 定位失败
			if (!CLLocationCoordinate2DIsValid(self.alarmTemp.realCoordinate)) //在这里 不用也可以吧
            {
                IADestinationCell* desCell = (IADestinationCell*)self.destionationCellDescription.tableViewCell;
                desCell.cellStatus = IADestinationCellStatusNormalWithoutDistanceAndAddress; //显示箭头动画

            }
			break;
		default:
			break;
	}
}

- (void) didSelectAddressCell:(id)sender{
	[self stopLocationAndReverseRestart:YES];
}

- (id)radiusCellDescription{
	
	static NSString *CellIdentifier = @"WaitingCell";
	
	if (!self->radiusCellDescription) {
		self->radiusCellDescription = [[TableViewCellDescription alloc] init];
		UITableViewCell *cell = [[[WaitingCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
		[(WaitingCell*)cell accessoryImageView1].image = [UIImage imageNamed:@"IAPinPurple.png"];
		[(WaitingCell*)cell accessoryImageView1].highlightedImage = [UIImage imageNamed:@"IAPinPressedPurple.png"];
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

- (void)didSelectNavDestionationCell:(id)sender{
    
    IAAlarm *theAlarm = self.alarmTemp;
    [IAContactManager sharedManager].currentViewController = self.navigationController;
    [[IAContactManager sharedManager] pushContactViewControllerWithAlarm:theAlarm];
	
}

- (id)destionationCellDescription{
		
	if (!self->destionationCellDescription) {
		self->destionationCellDescription = [[TableViewCellDescription alloc] init];
		
		IADestinationCell *cell = [IADestinationCell viewWithXib];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.alarm = self.alarmTemp;
        cell.cellStatus = IADestinationCellStatusNone;
        
		self->destionationCellDescription.tableViewCell = cell;
		
		self->destionationCellDescription.didSelectCellSelector = @selector(didSelectNavDestionationCell:); //向上动画，与其他的左右动画cell有区别
        
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
    
	self.enabledCellDescription.tableViewCell.userInteractionEnabled = enabled;
	self.enabledCellDescription.tableViewCell.textLabel.enabled = enabled;
	self.enabledCellDescription.tableViewCell.detailTextLabel.enabled = enabled;
    UISwitch *switchCtl= [(BoolCell*)self.enabledCellDescription.tableViewCell switchCtl];
    switchCtl.enabled = enabled;
    if ([switchCtl respondsToSelector:@selector(setOnTintColor:)]) 
        switchCtl.onTintColor = enabled ? [UIColor switchBlue] : [UIColor lightGrayColor];
	
    
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
	
	self.destionationCellDescription.tableViewCell.userInteractionEnabled = enabled;
    
	self.notesCellDescription.tableViewCell.userInteractionEnabled = enabled;
	self.notesCellDescription.tableViewCell.textLabel.enabled = enabled;
	self.notesCellDescription.tableViewCell.detailTextLabel.enabled = enabled;
    
    self.testAlarmButton.enabled = enabled;
    
}

#pragma mark -
#pragma mark Notification

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
	self.cellDescriptions = nil;
	[self.tableView reloadData];  //重新加载
	
	if (CLLocationCoordinate2DIsValid(self.alarmTemp.realCoordinate)) { //有效坐标才允许保存
		self.saveButtonItem.enabled = YES;
        self.testAlarmButton.enabled = YES;
	}else {
		self.saveButtonItem.enabled = NO;
        self.testAlarmButton.enabled = NO;
	}

}

- (void) handle_applicationDidEnterBackground:(id)notification{	

}

- (void)handle_applicationWillResignActive:(id)notification{	
    //关闭未关闭的对话框
    [locationServicesUsableAlert cancelAlertWithAnimated:NO];
}

- (void) registerNotifications {
	
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

	
	[notificationCenter addObserver: self
						   selector: @selector (handle_applicationDidEnterBackground:)
							   name: UIApplicationDidEnterBackgroundNotification
							 object: nil];
	
	[notificationCenter addObserver: self
						   selector: @selector (handle_applicationWillResignActive:)
							   name: UIApplicationWillResignActiveNotification
							 object: nil];
	 
}

- (void) unRegisterNotifications {
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
	[notificationCenter removeObserver:self	name: UIApplicationDidEnterBackgroundNotification object: nil];
	[notificationCenter removeObserver:self	name: UIApplicationWillResignActiveNotification object: nil];
}




#pragma mark -
#pragma mark Events Handle

-(IBAction)cancelButtonItemPressed:(id)sender{
	
	[self.navigationController dismissModalViewControllerAnimated:YES];
}


-(IBAction)saveButtonItemPressed:(id)sender{
	
	///////////////////////
	//保存闹钟
	self.alarm.enabled = self.alarmTemp.enabled;
	self.alarm.realCoordinate = self.alarmTemp.realCoordinate;
    self.alarm.visualCoordinate = self.alarmTemp.visualCoordinate;
	self.alarm.alarmName = self.alarmTemp.alarmName;
	self.alarm.position = self.alarmTemp.position;
	self.alarm.positionShort = self.alarmTemp.positionShort;
    self.alarm.positionTitle = self.alarmTemp.positionTitle;
    self.alarm.placemark = self.alarmTemp.placemark;
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
    
    self.alarm.person = self.alarmTemp.person;
    self.alarm.indexOfPersonAddresses = self.alarmTemp.indexOfPersonAddresses;
    
    self.alarm.usedAlarmSchedule = self.alarmTemp.usedAlarmSchedule;
    self.alarm.alarmSchedules = self.alarmTemp.alarmSchedules;
    self.alarm.sameBeginEndTime = self.alarmTemp.sameBeginEndTime;
	
	[self.alarm saveFromSender:self];

	///////////////////////

	
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

-(IBAction)testAlarmButtonPressed:(id)sender{
    //防止连按
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    IAAlarm *alarmForNotif = self.alarmTemp;

    //保存到文件
    IAAlarmNotification *alarmNotification = [[[IAAlarmNotification alloc] initWithAlarm:alarmForNotif] autorelease];
    [[IAAlarmNotificationCenter defaultCenter] addNotification:alarmNotification];
    
    //发本地通知
    BOOL arrived = [alarmForNotif.positionType.positionTypeId isEqualToString:@"p002"];//是 “到达时候”提醒
    NSString *promptTemple = arrived?kAlertFrmStringArrived:kAlertFrmStringLeaved;
    
    NSString *alarmName = alarmForNotif.alarmName ? alarmForNotif.alarmName : alarmForNotif.positionTitle;
    NSString *alertTitle = [[[NSString alloc] initWithFormat:promptTemple,alarmName,0.0] autorelease];
    NSString *alarmMessage = [alarmForNotif.notes stringByTrim];

    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:alarmNotification.notificationId forKey:@"knotificationId"];
    [userInfo setObject:alertTitle forKey:@"kTitleStringKey"];
    if (alarmMessage) 
        [userInfo setObject:alarmMessage forKey:@"kMessageStringKey"];
    
    NSString *iconString = nil;//这是铃铛🔔
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) 
        iconString = @"\U0001F514";
    else 
        iconString = @"\ue325";
    
    alertTitle =  [NSString stringWithFormat:@"%@ %@",iconString,alertTitle]; 
    [userInfo setObject:iconString forKey:@"kIconStringKey"];
    
    
    NSString *notificationBody = alertTitle;
    if (alarmMessage && alarmMessage.length > 0) {
        notificationBody = [NSString stringWithFormat:@"%@: %@",alertTitle,alarmMessage];
    }
    
    UIApplication *app = [UIApplication sharedApplication];
    NSInteger badgeNumber = app.applicationIconBadgeNumber + 1; //角标数
    UILocalNotification *notification = [[[UILocalNotification alloc] init] autorelease];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.repeatInterval = 0;
    notification.soundName = alarmForNotif.sound.soundFileName;
    notification.alertBody = notificationBody;
    notification.applicationIconBadgeNumber = badgeNumber;
    notification.userInfo = userInfo;
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

-(void)reverseGeocode
{	
    CLLocationCoordinate2D coordinate = self.alarmTemp.visualCoordinate;
    if (!CLLocationCoordinate2DIsValid(coordinate)) 
        return;
    
	// 显示等待指示控件
    IADestinationCell* cell = (IADestinationCell*)self.destionationCellDescription.tableViewCell;
    cell.cellStatus = IADestinationCellStatusReversing;
    
    
    self->endingManual = NO;
	self->locatingAndReversingStatus = IALocatingAndReversingStatusReversing;

    YCReverseGeocoder *geocoder = [[[YCReverseGeocoder alloc] initWithTimeout:kTimeOutForReverse] autorelease];
    CLLocation *location = [[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude] autorelease];
    [geocoder reverseGeocodeLocation:location completionHandler:^(YCPlacemark *placemark, NSError *error) {
        
        NSString *coordinateString = YCLocalizedStringFromCLLocationCoordinate2D(coordinate,kCoordinateFrmStringNorthLatitude,kCoordinateFrmStringSouthLatitude,kCoordinateFrmStringEastLongitude,kCoordinateFrmStringWestLongitude);
        
        IAAlarm *theAlarm = self.alarmTemp;
        if (!error){

            //优先使用name，其次titleAddress，最后KDefaultAlarmName
            NSString *titleAddress = placemark.name ? placemark.name :(placemark.titleAddress ? placemark.titleAddress : KDefaultAlarmName);
            NSString *shortAddress = placemark.shortAddress ? placemark.shortAddress : coordinateString;
            NSString *longAddress = placemark.longAddress ? placemark.longAddress : coordinateString;
            
            theAlarm.position = longAddress;
            theAlarm.positionShort = shortAddress;
            theAlarm.positionTitle = titleAddress;
            theAlarm.placemark = placemark;
            theAlarm.usedCoordinateAddress = NO;
            
        }else{            
            if (!theAlarm.nameChanged) {
                theAlarm.alarmName = nil;//把以前版本生成的名称冲掉
            }
            
            theAlarm.position = coordinateString;
            theAlarm.positionShort = coordinateString;
            theAlarm.positionTitle = KDefaultAlarmName;
            theAlarm.placemark = nil;
            theAlarm.usedCoordinateAddress = YES; //反转失败，用坐标做地址
            
        }
        
        self.cellDescriptions = nil;
        
        IADestinationCell* cell = (IADestinationCell*)self.destionationCellDescription.tableViewCell;
        cell.cellStatus = IADestinationCellStatusNormal;

        
        self->locatingAndReversingStatus = IALocatingAndReversingStatusNone;
                
    }];
    
}

#define kTimeOutForLocation 10.0
-(void)beginLocation
{
	self->endingManual = NO;
	self->locatingAndReversingStatus = IALocatingAndReversingStatusLocating;
	 
	//检测定位服务状态。如果不可用或未授权，弹出对话框
	[self.locationServicesUsableAlert showWaitUntilBecomeKeyWindow:self.view.window afterDelay:0.5];
    
    //定位服务没有开启，或没有授权时候：收到失败数据就直接结束定位
	BOOL enabledLocation = [[YCSystemStatus sharedSystemStatus] enabledLocation];
	if (!enabledLocation) {
		self.bestEffortAtLocation = nil;
		[self performSelector:@selector(endLocation) withObject:nil afterDelay:0.1];  //数据更新后，等待x秒
	}
	[self setTableCellsUserInteractionEnabled:NO]; //定位结束前不允许操作其他
	
	//cell
	IADestinationCell* desCell = (IADestinationCell*)self.destionationCellDescription.tableViewCell;
	desCell.cellStatus = IADestinationCellStatusLocating;
	
	[self.tableView reloadData]; //刷新界面
	
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
    
    //可以使用了
    [self setTableCellsUserInteractionEnabled:YES]; 
	
	if (self->endingManual) {//手工结束，不处理数据
		self.cellDescriptions = nil;	
		[self.tableView reloadData]; //刷新界面，使用原来的数据
		self->locatingAndReversingStatus = IALocatingAndReversingStatusNone;
		return;
	}
		
		
	if(self.bestEffortAtLocation==nil)
	{
		self.cellDescriptions = nil;
		
		//新的cell
		IADestinationCell* desCell = (IADestinationCell*)self.destionationCellDescription.tableViewCell;
        desCell.cellStatus = IADestinationCellStatusNormalWithoutDistanceAndAddress;//显示箭头动画
        
		self.alarmTemp.realCoordinate = kCLLocationCoordinate2DInvalid;
		self.alarmTemp.position = nil;
		self.alarmTemp.positionShort = nil;
        self.alarmTemp.positionTitle = nil;
        self.alarmTemp.placemark = nil;
		[self.tableView reloadData]; //失败了，刷新界面，赋空数据
		
		
		self->locatingAndReversingStatus = IALocatingAndReversingStatusNone;
	}else {
        
        //发送定位结束通知
        [YCSystemStatus sharedSystemStatus].lastLocation = self.bestEffortAtLocation;
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.bestEffortAtLocation forKey:IAStandardLocationKey];
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        NSNotification *aNotification = [NSNotification notificationWithName:IAStandardLocationDidFinishNotification 
                                                                      object:self 
                                                                    userInfo:userInfo];
        [notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
        
        
        //闹钟坐标赋值
        self.alarmTemp.realCoordinate = self.bestEffortAtLocation.coordinate;
        self.alarmTemp.locationAccuracy = self.bestEffortAtLocation.horizontalAccuracy;
        
		//开始 反转坐标
        [self reverseGeocode]; 
        
	}
	
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
	isFirstShow = YES;
    self.tableView.showsVerticalScrollIndicator = NO;
	
	[self registerNotifications];
	
	//重新loadview
	
	//取消所有定时执行的函数
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	self.cellDescriptions = nil;  
	self.enabledCellDescription = nil;
	self.repeatCellDescription = nil;
	self.soundCellDescription = nil;
	self.vibrateCellDescription = nil;
	self.nameCellDescription = nil;
	self.radiusCellDescription = nil; 
	
	
	self.navigationItem.leftBarButtonItem = self.cancelButtonItem;
	self.navigationItem.rightBarButtonItem = self.saveButtonItem;
	

	if (self.newAlarm && CLLocationCoordinate2DIsValid(self.alarmTemp.realCoordinate) && !self.alarmTemp.usedCoordinateAddress) //新alarm而且不用反转地址
        self.saveButtonItem.enabled = YES;
    else 
        self.saveButtonItem.enabled = NO;
	
	
	//测试按钮
    UIView *viewp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];    
    [viewp addSubview:self.testAlarmButton];
    self.tableView.tableFooterView = viewp;    
    [viewp release];
    
    //延时加载
    [self performBlock:^{
        [IAContactManager sharedManager].currentViewController = self.navigationController;
    } afterDelay:0.1];
    

}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if (self.newAlarm) 
		self.title = KViewTitleAddAlarms;
	else
		self.title = KViewTitleEditAlarms;
    
    
    IADestinationCell* cell = (IADestinationCell*)self.destionationCellDescription.tableViewCell;
    
    if (isFirstShow) {//第一次显示，执行定位、反转
        
        if (CLLocationCoordinate2DIsValid(self.alarmTemp.visualCoordinate)){ //坐标有效
            
            if (self.alarmTemp.usedCoordinateAddress) {//使用的是坐标地址
                cell.cellStatus = IADestinationCellStatusNone;
                [self performSelector:@selector(reverseGeocode) withObject:nil afterDelay:0.1];
            }else{ 
                 cell.cellStatus = IADestinationCellStatusNormal;
            }
            
        }else{
            cell.cellStatus = IADestinationCellStatusNone;
            [self performSelector:@selector(beginLocation) withObject:nil afterDelay:0.5];
        }
        
    }else {
        
        if (CLLocationCoordinate2DIsValid(self.alarmTemp.realCoordinate)) 
            cell.cellStatus = IADestinationCellStatusNormal;
        else 
            cell.cellStatus = IADestinationCellStatusNormalWithoutDistanceAndAddress;//显示箭头动画
        
    }
    
	[self.tableView reloadData];
	
	isFirstShow = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	
	//停止定位
	[self stopLocationAndReverseRestart:NO];
    
    //
    self.title = nil;
    //[self performSelector:@selector(setTitle:) withObject:nil afterDelay:0.2];
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
	BOOL enabledLocation = [[YCSystemStatus sharedSystemStatus] enabledLocation];
	if (!enabledLocation) {
		self.bestEffortAtLocation = nil;
		[self performSelector:@selector(endLocation) withObject:nil afterDelay:0.1];  //数据更新后，等待x秒
	}
}

#pragma mark -
#pragma mark Memory management

//释放资源，在viewDidLoad或能按要求重新创建的
-(void)freeResouceRecreated{

	[self unRegisterNotifications];
	
	[locationManager stopUpdatingLocation];
	[locationManager release]; locationManager = nil;
	[bestEffortAtLocation release]; bestEffortAtLocation = nil;
}

- (void)viewDidUnload {
    NSLog(@"AlarmDetailTableViewController viewDidUnload");
	[super viewDidUnload];
	[self freeResouceRecreated];
}


- (void)dealloc {
	NSLog(@"AlarmDetailTableViewController dealloc");
	[self freeResouceRecreated];
	//取消所有定时执行的函数
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	
	[locationManager release];
	[bestEffortAtLocation release];
	
	[locationServicesUsableAlert release];
	[cancelButtonItem release];
	[saveButtonItem release];
    [testAlarmButton release];
	
	[cellDescriptions release];
	[enabledCellDescription release];            
	[repeatCellDescription release];             
	[soundCellDescription release];              
	[vibrateCellDescription release];            
	[nameCellDescription release];    
	[notesCellDescription release];
	
	[radiusCellDescription release];
	[destionationCellDescription release];
		
	[alarm release];
	
	//////////////////////////////////
    
	if (alarmTemp) {
        [alarmTemp removeObserver:self forKeyPath:@"alarmName"];
        [alarmTemp removeObserver:self forKeyPath:@"positionTitle"];
        [alarmTemp removeObserver:self forKeyPath:@"positionShort"];
        [alarmTemp removeObserver:self forKeyPath:@"position"];
        [alarmTemp removeObserver:self forKeyPath:@"placemark"];
        [alarmTemp removeObserver:self forKeyPath:@"enabled"];
        [alarmTemp removeObserver:self forKeyPath:@"realCoordinate"];
        [alarmTemp removeObserver:self forKeyPath:@"visualCoordinate"];
        [alarmTemp removeObserver:self forKeyPath:@"vibrate"];
        [alarmTemp removeObserver:self forKeyPath:@"sound"];
        [alarmTemp removeObserver:self forKeyPath:@"repeatType"];
        [alarmTemp removeObserver:self forKeyPath:@"alarmRadiusType"];
        [alarmTemp removeObserver:self forKeyPath:@"radius"];
        [alarmTemp removeObserver:self forKeyPath:@"positionType"];
        [alarmTemp removeObserver:self forKeyPath:@"notes"];
        [alarmTemp removeObserver:self forKeyPath:@"person"];
        [alarmTemp removeObserver:self forKeyPath:@"indexOfPersonAddresses"];
        [alarmTemp removeObserver:self forKeyPath:@"usedAlarmSchedule"];
        [alarmTemp removeObserver:self forKeyPath:@"alarmSchedules"];
        [alarmTemp removeObserver:self forKeyPath:@"sameBeginEndTime"];
	}
     
	[alarmTemp release];
	//////////////////////////////////
    
    [vibratePlayer release];
    [ringplayer release];
	
    //为了personImageDidPress找个函数不至于有问题
    [IAContactManager sharedManager].currentViewController = nil;
    [super dealloc];
}


@end

