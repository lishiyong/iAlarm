//
//  AlarmListNotification.m
//  iAlarm
//
//  Created by li shiyong on 11-2-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IAGlobal.h"

/*
const CLLocationDistance kMiddleAccuracyThreshold   =  751.0;                    //中等精度阀值
const CLLocationDistance kHighAccuracyThreshold     =  181.0;                    //高效精度阀值
const CLLocationDistance kLowAccuracyThreshold      = 1201.0;                    //低等精度阀值
 */

const CLLocationDistance kMiddleAccuracyThreshold   =  1850.0;                    //中等精度阀值
const CLLocationDistance kHighAccuracyThreshold     =  581.0;                    //高效精度阀值
const CLLocationDistance kLowAccuracyThreshold      = 5001.0;                    //低等精度阀值

const CLLocationDistance kPreAlarmDistance          = 1500.0;                    //预警圈增加的距离
const CLLocationDistance kBigPreAlarmDistance       = 6000.0;                    //大预警圈增加的距离


//”当前位置与区域的距离“与”区域半径“的比率阀值。在没有高精度数据的情况下，大于这个值的的当前位置数据才有效。值越高，要求准度度越高
const double kDistanceRadiusRateWhenLowAccuracyThreshold = 5.0;//10.0;
//”区域半径“与”位置数据的精度“的比率阀值。在没有高精度数据的情况下，大于这个值的的当前位置数据才有效。值越高，要求准度度越高
const double kRadiusAccuracyRateWhenLowAccuracyThreshold = 5.0;//10.0; 


const CLLocationDistance kMixAlarmRadius            = 100.0;                     //最小闹钟半径
