//
//  YCMapPointAnnotation.m
//  iAlarm
//
//  Created by li shiyong on 12-4-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCLocationManager.h"
#import "YCMapPointAnnotation.h"

@implementation YCMapPointAnnotation
@synthesize coordinate = _visualCoordinate, title, subtitle, realCoordinate = _realCoordinate;

-(id) initWithCoordinate:(CLLocationCoordinate2D) coord title:(NSString *) theTitle subTitle:(NSString *) theSubTitle{
    return [self initWithCoordinate:coord title:theTitle subTitle:theSubTitle addressDictionary:nil];
}

-(id) initWithCoordinate:(CLLocationCoordinate2D) coord title:(NSString *) theTitle subTitle:(NSString *) theSubTitle
       addressDictionary:(NSDictionary *)addressDictionary{
    self = [super initWithCoordinate:coord addressDictionary:addressDictionary];
    if (self) {
        _visualCoordinate = coord;
        title = [theTitle copy];
        subtitle = [theSubTitle copy];
        distanceFromCurrentLocation = -1.0; //小于0，表示未初始化
        _realCoordinate = kCLLocationCoordinate2DInvalid; //表示未初始化
    }
    return self;
}

/*
- (void)setCoordinate:(CLLocationCoordinate2D)theCoordinate{
    coordinate = theCoordinate;
    realCoordinate = kCLLocationCoordinate2DInvalid; //要重新计算它
}

- (CLLocationCoordinate2D)realCoordinate{
    if (!CLLocationCoordinate2DIsValid(realCoordinate)) {
        if ([[YCLocationManager sharedLocationManager] chinaShiftEnabled] 
            && [[YCLocationManager sharedLocationManager] isInChinaWithCoordinate:self.coordinate]) { //火星坐标
            realCoordinate = [[YCLocationManager sharedLocationManager] convertToCoordinateFromMarsCoordinate:coordinate];
        }else{
            realCoordinate = coordinate;
        }
    }
    return realCoordinate;
}

- (void)setRealCoordinate:(CLLocationCoordinate2D)theRealCoordinate{
    //通过设置coordinate来更新realCoordinate
    if ([[YCLocationManager sharedLocationManager] chinaShiftEnabled] && [[YCLocationManager sharedLocationManager] isInChinaWithCoordinate:theRealCoordinate]) { //开启了转换选项 并且 坐标在中国境内
        
        coordinate = [[YCLocationManager sharedLocationManager] convertToMarsCoordinateFromCoordinate:theRealCoordinate];
        
    }else{
        coordinate = theRealCoordinate;
    }
    
    realCoordinate = theRealCoordinate;
}
 */

- (CLLocationCoordinate2D)coordinate{
    
    if (!CLLocationCoordinate2DIsValid(_visualCoordinate)) {//从真实坐标转换
        if ([[YCLocationManager sharedLocationManager] chinaShiftEnabled] && [[YCLocationManager sharedLocationManager] isInChinaWithCoordinate:_realCoordinate]) { //开启了转换选项 并且 坐标在中国境内
            
            _visualCoordinate = [[YCLocationManager sharedLocationManager] convertToMarsCoordinateFromCoordinate:_realCoordinate];
            
        }else{
            _visualCoordinate = _visualCoordinate;
        }
    }
    
    return _visualCoordinate;
}

- (CLLocationCoordinate2D)realCoordinatee{
    
    if (!CLLocationCoordinate2DIsValid(_realCoordinate)) {//从虚拟坐标转换
        if ([[YCLocationManager sharedLocationManager] chinaShiftEnabled] && [[YCLocationManager sharedLocationManager] isInChinaWithCoordinate:_visualCoordinate]) { //开启了转换选项 并且 坐标在中国境内
            
            _realCoordinate = [[YCLocationManager sharedLocationManager] convertToCoordinateFromMarsCoordinate:_visualCoordinate];
            
        }else{
            _realCoordinate = _visualCoordinate;
        }
    }
    
    return _realCoordinate;
    
}

- (void)setRealCoordinate:(CLLocationCoordinate2D)theRealCoordinate{
    _realCoordinate = theRealCoordinate;
    [self setVisualCoordinateWithRealCoordinate:_realCoordinate]; //计算虚拟坐标
}

- (void)setCoordinate:(CLLocationCoordinate2D)theVisualCoordinate{
    _visualCoordinate = theVisualCoordinate;
    [self setRealCoordinateWithVisualCoordinate:_visualCoordinate]; //计算真实坐标
}



- (void)setRealCoordinateWithVisualCoordinate:(CLLocationCoordinate2D)theVisualCoordinate{
    
    if ([[YCLocationManager sharedLocationManager] chinaShiftEnabled] && [[YCLocationManager sharedLocationManager] isInChinaWithCoordinate:theVisualCoordinate]) { //开启了转换选项 并且 坐标在中国境内
        
        _realCoordinate = [[YCLocationManager sharedLocationManager] convertToCoordinateFromMarsCoordinate:theVisualCoordinate];
        
    }else{
        _realCoordinate = theVisualCoordinate;
    }
    
}

- (void)setVisualCoordinateWithRealCoordinate:(CLLocationCoordinate2D)theRealCoordinate{
    
    if ([[YCLocationManager sharedLocationManager] chinaShiftEnabled] && [[YCLocationManager sharedLocationManager] isInChinaWithCoordinate:theRealCoordinate]) { //开启了转换选项 并且 坐标在中国境内
        
        _visualCoordinate = [[YCLocationManager sharedLocationManager] convertToMarsCoordinateFromCoordinate:theRealCoordinate];
        
    }else{
        _visualCoordinate = theRealCoordinate;
    }
    
}


- (void)dealloc{
    [title release];
    [subtitle release];
    [super dealloc];
}

@end