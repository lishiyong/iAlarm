//
//  IAAlarmsManager.h
//  iAlarm
//
//  Created by li shiyong on 12-5-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IASaveInfo;
@interface IAAlarmsManager : NSObject

//发送save通知
- (void)sendSaveNotificationWithInfo:(IASaveInfo*)saveInfo fromSender:(id)sender;
//保存闹钟,不发通知
- (IASaveInfo*)save;
//保存闹钟
- (void)saveFromSender:(id)sender;
//删除
- (void)deleteFromSender:(id)sender;
//发送通知更新所有关联视图
- (void)sendNotifyToUpdateAllViewsFromSender:(id)sender;


//根据Id找到闹钟
+ (id)findForAlarmId:(NSString*)theAlarmId;
//取得所有闹钟的列表
+ (NSArray*)alarmArray;

+ (IAAlarmsManager*)sharedIAAlarmsManager;

@end
