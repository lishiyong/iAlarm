//
//  DebugViewController.h
//  iAlarm
//
//  Created by li shiyong on 10-11-8.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DebugViewController : UIViewController {
	UITextView *textView;
	NSTimer *myTimer;
}

@property (nonatomic,retain) IBOutlet UITextView *textView;

- (IBAction)saveButtonPressed:(id)sender;

@end
