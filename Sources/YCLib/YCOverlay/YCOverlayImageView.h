//
//  YCOverlayImageView.h
//  TestMyOverlay
//
//  Created by li shiyong on 11-8-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class YCOverlayImage;
@interface YCOverlayImageView :  MKOverlayView //MKPolygonView
{
	MKZoomScale firstZoomScale; 
	UIImage *image;

}
@property (nonatomic, retain, readonly) UIImage *image;

- (id)initWithOverlay:(YCOverlayImage*)overlay andImage:(UIImage*)theImage;

@end
