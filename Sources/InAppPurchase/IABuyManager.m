//
//  IAPurchase.m
//  iAlarm
//
//  Created by li shiyong on 11-3-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocalizedStringAbout.h"
#import "YCMaskView.h"
#import "YCSystemStatus.h"
#import "YCParam.h"
#import "UIUtility.h"
#import "YCInAppPurchaseManager.h"
#import "IABuyManager.h"

NSString *IAInAppPurchaseProUpgradeProductId = @"com.yicheng.iAlarm.upgradetopro";

@implementation IABuyManager
#pragma mark -
#pragma mark Property
@synthesize delegate;
@synthesize maskWhenBuying;

- (id)iapManager{
	if (iapManager == nil) {
		iapManager = [[YCInAppPurchaseManager alloc] initWithProductId:IAInAppPurchaseProUpgradeProductId];
	}
	return iapManager;
}

- (id)maskView{
	if (maskView == nil) {
		//maskView = [[YCMaskView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)];
		maskView = [[YCMaskView alloc] init];
	}
	return maskView;
}

- (NSTimeInterval)timeOutIntervalForLoadStore{
	//检查网络
	BOOL connectedToInternet = [[YCSystemStatus sharedSystemStatus] connectedToInternet];
	if (connectedToInternet) //有网络时间长
		return 60.0;
	else 
	    return 3.0;
}

- (NSTimeInterval)timeOutIntervalForForPurchase{
	//检查网络
	BOOL connectedToInternet = [[YCSystemStatus sharedSystemStatus] connectedToInternet];
	if (connectedToInternet) //有网络时间长
		return 60.0*3;
	else 
	    return 3.0;
}

#pragma mark -
#pragma mark Private Mothod

- (void)setMaskViewHidden:(BOOL)hidden{
	
	if (hidden) {
		[self.maskView removeFromSuperview];
		self.maskView.hidden = YES;
	}else {
		if (self.maskWhenBuying){
			self.maskView.hidden = NO;
			UIWindow *mainWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
			[mainWindow addSubview:self.maskView];
		}
	}

}

//#define kTimeOutForLoadStore  60.0
//#define kTimeOutForPurchase  120.0


//购买超时处理
- (void)handleTimeOutForBuy{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleTimeOutForBuy) object:nil]; //取消超时处理
	[self setMaskViewHidden:YES];
	
}
 


#pragma mark -
#pragma mark Public Mothod
- (void)buy{
	
	//检查网络
	BOOL connectedToInternet = [[YCSystemStatus sharedSystemStatus] connectedToInternet];
	if (!connectedToInternet) {
		[UIUtility simpleAlertBody:kAlertNeedInternetBodyAccessAppStore alertTitle:kAlertNeedInternetTitleAccessAppStore cancelButtonTitle:kAlertBtnOK delegate:nil];
	}
	
	//处理取得product超时
	[self performSelector:@selector(handleTimeOutForBuy) withObject:nil afterDelay:self.timeOutIntervalForLoadStore];
	
	[self setMaskViewHidden:NO];
	[self.iapManager loadStore];
	if ([self.delegate respondsToSelector:@selector(buyBeginWithManager:)]) {
		[self.delegate buyBeginWithManager:self];
	}
}

- (void)buyWithAlert{
	[UIUtility simpleAlertBody:kAlertUpgradeProVesionBody alertTitle:kAlertUpgradeProVesionTitle cancelButtonTitle:kAlertBtnCancel OKButtonTitle:kAlertBtnUpgrade delegate:self];
}


#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	/*
	if (1==buttonIndex) { //OK按钮，用户同意购买
		[self buy];
	}
	 */
	
	
	if (1==buttonIndex) { //OK按钮，用户同意升级
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:KLinkAppStoreFullVersion]];
	}
	 
}

#pragma mark -
#pragma mark Notification

- (void) handle_inAppPurchaseManagerProductsFetched: (id) notification{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleTimeOutForBuy) object:nil]; //取消超时处理
	
	if ([self.iapManager canMakePurchases]) 
	{
		//处理下订单超时
		[self performSelector:@selector(handleTimeOutForBuy) withObject:nil afterDelay:self.timeOutIntervalForForPurchase];
		[self.iapManager purchaseProUpgrade];
	}else {
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleTimeOutForBuy) object:nil];//取消超时处理
		[self setMaskViewHidden:YES];
		
		//在设置中没有允许购买
		[UIUtility simpleAlertBody:kAlertPurchasenNotAllowPurchaseBody alertTitle:kAlertPurchaseTitle cancelButtonTitle:kAlertBtnOK delegate:nil];
		
		if ([self.delegate respondsToSelector:@selector(buyEndWithManager:)]) {
			[self.delegate buyEndWithManager:self];
		}
	}

}

- (void) handle_inAppPurchaseManagerTransactionSucceeded: (id) notification{
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleTimeOutForBuy) object:nil];//取消超时处理
	[self setMaskViewHidden:YES];
	
	/*
	YCParam *param = [YCParam paramSingleInstance];
	param.isProUpgradePurchased = YES;
	[param saveParam];
	 */
	
	
	if ([self.delegate respondsToSelector:@selector(buyEndWithManager:)]) {
		[self.delegate buyEndWithManager:self];
	}
}

- (void) handle_inAppPurchaseManagerTransactionFailed: (id) notification{
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleTimeOutForBuy) object:nil];//取消超时处理
	[self setMaskViewHidden:YES];
	
	//错误提示
	[UIUtility simpleAlertBody:nil alertTitle:kAlertNeedInternetTitleAccessAppStore cancelButtonTitle:kAlertBtnOK delegate:nil];

	
	if ([self.delegate respondsToSelector:@selector(buyEndWithManager:)]) {
		[self.delegate buyEndWithManager:self];
	}
}

- (void) handle_inAppPurchaseManagerTransactionCancelled: (id) notification{
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleTimeOutForBuy) object:nil];//取消超时处理
	[self setMaskViewHidden:YES];
		
	if ([self.delegate respondsToSelector:@selector(buyEndWithManager:)]) {
		[self.delegate buyEndWithManager:self];
	}
}

- (void) registerNotifications {
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	[notificationCenter addObserver: self
						   selector: @selector (handle_inAppPurchaseManagerProductsFetched:)
							   name: YCInAppPurchaseManagerProductsFetchedNotification
							 object: nil];
	[notificationCenter addObserver: self
						   selector: @selector (handle_inAppPurchaseManagerTransactionSucceeded:)
							   name: YCInAppPurchaseManagerTransactionSucceededNotification
							 object: nil];
	[notificationCenter addObserver: self
						   selector: @selector (handle_inAppPurchaseManagerTransactionFailed:)
							   name: YCInAppPurchaseManagerTransactionFailedNotification
							 object: nil];
	[notificationCenter addObserver: self
						   selector: @selector (handle_inAppPurchaseManagerTransactionCancelled:)
							   name: YCInAppPurchaseManagerTransactionCancelledNotification
							 object: nil];
	
	
}

- (void)unRegisterNotifications{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter removeObserver:self	name: YCInAppPurchaseManagerProductsFetchedNotification object: nil];
	[notificationCenter removeObserver:self	name: YCInAppPurchaseManagerTransactionSucceededNotification object: nil];
	[notificationCenter removeObserver:self	name: YCInAppPurchaseManagerTransactionFailedNotification object: nil];
	[notificationCenter removeObserver:self	name: YCInAppPurchaseManagerTransactionCancelledNotification object: nil];
}

#pragma mark -
#pragma mark Memory management

- (id)init{
	if (self = [super init]) {
		[self registerNotifications];
		maskWhenBuying = YES;
	}
	return self;
}

+ (IABuyManager*)shareBuyManager{
	static IABuyManager* bm = nil;
	if(bm == nil) 
		bm = [[IABuyManager alloc] init];
	return bm;
}

- (void)dealloc {
	[self unRegisterNotifications];
	[iapManager release];
	[maskView release];
    [super dealloc];
}

@end
