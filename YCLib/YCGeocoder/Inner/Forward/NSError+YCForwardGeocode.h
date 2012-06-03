//
//  NSError+YCGeocode.h
//  iAlarm
//
//  Created by li shiyong on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (YCForwardGeocode)

/**
 BSForwardGeocoder 的status 转换 CLError 的code
 **/
+ (id)errorWithBSForwardGeocodeStatus:(NSInteger)status;

@end
