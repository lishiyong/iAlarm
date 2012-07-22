//
//  YCLocationManagerDelegateProtocol.h
//  iArrived
//
//  Created by li shiyong on 10-10-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Availability.h>
#import <Foundation/Foundation.h>

@class IARegion, IALocationAlarmManager;

@protocol IALocationAlarmManagerDelegate<NSObject>

@required

- (void)locationManager:(IALocationAlarmManager*)manager
		 didEnterRegion:(IARegion *)region ;


- (void)locationManager:(IALocationAlarmManager*)manager
		  didExitRegion:(IARegion *)region ;

@optional

- (void)locationManager:(IALocationAlarmManager*)manager
	   didFailWithError:(NSError *)error;


- (void)locationManager:(IALocationAlarmManager*)manager
monitoringDidFailForRegion:(IARegion *)region
			  withError:(NSError *)error ;

@end
