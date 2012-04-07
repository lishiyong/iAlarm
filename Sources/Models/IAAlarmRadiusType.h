//
//  YCVehicleType.h
//  iArrived
//
//  Created by li shiyong on 10-10-17.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define    kvehicleTypeId        @"kvehicleTypeId"
#define    kvehicleTypeName      @"kvehicleTypeName"
#define    kalarmRadiusValue     @"kalarmRadiusValue"
#define    kalarmRadiusTypeImageName     @"kalarmRadiusTypeImageName"

@interface IAAlarmRadiusType : NSObject <NSCoding>{
	NSString *alarmRadiusTypeId;         
	NSString *alarmRadiusName;
	double alarmRadiusValue;  //单位:米
	NSString *alarmRadiusTypeImageName;
}

@property (nonatomic,copy) NSString *alarmRadiusTypeId;
@property (nonatomic,copy) NSString *alarmRadiusName;
@property (nonatomic,assign) double alarmRadiusValue;
@property (nonatomic,copy) NSString *alarmRadiusTypeImageName;

@end
