//
//  YCAlarmEntity.m
//  iArrived
//
//  Created by li shiyong on 10-10-15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IABuyManager.h"
#import "UIApplication-YC.h"
#import "IASaveInfo.h"
#import "NSCoder-YC.h"
#import "LocalizedString.h"
#import "YCPositionType.h"
#import "YCSound.h"
#import "YCRepeatType.h"
#import "IAAlarmRadiusType.h"
#import "DicManager.h"
#import "YCParam.h"
#import "IAAlarm.h"

//闹钟列表改变，包括：增，改，删
NSString *IAAlarmsDataListDidChangeNotification = @"IAAlarmsDataListDidChangeNotification";

#define kDataFilename @"alarms.plist"


@implementation IAAlarm

@synthesize alarmId;
@synthesize alarmName;
@synthesize nameChanged;

@synthesize position;
@synthesize positionShort;
@synthesize usedCoordinateAddress;
@synthesize coordinate;
@synthesize locationAccuracy;

@synthesize enabling;
@synthesize sound;
@synthesize repeatType;
@synthesize alarmRadiusType;
@synthesize soundId;
@synthesize repeatTypeId;
@synthesize alarmRadiusTypeId;
@synthesize radius;


@synthesize sortId;
@synthesize vibrate;
@synthesize ring;
@synthesize positionType;
@synthesize positionTypeId;
@synthesize description;

@synthesize reserve1;
@synthesize reserve2;
@synthesize reserve3;

//产生一个唯一的序列号
+ (NSString*) genSerialCode
{
	NSUInteger x = arc4random()/100;
	NSString *s = [NSString stringWithFormat:@"%d", time(NULL)];
	NSString *ss = [NSString stringWithFormat:@"%@%d",s,x];
	
	return ss;
}

- (id)init
{
    self = [super init];
	if (self) 
	{
		alarmId = [[IAAlarm genSerialCode] retain];
		alarmName = [KDefaultAlarmName retain];
		nameChanged = NO;
		
		position = [@"" retain];
		positionShort = [@"" retain];
		usedCoordinateAddress = YES;
		coordinate = CLLocationCoordinate2DMake(-10000.0,-10000.0);
		locationAccuracy = 101.1;
		
		enabling = YES; 
		sound = [[[DicManager soundDictionary] objectForKey:@"s001"] retain];
		repeatType = [[[DicManager repeatTypeDictionary] objectForKey:@"r001"] retain];
		alarmRadiusType = [[[DicManager alarmRadiusTypeDictionary] objectForKey:@"ar002"] retain];
		radius = alarmRadiusType.alarmRadiusValue ;

		
		sortId = 0;       
		YCDeviceType deviceType = [YCParam paramSingleInstance].deviceType; //不是iphone不振动
		if (YCDeviceTypeIPhone == deviceType)
			vibrate = YES;
		else 
			vibrate = NO;
		ring = YES;
		positionType = [[[DicManager positionTypeDictionary] objectForKey:@"p002"] retain]; //默认通过地图指定
	    description  = [@"" retain];              

		reserve1 = [@"" retain];
		reserve2 = [@"" retain];
		reserve3 = [@"" retain];
	}
	return self;
}



#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder {

	[encoder encodeObject:alarmId forKey:kalarmId];
	[encoder encodeObject:alarmName forKey:kalarmName];
	[encoder encodeBool:nameChanged forKey:knameChanged];

	
	[encoder encodeObject:position forKey:kposition];
	[encoder encodeObject:positionShort forKey:kpositionShort];
	[encoder encodeBool:usedCoordinateAddress forKey:kusedCoordinateAddress];
	[encoder encodeCLLocationCoordinate2D:coordinate forKey:kcoordinate];
	[encoder encodeDouble:locationAccuracy forKey:klocationAccuracy];

	[encoder encodeBool:enabling forKey:kenabling];
	[encoder encodeObject:sound.soundId forKey:kasoundId];
	[encoder encodeObject:repeatType.repeatTypeId forKey:karepeatTypeId];
	[encoder encodeObject:alarmRadiusType.alarmRadiusTypeId forKey:kavehicleTypeId];
	[encoder encodeDouble:radius forKey:kradius];

	[encoder encodeInteger:sortId  forKey:ksortId];
	[encoder encodeBool:vibrate forKey:kvibration];
	[encoder encodeBool:ring forKey:kring];
	[encoder encodeObject:positionType.positionTypeId forKey:kpositionTypeId];
	[encoder encodeObject:description forKey:kdescription];
	
	[encoder encodeObject:reserve1 forKey:kreserve1];
	[encoder encodeObject:reserve2 forKey:kreserve2];
	[encoder encodeObject:reserve3 forKey:kreserve3];
	
}

- (id)initWithCoder:(NSCoder *)decoder {
	
    self = [super init];
    if (self) {	
		
		alarmId = [[decoder decodeObjectForKey:kalarmId] retain];
		alarmName = [[decoder decodeObjectForKey:kalarmName] retain];
		nameChanged =[decoder decodeBoolForKey:knameChanged];

		position = [[decoder decodeObjectForKey:kposition] retain];
		positionShort = [[decoder decodeObjectForKey:kpositionShort] retain];
		usedCoordinateAddress = [decoder decodeBoolForKey:kusedCoordinateAddress];
		coordinate = [decoder decodeCLLocationCoordinate2DForKey:kcoordinate];
		locationAccuracy = [decoder decodeDoubleForKey:klocationAccuracy];
		
		enabling = [decoder decodeBoolForKey:kenabling];
		soundId =[[decoder decodeObjectForKey:kasoundId] retain];
		repeatTypeId =[[decoder decodeObjectForKey:karepeatTypeId] retain];
		alarmRadiusTypeId = [[decoder decodeObjectForKey:kavehicleTypeId] retain];
		sound = [[[DicManager soundDictionary] objectForKey:soundId] retain];
		repeatType = [[[DicManager repeatTypeDictionary] objectForKey:repeatTypeId] retain];
		alarmRadiusType = [[[DicManager alarmRadiusTypeDictionary] objectForKey:alarmRadiusTypeId] retain];
		radius = [decoder decodeDoubleForKey:kradius];
		
		
		sortId = [decoder decodeIntegerForKey:ksortId];
		vibrate =[decoder decodeBoolForKey:kvibration];
		ring =[decoder decodeBoolForKey:kring];
		description = [[decoder decodeObjectForKey:kdescription] retain];
		positionTypeId = [[decoder decodeObjectForKey:kpositionTypeId] retain];
		positionType = [[[DicManager positionTypeDictionary] objectForKey:positionTypeId] retain];
		description = [decoder decodeObjectForKey:kdescription];

		reserve1 = [[decoder decodeObjectForKey:kreserve1] retain];
		reserve2 = [[decoder decodeObjectForKey:kreserve2] retain];
		reserve3 = [[decoder decodeObjectForKey:kreserve3] retain];
		
    }
    return self;
}


#pragma mark -
#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
	
	IAAlarm *copy = [[[self class] allocWithZone: zone] init];
	
    copy.alarmId = self.alarmId;
    copy.alarmName = self.alarmName;
	copy.nameChanged = self.nameChanged;

    copy.position = self.position;
	copy.positionShort = self.positionShort;
	copy.usedCoordinateAddress = self.usedCoordinateAddress;
	copy.coordinate = self.coordinate;
	copy.locationAccuracy = self.locationAccuracy;
	
	copy.enabling = self.enabling;
	copy.sound = self.sound;
	copy.repeatType = self.repeatType;
	copy.alarmRadiusType = self.alarmRadiusType;
	copy.soundId = self.soundId;
	copy.repeatTypeId = self.repeatTypeId;
	copy.alarmRadiusTypeId = self.alarmRadiusTypeId;
	copy.radius = self.radius;

	
	copy.sortId = self.sortId ;
	copy.vibrate = self.vibrate;
	copy.ring = self.ring;
	copy.positionType = self.positionType;
	copy.positionTypeId = self.positionTypeId;
    copy.description = self.description;
	
	copy.reserve1 = self.reserve1;
	copy.reserve2 = self.reserve2;
	copy.reserve3 = self.reserve3;
    
    return copy;
}

- (void)dealloc {
	[alarmId release];
	[alarmName release];
	
	[position release];
	[positionShort release];
	
	[sound release];
	[repeatType release];
	[alarmRadiusType release];
	[soundId release];
	[repeatTypeId release];
	[alarmRadiusTypeId release];
	
	
	[positionType release];
	[positionTypeId release];
	[description release];
	
	[reserve1 release];
	[reserve2 release];
	[reserve3 release];
	
    [super dealloc];
}


//保存闹钟,不发通知
- (IASaveInfo*)save{
    
    NSMutableArray *alarms = (NSMutableArray*)[IAAlarm alarmArray];
	NSUInteger index = [alarms indexOfObject:self];
	
	IASaveInfo *saveInfo = [[[IASaveInfo alloc] init] autorelease];
	saveInfo.objId = self.alarmId;
	IASaveType saveType;
	if (NSNotFound == index) { //add
		
#ifndef FULL_VERSION
		//购买
		YCParam *param = [YCParam paramSingleInstance];
		if (!param.isProUpgradePurchased  && [IAAlarm alarmArray].count >=1) {
			[[IABuyManager shareBuyManager] buyWithAlert];
			return nil;
		}
#endif
		
		[alarms insertObject:self atIndex:0];
		saveType = IASaveTypeAdd;
	}else { //update
		[alarms replaceObjectAtIndex:index withObject:self];
		saveType = IASaveTypeUpdate;
	}
	saveInfo.saveType = saveType;
	
	NSString *filePathName =  [[UIApplication sharedApplication].libraryDirectory stringByAppendingPathComponent:kDataFilename];
	[NSKeyedArchiver archiveRootObject:alarms toFile:filePathName];
    
    return saveInfo;

}

//发送save通知
- (void)sendSaveNotificationWithInfo:(IASaveInfo*)saveInfo fromSender:(id)sender{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSNotification *aNotification = [NSNotification notificationWithName:IAAlarmsDataListDidChangeNotification 
                                                                  object:sender 
                                                                userInfo:[NSDictionary dictionaryWithObject:saveInfo forKey:IASaveInfoKey]];
    
    [notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
}

- (void)saveFromSender:(id)sender{
	
    IASaveInfo *saveInfo = [self save];
	if (saveInfo) {
        [self sendSaveNotificationWithInfo:saveInfo fromSender:sender];
    }
}

- (void)deleteFromSender:(id)sender{
	NSMutableArray *alarms = (NSMutableArray*)[IAAlarm alarmArray];
	NSUInteger index = [alarms indexOfObject:self];
	
	if (NSNotFound != index) { 
		IASaveInfo *saveInfo = [[[IASaveInfo alloc] init] autorelease];
		saveInfo.objId = self.alarmId;
		saveInfo.saveType = IASaveTypeDelete;
		
		[alarms removeObject:self];
		
		//NSString *filePathName =  [[YCParam paramSingleInstance].applicationDocumentsDirectory stringByAppendingPathComponent:kDataFilename];
		NSString *filePathName =  [[UIApplication sharedApplication].libraryDirectory stringByAppendingPathComponent:kDataFilename];
		[NSKeyedArchiver archiveRootObject:alarms toFile:filePathName];
		

		
		NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
		NSNotification *aNotification = [NSNotification notificationWithName:IAAlarmsDataListDidChangeNotification 
																	  object:sender 
																	userInfo:[NSDictionary dictionaryWithObject:saveInfo forKey:IASaveInfoKey]];
		[notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
		
		
	}
	
}

//发送通知更新所有关联视图
- (void)sendNotifyToUpdateAllViewsFromSender:(id)sender{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	NSNotification *aNotification = [NSNotification notificationWithName:IAAlarmsDataListDidChangeNotification object:sender];
	[notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
}

//根据Id找到闹钟
+ (id)findForAlarmId:(NSString*)theAlarmId{
	NSArray *alarmArray = [IAAlarm alarmArray];
	IAAlarm *result = nil;
	for (NSInteger i=0; i<alarmArray.count; i++) {
		IAAlarm* obj = [alarmArray objectAtIndex:i];
		if ([obj.alarmId isEqualToString:theAlarmId]) {
			result = obj;
			break;
		}
	}
	return result;
}


//取得所有闹钟的列表
+ (NSArray*)alarmArray
{
	static NSMutableArray *alarms;
	
	if (!alarms) {
		//NSString *filePathName =  [[YCParam paramSingleInstance].applicationDocumentsDirectory stringByAppendingPathComponent:kDataFilename];
		NSString *filePathName =  [[UIApplication sharedApplication].libraryDirectory stringByAppendingPathComponent:kDataFilename];
		alarms  = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:filePathName];
		[alarms retain];//NSKeyedUnarchiver 读出的对象autorelease
		
		if (alarms ==nil) { //文件还不存在的时候（一个闹钟也没有的时候）
			alarms = [[NSMutableArray alloc] init];
		}		 
	}
	return alarms;
}


@end
