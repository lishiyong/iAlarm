//
//  IAAlarmsManager.m
//  iAlarm
//
//  Created by li shiyong on 12-5-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IAAlarm.h"
#import "IASaveInfo.h"
#import "IAAlarmsManager.h"

@implementation IAAlarmsManager
/*
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
*/
 
#pragma mark - mothed for single 

static IAAlarmsManager *single = nil;
+ (IAAlarmsManager*)sharedIAAlarmsManager;{
    if (single == nil) {
        single = [[super allocWithZone:NULL] init];
    }
    return single;
}

- (id)init{
    self = [super init];
    return self;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedIAAlarmsManager] retain];
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
