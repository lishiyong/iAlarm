//
//  LocationManagerFactory.h
//  iAlarm
//
//  Created by li shiyong on 12-2-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IALocationManagerInterface.h"
#import <Foundation/Foundation.h>

@interface LocationManagerFactory : NSObject

+ (id<IALocationManagerInterface>)locationManagerInstanceWithDelegate:(id)delegate;

@end
