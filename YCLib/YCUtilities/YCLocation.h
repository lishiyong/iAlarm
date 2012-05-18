//
//  YCLocationUtility.h
//  iAlarm
//
//  Created by li shiyong on 11-1-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface YCLocationUtility : NSObject {

}

@end


//默认显示地图的范围
extern const  CLLocationDistance kDefaultLatitudinalMeters;
extern const CLLocationDistance kDefaultLongitudinalMeters;
 

//比较2个 CLLocationCoordinate2D；
//返回值:
//0：相等；非0值，不相等
int YCCompareCLLocationCoordinate2D(CLLocationCoordinate2D src1,CLLocationCoordinate2D src2);

//比较2个 CGPoint；
//返回值:
//0：相等；非0值，不相等
int YCCompareCGPoint(CGPoint src1,CGPoint src2);


//比较2个 CGPoint。有允许误差；
//返回值:
//0：相等；非0值，不相等
int YCCompareCGPointWithOffSet(CGPoint src1,CGPoint src2,NSUInteger offSet);

//是否是有限坐标，（0,0)认为无效
//BOOL isValidCoordinate(CLLocationCoordinate2D coordinate);

//缺省坐标－apple公司总部坐标
CLLocationCoordinate2D YCDefaultCoordinate();
