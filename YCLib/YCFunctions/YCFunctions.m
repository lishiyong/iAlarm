//
//  YCGFunctions.c
//  iAlarm
//
//  Created by li shiyong on 12-4-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCFunctions.h"

//转换经纬度
NSString *convert(CLLocationDegrees value, NSUInteger accuracy,NSString *formateString);
NSString *convert(CLLocationDegrees value, NSUInteger accuracy,NSString *formateString){
    double lTemp =  fabs(value);
	
	NSInteger a= (NSInteger)lTemp;
	double af = lTemp - a;
	
	NSInteger b= (NSInteger)(af*60);
	double bf = af * 60 -b;
	
	NSInteger c= (NSInteger)(bf*60);
	NSInteger cf = (NSInteger)((bf*60 - c) * pow(10,accuracy)) ;
	
    NSString *s = [NSString stringWithFormat:formateString,a,b,c,cf];
	return s;
}


NSString* YCSerialCode(){
	NSUInteger x = arc4random()/100;
	NSString *s = [NSString stringWithFormat:@"%d", time(NULL)];
	NSString *ss = [NSString stringWithFormat:@"%@%d",s,x];
	
	return ss;
}

NSString* YCStringFromCLLocationCoordinate2D(CLLocationCoordinate2D coord){
    return [NSString stringWithFormat:@"{%.6f, %.6f}",coord.latitude,coord.longitude];
}

NSString* YCLocalizedStringFromCLLocationCoordinate2D(CLLocationCoordinate2D coord, NSString *northLatitude, NSString *southLatitude, NSString *easeLongitude, NSString *westLongitude){
    /*
    NSString *latFString = nil;
	if (coord.latitude>0)
        latFString = northLatitude; //北纬
	else 
        latFString = southLatitude; //南纬
    
    NSString *lonFString = nil;
    if (coord.longitude>0)
        lonFString = easeLongitude; //东经
	else 
		lonFString = westLongitude; //西经
    
    
	NSString *latstr = convert(coord.latitude, 0, latFString);
	NSString *lonstr = convert(coord.latitude, 0, lonFString);
    
    return [NSString stringWithFormat:@"%@,%@",latstr,lonstr];
     */
    return YCLocalizedStringFromCLLocationCoordinate2DUsingSeparater(coord,northLatitude,southLatitude,easeLongitude,westLongitude,@", ");
}

NSString* YCLocalizedStringFromCLLocationCoordinate2DUsingSeparater(CLLocationCoordinate2D coord, NSString *northLatitude, NSString *southLatitude, NSString *easeLongitude, NSString *westLongitude, NSString *separater){
    
    NSString *latFString = nil;
	if (coord.latitude>0)
        latFString = northLatitude; //北纬
	else 
        latFString = southLatitude; //南纬
    
    NSString *lonFString = nil;
    if (coord.longitude>0)
        lonFString = easeLongitude; //东经
	else 
		lonFString = westLongitude; //西经
    
    
	NSString *latstr = convert(coord.latitude, 0, latFString);
	NSString *lonstr = convert(coord.longitude, 0, lonFString);
    
    NSMutableString *format = [NSMutableString stringWithString: @"%@"];
    [format appendString:separater];
    [format appendString:@"%@"];
    
    return [NSString stringWithFormat:format,latstr,lonstr];
}

BOOL YCCGPointEqualPoint(CGPoint src1,CGPoint src2){
	
	//CGPoint的x和y 使用double四舍五入后的整数部分
	BOOL retVal = NO;
	
	int src1X= src1.x > 0 ? (int)(src1.x+0.5):(int)(src1.x-0.5);
	int src1Y= src1.y > 0 ? (int)(src1.y+0.5):(int)(src1.y-0.5);
	
	int src2X= src2.x > 0 ? (int)(src2.x+0.5):(int)(src2.x-0.5);
	int src2Y= src2.y > 0 ? (int)(src2.y+0.5):(int)(src2.y-0.5);
	
	if (src1X == src2X) {
		if (src1Y == src2Y) {
			retVal = YES;
		}
	}
	
	return retVal;
}

BOOL YCCGPointEqualPointWithOffSet(CGPoint src1,CGPoint src2,NSUInteger offSet){
    
	BOOL retVal = NO;
	
	int src1X= src1.x ;
	int src1Y= src1.y ;
	
	int src2X= src2.x ;
	int src2Y= src2.y ;
	
	if (abs(src1X - src2X) < offSet) {
		if (abs(src1Y - src2Y) < offSet ) {
			retVal = YES;
		}
	}
	
	return retVal;
}