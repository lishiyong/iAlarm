//
//  DicManager.h
//  iArrived
//
//  Created by li shiyong on 10-10-17.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YCRepeatType;
@class YCSound;
@class YCPositionType;
@interface DicManager : NSObject {

}

+(NSDictionary*) soundDictionary;
+(NSDictionary*) repeatTypeDictionary;
+(NSDictionary*) positionTypeDictionary;

+(NSDictionary*) alarmRadiusTypeDictionary;
+(NSArray*)      alarmRadiusTypeArray;


//根据sortId取得对象
+(YCRepeatType*) repeatTypeForSortId:(NSUInteger)sortId;
+(YCSound*) soundForSortId:(NSUInteger)sortId;
+(YCPositionType*) positionTypeForSortId:(NSUInteger)sortId;


@end
