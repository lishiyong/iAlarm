//
//  MessageBody.h
//  TestShareApp
//
//  Created by li shiyong on 11-8-7.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MessageBodyCell : UITableViewCell<UIScrollViewDelegate> {
	IBOutlet UITextView *textView;
	IBOutlet UIImageView *imageView;
}

@property(nonatomic, retain) IBOutlet UITextView *textView;
@property(nonatomic, retain) IBOutlet UIImageView *imageView;


+ (id)viewWithXib;


@end
