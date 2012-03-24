//
//  IAPurchase.h
//  iAlarm
//
//  Created by li shiyong on 11-3-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *IAInAppPurchaseProUpgradeProductId;

@class IABuyManager;
@protocol IABuyManagerDelegate<NSObject>

@optional

//购买开始
- (void)buyBeginWithManager:(IABuyManager *)manager;
//购买结束
- (void)buyEndWithManager:(IABuyManager *)manager;


@end



@class YCMaskView;
@class YCInAppPurchaseManager;
@interface IABuyManager : NSObject <UIAlertViewDelegate>{
	YCInAppPurchaseManager *iapManager;
	id<IABuyManagerDelegate> delegate;
	
	BOOL maskWhenBuying;   //购买过程中，是否mask窗口
	YCMaskView *maskView;
	

	//NSTimeInterval timeOutIntervalForLoadStore;
	//NSTimeInterval timeOutIntervalForForPurchase;
}

@property (nonatomic, retain, readonly) YCInAppPurchaseManager *iapManager;
@property (nonatomic, assign)           id<IABuyManagerDelegate> delegate;
@property (nonatomic, assign)           BOOL maskWhenBuying;
@property (nonatomic, retain, readonly) YCMaskView *maskView;

//@property (nonatomic, assign, readonly) NSTimeInterval timeOutIntervalForLoadStore;
//@property (nonatomic, assign, readonly) NSTimeInterval timeOutIntervalForForPurchase;
- (void)buy;
- (void)buyWithAlert;

+ (IABuyManager*)shareBuyManager;

@end
