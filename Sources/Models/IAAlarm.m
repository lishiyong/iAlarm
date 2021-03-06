//
//  YCAlarmEntity.m
//  iArrived
//
//  Created by li shiyong on 10-10-15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IAAlarmSchedule.h"
#import "YCLib.h"
#import "IAPerson.h"
#import "IABuyManager.h"
#import "IASaveInfo.h"
#import "LocalizedString.h"
#import "YCPositionType.h"
#import "YCSound.h"
#import "YCRepeatType.h"
#import "IAAlarmRadiusType.h"
#import "DicManager.h"
#import "IAParam.h"
#import "IAAlarm.h"

//闹钟列表改变，包括：增，改，删
NSString *IAAlarmsDataListDidChangeNotification = @"IAAlarmsDataListDidChangeNotification";

#define kDataFilename @"alarms.plist"


#define    kalarmId                 @"kalarmId"
#define    kalarmName               @"kalarmName"
#define    knameChanged             @"knameChanged"

#define    kposition                @"kposition"
#define    kpositionShort           @"kpositionShort"
#define    kpositionTitle           @"kpositionTitle"
#define    kusedCoordinateAddress   @"kusedCoordinateAddress"
#define    kcoordinate              @"kcoordinate"
#define    kvisualCoordinate        @"kvisualCoordinate"
#define    klocationAccuracy        @"klocationAccuracy"

#define    kenabling                @"kenabling"
#define    kasoundId                @"kasoundId"
#define    karepeatTypeId           @"karepeatTypeId"
#define    kavehicleTypeId          @"kavehicleTypeId"
#define    kradius                  @"kradius"

#define    ksortId                  @"ksortId"
#define    kvibration               @"kvibration"
#define    kring                    @"kring"
#define    kdescription             @"kdescription"
#define    kpositionTypeId          @"kpositionTypeId"

#define    kreserve1                @"kreserve1"
#define    kreserve2                @"kreserve2"
#define    kreserve3                @"kreserve3"

#define    kplacemark               @"kplacemark"
#define    kPerson                  @"kPerson"
#define    kIndexOfPersonAddresses  @"kIndexOfPersonAddresses"

#define    kUsedAlarmSchedule       @"kUsedAlarmSchedule"
#define    kAlarmSchedules          @"kAlarmSchedules"
#define    kSameBeginEndTime        @"kSameBeginEndTime"


@implementation IAAlarm

@synthesize alarmId;
@synthesize alarmName;
@synthesize nameChanged;

@synthesize position;
@synthesize positionShort;
@synthesize positionTitle;
@synthesize usedCoordinateAddress;
//@synthesize realCoordinate;
//@synthesize visualCoordinate;
@synthesize locationAccuracy;

@synthesize enabled;
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
@synthesize notes;

@synthesize reserve1;
@synthesize reserve2;
@synthesize reserve3;

@synthesize placemark;
@synthesize person;
@synthesize indexOfPersonAddresses;

@synthesize usedAlarmSchedule;
@synthesize alarmSchedules;
@synthesize sameBeginEndTime;

- (void)setAlarmSchedules:(NSArray *)theAlarmSchedules{
    if (theAlarmSchedules != alarmSchedules) {
        //取消启动通知
        [alarmSchedules makeObjectsPerformSelector:@selector(cancelLocalNotification)];
        
        [alarmSchedules release];
        alarmSchedules = [theAlarmSchedules copy];
    }
}

- (id)init
{
    self = [super init];
	if (self) 
	{
		alarmId = [YCSerialCode() copy];
		alarmName = nil;
		nameChanged = NO;
		
		position = nil;
		positionShort = nil;
        positionTitle = [KDefaultAlarmName copy];
		usedCoordinateAddress = YES;
		realCoordinate = kCLLocationCoordinate2DInvalid;
        visualCoordinate = kCLLocationCoordinate2DInvalid;
		locationAccuracy = 101.1;
		
		enabled = YES; 
		sound = [[[DicManager soundDictionary] objectForKey:@"s001"] retain];
		repeatType = [[[DicManager repeatTypeDictionary] objectForKey:@"r001"] retain];
		alarmRadiusType = [[[DicManager alarmRadiusTypeDictionary] objectForKey:@"ar002"] retain];
		radius = alarmRadiusType.alarmRadiusValue ;

		
		sortId = 0;       
		YCDeviceType deviceType = [IAParam sharedParam].deviceType; //不是iphone不振动
		if (YCDeviceTypeIPhone == deviceType)
			vibrate = YES;
		else 
			vibrate = NO;
		ring = YES;
		positionType = [[[DicManager positionTypeDictionary] objectForKey:@"p002"] retain]; //默认通过地图指定
	    notes  = nil;

		reserve1 = nil;
		reserve2 = nil;
		reserve3 = nil;
        
        placemark = nil;
        person = nil;
        indexOfPersonAddresses = -1;
        
        usedAlarmSchedule = NO;
        alarmSchedules = nil;
        sameBeginEndTime = YES;
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
    [encoder encodeObject:positionTitle forKey:kpositionTitle];
	[encoder encodeBool:usedCoordinateAddress forKey:kusedCoordinateAddress];
	[encoder encodeCLLocationCoordinate2D:self.realCoordinate forKey:kcoordinate];
    [encoder encodeCLLocationCoordinate2D:self.visualCoordinate forKey:kvisualCoordinate];
	[encoder encodeDouble:locationAccuracy forKey:klocationAccuracy];

	[encoder encodeBool:enabled forKey:kenabling];
	[encoder encodeObject:sound.soundId forKey:kasoundId];
	[encoder encodeObject:repeatType.repeatTypeId forKey:karepeatTypeId];
	[encoder encodeObject:alarmRadiusType.alarmRadiusTypeId forKey:kavehicleTypeId];
	[encoder encodeDouble:radius forKey:kradius];

	[encoder encodeInteger:sortId  forKey:ksortId];
	[encoder encodeBool:vibrate forKey:kvibration];
	[encoder encodeBool:ring forKey:kring];
	[encoder encodeObject:positionType.positionTypeId forKey:kpositionTypeId];
	[encoder encodeObject:notes forKey:kdescription];
	
	[encoder encodeObject:reserve1 forKey:kreserve1];
	[encoder encodeObject:reserve2 forKey:kreserve2];
	[encoder encodeObject:reserve3 forKey:kreserve3];
	
    [encoder encodeObject:placemark forKey:kplacemark];
    [encoder encodeObject:person forKey:kPerson];
    [encoder encodeInteger:indexOfPersonAddresses forKey:kIndexOfPersonAddresses];
    
    [encoder encodeBool:usedAlarmSchedule forKey:kUsedAlarmSchedule];
    [encoder encodeObject:alarmSchedules forKey:kAlarmSchedules];
    [encoder encodeBool:sameBeginEndTime forKey:kSameBeginEndTime];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
	
    self = [super init];
    if (self) {	
		
		alarmId = [[decoder decodeObjectForKey:kalarmId] retain];
		alarmName = [[decoder decodeObjectForKey:kalarmName] retain];
		nameChanged =[decoder decodeBoolForKey:knameChanged];

		position = [[decoder decodeObjectForKey:kposition] retain];
		positionShort = [[decoder decodeObjectForKey:kpositionShort] retain];
        positionTitle = [[decoder decodeObjectForKey:kpositionTitle] retain];
		usedCoordinateAddress = [decoder decodeBoolForKey:kusedCoordinateAddress];
		realCoordinate = [decoder decodeCLLocationCoordinate2DForKey:kcoordinate];
        visualCoordinate = [decoder decodeCLLocationCoordinate2DForKey:kvisualCoordinate];
		locationAccuracy = [decoder decodeDoubleForKey:klocationAccuracy];
		
		enabled = [decoder decodeBoolForKey:kenabling];
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
		notes = [[decoder decodeObjectForKey:kdescription] retain];
		positionTypeId = [[decoder decodeObjectForKey:kpositionTypeId] retain];
		positionType = [[[DicManager positionTypeDictionary] objectForKey:positionTypeId] retain];
		notes = [decoder decodeObjectForKey:kdescription];

		reserve1 = [[decoder decodeObjectForKey:kreserve1] retain];
		reserve2 = [[decoder decodeObjectForKey:kreserve2] retain];
		reserve3 = [[decoder decodeObjectForKey:kreserve3] retain];
        
        placemark = [[decoder decodeObjectForKey:kplacemark] retain];
        person = [[decoder decodeObjectForKey:kPerson] retain];
        indexOfPersonAddresses = [decoder decodeIntegerForKey:kIndexOfPersonAddresses];
        
        usedAlarmSchedule = [decoder decodeBoolForKey:kUsedAlarmSchedule];
        alarmSchedules = [[decoder decodeObjectForKey:kAlarmSchedules] retain];
        sameBeginEndTime = [decoder decodeBoolForKey:kSameBeginEndTime];
        
        
        //////////////////////////
        //为了兼容以前版本的数据
        if (YCCompareDouble(realCoordinate.latitude, 0.0) == NSOrderedSame || YCCompareDouble(realCoordinate.longitude, 0.0) == NSOrderedSame ) {
            realCoordinate = [decoder oldDecodeCLLocationCoordinate2DForKey:kcoordinate];
        }
        if (YCCompareDouble(visualCoordinate.latitude, 0.0) == NSOrderedSame || YCCompareDouble(visualCoordinate.longitude, 0.0) == NSOrderedSame ) {
            visualCoordinate = kCLLocationCoordinate2DInvalid;
        }
        
        if (!positionTitle) {
            positionTitle = [reserve1 copy];
            if (!positionTitle) {
                positionTitle = [alarmName copy];
                if (!positionTitle || positionTitle.length == 0) {
                    positionTitle = [KDefaultAlarmName copy];
                    
                }
            }
        } 
        
        if (!nameChanged) {
            [alarmName release];
            alarmName = nil;
        }  
        
        
        //////////////////////////
		
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
    copy.positionTitle = self.positionTitle;
    copy.placemark = self.placemark;
	copy.usedCoordinateAddress = self.usedCoordinateAddress;
	copy.realCoordinate = self.realCoordinate;
    copy.visualCoordinate = self.visualCoordinate;
	copy.locationAccuracy = self.locationAccuracy;
	
	copy.enabled = self.enabled;
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
    copy.notes = self.notes;
	
	copy.reserve1 = self.reserve1;
	copy.reserve2 = self.reserve2;
	copy.reserve3 = self.reserve3;
    
    copy.person = self.person;
    copy.indexOfPersonAddresses = self.indexOfPersonAddresses;
    
    copy.usedAlarmSchedule = self.usedAlarmSchedule;
    //copy.alarmCalendars = self.alarmCalendars;
    if (self.alarmSchedules.count > 0) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.alarmSchedules.count];
        [self.alarmSchedules enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            id objCopied = [[obj copy] autorelease];
            [array addObject:objCopied];
        }];
        copy->alarmSchedules = [array retain];
    }
    copy.sameBeginEndTime = self.sameBeginEndTime;
        
    return copy;
}

- (void)dealloc {
    //NSLog(@"IAAlarm dealloc");
	[alarmId release];
	[alarmName release];
	
	[position release];
	[positionShort release];
    [positionTitle release];
	
	[sound release];
	[repeatType release];
	[alarmRadiusType release];
	[soundId release];
	[repeatTypeId release];
	[alarmRadiusTypeId release];
	
	
	[positionType release];
	[positionTypeId release];
	[notes release];
	
	[reserve1 release];
	[reserve2 release];
	[reserve3 release];
    
    //NSLog(@"dealloc self.placemark.retainCount = %d",self.placemark.retainCount);
    //NSLog(@"dealloc self.person.retainCount = %d",self.person.retainCount);
    [placemark release];
    [person release];
    
    [alarmSchedules release];
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
    
    //联系人
    if (person) {
        [self performBlock:^{
        
        
        IAPerson *theContact = [[[IAPerson alloc] initWithPersonId:person.personId] autorelease];
        
        //替换地址
        if (placemark.addressDictionary) {
            if (theContact.addressDictionaries.count > indexOfPersonAddresses && indexOfPersonAddresses >= 0 ) {
                [theContact replaceAddressDictionaryAtIndex:indexOfPersonAddresses withAddressDictionary:placemark.addressDictionary];
            }else{
                [theContact addAddressDictionary:placemark.addressDictionary];
                indexOfPersonAddresses = 0; //新的联系人
            }
        }
        
        //照片、公司名
        if (!theContact.image) 
            theContact.image = person.image;
        if (theContact.hasAlarmIdentifierInOrganization) 
            [theContact setOrganizationWithAlarmIdentifier:person.organization];
        
        @try {
            [theContact saveAddressBook];
        }
        @catch (NSException *exception) {
            
        }
            
        } afterDelay:0.1];
    }
    
    //发送、取消定时启动通知
    if (self.enabled && self.usedAlarmSchedule) {
        
        NSString *alertTitle = self.alarmName ? self.alarmName : self.positionTitle;
        for (IAAlarmSchedule * aCalender in self.alarmSchedules) {
            
            if (aCalender.vaild) 
                [aCalender scheduleLocalNotificationWithAlarmId:self.alarmId title:alertTitle message:nil soundName:self.sound.soundFileName];
            else 
                [aCalender cancelLocalNotification];
            
        }
        
    }else {
        for (IAAlarmSchedule * aCalender in self.alarmSchedules) {
            [aCalender cancelLocalNotification];
        }
    }
    
    //保存到文件.注意，保存文件要在处理“定时启动”之后，alarmSchedules的中的通知才能生成。
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
        
        //取消定时启动通知
        for (IAAlarmSchedule * aCalender in self.alarmSchedules) {
            [aCalender cancelLocalNotification];
        }
        
        //
		IASaveInfo *saveInfo = [[[IASaveInfo alloc] init] autorelease];
		saveInfo.objId = self.alarmId;
		saveInfo.saveType = IASaveTypeDelete;
		
		[alarms removeObject:self];
		
        //保存到文件
		NSString *filePathName =  [[UIApplication sharedApplication].libraryDirectory stringByAppendingPathComponent:kDataFilename];
		[NSKeyedArchiver archiveRootObject:alarms toFile:filePathName];
		

		//发送通知
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

+ (void)saveAlarms{
    NSArray *alarms = [IAAlarm alarmArray];
    NSString *filePathName =  [[UIApplication sharedApplication].libraryDirectory stringByAppendingPathComponent:kDataFilename];
	[NSKeyedArchiver archiveRootObject:alarms toFile:filePathName];
}

- (CLLocationCoordinate2D)visualCoordinate{
    
    if (!CLLocationCoordinate2DIsValid(visualCoordinate)) {//从真实坐标转换
        if ([[YCLocationManager sharedLocationManager] chinaShiftEnabled] && [[YCLocationManager sharedLocationManager] isInChinaWithCoordinate:realCoordinate]) { //开启了转换选项 并且 坐标在中国境内
            
            visualCoordinate = [[YCLocationManager sharedLocationManager] convertToMarsCoordinateFromCoordinate:realCoordinate];
            
        }else{
            visualCoordinate = realCoordinate;
        }
    }
    
    return visualCoordinate;
}

- (CLLocationCoordinate2D)realCoordinate{
    
    if (!CLLocationCoordinate2DIsValid(realCoordinate)) {//从虚拟坐标转换
        if ([[YCLocationManager sharedLocationManager] chinaShiftEnabled] && [[YCLocationManager sharedLocationManager] isInChinaWithCoordinate:visualCoordinate]) { //开启了转换选项 并且 坐标在中国境内
            
            realCoordinate = [[YCLocationManager sharedLocationManager] convertToCoordinateFromMarsCoordinate:visualCoordinate];
            
        }else{
            realCoordinate = visualCoordinate;
        }
    }
    
    return realCoordinate;
    
}

- (void)setRealCoordinate:(CLLocationCoordinate2D)theRealCoordinate{
    realCoordinate = theRealCoordinate;
    [self setVisualCoordinateWithRealCoordinate:realCoordinate]; //计算虚拟坐标
}

- (void)setVisualCoordinate:(CLLocationCoordinate2D)theVisualCoordinate{
    visualCoordinate = theVisualCoordinate;
    [self setRealCoordinateWithVisualCoordinate:visualCoordinate]; //计算真实坐标
}

- (void)setRealCoordinateWithVisualCoordinate:(CLLocationCoordinate2D)theVisualCoordinate{
    
    if ([[YCLocationManager sharedLocationManager] chinaShiftEnabled] && [[YCLocationManager sharedLocationManager] isInChinaWithCoordinate:theVisualCoordinate]) { //开启了转换选项 并且 坐标在中国境内
        
        realCoordinate = [[YCLocationManager sharedLocationManager] convertToCoordinateFromMarsCoordinate:theVisualCoordinate];
        
    }else{
        realCoordinate = theVisualCoordinate;
    }
    
}

- (void)setVisualCoordinateWithRealCoordinate:(CLLocationCoordinate2D)theCoordinate{
    
    if ([[YCLocationManager sharedLocationManager] chinaShiftEnabled] && [[YCLocationManager sharedLocationManager] isInChinaWithCoordinate:theCoordinate]) { //开启了转换选项 并且 坐标在中国境内
        
        visualCoordinate = [[YCLocationManager sharedLocationManager] convertToMarsCoordinateFromCoordinate:theCoordinate];
        
    }else{
        visualCoordinate = theCoordinate;
    }
    
}
 

- (NSString*)name{
    NSString *theName = nil;
    theName = self.alarmName;
    theName = theName ? theName : self.person.personName;
    theName = theName ? theName : self.placemark.name;
    theName = [theName stringByTrim];
    theName = (theName.length > 0) ? theName : nil;
    return theName;
}

- (NSString*)title{
    NSString *theTitle = [self name];
    theTitle = theTitle ? theTitle : self.person.organization;
    theTitle = theTitle ? theTitle : self.positionTitle; 
    theTitle = theTitle ? theTitle : KDefaultAlarmName;
    
    return theTitle;
}

- (BOOL)shouldWorking{
    if (self.enabled) {
        if (self.usedAlarmSchedule) {
            
            NSDate *now = [NSDate date];
            IAAlarmSchedule *aSchedule = nil;
            if(self.alarmSchedules.count == 1)  {
                //仅提醒一次
                aSchedule = [self.alarmSchedules objectAtIndex:0];
            }else if(self.alarmSchedules.count == 7){
                //连续闹钟
                NSCalendar *currentCalendar = [NSCalendar currentCalendar];
                currentCalendar.firstWeekday = 2;//一周从周一开始
                int weekday = [currentCalendar ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:now];
                weekday = weekday -1;//周一 weekday = 1
                aSchedule = [self.alarmSchedules objectAtIndex:weekday];
            }
            
            NSComparisonResult r1 = [aSchedule.beginTime compare:now];
            NSComparisonResult r2 = [aSchedule.endTime compare:now];
                        
            //anCalendar被选中了 && now在开始和结束之间
            if (aSchedule.vaild && (NSOrderedSame == r1 || NSOrderedAscending == r1) 
                && (NSOrderedSame == r2 || NSOrderedDescending == r2)) {
                return YES;
            }else {
                return NO;
            }
            
            
        }else {
            return YES;
        }
    }else {
        return NO;
    }
}

- (CLLocationDistance)distanceFromLocation:(CLLocation*)location{
    if (nil == location || !CLLocationCoordinate2DIsValid(self.realCoordinate) ){
        return -1;
    }else {
        return [location distanceFromCoordinate:self.realCoordinate];
    }
}

- (NSString*)distanceLocalStringFromLocation:(CLLocation*)location{
    if ([self distanceFromLocation:location] == -1) {
        return nil;
    }else {
        return [location distanceStringFromCoordinate:self.realCoordinate withFormat1:KTextPromptDistanceCurrentLocation withFormat2:KTextDistanceLessThan0_1Km];
    }
}

- (NSString *)description{
    return self.alarmName ? self.alarmName : self.positionTitle;
}

/*
- (id)retain{
    return [super retain];
    
}
 */


@end
