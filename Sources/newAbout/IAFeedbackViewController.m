//
//  IAFeedback.m
//  iAlarm
//
//  Created by li shiyong on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCSoundPlayer.h"
#import "UIApplication+YC.h"
#import "NSData+Base64Additions.h"
#import "LocalizedStringAbout.h"
#import <QuartzCore/QuartzCore.h>
#import "IAFeedbackViewController.h"



@interface IAFeedbackViewController(private)

- (void)sendButtonPressed:(id)sender;
- (void)cancelButtonPressed:(id)sender;
@property (nonatomic, retain, readonly) UIBarButtonItem *sendButtonItem;;
@property (nonatomic, retain, readonly) UIBarButtonItem *cancelButtonItem;;
@property (nonatomic, retain, readonly) UIProgressView *progressView;
@property (nonatomic, retain, readonly) UIView *navTitleView;
@property (nonatomic, retain, readonly) SKPSMTPMessage *smtpEngine;


@end

@implementation IAFeedbackViewController
@synthesize player;
@synthesize textView;
@synthesize textField;

- (id)sendButtonItem{
	if (!sendButtonItem) {
		sendButtonItem = [[UIBarButtonItem alloc] initWithTitle:kBtnSend 
                                                          style:UIBarButtonItemStyleDone
                                                         target:self 
                                                         action:@selector(sendButtonItemPressed:)];
	}
	return sendButtonItem;
}

- (id)cancelButtonItem{
	if (!cancelButtonItem) {
		cancelButtonItem = [[UIBarButtonItem alloc]
								initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
								target:self
								action:@selector(cancelButtonItemPressed:)];
	}
	return cancelButtonItem;
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

- (id)smtpEngine{
    
    if (smtpEngine == nil) {
        smtpEngine = [[SKPSMTPMessage alloc] init];
        smtpEngine.connectTimeout = 20.0;
        smtpEngine.fromEmail = @"ialarmtest@gmail.com";
        smtpEngine.toEmail = @"iAlarmABC@gmail.com";
        smtpEngine.relayHost = @"smtp.gmail.com";
        smtpEngine.requiresAuth = YES;
        smtpEngine.login = @"ialarmtest";
        smtpEngine.pass = @"lsy132test";
        smtpEngine.wantsSecure = YES; // smtp.gmail.com doesn't work without TLS!
        smtpEngine.subject = @"iAlarm feedback";
        //test_smtp_message.bccEmail = @"testbcc@test.com";
        
        // Only do this for self-signed certs!
        // test_smtp_message.validateSSLChain = NO;
        smtpEngine.delegate = self;
    }
    
  

	
	return smtpEngine;
}

- (id)textView{
    if (!textView) {
        textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
        textView.font = [UIFont systemFontOfSize:17];
        
        //圆角的UITextView
        textView.layer.cornerRadius = 10;
        textView.layer.masksToBounds = YES;
        //UITextView 加边框
        textView.layer.borderWidth = 1.0f;
        textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    return textView;
}

- (id)textField{
    if (!textField) {
        textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 300, 45)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.font = [UIFont systemFontOfSize:18];
        textField.adjustsFontSizeToFitWidth = YES;
        textField.minimumFontSize = 14;
        textField.clearButtonMode = UITextFieldViewModeAlways;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return textField;
}



- (void)sendButtonItemPressed:(id)sender{

    
    NSMutableArray *parts = [NSMutableArray array];
    

    //邮件内容
    NSDictionary *textPart = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"text/plain\r\n\tcharset=UTF-8;\r\n\tformat=flowed", kSKPSMTPPartContentTypeKey,
                                     [self.textView.text stringByAppendingString:@"\n"], kSKPSMTPPartMessageKey,
                                     @"quoted-printable", kSKPSMTPPartContentTransferEncodingKey,
                                     nil];
    [parts addObject:textPart];
    
    
    //附件1
    NSString *file1 = [[UIApplication sharedApplication].libraryDirectory stringByAppendingPathComponent:@"alarms.plist"];
    
    NSData *file1Data = [NSData dataWithContentsOfFile:file1];
    if (file1Data) {
        NSDictionary *file1Part = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"xml/text;\r\n\tx-unix-mode=0644;\r\n\tname=\"alarms.plist\"",kSKPSMTPPartContentTypeKey,
                                   @"attachment;\r\n\tfilename=\"alarms.plist\"",kSKPSMTPPartContentDispositionKey,
                                   [file1Data encodeBase64ForData],kSKPSMTPPartMessageKey,
                                   @"base64",kSKPSMTPPartContentTransferEncodingKey,nil];
        [parts addObject:file1Part];
    }
   
    
    //签名
    if (self.textField.text) {
        NSDictionary *sigPart = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"text/plain\r\n\tcharset=UTF-8;\r\n\tformat=flowed", kSKPSMTPPartContentTypeKey,
                                 [@"\n" stringByAppendingString:self.textField.text], kSKPSMTPPartMessageKey,
                                 @"quoted-printable", kSKPSMTPPartContentTransferEncodingKey,
                                 nil];
        [parts addObject:sigPart];
    }
   
    self.smtpEngine.parts = parts;
    
    self.sendButtonItem.enabled = NO;
    highestState = 0;
    self.navigationItem.titleView = self.navTitleView;
    
    [self.smtpEngine send];
}


- (void)cancelButtonItemPressed:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark SKPSMTPMessage Delegate Methods
- (void)messageState:(SKPSMTPState)messageState;
{    
    if (messageState > highestState)
        highestState = messageState;
    
    self.progressView.progress = (float)highestState/(float)kSKPSMTPWaitingSendSuccess;
}

- (void)mailSent:(BOOL)sent{
    
    [smtpEngine release];
    smtpEngine = nil;
    
    self.sendButtonItem.enabled = YES;
    self.navigationItem.titleView = nil;
    self.progressView.progress = 0;
    highestState = 0;
    if ([messageDelegate respondsToSelector:@selector(messageComposeYCViewController:didFinishWithResult:)]) {
        [messageDelegate messageComposeYCViewController:self didFinishWithResult:sent];
    }
    
    if (sent) {
		self.player = [YCSoundPlayer soundPlayerWithSoundFileName:@"Share-Complete.aif"];
	}else {
		self.player = [YCSoundPlayer soundPlayerWithSoundFileName:@"Share-Error.aif"];
	}
	[self.player play];
    
}
- (void)messageSent:(SKPSMTPMessage *)SMTPmessage
{
    [self mailSent:YES];
}
- (void)messageFailed:(SKPSMTPMessage *)SMTPmessage error:(NSError *)error
{
    [self mailSent:NO];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        static NSString *kCellTextView = @"CellTextView";
        cell = [theTableView dequeueReusableCellWithIdentifier:kCellTextView];
        if (cell == nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellTextView] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.textView];
        }
    }else { /* (section == 1) */
        static NSString *kCellTextField = @"CellTextField";
        cell = [theTableView dequeueReusableCellWithIdentifier:kCellTextField];
        if (cell == nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellTextField] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor]; //
            [cell.contentView addSubview:self.textField];
        }
    }
    
    return cell;
    
}



#pragma mark -
#pragma mark Table view delegate


- (CGFloat)tableView:(UITableView *)theTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	switch (indexPath.section) {
		case 0:
			return self.textView.frame.size.height;
			break;
		case 1:
			return self.textField.frame.size.height;
			break;
		default:
			return 0; 
			break;
	}
	
}
 


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"反馈";
    self.navigationItem.rightBarButtonItem = self.sendButtonItem;
	self.navigationItem.leftBarButtonItem = self.cancelButtonItem;
    
    self.textField.placeholder = @"联系方式(可不填)";
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    
    //圆角的UITextView
    self.textView.layer.cornerRadius = 10;
    self.textView.layer.masksToBounds = YES;
    //UITextView 加边框
    self.textView.layer.borderWidth = 1.0f;
    self.textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

- (id)initWithStyle:(UITableViewStyle)style messageDelegate:(id)theDategate{
    self = [super initWithStyle:style];
    if (self) {
        messageDelegate = theDategate;
    }
    return self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.textView = nil;
    self.textField = nil;
    [sendButtonItem release];
    sendButtonItem = nil;
    [cancelButtonItem release];
    cancelButtonItem = nil;
    [progressView release];
    progressView = nil;
    [navTitleView release];
    navTitleView = nil;
}

- (void)dealloc{
    [player release];
    
    [textView release];
    [textField release];
    [sendButtonItem release];
    [cancelButtonItem release];
    [progressView release];
    [navTitleView release];
    
    smtpEngine.delegate = nil;
    [smtpEngine release];
    [super dealloc];
}

@end
