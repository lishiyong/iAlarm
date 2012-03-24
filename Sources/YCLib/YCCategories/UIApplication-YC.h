//
//  UIApplication-YC.h
//  iAlarm
//
//  Created by li shiyong on 11-3-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIApplication (YC)


@property(nonatomic,readonly) NSString* documentsDirectory;     // ~ Documents
@property(nonatomic,readonly) NSString* libraryDirectory;       // ~ Library


@property(nonatomic,readonly) NSDate *applicationDidFinishLaunchingTime;                       //程序启动的时间
@property(nonatomic,readonly) NSTimeInterval applicationDidFinishLaunchineTimeElapsing;       //程序启动后度过的世纪



 
@end
