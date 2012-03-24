//
//  YCButton.h
//  iAlarm
//
//  Created by li shiyong on 11-2-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YCButton : UIButton {
	NSString *identifier;    //标志号
	UIButton *typeButton;    //通过buttonWithType创建的按钮
}

@property(nonatomic,retain) NSString *identifier;    //标志号
@property(nonatomic,retain) UIButton *typeButton;

@end
