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
	NSComparisonResult cResult = YCCompareDoubleWithAccuracy(src1.latitudeDelta, src2.latitudeDelta, 2); 
	if (NSOrderedSame != cResult) return NO;
    
	cResult = YCCompareDoubleWithAccuracy(src1.longitudeDelta, src2.longitudeDelta,2);
	if (NSOrderedSame != cResult) return NO;
	
	return YES;
}

BOOL YCMKCoordinateRegionEqualToRegion(MKCoordinateRegion src1,MKCoordinateRegion src2){
    if (!YCCLLocationCoordinate2DEqualToCoordinateWithAccuracy(src1.center, src2.center, 2)) 
        return NO;
	return YCMKCoordinateSpanEqualToSpan(src1.span,src2.span);
}

MKMapRect YCMapRectForRegion(CLRegion *region){
    MKMapRect mapRect = MKMapRectNull;
    
    if (region) {
        double width = (region.radius * 2) * MKMapPointsPerMeterAtLatitude(region.center.latitude);
        double height = (region.radius * 2) * MKMapPointsPerMeterAtLatitude(0); 
        //长、宽距离与MKMapSize的转换原理，来源于墨卡托投影的原理。
        
        MKMapPoint center = MKMapPointForCoordinate(region.center);
        MKMapPoint origin = (MKMapPoint){center.x - width/2, center.y - height/2};
        
        mapRect = (MKMapRect){origin,{width,height}};
    }
    
    return mapRect;
}

CLLocationCoordinate2D YCCoordinateForMapPoint(MKMapPoint mapPoint){
    
    CLLocationCoordinate2D coord = MKCoordinateForMapPoint(mapPoint);
    CLLocationDegrees latitude = coord.latitude; 
    CLLocationDegrees longitude = coord.longitude;
    if (latitude  >  85.0)  latitude  =  85.0;
    if (latitude  < -85.0)  latitude  = -85.0;
    if (longitude >  180.0) longitude = longitude - 360.0;
    if (longitude < -180.0) longitude = longitude + 360.0;
    
    return (CLLocationCoordinate2D){latitude,longitude};
}

MKMapPoint YCMapRectCenter(MKMapRect mapRect){
    //算出中心点
    MKMapPoint origin = mapRect.origin;
    double width = MKMapRectGetWidth(mapRect);
    double height = MKMapRectGetHeight(mapRect);
    MKMapPoint center = (MKMapPoint){origin.x + width/2, origin.y + height/2};
    return center;
}

CLRegion* YCRegionForMapRect(MKMapRect mapRect){
    if (MKMapRectIsNull(mapRect) || MKMapRectIsEmpty(mapRect)) {
        return nil;
    }
    
    MKMapPoint center = YCMapRectCenter(mapRect);
    CLLocationCoordinate2D coordinate = MKCoordinateForMapPoint(center);
    CLLocationDistance radius = (MKMetersPerMapPointAtLatitude(0.0)*mapRect.size.height)/2; //墨卡托投影:地图点高度代表的实际距离不变化
    CLRegion *region = [[[CLRegion alloc] initCircularRegionWithCenter:coordinate radius:radius identifier:@"RegionForMapRect"] autorelease];
    
    return region;
}

CLRegion* YCRegionForCoordinateRegion(MKCoordinateRegion coordinateRegion){
    if (!YCMKCoordinateRegionIsValid(coordinateRegion)) {
        return nil;
    }
    
    CLLocationDistance radius = coordinateRegion.span.latitudeDelta * 111000;//每纬度111公里
    CLRegion *region = [[[CLRegion alloc] initCircularRegionWithCenter:coordinateRegion.center radius:radius identifier:@"RegionForCoordinateRegion"] autorelease];
    return region;
}


NSString* YCGetAddressString(MKPlacemark* placemark){
    
    NSLog(@"placemark.description = %@",[placemark description]);
    NSLog(@"========================================================================");
    NSLog(@"placemark.addressDictionary = %@",[placemark.addressDictionary description]);
    NSLog(@"========================================================================");
    
	
	NSString * thoroughfare = placemark.thoroughfare; //街道
	NSString * subthoroughfare = placemark.subThoroughfare;//街道号
	NSString * locality = placemark.locality; //城市
	NSString * administrativeArea = placemark.administrativeArea;//省
	NSString * country = placemark.country;//国
	
	///////////////
	//去空格
	thoroughfare = [thoroughfare stringByTrim];	
	subthoroughfare = [subthoroughfare stringByTrim];
	locality = [locality stringByTrim];
	administrativeArea = [administrativeArea stringByTrim];
	country = [country stringByTrim];
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
	NSString *stringTrim = [string stringByTrim];
	
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
	thoroughfare = [thoroughfare stringByTrim];	
	subthoroughfare = [subthoroughfare stringByTrim];
	locality = [locality stringByTrim];
	///////////////
	
	if(thoroughfare == nil && subthoroughfare == nil && locality) return nil;
	
	if (thoroughfare ==nil) thoroughfare=@"";
	if (subthoroughfare ==nil) subthoroughfare=@"";
	if (locality ==nil) locality=@"";
	
	NSString *string = [[[NSString alloc] initWithFormat:@"%@ %@ %@",thoroughfare,subthoroughfare,locality] autorelease];
	NSString *stringTrim = [string stringByTrim];
	if ([stringTrim length] == 0) {
		stringTrim = YCGetAddressString(placemark); //短地址为空，使用长地址
	}
	
	return stringTrim;
}
NSString* YCGetAddressTitleString(MKPlacemark* placemark){
	
	NSString * thoroughfare = placemark.thoroughfare; //街道
	
	///////////////
	//去空格
	thoroughfare = [thoroughfare stringByTrim];	
	///////////////
	
	if([thoroughfare length] == 0) thoroughfare = YCGetAddressShortString(placemark);
	
	
	return thoroughfare;
}

