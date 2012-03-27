//
//  YCAnnotationView.m
//  iArrived
//
//  Created by li shiyong on 10-10-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "YCAnnotation.h"
#import "YCRemoveMinusButton.h"
#import "YCPinAnnotationView.h"
#import "YCMoveInButton.h"


@implementation YCPinAnnotationView
@synthesize delegate;
@synthesize ycPinColor;
@synthesize calloutViewEditing;
@synthesize canEditCalloutTitle;


#pragma mark -
#pragma mark Utility
- (void)setTitleCalloutTextFieldShow:(BOOL)isShow{
	
	CGFloat titleX = titleLabel.frame.origin.x - 4.0;
	CGFloat titleY = titleLabel.frame.origin.y - 0.0;
	CGFloat titleW = titleLabel.frame.size.width + 8.0;
	CGFloat titleH = titleLabel.frame.size.height + 0.0;
	
	if ([(YCAnnotation*)self.annotation subtitle] == nil) {
		titleY -= 4.0;
		titleH += 8.0;
	}
	
	titleCalloutTextField.frame = CGRectMake(titleX, titleY, titleW, titleH);
	
	
	titleCalloutTextField.text = nil;
	titleCalloutTextField.placeholder = nil;
	titleCalloutTextField.borderStyle = UITextBorderStyleBezel;
	titleCalloutTextField.hidden = !isShow;
	self.leftCalloutAccessoryView.hidden = NO;
	self.rightCalloutAccessoryView.hidden = NO;

	if (titleCalloutTextField.superview == nil)
		[self->calloutView addSubview:titleCalloutTextField];	
	
	
}

#pragma mark -
#pragma mark property
- (void)setCalloutViewEditing:(BOOL)isEditing{
	
	if (calloutViewEditing == isEditing)//免得做无用功，出现界面闪烁
		return;
	
	if (isEditing) {
		
		//把正常模式的按钮存储起来
		[self->leftNormalCalloutAccessoryView release];
		[self->rightNormalCalloutAccessoryView release];
		self->leftNormalCalloutAccessoryView = [self.leftCalloutAccessoryView retain];
		self->rightNormalCalloutAccessoryView = (YCButton*)[self.rightCalloutAccessoryView retain];

		//先赋值nil，可以显示按钮转换动画效果
		self.leftCalloutAccessoryView = nil;  
		self.rightCalloutAccessoryView = nil;
		
		[(YCMoveInButton*)self->rightDeleteCalloutAccessoryView setHidden:YES animated:NO]; //先隐藏了
		self.rightCalloutAccessoryView = self->rightDeleteCalloutAccessoryView;
		[(YCRemoveMinusButton*)self->leftMinusAndVerticalLineCalloutAccessoryView switchOpenStatus:NO]; //如果是打开状态，先关闭了
		self.leftCalloutAccessoryView = self->leftMinusAndVerticalLineCalloutAccessoryView;
		
		//////////////////////////////
		//编辑title使用
		
		//设置title编辑框
		if (self.canEditCalloutTitle) 
			[self setTitleCalloutTextFieldShow:self.canEditCalloutTitle];
		
		//////////////////////////////

		
	}else {
		//先赋值nil，可以显示按钮转换动画效果
		self.leftCalloutAccessoryView = nil;  
		self.rightCalloutAccessoryView = nil;
		
		self.leftCalloutAccessoryView = self->leftNormalCalloutAccessoryView;
		self.rightCalloutAccessoryView = self->rightNormalCalloutAccessoryView;
		
		//////////////////////////////
		//设置title编辑框
		
		//设置title编辑框：非编辑模式下，title编辑框一定不显示
		if (self.canEditCalloutTitle) 
			[self setTitleCalloutTextFieldShow:NO];
		
		//////////////////////////////
	}

	
	calloutViewEditing = isEditing;
	
	if ([self.delegate respondsToSelector:@selector(annotationView:didChangeEditingStatus:)]) {
		[self.delegate annotationView:self didChangeEditingStatus:isEditing];
	}
	 
}

- (BOOL)titleEditing{
	return [titleCalloutTextField isFirstResponder];
}

#pragma mark -
#pragma mark pin color
/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesBegan:touches withEvent:event];
	if (calloutViewEditing) return;
	if (self.ycPinColor == YCPinAnnotationColorGray)
		self.image = [UIImage imageNamed:@"IAMapPinGray.png"];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesMoved:touches withEvent:event];
	if (calloutViewEditing) return;
	if (self.ycPinColor == YCPinAnnotationColorGray)
		self.image = [UIImage imageNamed:@"IAMapPinGray.png"];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesEnded:touches withEvent:event];
	if (calloutViewEditing) return;
	if (self.ycPinColor == YCPinAnnotationColorGray)
		self.image = [UIImage imageNamed:@"IAMapPinGray.png"];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesCancelled:touches withEvent:event];
	if (calloutViewEditing) return;
	if (self.ycPinColor == YCPinAnnotationColorGray)
		self.image = [UIImage imageNamed:@"IAMapPinGray.png"];	
}
 */
 


//为了对付GrayPin长按颜色转不过来
- (void)updatePinColor{
	if (self.ycPinColor == YCPinAnnotationColorGray){
		//pin image
		self.image = [UIImage imageNamed:@"IAMapPinGray.png"];

	}
}

#pragma mark -
#pragma mark button in calloutView 

- (void)minusButtonpressed:(id)sender{
	if (leftMinusAndVerticalLineCalloutAccessoryView.isOpen) {
		[leftMinusAndVerticalLineCalloutAccessoryView switchOpenStatus:NO];
		[rightDeleteCalloutAccessoryView setHidden:YES animated:YES];
	}else {
		[leftMinusAndVerticalLineCalloutAccessoryView switchOpenStatus:YES];
		[rightDeleteCalloutAccessoryView setHidden:NO animated:YES];
	}
	
}


- (void)deleteButtonpressed:(id)sender{
	if ([self.delegate respondsToSelector:@selector(annotationView:didPressDeleteButton:)]) {
		[self.delegate annotationView:self didPressDeleteButton:rightDeleteCalloutAccessoryView];
	}
}


//////////////////////////////
//编辑title使用

- (void)titleCalloutTextFieldDoneEditing:(id)sender{
	//NSLog(@"titleCalloutTextFieldDoneEditing");
	//不绑定这个函数，点Done竟然不能隐藏键盘。不明白
}
 
 


- (void)titleCalloutTextFieldEndEditing:(id)sender{
	
	NSString *newTitle = self->titleCalloutTextField.text; //TODO 去空格
	NSString *oldTitle = self.annotation.title;
	BOOL isChanged = ![newTitle isEqualToString:oldTitle];
	if ([newTitle length] > 0 && isChanged) 
		[(YCAnnotation*)self.annotation setTitle:newTitle];
	
	if ([self.delegate respondsToSelector:@selector(annotationView:didEndTitleEditing:)]) {		
		[self.delegate annotationView:self didEndTitleEditing:isChanged];
	}
	
	
	//设置title编辑框
	[self setTitleCalloutTextFieldShow:YES];
}

- (void)titleCalloutTextFieldBeginEditing:(id)sender{
	
	CGFloat titleX = 13.0;
	CGFloat titleY = 8.0;
	CGFloat titleW = self->calloutView.frame.size.width - titleX*2;
	CGFloat titleH = self->calloutView.frame.size.height - 39.0;
	titleCalloutTextField.frame = CGRectMake(titleX, titleY, titleW, titleH);

	titleCalloutTextField.borderStyle = UITextBorderStyleRoundedRect;
	titleCalloutTextField.font = [UIFont boldSystemFontOfSize:16];
	titleCalloutTextField.textColor = [UIColor darkTextColor];
	
	titleCalloutTextField.text = titleLabel.text;
	titleCalloutTextField.placeholder = titleLabel.text;
	
	self.leftCalloutAccessoryView.hidden = YES;
	self.rightCalloutAccessoryView.hidden = YES;
		
}


#pragma mark -
#pragma mark override super method



//为了让setSelected:animated中延时调用：下一次消息中calloutView才能生成
- (void)whenPinViewSelected{
	
	//找到callout
	NSArray *subArray =[self subviews];
	for (UIView *subView in subArray) {
		NSString *className = NSStringFromClass([subView class]) ;
		if ([className isEqualToString:@"UICalloutView"]){
			[self->calloutView release];
			self->calloutView = [subView retain];
			break;
		}
	}
	
	//找到titleLabel
	NSArray *array = [self->calloutView subviews];
	for (UIView *aView in array) {
		CGRect aViewFrame = aView.frame;
		if ([aView isKindOfClass:[UILabel class]] && aViewFrame.origin.y > 0.0 && aViewFrame.origin.y<15.0){
			[self->titleLabel release];
			self->titleLabel = [(UILabel*)aView retain];
			
			//设置titleLabel的最小的最小字号
			self->titleLabel.minimumFontSize = 14;
			self->titleLabel.adjustsFontSizeToFitWidth = YES;
			
			break;
		}
	}
	
	if (self.calloutViewEditing && self.canEditCalloutTitle) {
		[self setTitleCalloutTextFieldShow:self.canEditCalloutTitle];
	}
	
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
	[super setSelected:selected animated:animated];
	
	if (selected)
		[self performSelector:@selector(whenPinViewSelected) withObject:nil afterDelay:0.0];
	else 
		[titleCalloutTextField removeFromSuperview];

}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
	
	if (self.ycPinColor == YCPinAnnotationColorGray)
		self.image = [UIImage imageNamed:@"IAMapPinGray.png"];
	
	if (self.calloutViewEditing && self.canEditCalloutTitle){ 
		CGRect titleCalloutViewFrame = [self convertRect:titleCalloutTextField.frame fromView:calloutView];
		BOOL touchInCalloutView = CGRectContainsPoint(titleCalloutViewFrame,point);
		
		if (touchInCalloutView) {
			return titleCalloutTextField; //如果点的在编辑框范围内
		}else {
			[titleCalloutTextField resignFirstResponder]; //如果点的不在编辑框范围内，则编辑框失去焦点
			return [super hitTest:point withEvent:event];
		}
	}else {
		return [super hitTest:point withEvent:event];
	}


}
 

//编辑title使用
//////////////////////////////


#pragma mark -
#pragma mark init and dealloc
- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{	
	self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	if (self) {
		leftMinusAndVerticalLineCalloutAccessoryView = [[YCRemoveMinusButton alloc] init];
		rightDeleteCalloutAccessoryView = [[YCMoveInButton alloc] init];
		[leftMinusAndVerticalLineCalloutAccessoryView addTarget:self action:@selector(minusButtonpressed:) forControlEvents:UIControlEventTouchUpInside];
		[rightDeleteCalloutAccessoryView addTarget:self action:@selector(deleteButtonpressed:) forControlEvents:UIControlEventTouchUpInside];

		
		//////////////////////////////
		//编辑title使用
		
		titleCalloutTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
		titleCalloutTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		titleCalloutTextField.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
		titleCalloutTextField.returnKeyType =  UIReturnKeyDone;
		titleCalloutTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
		[titleCalloutTextField addTarget:self action:@selector(titleCalloutTextFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
		[titleCalloutTextField addTarget:self action:@selector(titleCalloutTextFieldEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
		[titleCalloutTextField addTarget:self action:@selector(titleCalloutTextFieldBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
		
		
		titleCalloutTextField.borderStyle = UITextBorderStyleBezel;
		titleCalloutTextField.font = [UIFont boldSystemFontOfSize:14];
		titleCalloutTextField.textColor = [UIColor whiteColor];
		
		//////////////////////////////
			
		if ([annotation isKindOfClass:[YCAnnotation class]]) {
			if (YCMapAnnotationTypeDisabled == ((YCAnnotation*)annotation).annotationType){
				ycPinColor = YCPinAnnotationColorGray;
				self.image = [UIImage imageNamed:@"IAMapPinGray.png"];	
			}else {
				ycPinColor = YCPinAnnotationColorNone;
			}
			
		}
		
	}
	return self;
}

- (void)dealloc 
{
	[leftNormalCalloutAccessoryView release];
	[rightNormalCalloutAccessoryView release];
	[leftMinusAndVerticalLineCalloutAccessoryView release];
	[rightDeleteCalloutAccessoryView release];
	[titleCalloutTextField release];
	[super dealloc];
	
}




@end
