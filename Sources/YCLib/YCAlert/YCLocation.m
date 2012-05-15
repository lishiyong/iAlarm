//
//  YCLocation.c
//  TestMapOffset
//
//  Created by li shiyong on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OffsetDataDao.h"
#import "OffsetData.h"
#import "YCLocation.h"
OffsetData* getOffsetData(CLLocationCoordinate2D coordinate);
OffsetData* getOffsetData(CLLocationCoordinate2D coordinate){
    NSString *lat =  [NSString stringWithFormat:@"%.1f",coordinate.latitude];
    NSString *lng =  [NSString stringWithFormat:@"%.1f",coordinate.longitude];
    
    OffsetDataDao *dao = [[[OffsetDataDao alloc] init] autorelease];
    OffsetData *offsetData = [dao findOffsetDataWithLatitude:lat longitude:lng];
    return offsetData;
}
 
 

/**
 把“正常坐标”转换成“火星坐标”
 **/
CLLocationCoordinate2D convertCoordinateToMarsCoordinate(CLLocationCoordinate2D coordinate){
    
    OffsetData *offsetData = getOffsetData(coordinate);
    if (offsetData) {
        CLLocationCoordinate2D marsCoordinate = (CLLocationCoordinate2D){coordinate.latitude + offsetData.offsetLatitude, coordinate.longitude + offsetData.offsetLongitude};
        return marsCoordinate;
    }else{
        return coordinate;
    }
    
}

/**
 把“火星坐标”转换成“正常坐标”
 **/
CLLocationCoordinate2D convertMarsCoordinateToCoordinate(CLLocationCoordinate2D marsCoordinate){
    
    OffsetData *offsetData = getOffsetData(marsCoordinate);
    if (offsetData) {
        CLLocationCoordinate2D coordinate = (CLLocationCoordinate2D){marsCoordinate.latitude - offsetData.offsetLatitude, marsCoordinate.longitude - offsetData.offsetLongitude};
        return coordinate;
    }else{
        return marsCoordinate;
    }
    
}

