//
//  YCLocationManagerDelegateProtocol.h
//  iArrived
//
//  Created by li shiyong on 10-10-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Availability.h>
#import <Foundation/Foundation.h>

@class IARegion;
//@class IALocationManager;
@protocol IALocationManagerInterface;


@protocol IALocationManagerDelegate<NSObject>

@required

/*
 *  locationManager:didEnterRegion:
 *
 *  Discussion:
 *    Invoked when the user enters a monitored region.  This callback will be invoked for every allocated
 *    CLLocationManager instance with a non-nil delegate that implements this method.
 */
- (void)locationManager:(id<IALocationManagerInterface>)manager
		 didEnterRegion:(IARegion *)region ;

/*
 *  locationManager:didExitRegion:
 *
 *  Discussion:
 *    Invoked when the user exits a monitored region.  This callback will be invoked for every allocated
 *    CLLocationManager instance with a non-nil delegate that implements this method.
 */
- (void)locationManager:(id<IALocationManagerInterface>)manager
		  didExitRegion:(IARegion *)region ;

@optional
/*
 *  locationManager:didFailWithError:
 *  
 *  Discussion:
 *    Invoked when an error has occurred. Error types are defined in "CLError.h".
 */
- (void)locationManager:(id<IALocationManagerInterface>)manager
	   didFailWithError:(NSError *)error;

/*
 *  locationManager:monitoringDidFailForRegion:withError:
 *  
 *  Discussion:
 *    Invoked when a region monitoring error has occurred. Error types are defined in "CLError.h".
 */
- (void)locationManager:(id<IALocationManagerInterface>)manager
monitoringDidFailForRegion:(IARegion *)region
			  withError:(NSError *)error ;

@end
