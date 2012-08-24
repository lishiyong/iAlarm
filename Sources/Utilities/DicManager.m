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
        
        NSArray *soundPairs = [NSArray 
                               arrayWithObjects
                               :[YCPair pairWithValue:[NSNull null] forKey:@"my-ring:None"]
                               
                               ,[YCPair pairWithValue:@"Toreador_Song.caf" forKey:@"my-ring:Toreador Song"]
                               ,[YCPair pairWithValue:@"Beach_Hut.caf" forKey:@"my-ring:Beach Hut"]
                               ,[YCPair pairWithValue:@"Buskers.caf" forKey:@"my-ring:Buskers"]
                               ,[YCPair pairWithValue:@"Canon.caf" forKey:@"my-ring:Canon"]
                               ,[YCPair pairWithValue:@"Carmen_Fantasy.caf" forKey:@"my-ring:Carmen Fantasy"]
                               ,[YCPair pairWithValue:@"Crystal_Tears.caf" forKey:@"my-ring:Crystal Tears"]
                               ,[YCPair pairWithValue:@"Lonely_Valley.caf" forKey:@"my-ring:Lonely Valley"]
                               ,[YCPair pairWithValue:@"The_Black_and_White.caf" forKey:@"my-ring:The Black and White"]
                               
                               ,[YCPair pairWithValue:@"Marimba.caf" forKey:@"apple-sound:Marimba"]
                               ,[YCPair pairWithValue:@"Ascending.caf" forKey:@"system:Ascending"]
                               ,[YCPair pairWithValue:@"Bell_Tower.caf" forKey:@"system:Bell Tower"]
                               ,[YCPair pairWithValue:@"Blues.caf" forKey:@"system:Blues"]
                               ,[YCPair pairWithValue:@"Boing.caf" forKey:@"system:Boing"]
                               ,[YCPair pairWithValue:@"Crickets.caf" forKey:@"system:Crickets"]
                               ,[YCPair pairWithValue:@"Digital.caf" forKey:@"system:Digital"]
                               ,[YCPair pairWithValue:@"Doorbell.caf" forKey:@"system:Doorbell"]
                               ,[YCPair pairWithValue:@"Duck.caf" forKey:@"system:Duck"]
                               ,[YCPair pairWithValue:@"Harp.caf" forKey:@"system:Harp"]
                               ,[YCPair pairWithValue:@"Motorcycle.caf" forKey:@"system:Motorcycle"]
                               ,[YCPair pairWithValue:@"Old_Car_Horn.caf" forKey:@"system:Old Car Horn"]
                               ,[YCPair pairWithValue:@"Old_Phone.caf" forKey:@"system:Old Phone"]
                               ,[YCPair pairWithValue:@"Piano_Riff.caf" forKey:@"system:Piano Riff"]
                               ,[YCPair pairWithValue:@"Pinball.caf" forKey:@"system:Pinball"]
                               ,[YCPair pairWithValue:@"Robot.caf" forKey:@"system:Robot"]
                               ,[YCPair pairWithValue:@"Strum.caf" forKey:@"system:Strum"]
                               ,[YCPair pairWithValue:@"Timba.caf" forKey:@"system:Timba"]
                               ,[YCPair pairWithValue:@"Trill.caf" forKey:@"system:Trill"]
                               ,[YCPair pairWithValue:@"Xylophone.caf" forKey:@"system:Xylophone"]
                               , nil];
        
		
		soundDic = [[NSMutableDictionary alloc] init];
		for (int i=0; i<soundPairs.count; i++) 
		{
            YCPair *aPair = [soundPairs objectAtIndex:i];
            
			YCSound *obj = [[YCSound alloc] init];
			obj.soundId = [NSString stringWithFormat:@"s%.3d",i];
			obj.soundName = NSLocalizedStringFromTable((NSString*)aPair.key, @"ring", @"");
			obj.soundFileName = ((id)aPair.value != [NSNull null]) ? (NSString*)aPair.value : nil;
			obj.sortId = i;
            			
			if (obj.soundFileName) {
				NSString *soundFilePath =
				[[NSBundle mainBundle] pathForResource: [obj.soundFileName nameInFullFileName]
												ofType: [obj.soundFileName typeInFullFileName]];
				if (soundFilePath)
					obj.soundFileURL = [NSURL fileURLWithPath:soundFilePath];
			}

			

			[soundDic setObject:obj forKey:obj.soundId];
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
