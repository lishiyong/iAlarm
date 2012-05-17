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


NSComparisonResult compareFloat(CGFloat anFloat, CGFloat anotherFloat){
    if (fabs(anFloat - anotherFloat) < 1.0e-5) {
        return NSOrderedSame;
    }else if(anFloat >anotherFloat){
        return NSOrderedDescending;
    }else{
        return NSOrderedAscending;
    }
}

NSString* NSStringFromCLLocationCoordinate2D(CLLocationCoordinate2D coord){
    return [NSString stringWithFormat:@"latitude = %.6f, longitude = %.6f",coord.latitude,coord.longitude];
}

