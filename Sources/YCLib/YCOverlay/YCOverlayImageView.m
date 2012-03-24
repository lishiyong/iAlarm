//
//  YCOverlayImageView.m
//  TestMyOverlay
//
//  Created by li shiyong on 11-8-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YCOverlayImage.h"
#import "YCOverlayImageView.h"


@implementation YCOverlayImageView
@synthesize image;

 
/*
- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context{
	
	
    // Load image from applicaiton bundle
    NSString* imageFileName = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"map.jpg"];
    CGDataProviderRef provider = CGDataProviderCreateWithFilename([imageFileName UTF8String]);
    CGImageRef image = CGImageCreateWithJPEGDataProvider(provider, NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(provider);
	
    // save context before screwing with it
    CGContextSaveGState(context);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetAlpha(context, 1.0);
	
    // get the overlay bounds
    MKMapRect theMapRect = [self.overlay boundingMapRect];
    CGRect theRect = [self rectForMapRect:theMapRect];
	
    // Draw image
    CGContextDrawImage(context, theRect, image);
    CGImageRelease(image);
    CGContextRestoreGState(context);
}
 */

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context{
		
	if (firstZoomScale < 0.0) firstZoomScale = zoomScale;
    
		
    // save context before screwing with it
    CGContextSaveGState(context);
    CGContextScaleCTM(context, 1.0, 1.0);
    CGContextSetAlpha(context, 1.0);
	
    // get the overlay bounds
    MKMapRect theMapRect = [self.overlay boundingMapRect];
	float zoomRate = zoomScale/firstZoomScale;
    CGRect theRect = [self rectForMapRect:theMapRect];
	CGRect zoomRect = CGRectMake(theRect.origin.x, theRect.origin.y, theRect.size.width/zoomRate, theRect.size.height/zoomRate);
	zoomRect  = CGRectOffset(zoomRect, (theRect.size.width-zoomRect.size.width)/2, (theRect.size.height-zoomRect.size.height)/2);
	//NSLog(@"zoomRect.orgin.x = %f zoomRect.size.width = %f",zoomRect.origin.x,zoomRect.size.width);

    // Draw image
	CGImageRef anCGImage = self.image.CGImage; 
    CGContextDrawImage(context, zoomRect, anCGImage);
    CGContextRestoreGState(context);
	

}


- (id)initWithOverlay:(id <MKOverlay>)theOverlay andImage:(UIImage*)theImage{

	self = [super initWithOverlay:theOverlay];
	if (self) {
		image = [theImage retain];
		firstZoomScale = -1.0;
	}
	return self;
}

- (void)dealloc{
	[image release];
	[super dealloc];
}

@end
