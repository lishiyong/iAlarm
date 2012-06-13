//
//  YCGeometry.h
//  iAlarm
//
//  Created by li shiyong on 12-6-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 通过中心点创建CGRect
 **/
CGRect YCRectMakeWithCenter(CGPoint center,CGSize size);

/**
 通过左下点创建CGRect
 **/
CGRect YCRectMakeWithLeftBottom(CGPoint leftBottom,CGSize size);


/**
 返回CGRect的中心点
 **/
CGPoint YCRectCenter(CGRect rect);

/**
 按比例缩放Point
 **/
//CGPoint YCPointWithScale(CGPoint point, CGFloat scale);

/**
 按比例缩放Size
 **/
CGSize YCSizeWithScale(CGSize size, CGFloat scale);

/**
 按比例缩放Rect
 **/
//CGRect YCRectWithScale(CGRect rect, CGFloat scale);

