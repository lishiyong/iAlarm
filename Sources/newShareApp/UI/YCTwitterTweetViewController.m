//
//  YCTwitterFeedViewController.m
//  iAlarm
//
//  Created by li shiyong on 11-8-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSObject+YC.h"
#import "YCBarButtonItem.h"
#import "YCShareContent.h"
#import "LocalizedStringAbout.h"
//#import "LocalizedString.h"
#import "SA_OAuthTwitterEngine.h"
#import "YCTwitterTweetViewController.h"


@implementation YCTwitterTweetViewController
@synthesize textView;



- (id)cancelButtonItem{
	
	if (!self->cancelButtonItem) {
		self->cancelButtonItem = [[UIBarButtonItem alloc]
								  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
								  target:self
								  action:@selector(cancelButtonItemPressed:)];
	}
	
	return self->cancelButtonItem;
}

- (id)shareButtonItem{
	
	if (!self->shareButtonItem) {
		self->shareButtonItem = [[UIBarButtonItem alloc] initWithTitle:kBtnSend 
																 style:UIBarButtonItemStyleDone
																target:self 
																action:@selector(doneButtonItemPressed:)];
		
	}
	
	return self->shareButtonItem;
}

- (id)progressView{
	if (progressView == nil) {
		progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
		CGFloat h = progressView.frame.size.height;
		progressView.frame = CGRectMake(0.0, 24.0, 106.0, h);
	}
	return progressView;
}

- (id)navTitleView{
	if (navTitleView == nil) {
		
		CGRect vframe = CGRectMake(0.0, 0.0, 106.0, 44.0);
		navTitleView = [[UIView alloc] initWithFrame:vframe];
		
		CGRect lframe = CGRectMake(0.0, 0.0, 106.0, 24.0);
		UILabel *lable = [[[UILabel alloc] initWithFrame:lframe] autorelease];
		lable.backgroundColor = [UIColor clearColor];
		lable.textAlignment = UITextAlignmentCenter;
		lable.textColor = [UIColor whiteColor];
		lable.font = [UIFont boldSystemFontOfSize:13.0];
		lable.shadowColor = [UIColor darkGrayColor];
		lable.shadowOffset = CGSizeMake(0.0, -1.0);
		lable.text = KTextPromptSending;
		
		[navTitleView addSubview:lable];
		[navTitleView addSubview:self.progressView];
	}
	return navTitleView;
}

- (id)navTitleView1{
	if (navTitleView1 == nil) {
		
		CGRect vframe = CGRectMake(0.0, 0.0, 106.0, 44.0);
		navTitleView1 = [[UIView alloc] initWithFrame:vframe];
		
		CGRect lframe = CGRectMake(0.0, 0.0, 106.0, 26.0);
		UILabel *lable = [[[UILabel alloc] initWithFrame:lframe] autorelease];
		lable.backgroundColor = [UIColor clearColor];
		lable.textAlignment = UITextAlignmentCenter;
		lable.textColor = [UIColor whiteColor];
		lable.font = [UIFont boldSystemFontOfSize:17.0];
		lable.adjustsFontSizeToFitWidth = YES;
		lable.minimumFontSize = 14.0;
		lable.shadowColor = [UIColor darkGrayColor];
		lable.shadowOffset = CGSizeMake(0.0, -1.0);
		lable.text = KViewTitleTWNewTweet; 
		
		CGRect lframe1 = CGRectMake(0.0, 22.0, 106.0, 20.0);
		UILabel *lable1 = [[[UILabel alloc] initWithFrame:lframe1] autorelease];
		lable1.backgroundColor = [UIColor clearColor];
		lable1.textAlignment = UITextAlignmentCenter;
		lable1.textColor = [UIColor whiteColor];
		lable1.font = [UIFont systemFontOfSize:14.0];
		lable1.shadowColor = [UIColor darkGrayColor];
		lable1.shadowOffset = CGSizeMake(0.0, -1.0);
		NSString *s = [NSString stringWithFormat:@"@%@",[twitterEngine username]];
		lable1.text = s;
				
		[navTitleView1 addSubview:lable];
		[navTitleView1 addSubview:lable1];
	}
	return navTitleView1;
}

#pragma mark -
#pragma mark Event

-(IBAction)cancelButtonItemPressed:(id)sender{
	[self dismissModalViewControllerAnimated:YES];
}


-(IBAction)doneButtonItemPressed:(id)sender{
	
	self.navigationItem.rightBarButtonItem.enabled = NO;	
	self.navigationItem.titleView = self.navTitleView;
	[self.progressView performSelector:@selector(setProgress:) withFloat:0.1 afterDelay:0.1];
	
    //[twitterEngine sendUpdate:self.textView.text ];
    [twitterEngine sendUpdate:self.textView.text image:shareContent.image1];
	
}


#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
	if ([messageDelegate respondsToSelector:@selector(messageComposeYCViewController:didFinishWithResult:)]) {
		[self.progressView performSelector:@selector(setProgress:) withFloat:0.5 afterDelay:0.1];
		[self.progressView performSelector:@selector(setProgress:) withFloat:0.8 afterDelay:0.25];
		[self.progressView performSelector:@selector(setProgress:) withFloat:1.0 afterDelay:0.5];
        [messageDelegate performSelector:@selector(messageComposeYCViewController:didFinishWithResult:) withObject:self withInteger:YES afterDelay:0.5];
	}
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	if ([messageDelegate respondsToSelector:@selector(messageComposeYCViewController:didFinishWithResult:)]) {
		self.progressView.progress = 0.0;
        [messageDelegate performSelector:@selector(messageComposeYCViewController:didFinishWithResult:) withObject:self withInteger:NO afterDelay:0.25];

	}
}



#pragma mark ViewController Stuff

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil engine:(MGTwitterEngine*)theEngine messageDelegate:(id)theDategate shareData:(YCShareContent*)theShareData{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        twitterEngine = [theEngine retain];
        messageDelegate = theDategate;
        shareContent = [theShareData retain];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.rightBarButtonItem = self.shareButtonItem;
	self.navigationItem.leftBarButtonItem = self.cancelButtonItem;
	
	//共享的消息
	//NSString *s = [NSString stringWithFormat:@"%@\n%@",shareContent.message,KLinkCustomAppStoreFullVersion];//twitter上直接完全版
	self.textView.text = shareContent.message;
    
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	self.navigationItem.titleView = self.navTitleView1;
	[self.textView becomeFirstResponder];
	self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)viewDidUnload {
	self.textView = nil;
}


- (void)dealloc {
	[cancelButtonItem release];
	[shareButtonItem release];
	[progressView release];
	[navTitleView release];
	[navTitleView1 release];
	[textView release];

	[shareContent release]; 
	[twitterEngine release];
    [super dealloc];
}




@end
