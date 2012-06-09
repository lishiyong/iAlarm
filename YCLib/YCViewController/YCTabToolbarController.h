//
//  IABookmarkController.h
//  TestABController
//
//  Created by li shiyong on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCTabToolbarController : UIViewController{
    UIView *_currentView;
}

@property (nonatomic, retain) NSArray *viewControllers;

//@private
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIView *containerView;

@end
