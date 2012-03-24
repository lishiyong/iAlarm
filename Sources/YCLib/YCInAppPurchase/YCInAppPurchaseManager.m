// InAppPurchaseManager.m


#import "YCInAppPurchaseManager.h"

NSString *YCInAppPurchaseManagerProductsFetchedNotification      = @"YCInAppPurchaseManagerProductsFetchedNotification";
NSString *YCInAppPurchaseManagerTransactionSucceededNotification = @"YCInAppPurchaseManagerTransactionSucceededNotification";
NSString *YCInAppPurchaseManagerTransactionFailedNotification    = @"YCInAppPurchaseManagerTransactionFailedNotification";
NSString *YCInAppPurchaseManagerTransactionCancelledNotification = @"YCInAppPurchaseManagerTransactionCancelNotification";





@implementation YCInAppPurchaseManager

@synthesize productsRequest;
@synthesize productId;

- (id) productsRequest{
	if (productsRequest == nil) {
		NSSet *productIdentifiers = [NSSet setWithObject:self.productId ];
		productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
		productsRequest.delegate = self;
	}
	return productsRequest;
}




- (void)requestProUpgradeProductData
{

	self.productsRequest = nil; //为了能够重新start
    [self.productsRequest start];
    
    // we will release the request object in the delegate callback
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	/*
    NSArray *products = response.products;
	
	SKProduct *proUpgradeProduct = [products count] == 1 ? [products objectAtIndex:0] : nil;
    
	if (proUpgradeProduct)
    {
        NSLog(@"Product title: %@" , proUpgradeProduct.localizedTitle);
        NSLog(@"Product description: %@" , proUpgradeProduct.localizedDescription);
        NSLog(@"Product price: %@" , proUpgradeProduct.price);
        NSLog(@"Product id: %@" , proUpgradeProduct.productIdentifier);
    }
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
	 */
	 
        
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YCInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}


#pragma mark-
#pragma mark Public methods

//
// call this method once on startup
//
- (void)loadStore
{
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // get the product description (defined in early sections)
    [self requestProUpgradeProductData];
}

//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

//
// kick off the upgrade transaction
//
- (void)purchaseProUpgrade
{
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:self.productId];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)cancelLoadStore
{
	[self.productsRequest cancel];
}

- (void)cancelPurchaseProUpgrade
{
	// remove all transaction from the payment queue.
    SKPaymentQueue *queue = [SKPaymentQueue defaultQueue];
	for (id aTransaction in queue.transactions) {
		[queue finishTransaction:aTransaction];
	}
}

#pragma mark-
#pragma mark Purchase helpers

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    if ([transaction.payment.productIdentifier isEqualToString:self.productId])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:self.productId ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//
// enable pro features
//
- (void)provideContent:(NSString *)theProductId
{
    if ([productId isEqualToString:self.productId])
    {
        // enable the pro features
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:self.productId];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:YCInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
    }
    else
    {
		if (transaction.error.code == SKErrorPaymentCancelled){
			//用户取消了交易
			[[NSNotificationCenter defaultCenter] postNotificationName:YCInAppPurchaseManagerTransactionCancelledNotification object:self userInfo:userInfo];
		}else {
			// send out a notification for the failed transaction
			[[NSNotificationCenter defaultCenter] postNotificationName:YCInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
		}

    }
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
	/*
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
	 */
	[self finishTransaction:transaction wasSuccessful:NO];
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
		
		//NSLog(@"transaction.transactionState = %d",transaction.transactionState);
		//NSLog(@"transaction.error = %@",transaction.error);
    }
	
}


#pragma mark -
#pragma mark Memory management

- (id)initWithProductId:(NSString*)theProductId{
	if (self = [super init]) {
		productId = [theProductId retain];
	}
	return self;
}

- (void)dealloc {
	[productsRequest release];
    [super dealloc];
}

@end