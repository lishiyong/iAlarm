//
//  IALocationManagerInterface.h
//  iAlarm
//
//  Created by li shiyong on 12-1-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IALocationManagerDelegate.h"
#import <Foundation/Foundation.h>

//@protocol IALocationManagerDelegate;
@protocol IALocationManagerInterface <NSObject>

@required

- (void)start;
- (void)stop;

@property(nonatomic,assign) id<IALocationManagerDelegate> delegate;

@end
