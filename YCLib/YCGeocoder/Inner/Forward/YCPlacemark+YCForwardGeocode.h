//
//  YCPlacemark+YCForwardGeocode.h
//  iAlarm
//
//  Created by li shiyong on 12-6-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCPlacemark.h"

@class BSKmlResult;
@interface YCPlacemark (YCForwardGeocode)

- (id)initWithBSKmlResult:(BSKmlResult*)kmlResult;

+ (NSArray *)placemarksWithBSKmlResults:(NSArray*)kmlResults;
+ (NSArray *)placemarksWithCLPacemarks:(NSArray*)pacemarks;

@end
