//
//  YCTextView.m
//  iAlarm
//
//  Created by li shiyong on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCTextView.h"

@interface YCTextView()

@property (nonatomic,readonly) UITextField *textField;
- (void)updatePlaceholder;

@end

@implementation YCTextView
@synthesize placeholder;

- (void)updatePlaceholder{
    if (![self hasText]) {
        self.textField.placeholder = self.placeholder;
    }else{
        self.textField.placeholder = nil;
    }
}

- (id)textField{
    if (textField == nil) {
        CGRect frame = CGRectMake(7.0, 7.0, self.frame.size.width, 31.0);
        textField = [[UITextField alloc] initWithFrame:frame];
        textField.font = self.font;
        textField.userInteractionEnabled = NO;
        //自动调整字号
        textField.adjustsFontSizeToFitWidth = YES;
        textField.minimumFontSize = 10.0;
    }
    return textField;
}

- (void)setPlaceholder:(NSString *)thePlaceholder{
    [placeholder release];
    placeholder = [thePlaceholder copy];
    [self updatePlaceholder];
}

- (void)handleTextViewTextDidChange:(id)notification{	
    [self updatePlaceholder];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
		
	if ([keyPath isEqualToString:@"text"]) { 
        [self updatePlaceholder];
	}
}

- (void)registerNotifications {
		
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	[notificationCenter addObserver: self
						   selector: @selector (handleTextViewTextDidChange:)
							   name: UITextViewTextDidChangeNotification
							 object: self];
    [self addObserver:self forKeyPath:@"text" options:0 context:nil];

}

- (void)unRegisterNotifications {
	
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
	[notificationCenter removeObserver:self	name:UITextViewTextDidChangeNotification object: self];
    [self removeObserver:self forKeyPath:@"text"];

}


- (id)initWithFrame:(CGRect)aRect{
    self = [super initWithFrame:aRect];
    if (self) {
        [self addSubview:self.textField];
        [self registerNotifications];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addSubview:self.textField];
        [self registerNotifications];
    }
    return self;
}

- (void)setFont:(UIFont *)font{
    [super setFont:font];
    //placeholder的字体与textView相同
    self.textField.font = font;
}

/*
- (void)awakeFromNib{
    [self registerNotifications];
    [self addSubview:self.textField];
}
 */

- (void)dealloc{
    [self unRegisterNotifications];
    [placeholder release];
    [textField release];
    [super dealloc];
}

@end
