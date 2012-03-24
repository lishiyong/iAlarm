//
//  YCMapsUtility.m
//  iAlarm
//
//  Created by li shiyong on 11-2-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YCDouble.h"
#import "NSString-YC.h"
#import "YCLocationUtility.h"
#import "YCMapsUtility.h"


@implementation YCMapsUtility

BOOL YCMKCoordinateSpanIsValid(MKCoordinateSpan span)
{	/*
	 double lad = span.latitudeDelta;
	 double lod = span.longitudeDelta;
	 if (lad > 180.0 || lad < 0.0) return NO;
	 if (lod > 180.0 || lod < 0.0) return NO;
	 */
	
	return YES;
}

BOOL YCMKCoordinateRegionIsValid(MKCoordinateRegion region)
{	
	if(!CLLocationCoordinate2DIsValid(region.center)) return NO;
	if(!YCMKCoordinateSpanIsValid(region.span)) return NO;
	return YES;
}

/*
NSString* trimString(NSString* src){
	NSString* des = [src stringByTrimmingCharactersInSet: 
					[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if([des length] == 0) des = nil; 
	return des;
}
 */

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

BOOL YCCompareMKCoordinateSpan(MKCoordinateSpan src1,MKCoordinateSpan src2){
	int b = YCCompareDouble(src1.latitudeDelta, src2.latitudeDelta); 
	if (b !=0) return NO;
	b = YCCompareDouble(src1.longitudeDelta, src2.longitudeDelta);
	if (b !=0) return NO;
	
	return YES;
}

BOOL YCCompareMKCoordinateRegion(MKCoordinateRegion src1,MKCoordinateRegion src2){
	int b = YCCompareCLLocationCoordinate2D(src1.center, src2.center);
	if (b !=0) return NO;
	return YCCompareMKCoordinateSpan(src1.span,src2.span);
}

@end
