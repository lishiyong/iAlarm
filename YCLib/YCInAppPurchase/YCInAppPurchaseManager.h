
#import <StoreKit/StoreKit.h>

extern NSString *YCInAppPurchaseManagerProductsFetchedNotification;
extern NSString *YCInAppPurchaseManagerTransactionSucceededNotification;
extern NSString *YCInAppPurchaseManagerTransactionFailedNotification;
extern NSString *YCInAppPurchaseManagerTransactionCancelledNotification;



@interface YCInAppPurchaseManager : NSObject <SKProductsRequestDelegate,SKPaymentTransactionObserver>
{
    //SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
	
	NSString *productId;
}

//@property(nonatomic,retain,readonly) SKProduct *proUpgradeProduct;
@property(nonatomic,retain) SKProductsRequest *productsRequest;
@property(nonatomic,retain,readonly) NSString *productId;

// public methods
- (void)loadStore;
- (void)purchaseProUpgrade;
- (BOOL)canMakePurchases;

- (void)cancelLoadStore;
- (void)cancelPurchaseProUpgrade;

- (id)initWithProductId:(NSString*)productId;

@end