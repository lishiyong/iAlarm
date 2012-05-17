//
//  YCTexturedButton.h
//  iAlarm
//
//  Created by li shiyong on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCTexturedButton : UIButton{
    @package
    UIImageView *_newBackgroundView; //因为需要得到背景视图的指针，来指定拉伸属性，所以重新做背景。
}

@end
