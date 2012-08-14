//
//  YCParam.m
//  iArrived
//
//  Created by li shiyong on 10-10-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "YCLib.h"
#import "YCParam.h"
#import "UIUtility.h"
#import "IAAlarm.h"

extern NSString *IAInAppPurchaseProUpgradeProductId;
#define kParamFilename @"param.plist"

@implementation YCParam


@synthesize lastLoadMapRegion;
@synthesize alertWhenCannotLocation;
@synthesize isProUpgradePurchased;
@synthesize skinType = _skinType;

- (void)setSkinType:(IASkinType)skinType{
    _skinType = skinType;
    [self saveParam];
}

- (BOOL)regionMonitoring{
    //return [CLLocationManager regionMonitoringAvailable];
    return NO;
}

- (BOOL)leaveAlarmEnabled{
    //return [CLLocationManager regionMonitoringAvailable];
    return NO;
}

- (void)readUserDefaults{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	alertWhenCannotLocation = [[defaults objectForKey:@"CannotLocationPreference"] boolValue];
}

- (BOOL)isProUpgradePurchased{
	BOOL b = [[NSUserDefaults standardUserDefaults] boolForKey:IAInAppPurchaseProUpgradeProductId];
	return b;
}

- (YCDeviceType)deviceType{

	
	static YCDeviceType deviceType = YCDeviceTypeUnKnown;
	if (YCDeviceTypeUnKnown == deviceType) {
		
		NSString *model = [[UIDevice currentDevice] model];
		
		NSArray *array = [NSArray arrayWithObjects:@"iPhone",@"iPodTouch",@"iPad",nil];
		for (NSString *oneObj in array) {
			NSComparisonResult result = [model compare:oneObj 
											   options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) 
												 range:NSMakeRange(0, [oneObj length])];
			if (result == NSOrderedSame){
				deviceType = [array indexOfObject:oneObj];
				break;
			}
				
		}
	}
	
	return deviceType;
	
}

+(YCParam*) paramSingleInstance
{
	static YCParam* obj = nil;
	if (obj == nil) {
		NSString *filePathName =  [[UIApplication sharedApplication].libraryDirectory stringByAppendingPathComponent:kParamFilename];
		obj = [(YCParam*)[NSKeyedUnarchiver unarchiveObjectWithFile:filePathName] retain];
		if (obj == nil) {
			obj = [[YCParam alloc] init];
			obj.lastLoadMapRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(-1000,-1000), MKCoordinateSpanMake(0, 0));
		}
		
	}
	return obj;
}


- (void)handle_applicationWillEnterForeground:(id)notification {
	[self readUserDefaults];
}

//闹钟列表发生变化
- (void) handle_alarmsDataListDidChange:(id)notification {
	if ([IAAlarm alarmArray].count == 0) { //闹钟数量=0,删除最后加载地图区域。目的让，下次打开后以当前位置为中心
		self.lastLoadMapRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(-1000.0, -1000.0), 0.0, 0.0);
		[self saveParam];
	}
}



- (void)registerNotifications {
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver: self
						   selector: @selector (handle_applicationWillEnterForeground:)
							   name: UIApplicationWillEnterForegroundNotification
							 object: nil];
	[notificationCenter addObserver: self
						   selector: @selector (handle_alarmsDataListDidChange:)
							   name: IAAlarmsDataListDidChangeNotification
							 object: nil];

}

- (void)unRegisterNotifications{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter removeObserver:self	name: UIApplicationWillEnterForegroundNotification object: nil];
	[notificationCenter removeObserver:self	name: IAAlarmsDataListDidChangeNotification object: nil];

}

- (id)init{
	if (self = [super init]) {
		isProUpgradePurchased = NO;
        _skinType = IASkinTypeSilver;
		[self readUserDefaults];
		[self registerNotifications];
	}
	return self;
}

#pragma mark -
#pragma mark NSCoding

#define    klastLoadMapRegion                 @"lastLoadMapRegion"
#define    kunlock                            @"unlock"
#define    kskinType                          @"skinType"

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeMKCoordinateRegion:lastLoadMapRegion forKey:klastLoadMapRegion];
    [encoder encodeInteger:_skinType forKey:kskinType];
}



- (id)initWithCoder:(NSCoder *)decoder {
	
    if (self = [self init]) {		
		lastLoadMapRegion = [decoder decodeMKCoordinateRegionForKey:klastLoadMapRegion];
        //_skinType = [decoder decodeIntegerForKey:kskinType];
    }
    return self;
}



-(void)saveParam{
	NSString *filePathName =  [[UIApplication sharedApplication].libraryDirectory stringByAppendingPathComponent:kParamFilename];

	[NSKeyedArchiver archiveRootObject:self toFile:filePathName];
}





- (void)dealloc {
	[self unRegisterNotifications];
    [super dealloc];
}



@end
