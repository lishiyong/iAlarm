//
//  YCLocationUtility.m
//  iAlarm
//
//  Created by li shiyong on 11-1-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YCDouble.h"
#import "YCLocationUtility.h"


@implementation YCLocationUtility

@end

//默认显示地图的范围
const  CLLocationDistance kDefaultLatitudinalMeters  = 2500.0;
const  CLLocationDistance kDefaultLongitudinalMeters = 2500.0;


//比较2个 CLLocationCoordinate2D；
//返回值:
//0：相等；非0值，不相等
int YCCompareCLLocationCoordinate2D(CLLocationCoordinate2D src1,CLLocationCoordinate2D src2){
	/*
	int retVal = 1;
	if (0 == YCCompareDouble(src1.latitude,src2.latitude)) {
		if (0 == YCCompareDouble(src1.longitude,src2.longitude)) {
			retVal = 0;
		}
	}
	return retVal;
	 */
	int retVal = 1;
	if (0 == YCCompareDoubleWithNumber(src1.latitude,src2.latitude,4)) {
		if (0 == YCCompareDoubleWithNumber(src1.longitude,src2.longitude,4)) {
			retVal = 0;
		}
	}
	return retVal;
}

//比较2个 CGPoint；
//返回值:
//0：相等；非0值，不相等
int YCCompareCGPoint(CGPoint src1,CGPoint src2){
	/*
	NSLog(@"(int)(-1.0 - 0.5):%d",(int)(-1.0 - 0.5));  //result:-1
	NSLog(@"(int)(-1.51- 0.5):%d",(int)(-1.51- 0.5));  //result:-2
	
	NSLog(@"(int)(1.0 + 0.5):%d",(int)(1.0+0.5));  //result:1
	NSLog(@"(int)(0.0 + 0.5):%d",(int)(0.0+0.5));  //result:0
	 */
	
	//CGPoint的x和y 使用double四舍五入后的整数部分
	int retVal = 1;
	
	int src1X= src1.x > 0 ? (int)(src1.x+0.5):(int)(src1.x-0.5);
	int src1Y= src1.y > 0 ? (int)(src1.y+0.5):(int)(src1.y-0.5);
	
	int src2X= src2.x > 0 ? (int)(src2.x+0.5):(int)(src2.x-0.5);
	int src2Y= src2.y > 0 ? (int)(src2.y+0.5):(int)(src2.y-0.5);
	
	if (src1X == src2X) {
		if (src1Y == src2Y) {
			retVal = 0;
		}
	}
	
	return retVal;
}

//比较2个 CGPoint。有允许误差；
//返回值:
//0：相等；非0值，不相等
int YCCompareCGPointWithOffSet(CGPoint src1,CGPoint src2,NSUInteger offSet){

	int retVal = 1;
	
	int src1X= src1.x ;
	int src1Y= src1.y ;
	
	int src2X= src2.x ;
	int src2Y= src2.y ;
	
	if (abs(src1X - src2X) < offSet) {
		if (abs(src1Y - src2Y) < offSet ) {
			retVal = 0;
		}
	}
	
	return retVal;
}

/*
BOOL isValidCoordinate(CLLocationCoordinate2D coordinate){
	int la = (int)coordinate.latitude;
	int lo = (int)coordinate.longitude;
	if (la == 0 && lo == 0 ) 
		return NO;
	
	return CLLocationCoordinate2DIsValid(coordinate);
}
 */

//缺省坐标－apple公司总部坐标
CLLocationCoordinate2D YCDefaultCoordinate(){
	return CLLocationCoordinate2DMake(37.331689, -122.030731);
}