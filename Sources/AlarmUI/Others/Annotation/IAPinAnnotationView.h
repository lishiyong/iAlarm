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


@class IAPinAnnotationView;
@protocol IAAnnotationViewDelegete 

@optional

//按下了按钮
- (void)annotationView:(IAPinAnnotationView *)annotationView didPressDeleteButton:(UIButton*)button;
- (void)annotationView:(IAPinAnnotationView *)annotationView didPressDetailButton:(UIButton*)button;
//改变了calloutview的状态
- (void)annotationView:(IAPinAnnotationView *)annotationView didChangeEditingStatus:(BOOL)isEditing;

@end

@interface IAPinAnnotationView : MKPinAnnotationView {
    
    YCRemoveMinusButton *minusButton;
    YCMoveInButton *deleteButton;
    UIImageView *flagImageView;
    UIButton *detailButton;
    UIImage *grayPin;
}

@property (nonatomic,assign) id delegate;
@property (nonatomic,getter = isEditing) BOOL editing;

- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

@end
