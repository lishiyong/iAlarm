//
//  IAAnnotationView.h
//  iArrived
//
//  Created by li shiyong on 10-10-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "YCButton.h"
#import "YCRemoveMinusButton.h"
#import "YCMoveInButton.h"


@class IAAnnotationView;
@protocol IAAnnotationViewDelegete 

@optional

//按下了按钮
- (void)annotationView:(IAAnnotationView *)annotationView didPressDeleteButton:(UIButton*)button;
- (void)annotationView:(IAAnnotationView *)annotationView didPressDetailButton:(UIButton*)button;
//改变了calloutview的状态
- (void)annotationView:(IAAnnotationView *)annotationView didChangeEditingStatus:(BOOL)isEditing;

@end

@interface IAAnnotationView : MKPinAnnotationView {
    
    YCRemoveMinusButton *minusButton;
    YCMoveInButton *deleteButton;
    UIImageView *flagImageView;
    UIButton *detailButton;
    UIImage *grayPin;
    
    //反射查找到的对象，每次选择反选可能都重新生成，所以不需要保存
    UIView *calloutView;
    UILabel *titleLabel;
    
}

@property (nonatomic,assign) id delegate;
@property (nonatomic,getter = isEditing) BOOL editing;

- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

@end
