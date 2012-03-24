
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>



extern const CLLocationDistance kMiddleAccuracyThreshold   ;                    //中等精度阀值
extern const CLLocationDistance kHighAccuracyThreshold     ;                    //高效精度阀值
extern const CLLocationDistance kLowAccuracyThreshold      ;                    //低等精度阀值

extern const CLLocationDistance kPreAlarmDistance         ;                     //预警圈增加的距离
extern const CLLocationDistance kBigPreAlarmDistance      ;                     //预警圈增加的距离


//”当前位置与区域的距离“与”区域半径“的比率阀值。在没有高精度数据的情况下，大于这个值的的当前位置数据才有效
extern const double kDistanceRadiusRateWhenLowAccuracyThreshold;
//”区域半径“与”位置数据的精度“的比率阀值。在没有高精度数据的情况下，大于这个值的的当前位置数据才有效
extern const double kRadiusAccuracyRateWhenLowAccuracyThreshold; 

extern const CLLocationDistance kMixAlarmRadius;                                 //最小闹钟半径


