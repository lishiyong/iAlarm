/*
 *  ShareAppConfig.h
 *  iAlarm
 *
 *  Created by li shiyong on 11-9-14.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef FULL_VERSION
static NSString *kAppStoreAppID = @"427929181"; //Lite
#else
static NSString *kAppStoreAppID = @"468639288"; //Full
#endif

//启动程序多少次，才有rate
#define kLetOneVisibleBecomeActiveNumber 2
