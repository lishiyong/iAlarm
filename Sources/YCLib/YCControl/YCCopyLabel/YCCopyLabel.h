//
//  YCCopyMenuLabel.h
//  TestResponder
//
//  Created by 李世勇 on 12-4-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCCopyLabel : UILabel{
    UITapGestureRecognizer       *tapGesture;
    UILongPressGestureRecognizer *longGesture;
}

@end
