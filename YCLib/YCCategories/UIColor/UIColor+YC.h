//
//  UIColor+YC.h
//  iAlarm
//
//  Created by li shiyong on 12-4-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (YC)

/**
 255做被除数
 **/
- (UIColor *)initWithIntRed:(NSInteger)intRed intGreen:(NSInteger)intGreen intBlue:(NSInteger)intBlue intAlpha:(NSInteger)intAlpha;
+ (UIColor *)colorWithIntRed:(NSInteger)intRed intGreen:(NSInteger)intGreen intBlue:(NSInteger)intBlue intAlpha:(NSInteger)intAlpha;


// 151.0/255.0, 152.0/255.0, 155.0/255.0 RGB
+ (UIColor *)darkBackgroundColor; 
// 172.0/255.0, 173.0/255.0, 175.0/255.0 RGB
+ (UIColor *)lightBackgroundColor;        

// 用于默认groudTableView的footer或header
// 76.0/255.0,  86.0/255.0,  108.0/255.0 RGB
+ (UIColor *)tableViewFooterTextColor; 

// 用于灰背景的 groudTableView的footer或header
// 37.0/255.0,  50.0/255.0,  67.0/255.0 RGB
+ (UIColor *)tableViewFooter2TextColor; 


// 用于灰背景的文本阴影的颜色
// 200.0/255.0,  200.0/255.0,  200.0/255.0 RGB
+ (UIColor *)textShadowColor; 

/**
 来自YCTexturedButtonTextGradient.png
 **/
+ (UIColor *)texturedButtonGradientColor;

/**
 来自YCTexturedButtonTextGradientSmall.png
 **/
+ (UIColor *)texturedButtonGradientSmallColor; 

/**
 地图没有打开时候显示的view的颜色
 **/
+ (UIColor *)mapsMaskColor;

/**
 源于未文档颜色：tableCellGrayTextColor
 0.50, 0.50, 0.50
 **/
+ (UIColor *)tableCellGrayTextYCColor;

// cell详细文本的默认颜色
/**
 源于未文档颜色：tableCellBlueTextColor
 0.22, 0.33, 0.53
 **/
+ (UIColor *)tableCellBlueTextYCColor;


/**
 背景图片颜色均匀，不能用做图案颜色
 ipad groupTableViewBackgroundColor
 来自YCiPadGroupTableViewBackgroundColor.png
 **/
//+ (UIColor *)iPadGroupTableViewBackgroundColor;

/**
 源于未文档颜色：tableCellGroupedBackgroundColor(ipad)
 0.97, 0.97, 0.97, 1
 **/
+ (UIColor *)iPadTableCellGroupedBackgroundColor;


/**
 BackgroundView of tableView 背景色
 92, 99, 103, 255
 **/
+ (UIColor *)tableViewBackgroundViewBackgroundColor;

/**
 源于未文档颜色：underPageBackgroundColor
 **/
+ (UIColor *)underPageBackgroundYCColor;


/**
 对groupTableViewBackgroundColor的补充
 来自YCGroupTableViewBackgroundColor1.png
 **/
+ (UIColor *)groupTableViewBackgroundColor1;

/**
 UISwitch 的蓝色
 0, 127, 234, 255
 **/
+ (UIColor *)switchBlue;

@end
