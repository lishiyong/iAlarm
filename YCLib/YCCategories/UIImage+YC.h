//
//  UIImage+YC.h
//  iAlarm
//
//  Created by li shiyong on 12-6-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YC)

/**
 从整个图中截取一部分
 **/
- (UIImage*)imageWithRect:(CGRect)rect;

/**
 覆盖上另一个图
 **/
- (UIImage*)imageOverrideWihtAnotherImage:(UIImage*)anotherImage;

@end
