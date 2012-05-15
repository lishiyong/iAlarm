//
//  offSetData.h
//  TestMapOffset
//
//  Created by li shiyong on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OffsetData : NSObject

@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic) CGFloat offsetLatitude;
@property (nonatomic) CGFloat offsetLongitude;

@end
