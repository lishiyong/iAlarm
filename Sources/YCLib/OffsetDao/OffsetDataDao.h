//
//  offSetDataDao.h
//  TestMapOffset
//
//  Created by li shiyong on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDao.h"

@class OffsetData;
@interface OffsetDataDao : BaseDao

- (OffsetData*)findOffsetDataWithLatitude:(NSString*)latitude longitude:(NSString*)longitude;

@end
