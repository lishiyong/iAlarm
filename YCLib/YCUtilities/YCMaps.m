//
//  YCMapsUtility.m
//  iAlarm
//
//  Created by li shiyong on 11-2-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YCDouble.h"
#import "NSString+YC.h"
#import "YCLocation.h"
#import "YCMaps.h"

BOOL YCMKCoordinateSpanIsValid(MKCoordinateSpan span);
BOOL YCMKCoordinateSpanIsValid(MKCoordinateSpan span)
{	
	return YES;
}

BOOL YCMKCoordinateRegionIsValid(MKCoordinateRegion region)
{	
	if(!CLLocationCoordinate2DIsValid(region.center)) return NO;
	if(!YCMKCoordinateSpanIsValid(region.span)) return NO;
	return YES;
}

BOOL YCMKCoordinateSpanEqualToSpan(MKCoordinateSpan src1,MKCoordinateSpan src2){
	NSComparisonResult cResult = YCCompareFloatWithAccuracy(src1.latitudeDelta, src2.latitudeDelta, 2); 
	if (NSOrderedSame != cResult) return NO;
    
	cResult = YCCompareFloatWithAccuracy(src1.longitudeDelta, src2.longitudeDelta,2);
	if (NSOrderedSame != cResult) return NO;
	
	return YES;
}

BOOL YCMKCoordinateRegionEqualToRegion(MKCoordinateRegion src1,MKCoordinateRegion src2){
    if (!YCCLLocationCoordinate2DEqualToCoordinateWithAccuracy(src1.center, src2.center, 2)) 
        return NO;
	return YCMKCoordinateSpanEqualToSpan(src1.span,src2.span);
}

NSString* YCGetAddressString(MKPlacemark* placemark){
	
	NSString * thoroughfare = placemark.thoroughfare; //街道
	NSString * subthoroughfare = placemark.subThoroughfare;//街道号
	NSString * locality = placemark.locality; //城市
	NSString * administrativeArea = placemark.administrativeArea;//省
	NSString * country = placemark.country;//国
	
	///////////////
	//去空格
	thoroughfare = [thoroughfare trim];	
	subthoroughfare = [subthoroughfare trim];
	locality = [locality trim];
	administrativeArea = [administrativeArea trim];
	country = [country trim];
	///////////////
	
	if(locality == nil && thoroughfare == nil && subthoroughfare == nil  
	   && administrativeArea == nil && country == nil) 
		return nil;
	
	if (locality ==nil) locality=@"";
	if (thoroughfare ==nil) thoroughfare=@"";
	if (subthoroughfare ==nil) subthoroughfare=@"";
	if (administrativeArea ==nil) administrativeArea=@"";
	if (country ==nil) country=@"";
	
	//NSString *string = [[[NSString alloc] initWithFormat:@"%@ %@ %@ %@ %@",thoroughfare,subthoroughfare,locality,administrativeArea,country] autorelease];
	NSString *string = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",thoroughfare,subthoroughfare,locality,administrativeArea,country];
	NSString *stringTrim = [string trim];
	
	if ([stringTrim length] == 0) {
		 return nil;
	}
	
	return stringTrim;
}

NSString* YCGetAddressShortString(MKPlacemark* placemark){
	NSString * thoroughfare = placemark.thoroughfare; //街道
	NSString * subthoroughfare = placemark.subThoroughfare;//街道号
	NSString * locality = placemark.locality; //城市
	
	///////////////
	//去空格
	thoroughfare = [thoroughfare trim];	
	subthoroughfare = [subthoroughfare trim];
	locality = [locality trim];
	///////////////
	
	if(thoroughfare == nil && subthoroughfare == nil && locality) return nil;
	
	if (thoroughfare ==nil) thoroughfare=@"";
	if (subthoroughfare ==nil) subthoroughfare=@"";
	if (locality ==nil) locality=@"";
	
	NSString *string = [[[NSString alloc] initWithFormat:@"%@ %@ %@",thoroughfare,subthoroughfare,locality] autorelease];
	NSString *stringTrim = [string trim];
	if ([stringTrim length] == 0) {
		stringTrim = YCGetAddressString(placemark); //短地址为空，使用长地址
	}
	
	return stringTrim;
}
NSString* YCGetAddressTitleString(MKPlacemark* placemark){
	
	NSString * thoroughfare = placemark.thoroughfare; //街道
	
	///////////////
	//去空格
	thoroughfare = [thoroughfare trim];	
	///////////////
	
	if([thoroughfare length] == 0) thoroughfare = YCGetAddressShortString(placemark);
	
	
	return thoroughfare;
}

