//
//  UIColor+YC.m
//  iAlarm
//
//  Created by li shiyong on 12-4-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIColor+YC.h"

@implementation UIColor (YC)

+ (UIColor *)darkBackgroundColor{
    return [UIColor colorWithRed:151.0/255.0 green:152.0/255.0 blue:155.0/255.0 alpha:1.0];
}

+ (UIColor *)lightBackgroundColor{
    return [UIColor colorWithRed:172.0/255.0 green:173.0/255.0 blue:175.0/255.0 alpha:1.0];
}

+ (UIColor *)textColor{
    return [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
}

+ (UIColor *)text1Color{
    return [UIColor colorWithRed:76.0/255.0 green:86.0/255.0 blue:108.0/255.0 alpha:1.0];
}

+ (UIColor *)text2Color{
    return [UIColor colorWithRed:37.0/255.0 green:50.0/255.0 blue:67.0/255.0 alpha:1.0];
}

+ (UIColor *)shadowColor{
    return [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
}

+ (UIColor *)texturedButtonGradientColor{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"YCTexturedButtonTextGradient.png"]];
}

+ (UIColor *)texturedButtonGradientSmallColor{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"YCTexturedButtonTextGradientSmall.png"]];
}


@end
