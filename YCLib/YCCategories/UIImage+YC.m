//
//  UIImage+YC.m
//  iAlarm
//
//  Created by li shiyong on 12-6-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCGeometry.h"
#import "UIImage+YC.h"

@implementation UIImage (YC)

- (UIImage*)imageWithRect:(CGRect)rect{
    CGFloat scale = self.scale;
    CGFloat x = rect.origin.x * scale;
    CGFloat y = rect.origin.y * scale;
    CGFloat w = rect.size.width * scale;
    CGFloat h = rect.size.height * scale;
    
    CGRect rectSacel = CGRectMake(x, y, w, h);
    
    CGImageRef cgimg = CGImageCreateWithImageInRect(self.CGImage, rectSacel);
    UIImage *img=[UIImage imageWithCGImage:cgimg scale:scale orientation:self.imageOrientation];
    CGImageRelease(cgimg);
    
    return img;
}

- (UIImage*)imageOverrideWihtAnotherImage:(UIImage*)anotherImage{
    
    CGFloat scale = self.scale;
    CGRect rect = {{0.0,0.0},YCSizeWithScale(self.size, scale)};
    CGPoint center = YCRectCenter(rect);
    
    CGRect anotherRect = YCRectMakeWithCenter(center, YCSizeWithScale(anotherImage.size,scale));
    
    UIGraphicsBeginImageContext(rect.size);
    [self drawInRect:rect];
    [anotherImage drawInRect:anotherRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    /*
    NSLog(@"self.scale = %.1f",self.scale);
    NSLog(@"anotherImage.scale = %.1f",anotherImage.scale);
    NSLog(@"newImage.scale = %.1f",newImage.scale);
     */
    
    return newImage;
}

@end
