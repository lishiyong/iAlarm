//
//  DicManager.m
//  iArrived
//
//  Created by li shiyong on 10-10-17.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "YCLib.h"
#import "LocalizedString.h"
#import "DicManager.h"
#import "YCSound.h"
#import "YCRepeatType.h"
#import "IAAlarmRadiusType.h"
#import "YCPositionType.h"


@implementation DicManager

#define ksoundCount 6
+(NSDictionary*) soundDictionary
{

	static NSMutableDictionary* soundDic;

	if (!soundDic) 
	{
		NSString* names[ksoundCount] = 
		{
			KDicSoundName000,
			KDicSoundName001,
			KDicSoundName002,
			KDicSoundName003,
			KDicSoundName004,
			KDicSoundName005
		};
		
		NSString* fileNames[ksoundCount] = 
		{
			nil,
			@"Marimba.caf",
			@"Xylophone.caf",
			@"Harp.caf",
			@"Old_Phone.caf",
			@"Trill.caf"
			
		};
		
		NSString* ids[ksoundCount] = 
		{
			@"s000",
			@"s001",
			@"s002",
			@"s003",
			@"s004",
			@"s005"
		};
		
		NSUInteger sortIds[ksoundCount] = 
		{
			0,
			1,
			2,
			3,
			4,
			5
		};
		
		soundDic = [[NSMutableDictionary alloc] init];
		for (int i=0; i<ksoundCount; i++) 
		{
			YCSound *obj = [[YCSound alloc] init];
			obj.soundId = ids[i];
			obj.soundName = names[i];
			obj.soundFileName = fileNames[i];
			obj.sortId = sortIds[i];
			obj.customSound = NO;
			
			if (obj.soundFileName) {
				NSString *soundFilePath =
				[[NSBundle mainBundle] pathForResource: [obj.soundFileName nameInFullFileName]
												ofType: [obj.soundFileName typeInFullFileName]];
				if (soundFilePath)
					obj.soundFileURL = [NSURL fileURLWithPath:soundFilePath];
			}

			

			[soundDic setObject:obj forKey:ids[i]];
			[obj release];
		}
		
	}
	
	return soundDic;
	
}

#define krepeatTypeCount 2
+(NSDictionary*) repeatTypeDictionary
{
	static NSMutableDictionary* repeatTypeDic;
	if (!repeatTypeDic) 
	{
		NSString* names[krepeatTypeCount] = 
		{
			KDicRepeateTypeName001,
			KDicRepeateTypeName002
		};
		
		NSString* ids[krepeatTypeCount] = 
		{
			@"r001",
			@"r002"
		};
		
		NSUInteger sortIds[krepeatTypeCount] = 
		{
			0,
			1
		};
		
		repeatTypeDic = [[NSMutableDictionary alloc] init];
		for (int i=0; i<krepeatTypeCount; i++) 
		{
			YCRepeatType *obj = [[YCRepeatType alloc] init];
			obj.repeatTypeId = ids[i];
			obj.repeatTypeName = names[i];
			obj.sortId = sortIds[i];
			[repeatTypeDic setObject:obj forKey:ids[i]];
			[obj release];
		}
		
	}
	
	return repeatTypeDic;
}

#define kalarmRadiusTypeCount 4
+(NSDictionary*) alarmRadiusTypeDictionary
{
	static NSMutableDictionary* vehicleTypeDic;
	if (!vehicleTypeDic) 
	{
		vehicleTypeDic = [[NSMutableDictionary alloc] initWithCapacity:kalarmRadiusTypeCount];
		for (id oneObject in [DicManager alarmRadiusTypeArray]) {
			IAAlarmRadiusType *obj = (IAAlarmRadiusType*)oneObject;
			[vehicleTypeDic setObject:obj forKey:obj.alarmRadiusTypeId];
			[obj release];
		}
		
	}
	
	return vehicleTypeDic;
}


+(NSArray*) alarmRadiusTypeArray
{
	static NSMutableArray* vehicleTypes;
	if (!vehicleTypes) 
	{
		NSString* names[kalarmRadiusTypeCount] = 
		{
			KDicAlarmRadius001,
			KDicAlarmRadius002,
			KDicAlarmRadius003,
			KDicAlarmRadius004
		};
		
		NSString* ids[kalarmRadiusTypeCount] = 
		{
			@"ar001",
			@"ar002",
			@"ar003",
			@"ar004"
		};
		
		double values[kalarmRadiusTypeCount] = 
		{
			 500.0,
			1000.0,
			2000.0,
			1000.0
		};
		
		NSString* imageNames[kalarmRadiusTypeCount] = 
		{
			@"IAFlagGreen.png",
            @"IAFlagOrange.png",
            @"IAFlagBlueDeep.png",
			@"IAFlagPurple.png"
		};
		
		vehicleTypes = [[NSMutableArray alloc] initWithCapacity:kalarmRadiusTypeCount];
		for (int i=0; i<kalarmRadiusTypeCount; i++) 
		{
			IAAlarmRadiusType *obj = [[IAAlarmRadiusType alloc] init];
			obj.alarmRadiusTypeId = ids[i];
			obj.alarmRadiusName = names[i];
			obj.alarmRadiusValue = values[i];
			obj.alarmRadiusTypeImageName = imageNames[i];
			[vehicleTypes addObject:obj];
			[obj release];
		}
		
	}
	
	return vehicleTypes;
}

#define kpositionTypeCount 2
+(NSDictionary*) positionTypeDictionary
{
	static NSMutableDictionary* dic;
	if (!dic) 
	{
		NSString* names[kpositionTypeCount] = 
		{
			kDicTriggerTypeNameWhenArrive,
			kDicTriggerTypeNameWhenLeave
		};
		
		NSString* ids[kpositionTypeCount] = 
		{
			@"p002",
			@"p001"
		};
		
		NSUInteger sortIds[kpositionTypeCount] = 
		{
			0,
			1
		};
		
		dic = [[NSMutableDictionary alloc] init];
		for (int i=0; i<kpositionTypeCount; i++) 
		{
			YCPositionType *obj = [[YCPositionType alloc] init];
			obj.positionTypeId = ids[i];
			obj.positionTypeName = names[i];
			obj.sortId = sortIds[i];
			[dic setObject:obj forKey:ids[i]];
			[obj release];
		}
		
	}
	
	return dic;
}

+(YCRepeatType*) repeatTypeForSortId:(NSUInteger)sortId
{
	NSArray *repArray = [[DicManager repeatTypeDictionary] allValues];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sortId == %d",sortId];
	NSArray* results = [repArray filteredArrayUsingPredicate:predicate];
	YCRepeatType *obj = nil;
	if (results.count > 0) {
		obj = [results objectAtIndex:0]; //有，且有一个
	}
	return obj;
}

+(YCSound*) soundForSortId:(NSUInteger)sortId
{
	NSArray *repArray = [[DicManager soundDictionary] allValues];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sortId == %d",sortId];
	NSArray* results = [repArray filteredArrayUsingPredicate:predicate];
	YCSound *obj = nil;
	if (results.count > 0) {
		obj = [results objectAtIndex:0]; //有，且有一个
	}
	return obj;
}

+(YCPositionType*) positionTypeForSortId:(NSUInteger)sortId
{
	NSArray *repArray = [[DicManager positionTypeDictionary] allValues];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sortId == %d",sortId];
	NSArray* results = [repArray filteredArrayUsingPredicate:predicate];
	YCPositionType *obj = nil;
	if (results.count > 0) {
		obj = [results objectAtIndex:0]; //有，且有一个
	}
	return obj;
}

@end
