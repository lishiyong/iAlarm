//
//  YCGFunctions.c
//  iAlarm
//
//  Created by li shiyong on 12-4-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCFunctions.h"

NSString* YCSerialCode(){
	NSUInteger x = arc4random()/100;
	NSString *s = [NSString stringWithFormat:@"%d", time(NULL)];
	NSString *ss = [NSString stringWithFormat:@"%@%d",s,x];
	
	return ss;
}

NSString* NSStringFromCLLocationCoordinate2D(CLLocationCoordinate2D coord){
    return [NSString stringWithFormat:@"latitude = %.6f, longitude = %.6f",coord.latitude,coord.longitude];
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