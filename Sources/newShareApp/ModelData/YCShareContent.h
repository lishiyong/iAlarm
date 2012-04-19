//
//  YCShareData.h
//  iAlarm
//
//  Created by li shiyong on 11-8-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YCShareContent : NSObject {
    
    NSString *message;
    NSString *title;
    UIImage  *image1;
    UIImage  *image2;
    NSString *imageLink1; //在图床上的链接
    NSString *imageLink2;
    NSString *link1;
    NSString *link2;

}


+ (YCShareContent*)facebookShareContentWithMessage:(NSString*)theMessage image:(UIImage*)theImage;
+ (YCShareContent*)twitterShareContentWithMessage:(NSString*)theMessage image:(UIImage*)theImage;
+ (YCShareContent*)mailShareContentWithMessage:(NSString*)theMessage image:(UIImage*)theImage;
+ (YCShareContent*)messageShareContentWithMessage:(NSString*)theMessage;

@property(nonatomic, copy) NSString *message;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, retain) UIImage *image1;
@property(nonatomic, retain) UIImage *image2;
@property(nonatomic, copy) NSString *imageLink1;
@property(nonatomic, copy) NSString *imageLink2;
@property(nonatomic, copy) NSString *link1;
@property(nonatomic, copy) NSString *link2;



+ (YCShareContent*)shareContentWithTitle:(NSString *)theTitle message:(NSString*)theMessage image:(UIImage *)theImage;

@end
