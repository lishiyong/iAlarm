//
//  DebugViewController.m
//  iAlarm
//
//  Created by li shiyong on 10-11-8.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIApplication-YC.h"
#import "DebugViewController.h"
#import "YCLog.h"


@implementation DebugViewController
@synthesize textView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.textView.text = @"";
	self.textView.font = [UIFont fontWithName:@"Arial" size:10];
	self.textView.scrollsToTop = NO;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(void)refreshDebugLog
{
	self.textView.text = [[YCLog logSingleInstance] stringLogs];
}

-(void)viewWillAppear:(BOOL)animated
{
	myTimer = [[NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(refreshDebugLog) userInfo:nil repeats:YES] retain];
	[[NSRunLoop currentRunLoop] addTimer:myTimer forMode:NSRunLoopCommonModes];
}

-(void) viewDidDisappear:(BOOL)animated
{
	// reset the timer
	[myTimer invalidate];
	[myTimer release];
	myTimer = nil;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.textView = nil;
}


- (void)dealloc {
	[textView release];
	[myTimer release];
    [super dealloc];
}

- (IBAction)saveButtonPressed:(id)sender{
    
    NSString *documentsDirectory = [UIApplication sharedApplication].documentsDirectory;
    NSString *filePathName = [documentsDirectory stringByAppendingPathComponent:@"log.txt"];
   

    NSMutableData *mydata =[[NSMutableData alloc] init]; 
    [mydata appendData:[[[YCLog logSingleInstance] stringLogs] dataUsingEncoding:NSUnicodeStringEncoding]];
    
   
    NSFileHandle *logFile = nil;
    logFile = [NSFileHandle fileHandleForWritingAtPath: filePathName];
    
    [logFile truncateFileAtOffset:[logFile seekToEndOfFile]];//定位到filename4的文件末尾
    
    [logFile writeData: mydata];//写入数据
    
    [logFile closeFile];

}

@end
