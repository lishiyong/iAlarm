//
//  IAShareSettingViewController.m
//  iAlarm
//
//  Created by li shiyong on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IANotifications.h"
#import "IAParam.h"
#import "YCShareAppNotifications.h"
#import "UIUtility.h"
#import "YCSystemStatus.h"
#import "YCShareAppEngine.h"
#import "LocalizedStringAbout.h"
#import "TableViewCellDescription.h"
#import "IAShareSettingViewController.h"

@interface IAShareSettingViewController(private) 

- (UIButton*)makeSignButton; //产生一个登录登出按钮的实例。
- (void)setSignButton:(UIButton*)signButton forSignIn:(BOOL)isSignIn; //设置按钮为登录或为登出
- (void)registerNotifications;
- (void)unRegisterNotifications;

- (id)facebookCell;
- (id)twitterCell;
- (id)kxCell;

- (void)setSkinWithType:(IASkinType)type;

@end

@implementation IAShareSettingViewController

- (void)setSkinWithType:(IASkinType)type{
    
    YCBarButtonItemStyle buttonItemStyle = YCBarButtonItemStyleDefault;
    YCTableViewBackgroundStyle tableViewBgStyle = YCTableViewBackgroundStyleDefault;
    YCBarStyle barStyle = YCBarStyleDefault;
    UIColor *cellBackgroundColor = nil;
    if (IASkinTypeDefault == type) {
        buttonItemStyle = YCBarButtonItemStyleDefault;
        tableViewBgStyle = YCTableViewBackgroundStyleDefault;
        barStyle = YCBarStyleDefault;
        cellBackgroundColor = [UIColor iPhoneTableCellGroupedBackgroundColor];
    }else {
        buttonItemStyle = YCBarButtonItemStyleSilver;
        tableViewBgStyle = YCTableViewBackgroundStyleSilver;
        barStyle = YCBarStyleSilver;
        cellBackgroundColor = [UIColor iPadTableCellGroupedBackgroundColor];
    }
    [self.navigationItem.leftBarButtonItem setCustomBackButtonYCStyle:buttonItemStyle];
    [self.tableView setYCBackgroundStyle:tableViewBgStyle];
    [[self.tableView visibleCells] makeObjectsPerformSelector:@selector(setBackgroundColor:) withObject:cellBackgroundColor];
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.1];//
}


#pragma mark - Utility

-(void)alertInternetWithTitle:(NSString*)title andBody:(NSString*)body{
	//检查网络
	BOOL connectedToInternet = [[YCSystemStatus sharedSystemStatus] connectedToInternet];
	if (!connectedToInternet) {
		[UIUtility simpleAlertBody:body alertTitle:title cancelButtonTitle:kAlertBtnOK delegate:nil];
	}
}

- (void)signButtonPressed:(id)obj{
    
    UITableViewCell *theCell = (UITableViewCell*)[(UIView*)obj superview];
    UIButton *theButton = (UIButton*)theCell.accessoryView;
    BOOL isSigned = YES;
    
    if (theCell == self.twitterCell) {
        
        //检查是否登录过
        isSigned = shareAppEngine.isTwitterAuthorized;
        if (isSigned) {
            //登出
            [shareAppEngine removeAuthorizeTwitter];
        }else{
            //登录
            [shareAppEngine authorizeTwitter];
        }
        
    }else if(theCell == self.facebookCell){
        //检查是否登录过
        isSigned = shareAppEngine.isFacebookAuthorized;
        if (isSigned) {
            //登出
            [shareAppEngine removeAuthorizeFacebook];
        }else{
            //登录
            [shareAppEngine authorizeFacebook];
        }
        
        
    }else if(theCell == self.kxCell){
        
        
    }

    
    //////////////////////////
	//动画按钮转换
	[UIView beginAnimations:@"Button Change" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	UIViewAnimationTransition trType;
	if (isSigned) {
		trType = UIViewAnimationTransitionFlipFromRight;
	}else {
		trType = UIViewAnimationTransitionFlipFromLeft;
	}
	
	[UIView setAnimationTransition:trType forView:theButton cache:YES];
	[UIView commitAnimations];
    
}

- (UIButton*)makeSignButton{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 67, 32);
    
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button setTitle:@"Sign In" forState:UIControlStateNormal];
    button.titleLabel.font            = [UIFont boldSystemFontOfSize: 13];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.minimumFontSize = 10.0;
    button.titleLabel.shadowOffset    = CGSizeMake (0, -1);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIImage *imageNormal = [UIImage imageNamed:@"UINavigationBarDoneButton.png"];
    UIImage *newImageNormal = [imageNormal stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [button setBackgroundImage:newImageNormal forState:UIControlStateNormal];
    
    [button setBackgroundColor:[UIColor clearColor]];
    
    [button addTarget:self action:@selector(signButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}


- (void)setSignButton:(UIButton*)signButton forSignIn:(BOOL)isSignIn{
    
    UIImage *imageNormal = nil; 
    UIImage *imagePressed = nil;
    if (isSignIn){
        imageNormal = [UIImage imageNamed:@"UINavigationBarDoneButton.png"];
        imagePressed = [UIImage imageNamed:@"UINavigationBarDoneButtonPressed.png"];
        [signButton setTitle:@"Sign in" forState:UIControlStateNormal];
    }else{
        imageNormal = [UIImage imageNamed:@"UINavigationBarDefaultButton.png"];
        imagePressed = [UIImage imageNamed:@"UINavigationBarDefaultButtonPressed.png"];
        [signButton setTitle:@"Sign out" forState:UIControlStateNormal];
    }
    
    UIImage *newImageNormal = [imageNormal stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    UIImage *newImagePressed = [imagePressed stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [signButton setBackgroundImage:newImageNormal forState:UIControlStateNormal];
    [signButton setBackgroundImage:newImagePressed forState:UIControlStateHighlighted];
    
}

#pragma mark -
#pragma mark Notification

- (void) handle_shareAppAuthorizeDidChange:(id)notification{
    [self facebookCell]; //访问一次更新数据
    [self twitterCell];
    [self kxCell];
    [self.tableView reloadData];
}

- (void)IASkinStyleDidChange:(NSNotification*)notification{	
    //skin Style
    NSNumber *styleObj = [notification.userInfo objectForKey:IASkinStyleKey];
    [self setSkinWithType:[styleObj integerValue]];
    [self.tableView reloadData];
}

- (void)registerNotifications 
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver: self
                           selector: @selector (handle_shareAppAuthorizeDidChange:)
                               name: YCShareAppAuthorizeDidChangeNotification
                             object: nil];
    [notificationCenter addObserver: self
						   selector: @selector (IASkinStyleDidChange:)
							   name: IASkinStyleDidChange
							 object: nil];
}


- (void)unRegisterNotifications{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self	name: YCShareAppAuthorizeDidChangeNotification object: nil];
    [notificationCenter removeObserver:self	name: IASkinStyleDidChange object: nil];
}


#pragma mark - View lifecycle

- (id)facebookCell{
    if (_facebookCell == nil) {
        _facebookCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"shareAppCell"];
        
        _facebookCell.textLabel.text = KLabelCellFacebook;
		_facebookCell.accessoryType = UITableViewCellAccessoryNone;
        _facebookCell.imageView.image = [UIImage imageNamed:@"facebook-Icon-Small.png"];
        _facebookCell.accessoryView = [self makeSignButton];
    }
    
    UIButton *button = (UIButton*)_facebookCell.accessoryView;
    [self setSignButton:button forSignIn:!shareAppEngine.isFacebookAuthorized];
    _facebookCell.detailTextLabel.text = shareAppEngine.isFacebookAuthorized ? shareAppEngine.facebookUserName : nil;
    
    return _facebookCell;
}

- (id)twitterCell{
    if (_twitterCell == nil) {
        _twitterCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"shareAppCell"];
        
        _twitterCell.textLabel.text = KLabelCellTwitter;
		_twitterCell.accessoryType = UITableViewCellAccessoryNone;
        _twitterCell.imageView.image = [UIImage imageNamed:@"twitter-Icon-Small.png"];
        _twitterCell.accessoryView = [self makeSignButton];
    }
    
    UIButton *button = (UIButton*)_twitterCell.accessoryView;
    [self setSignButton:button forSignIn:!shareAppEngine.isTwitterAuthorized];
    _twitterCell.detailTextLabel.text = shareAppEngine.isTwitterAuthorized ? shareAppEngine.twitterUserName : nil;
    
    return _twitterCell;
}

- (id)kxCell{
    if (_kxCell == nil) {
        _kxCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"shareAppCell"];
        
        _kxCell.textLabel.text = @"开心网";
		_kxCell.accessoryType = UITableViewCellAccessoryNone;
        _kxCell.imageView.image = [UIImage imageNamed:@"kaixin-Icon-Small.png"];
        _kxCell.accessoryView = [self makeSignButton];
    }
    
    UIButton *button = (UIButton*)_kxCell.accessoryView;
    [self setSignButton:button forSignIn:!shareAppEngine.isKaixinAuthorized];
    _kxCell.detailTextLabel.text = shareAppEngine.isKaixinAuthorized ? shareAppEngine.twitterUserName : nil;
    
    return _kxCell;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = KViewTitleSetting;
    
    //
    NSArray *shareSettingSection = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) {// 5.0以上使用系统的twitter帐户
        shareSettingSection = [NSArray arrayWithObjects:self.facebookCell, nil];
    }else {
        shareSettingSection = [NSArray arrayWithObjects:self.facebookCell, self.twitterCell, nil];
    }
    
    //
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) {
        
        _defaultSkinCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        _silverSkinCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        _defaultSkinCell.textLabel.text = @"经典蓝色";
        _silverSkinCell.textLabel.text = @"银色";
        NSArray *skinStylesSection = [NSArray arrayWithObjects:_defaultSkinCell, _silverSkinCell, nil];
        
        _sections = [[NSMutableArray arrayWithObjects:shareSettingSection, skinStylesSection, nil] retain];
        
    }else {
        _sections = [[NSMutableArray arrayWithObjects:shareSettingSection, nil] retain];
    }
    
    //skin Style
    if (IASkinTypeSilver == [IAParam sharedParam].skinType) {
        [_silverSkinCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else {
        [_defaultSkinCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    [self setSkinWithType:[IAParam sharedParam].skinType];
    
        
    [self registerNotifications];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_sections count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_sections objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[_sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    if (IASkinTypeDefault == [IAParam sharedParam].skinType) 
        cell.backgroundColor = [UIColor iPhoneTableCellGroupedBackgroundColor];
    else 
        cell.backgroundColor = [UIColor iPadTableCellGroupedBackgroundColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //反选
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //√
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    [selectedCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    IASkinType skinType = IASkinTypeDefault;
    if (selectedCell == _defaultSkinCell) {
        [_silverSkinCell setAccessoryType:UITableViewCellAccessoryNone];
        skinType = IASkinTypeDefault;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }else {
        [_defaultSkinCell setAccessoryType:UITableViewCellAccessoryNone];
        skinType = IASkinTypeSilver;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    }
    
    //保存
    [IAParam sharedParam].skinType = skinType;
    
    //发通知
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSNotification *aNotification = [NSNotification notificationWithName:IASkinStyleDidChange 
                                                                  object:self
                                                                userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:skinType] forKey:IASkinStyleKey]];
    //[notificationCenter postNotification:aNotification];
    [notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.5];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [[UIApplication sharedApplication] performSelector:@selector(endIgnoringInteractionEvents) withObject:nil afterDelay:0.5];
    
}
 
#pragma mark - memory manager

- (id)initWithStyle:(UITableViewStyle)style shareAppEngine:(YCShareAppEngine *)theShareAppEngine{
    self = [super initWithStyle:style];
    if(self){
        shareAppEngine = [theShareAppEngine retain];
    }
    return self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self unRegisterNotifications];
    [_facebookCell release]; _facebookCell = nil;
    [_twitterCell release]; _twitterCell = nil;
    [_kxCell release]; _kxCell = nil;
}

- (void)dealloc {
    [self unRegisterNotifications];
    [shareAppEngine release];
    
    [_facebookCell release];
    [_twitterCell release];
    [_kxCell release];
    [super dealloc];
}

@end
