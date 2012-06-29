//
//  UIColor+YC.m
//  iAlarm
//
//  Created by li shiyong on 12-4-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIColor+YC.h"

@implementation UIColor (YC)

- (UIColor *)initWithIntRed:(NSInteger)intRed intGreen:(NSInteger)intGreen intBlue:(NSInteger)intBlue intAlpha:(NSInteger)intAlpha{
    return [self initWithRed:intRed/255.0f green:intGreen/255.0f blue:intBlue/255.0f alpha:intAlpha/255.0];
}

+ (UIColor *)colorWithIntRed:(NSInteger)intRed intGreen:(NSInteger)intGreen intBlue:(NSInteger)intBlue intAlpha:(NSInteger)intAlpha{
    return [[[UIColor alloc] initWithIntRed:intRed intGreen:intGreen intBlue:intBlue intAlpha:intAlpha] autorelease];
}

+ (UIColor *)darkBackgroundColor{
    return [UIColor colorWithRed:151.0/255.0 green:152.0/255.0 blue:155.0/255.0 alpha:1.0];
}

+ (UIColor *)lightBackgroundColor{
    return [UIColor colorWithRed:172.0/255.0 green:173.0/255.0 blue:175.0/255.0 alpha:1.0];
}

+ (UIColor *)tableCellBlueTextYCColor{
    return [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
}

+ (UIColor *)tableViewFooterTextColor{
    return [UIColor colorWithRed:76.0/255.0 green:86.0/255.0 blue:108.0/255.0 alpha:1.0];
}

+ (UIColor *)tableViewFooter2TextColor{
    return [UIColor colorWithRed:37.0/255.0 green:50.0/255.0 blue:67.0/255.0 alpha:1.0];
}

+ (UIColor *)textShadowColor{
    return [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
}

+ (UIColor *)texturedButtonGradientColor{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"YCTexturedButtonTextGradient.png"]];
}

+ (UIColor *)texturedButtonGradientSmallColor{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"YCTexturedButtonTextGradientSmall.png"]];
}

+ (UIColor *)mapsMaskColor{
    return [UIColor colorWithIntRed:179 intGreen:177 intBlue:173 intAlpha:255];
}

+ (UIColor *)tableCellGrayTextYCColor{
    return [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
}

@end
