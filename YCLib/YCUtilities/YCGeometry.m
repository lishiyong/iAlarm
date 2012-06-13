//
//  YCGeometry.m
//  iAlarm
//
//  Created by li shiyong on 12-6-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCGeometry.h"

CGRect YCRectMakeWithCenter(CGPoint center,CGSize size){
    CGRect rect = {center,size};
    CGFloat w = size.width;
    CGFloat h = size.height;
    
    CGRect rectOffseted = CGRectOffset(rect, -w/2, -h/2);
    
    return rectOffseted;
}

CGRect YCRectMakeWithLeftBottom(CGPoint leftBottom,CGSize size){
    CGPoint origin = {leftBottom.x, leftBottom.y - size.height};
    CGRect rect = {origin,size};
    return rect;
}

CGPoint YCRectCenter(CGRect rect){
    CGFloat x = rect.origin.x + rect.size.width/2;
    CGFloat y = rect.origin.y + rect.size.height/2;
    
    CGPoint center = {x,y};
    return center;
}

CGPoint YCPointWithScale(CGPoint point, CGFloat scale){
    CGPoint newPoint = {point.x * scale, point.y * scale};
    return newPoint;
}

CGSize YCSizeWithScale(CGSize size, CGFloat scale){
    CGSize newSize = {size.width * scale, size.height * scale};
    return newSize;
}

CGRect YCRectWithScale(CGRect rect, CGFloat scale){
    CGPoint newPoint = YCPointWithScale(rect.origin, scale);
    CGSize newSize = YCSizeWithScale(rect.size,scale);
    CGRect newRect = {newPoint,newSize};
    return newRect;
}

