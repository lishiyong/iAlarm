//
//  MapBookmark.h
//  iAlarm
//
//  Created by li shiyong on 10-12-5.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MKAnnotation;
@interface MapBookmark : NSObject 
{
	NSString *bookmarkName;
	id<MKAnnotation> annotation;
}

@property(nonatomic,retain) NSString *bookmarkName;
@property(nonatomic,assign) id<MKAnnotation> annotation;

@end
