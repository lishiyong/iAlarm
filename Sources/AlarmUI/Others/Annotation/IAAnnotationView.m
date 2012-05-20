//
//  IAAnnotationView.m
//  iArrived
//
//  Created by li shiyong on 10-10-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IAAlarm.h"
#import "IAAnnotation.h"
#import "YCRemoveMinusButton.h"
#import "IAAnnotationView.h"
#import "YCMoveInButton.h"


@implementation IAAnnotationView

#pragma mark - property
@synthesize delegate, editing, editingForKVO;

- (void)setEditing:(BOOL)isEditing{
    [self setEditing:isEditing animated:NO];
    self.editingForKVO = isEditing;
}

- (void)setEditing:(BOOL)isEditing animated:(BOOL)animated{
    self.editingForKVO = isEditing;

    if (editing == isEditing)
		return;
	
	if (animated) {
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView animateWithDuration:0.5 animations:^{
            minusButton.alpha = isEditing ? 1.0: 0.0;
            deleteButton.alpha = isEditing ? 1.0: 0.0;
            flagImageView.alpha = isEditing ? 0.0: 1.0;
            detailButton.alpha = isEditing ? 0.0: 1.0;
            self.pinColor = isEditing ? MKPinAnnotationColorPurple : MKPinAnnotationColorRed;
            
            self.rightCalloutAccessoryView = nil; //titleLable 可以自动拉伸
            self.leftCalloutAccessoryView = nil;
        }completion:^(BOOL finished){
            if (!isEditing) {
                [minusButton switchOpenStatus:NO];
                [deleteButton setHidden:YES animated:NO];
            }
            self.rightCalloutAccessoryView = rightView;
            self.leftCalloutAccessoryView = leftView;
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
        
	}else {
        minusButton.alpha = isEditing ? 1.0: 0.0;
        deleteButton.alpha = isEditing ? 1.0: 0.0;;
        flagImageView.alpha = isEditing ? 0.0: 1.0;;
        detailButton.alpha = isEditing ? 0.0: 1.0;;
        self.pinColor = isEditing ? MKPinAnnotationColorPurple : MKPinAnnotationColorRed;
        if (!isEditing) {
            [minusButton switchOpenStatus:NO];
            [deleteButton setHidden:YES animated:NO];
        }
    }    
    
	editing = isEditing;
	if ([self.delegate respondsToSelector:@selector(annotationView:didChangeEditingStatus:)]) {
		[self.delegate annotationView:self didChangeEditingStatus:isEditing];
	}
    
}


#pragma mark - pin color


- (void)updatePinColor{
	if (![(IAAnnotation*) self.annotation alarm].enabled && self.editing == NO)
		self.image = [UIImage imageNamed:@"IAMapPinGray.png"];
}


#pragma mark -

- (void)minusButtonPressed:(id)sender{
	if (minusButton.isOpen) {
		[minusButton switchOpenStatus:NO];
		[deleteButton setHidden:YES animated:YES];
	}else {
		[minusButton switchOpenStatus:YES];
		[deleteButton setHidden:NO animated:YES];
	}
	
}


- (void)deleteButtonPressed:(id)sender{
	if ([self.delegate respondsToSelector:@selector(annotationView:didPressDeleteButton:)]) {
		[self.delegate annotationView:self didPressDeleteButton:deleteButton];
	}
}
 
- (void)detailButtonPressed:(id)sender{
	if ([self.delegate respondsToSelector:@selector(annotationView:didPressDetailButton:)]) {
		[self.delegate annotationView:self didPressDetailButton:deleteButton];
	}
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
			calloutView = subView;
			break;
		}
	}
	
	//找到titleLabel
	NSArray *array =  [calloutView subviews];
	for (UIView *aView in array) {
		CGRect aViewFrame = aView.frame;
		if ([aView isKindOfClass:[UILabel class]] && aViewFrame.origin.y > 0.0 && aViewFrame.origin.y<15.0){
			titleLabel = (UILabel*)aView;
			
			//设置titleLabel的最小的最小字号
			titleLabel.minimumFontSize = 14;
			titleLabel.adjustsFontSizeToFitWidth = YES;
			
			break;
		}
	}
    	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
	[super setSelected:selected animated:animated];
    [self performSelector:@selector(updatePinColor) withObject:nil afterDelay:1.0];
    if (selected)
		[self performSelector:@selector(whenPinViewSelected) withObject:nil afterDelay:0.1];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self performSelector:@selector(updatePinColor) withObject:nil afterDelay:0.0];
    [self.nextResponder touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self performSelector:@selector(updatePinColor) withObject:nil afterDelay:0.0];
    [self.nextResponder touchesEnded:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [self performSelector:@selector(updatePinColor) withObject:nil afterDelay:0.0];
    [self.nextResponder touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self performSelector:@selector(updatePinColor) withObject:nil afterDelay:0.0];
    [self.nextResponder touchesCancelled:touches withEvent:event];
}
 
#pragma mark -
#pragma mark init and dealloc

- (id)initWithAnnotation:(IAAnnotation*)annotation reuseIdentifier:(NSString *)reuseIdentifier{	
	self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	if (self) {
        static CGFloat kWH = 32;
		leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWH, kWH)];
        rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWH, kWH)];
        leftView.backgroundColor = [UIColor clearColor];
        rightView.backgroundColor = [UIColor clearColor]; 
        self.leftCalloutAccessoryView = leftView;
        self.rightCalloutAccessoryView = rightView;
        
        minusButton = [[YCRemoveMinusButton alloc] init];
		deleteButton = [[YCMoveInButton alloc] init];
        flagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        detailButton = [[UIButton buttonWithType:UIButtonTypeDetailDisclosure] retain];
        [minusButton addTarget:self action:@selector(minusButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[deleteButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [detailButton addTarget:self action:@selector(detailButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        CGPoint leftViewCenter = {leftView.bounds.size.width/2, leftView.bounds.size.height/2} ;
        CGPoint rightViewCenter = {rightView.bounds.size.width/2, rightView.bounds.size.height/2} ;
        minusButton.center = leftViewCenter;
        deleteButton.center = rightViewCenter;
        flagImageView.center = leftViewCenter;
        detailButton.center = rightViewCenter;
        minusButton.alpha = 0;
        deleteButton.alpha = 0;
        
        [leftView addSubview:minusButton];
        [leftView addSubview:flagImageView];
        [rightView addSubview:deleteButton];
        [rightView addSubview:detailButton];
        

        if ([annotation isKindOfClass:[IAAnnotation class]]) {
            IAAlarm *alarm = annotation.alarm;
            NSString *imageName = alarm.alarmRadiusType.alarmRadiusTypeImageName;
            imageName = [NSString stringWithFormat:@"20_%@",imageName]; //使用20像素的图标
            imageName = alarm.enabled ? imageName: @"20_IAFlagGray.png";  //没有启用，使用灰色旗帜
            flagImageView.image = [UIImage imageNamed:imageName];
        }
        
        self.canShowCallout = YES;
        self.animatesDrop = NO;
        self.draggable = NO;
        self.pinColor = MKPinAnnotationColorRed;
        
        [self addObserver:self forKeyPath:@"annotation.alarm.enabled" options:0 context:nil];
        [self addObserver:self forKeyPath:@"selected" options:0 context:nil];
        [self addObserver:self forKeyPath:@"editingForKVO" options:0 context:nil];
        
	}
	return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    [self updatePinColor];
    [self performSelector:@selector(updatePinColor) withObject:nil afterDelay:0.5];
}

- (void)dealloc 
{
    [self removeObserver:self forKeyPath:@"annotation.alarm.enabled"];
    [self removeObserver:self forKeyPath:@"selected"];
    [self removeObserver:self forKeyPath:@"editingForKVO"];
	[leftView release];
    [rightView release];
    [minusButton release];
    [deleteButton release];
    [flagImageView release];
    [detailButton release];
	[super dealloc];
}

@end
