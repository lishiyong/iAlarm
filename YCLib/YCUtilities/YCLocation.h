//
//  YCLocationUtility.h
//  iAlarm
//
//  Created by li shiyong on 11-1-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


//默认显示地图的范围
extern const  CLLocationDistance kDefaultLatitudinalMeters;
extern const CLLocationDistance kDefaultLongitudinalMeters;
//缺省坐标－apple公司总部坐标
extern const CLLocationCoordinate2D kYCDefaultCoordinate;
 
//比较2个 CLLocationCoordinate2D；
BOOL YCCLLocationCoordinate2DEqualToCoordinate(CLLocationCoordinate2D src1,CLLocationCoordinate2D src2);

//两点坐标间距离，假定海拔都是0
CLLocationDistance distanceBetweenCoordinates(CLLocationCoordinate2D aCoordinate,CLLocationCoordinate2D anotherCoordinate);
