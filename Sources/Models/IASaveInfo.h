//
//  IAAlarmSaveType.h
//  iAlarm
//
//  Created by li shiyong on 11-2-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//
extern NSString *IASaveInfoKey;

enum {
    IASaveTypeAdd = 0,        
	IASaveTypeUpdate,
	IASaveTypeDelete
};
typedef NSUInteger IASaveType;

@interface IASaveInfo : NSObject {
	NSString *objId;
	IASaveType saveType;
}

@property (nonatomic,retain) NSString *objId;
@property (nonatomic,assign) IASaveType saveType;


@end
