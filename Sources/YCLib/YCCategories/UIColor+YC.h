//
//  UIColor+YC.h
//  iAlarm
//
//  Created by li shiyong on 12-4-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (YC)


// 151.0/255.0, 152.0/255.0, 155.0/255.0 RGB
+ (UIColor *)darkBackgroundColor; 
// 172.0/255.0, 173.0/255.0, 175.0/255.0 RGB
+ (UIColor *)lightBackgroundColor;        

// cell详细文本的默认颜色
+ (UIColor *)textColor;

// 用于默认groudTableView的footer或header
// 76.0/255.0,  86.0/255.0,  108.0/255.0 RGB
+ (UIColor *)text1Color; 

// 用于灰背景的 groudTableView的footer或header
// 37.0/255.0,  50.0/255.0,  67.0/255.0 RGB
+ (UIColor *)text2Color; 


// 用于灰背景的文本阴影的颜色
// 200.0/255.0,  200.0/255.0,  200.0/255.0 RGB
+ (UIColor *)shadowColor; 

@end
