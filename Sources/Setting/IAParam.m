//
//  YCParam.m
//  iArrived
//
//  Created by li shiyong on 10-10-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "YCLib.h"
#import "IAParam.h"
#import "UIUtility.h"
#import "IAAlarm.h"

extern NSString *IAInAppPurchaseProUpgradeProductId;
#define kParamFilename @"IAParam.plist"

@interface IAParam (private)

- (void)saveParam;

@end

@implementation IAParam
@synthesize lastLoadMapRegion = _lastLoadMapRegion, skinType = _skinType;

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

- (BOOL)leaveAlarmEnabled{
    return NO;
}

- (BOOL)isProUpgradePurchased{
    //这个特殊，存储在 NSUserDefaults 中
	BOOL b = [[NSUserDefaults standardUserDefaults] boolForKey:IAInAppPurchaseProUpgradeProductId];
	return b;
}

- (void)setSkinType:(IASkinType)skinType{
    _skinType = skinType;
    [self saveParam];
}

- (void)setLastLoadMapRegion:(MKCoordinateRegion)lastLoadMapRegion{
    _lastLoadMapRegion = lastLoadMapRegion;
    [self saveParam];
}


#pragma mark - NSCoding

#define    klastLoadMapRegion                 @"lastLoadMapRegion"
#define    kskinType                          @"skinType"

- (void)saveParam{
	NSString *filePathName =  [[UIApplication sharedApplication].libraryDirectory stringByAppendingPathComponent:kParamFilename];
	[NSKeyedArchiver archiveRootObject:self toFile:filePathName];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeMKCoordinateRegion:_lastLoadMapRegion forKey:klastLoadMapRegion];
    [encoder encodeInteger:_skinType forKey:kskinType];
}

- (id)initWithCoder:(NSCoder *)decoder {
	
    if (self = [self init]) {		
		_lastLoadMapRegion = [decoder decodeMKCoordinateRegionForKey:klastLoadMapRegion];
        _skinType = [decoder decodeIntegerForKey:kskinType];
    }
    return self;
}


#pragma mark - Init

- (id)init{
    self = [super init];
    if (self) {
        _lastLoadMapRegion = MKCoordinateRegionMake(kCLLocationCoordinate2DInvalid,MKCoordinateSpanMake(0, 0));
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) 
            _skinType = IASkinTypeSilver;
        else 
            _skinType = IASkinTypeDefault;
	}
    return self;
}

#pragma mark - single Instance

static IAParam *single =nil;
+ (IAParam*)sharedParam{
    if (single == nil) {
        //先从文件读
        NSString *filePathName =  [[UIApplication sharedApplication].libraryDirectory stringByAppendingPathComponent:kParamFilename];
        @try {
            single = [(IAParam*)[NSKeyedUnarchiver unarchiveObjectWithFile:filePathName] retain];
        }
        @catch (NSException *exception) {
            single = nil;
        }
        
        if (single == nil) 
            single = [[super allocWithZone:NULL] init];
    }
    return single;
}

+ (id)allocWithZone:(NSZone *)zone
{    
    return single ? single : [super allocWithZone:NULL] ;
    //return [[self sharedParam] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}



@end
