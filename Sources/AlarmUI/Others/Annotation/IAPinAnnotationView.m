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
#import "IAPinAnnotationView.h"
#import "YCMoveInButton.h"

@interface IAPinAnnotationView (private) 
- (void)_setEditing:(BOOL)isEditing animated:(BOOL)animated;
@end

@implementation IAPinAnnotationView

#pragma mark - property
@synthesize delegate, editing;

- (void)_setEditing:(BOOL)isEditing animated:(BOOL)animated{
    
    if (editing != isEditing){
        editing = isEditing;//一定放到前面，因为下面的self.pinColor 引发的 self.image 需要判断 editing
        
        //UIView *leftView = editing ? minusButton : flagImageView;
        UIView *leftView = editing ? minusButton : flagButton;
        UIView *rightView = editing ? deleteButton : detailButton;
        
        
        if (animated) {
            
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            [UIView transitionWithView:self duration:0.25 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve animations:^{
                
                self.rightCalloutAccessoryView = nil; //先赋空，titleLable可以自动拉伸。
                self.leftCalloutAccessoryView = nil;
                self.pinColor = editing ? MKPinAnnotationColorPurple : MKPinAnnotationColorRed;
                
            }completion:^(BOOL finished){
                
                self.rightCalloutAccessoryView = rightView;
                self.leftCalloutAccessoryView = leftView;
                
                if ([UIApplication sharedApplication].isIgnoringInteractionEvents) 
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
            }];
            
        }else {
            self.rightCalloutAccessoryView = nil; //系统bug，不先赋空，竟然不能显示新的按钮
            self.leftCalloutAccessoryView = nil;
            
            self.rightCalloutAccessoryView = rightView;
            self.leftCalloutAccessoryView = leftView;
            self.pinColor = editing ? MKPinAnnotationColorPurple : MKPinAnnotationColorRed;
        }
        
        //把减号恢复到水平,等
        if (!editing) {
            if(minusButton.isOpen)
                [minusButton switchOpenStatus:NO];
            
            [deleteButton setHidden:YES animated:NO];
        }
        
        //调用delegate
        if ([self.delegate respondsToSelector:@selector(annotationView:didChangeEditingStatus:)]) {
            [self.delegate annotationView:self didChangeEditingStatus:editing];
        }
    }
    
}

- (void)setEditing:(BOOL)isEditing{
    [self _setEditing:isEditing animated:NO];
}
 

- (void)setEditing:(BOOL)isEditing animated:(BOOL)animated{
    [self _setEditing:isEditing animated:animated];
    self.editing = isEditing;//者两条语句顺序不能颠倒：先执行实际操作，后设置的虽不起作用，但是可以启动kvo。
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

- (void)flagButtonPressed:(id)sender{
    //更换Annotation的状态
    if (IAAnnotationStatusNormal == [(IAAnnotation*)self.annotation annotationStatus]) 
        [(IAAnnotation*)self.annotation setAnnotationStatus:IAAnnotationStatusNormal1];
    
    else if(IAAnnotationStatusNormal1 == [(IAAnnotation*)self.annotation annotationStatus])
        [(IAAnnotation*)self.annotation setAnnotationStatus:IAAnnotationStatusNormal];
    
    else if(IAAnnotationStatusDisabledNormal == [(IAAnnotation*)self.annotation annotationStatus])
        [(IAAnnotation*)self.annotation setAnnotationStatus:IAAnnotationStatusDisabledNormal1];
    
    else if(IAAnnotationStatusDisabledNormal1 == [(IAAnnotation*)self.annotation annotationStatus])
        [(IAAnnotation*)self.annotation setAnnotationStatus:IAAnnotationStatusDisabledNormal];
    
    
	if ([self.delegate respondsToSelector:@selector(annotationView:didPressFlagButton:)]) {
		[self.delegate annotationView:self didPressFlagButton:flagButton];
	}
}


#pragma mark -
#pragma mark override super method

//为了让setSelected:animated中延时调用：下一次消息中calloutView才能生成
- (void)whenPinViewSelected{
	//反射查找到的对象
    
	//找到callout
    UIView *calloutView = nil;
	NSArray *subArray =[self subviews];
	for (UIView *subView in subArray) {
		NSString *className = NSStringFromClass([subView class]) ;
		if ([className isEqualToString:@"UICalloutView"]){
			calloutView = subView;
			break;
		}
	}
    
    if (calloutView == nil) 
        return;
	
	//找到titleLabel
    UILabel *titleLabel = nil;
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
    if (selected)
		[self performSelector:@selector(whenPinViewSelected) withObject:nil afterDelay:0.1];
}
 

/**
 在这里使用灰色的pin
 **/
- (void)setImage:(UIImage *)aImage{
    if ([(IAAnnotation*) self.annotation alarm].enabled == NO && editing == NO){
        super.image = grayPin;    
    }else{
        super.image = aImage;
    }
}
 
 
#pragma mark -
#pragma mark init and dealloc

- (id)initWithAnnotation:(IAAnnotation*)annotation reuseIdentifier:(NSString *)reuseIdentifier{	
	//优先初始化。因为setImage:中要使用，而super的initWithAnnotation:reuseIdentifier:要调用setImage:。
    grayPin = [[UIImage imageNamed:@"IAMapPinGray.png"] retain];
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	if (self) {
        minusButton = [[YCRemoveMinusButton alloc] init];
		deleteButton = [[YCMoveInButton alloc] init];
        flagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        detailButton = [[UIButton buttonWithType:UIButtonTypeDetailDisclosure] retain];
        [minusButton addTarget:self action:@selector(minusButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[deleteButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [detailButton addTarget:self action:@selector(detailButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        flagButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        flagButton.frame = CGRectMake(0, 0, 20, 20);
        [flagButton addTarget:self action:@selector(flagButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

        if ([annotation isKindOfClass:[IAAnnotation class]]) {
            IAAlarm *alarm = annotation.alarm;
            NSString *imageName = alarm.alarmRadiusType.alarmRadiusTypeImageName;
            imageName = [NSString stringWithFormat:@"20_%@",imageName]; //使用20像素的图标
            imageName = alarm.enabled ? imageName: @"20_IAFlagGray.png";  //没有启用，使用灰色旗帜
            flagImageView.image = [UIImage imageNamed:imageName];
            
            [flagButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            
            /*
            //禁用状态时候，缺省是状态1，subtitle显示地址
            if (alarm.enabled) 
                annotation.annotationStatus = IAAnnotationStatusNormal;
            else
                annotation.annotationStatus = IAAnnotationStatusDisabledNormal;
             */
            
        }
        
        [self addObserver:self forKeyPath:@"annotation.alarm.enabled" options:0 context:nil];
        [self addObserver:self forKeyPath:@"editing" options:0 context:nil];
        
        self.canShowCallout = YES;
        self.animatesDrop = NO;
        self.draggable = NO;
        editing = YES;self.editing = NO; //改变初始值，才能触发属性的功能
        
	}
	return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    //setPinColor可以引发setImage:
    self.pinColor = self.isEditing ? MKPinAnnotationColorPurple : MKPinAnnotationColorRed;
}

- (void)dealloc 
{
    NSLog(@"IAPinAnnotationView dealloc");
    [self removeObserver:self forKeyPath:@"annotation.alarm.enabled"];
    [self removeObserver:self forKeyPath:@"editing"];
    [minusButton release];
    [deleteButton release];
    [flagImageView release];
    [detailButton release];
    [grayPin release];
    [flagButton release];
	[super dealloc];
}

@end
