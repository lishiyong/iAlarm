//
//  YCTextView.h
//  
//   为UITextView类增加了 placeholder属性
//
//  Created by li shiyong on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCTextView : UITextView{
    UITextField *textField;
    NSString *placeholder;
}

@property(nonatomic,copy) NSString *placeholder;

@end
