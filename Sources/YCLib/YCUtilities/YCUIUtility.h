//
//  YCUIUtility.h
//  iAlarm
//
//  Created by li shiyong on 11-3-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YCUIUtility : NSObject {

}

@end


//返回指定文本需要的宽 －单行
CGFloat textLabelWidth(NSString*text, UIFont* font);
//返回指定文本需要的高 －多行
CGFloat textLabelHeigth(NSString*text, UIFont* font,CGFloat maxWidth);