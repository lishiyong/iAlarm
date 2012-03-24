//
//  AlarmNameViewController.h
//  iArrived
//
//  Created by li shiyong on 10-10-19.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MKAnnotation;
@interface AnnotationInfoViewController : UITableViewController
<UITableViewDataSource,UITableViewDelegate> 
{
	id<MKAnnotation> annotation;
	NSString *annotationTitle;
	NSString *annotationSubtitle;
}

@property (nonatomic,assign) id<MKAnnotation> annotation;
@property (nonatomic,retain) NSString *annotationTitle;
@property (nonatomic,retain) NSString *annotationSubtitle;


@end
