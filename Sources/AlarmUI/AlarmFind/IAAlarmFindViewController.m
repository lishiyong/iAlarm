//
//  IAAlarmFindViewController.m
//  iAlarm
//
//  Created by li shiyong on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "IAAlarmFindViewController.h"

@implementation IAAlarmFindViewController
@synthesize textView;
@synthesize button1;
@synthesize button2;

- (id)doneButtonItem{
	
	if (!self->doneButtonItem) {
		self->doneButtonItem = [[UIBarButtonItem alloc]
								initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
								target:self
								action:@selector(doneButtonItemPressed:)];
	}
	
	return self->doneButtonItem;
}


- (void)doneButtonItemPressed:(id)sender{
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIScrollView *sv = (UIScrollView*)self.view;
    sv.alwaysBounceVertical = YES;
    
    
    //圆角的UITextView
    self.textView.layer.cornerRadius = 10;
    self.textView.layer.masksToBounds = YES;
    //UITextView 加边框
    self.textView.layer.borderWidth = 1.0f;
    self.textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    
    /*
    
    UIImage *imageWhite = [UIImage imageNamed:@"passcode-change-normal.png"];
    UIImage *newImageWhite = [imageWhite stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [self->button1 setBackgroundImage:newImageWhite forState:UIControlStateNormal & UIControlStateHighlighted];
    
    //[self->button1 addTarget:self action:@selector(testAlarmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self->button1.adjustsImageWhenDisabled = YES;
    self->button1.adjustsImageWhenHighlighted = YES;
    [self->button1 setBackgroundColor:[UIColor clearColor]];
    [self->button1 setTitle:@"推迟10分钟提醒" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
    
    
    UIImage *imageGreen = [UIImage imageNamed:@"passcode-change-normal.png"];
    UIImage *newImageGreen = [imageGreen stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [self->button2 setBackgroundImage:newImageGreen forState:UIControlStateNormal & UIControlStateHighlighted];
    
    //[self->button2 addTarget:self action:@selector(testAlarmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self->button2.adjustsImageWhenDisabled = YES;
    self->button2.adjustsImageWhenHighlighted = YES;
    [self->button2 setBackgroundColor:[UIColor clearColor]];
    [self->button2 setTitle:@"分享" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
     */
    
    
    UIImage *imageWhite = [UIImage imageNamed:@"IARedButtonNormal.png"];
    UIImage *newImageWhite = [imageWhite stretchableImageWithLeftCapWidth:6 topCapHeight:6];
    [self->button1 setBackgroundImage:newImageWhite forState:UIControlStateNormal & UIControlStateHighlighted];
    
    //[self->button1 addTarget:self action:@selector(testAlarmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self->button1.adjustsImageWhenDisabled = YES;
    self->button1.adjustsImageWhenHighlighted = YES;
    [self->button1 setBackgroundColor:[UIColor clearColor]];
    [self->button1 setTitle:@"推迟10分钟提醒" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
    
    
    UIImage *imageGreen = [UIImage imageNamed:@"IARedButtonNormal.png"];
    UIImage *newImageGreen = [imageGreen stretchableImageWithLeftCapWidth:6 topCapHeight:6];
    [self->button2 setBackgroundImage:newImageGreen forState:UIControlStateNormal & UIControlStateHighlighted];
    
    //[self->button2 addTarget:self action:@selector(testAlarmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self->button2.adjustsImageWhenDisabled = YES;
    self->button2.adjustsImageWhenHighlighted = YES;
    [self->button2 setBackgroundColor:[UIColor clearColor]];
    [self->button2 setTitle:@"分享" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
    
    
    self.navigationItem.leftBarButtonItem = self.doneButtonItem;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
