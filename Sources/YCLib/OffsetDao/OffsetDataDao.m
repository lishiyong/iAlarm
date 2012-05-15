//
//  offSetDataDao.m
//  TestMapOffset
//
//  Created by li shiyong on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FMDatabase.h"
#import "FMResultSet.h"
#import "OffsetData.h"
#import "OffsetDataDao.h"

@implementation OffsetDataDao

- (OffsetData*)findOffsetDataWithLatitude:(NSString*)latitude longitude:(NSString*)longitude{

    OffsetData *obj = nil;
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM offsetData where lat = '%@' and lng = '%@' ",latitude,longitude];
	FMResultSet *rs = [db executeQuery:sql];
    
    if([rs next]){
        obj = [[[OffsetData alloc] init] autorelease];
        obj.latitude = [rs objectForColumnName:@"lat"];
        obj.longitude = [rs objectForColumnName:@"lng"];
        obj.offsetLatitude = [rs doubleForColumn:@"offsetlat"];
        obj.offsetLongitude = [rs doubleForColumn:@"offsetlng"];
    }
	
	[rs close];
    
    return obj;
}

@end
