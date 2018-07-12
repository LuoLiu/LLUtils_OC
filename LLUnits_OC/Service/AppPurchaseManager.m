//
//  AppPurchaseManager.m
//  LLUnits_OC
//
//  Created by mac on 2018/6/10.
//  Copyright © 2018年 luoliu. All rights reserved.
//

#ifdef DEBUG
#define ItunesCheckURL @"https://sandbox.itunes.apple.com/verifyReceipt"
#else
#define ItunesCheckURL @"https://buy.itunes.apple.com/verifyReceipt"
#endif

#import "AppPurchaseManager.h"

@interface AppPurchaseManager()<SKPaymentTransactionObserver,SKProductsRequestDelegate>

@property (nonatomic, strong) NSMutableDictionary *productDict;

@end

@implementation AppPurchaseManager

+ (AppPurchaseManager *)sharedManager {
    static AppPurchaseManager *sharedManager = nil;
    
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        sharedManager = [[self alloc] init];
        [sharedManager initManager];
    });
    
    return sharedManager;
}

- (void)initManager {
    self.checkAfterPay = YES;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

// 是否去广告
- (BOOL)isPurchase {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"purchase"];
}

/**
 *  恢复商品
 */
- (void)restorePurchase {
    // 恢复已经完成的所有交易.（仅限永久有效商品）
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

/**
 *  询问苹果的服务器能够销售哪些商品
 */
- (void)requestProductsWithProductArray:(NSArray *)products {
    NSSet *set = [[NSSet alloc] initWithArray:products];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
}

/**
 *  获取询问结果，成功采取操作把商品加入可售商品字典里
 */
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    if (self.productDict == nil) {
        self.productDict = [NSMutableDictionary dictionaryWithCapacity:response.products.count];
    }
    
    NSMutableArray *productArray = [NSMutableArray array];
    for (SKProduct *product in response.products) {
        [self.productDict setObject:product forKey:product.productIdentifier];
        [productArray addObject:product];
    }
    
    [self.delegate gotProducts:productArray];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    [self.delegate canceldWithProductID:nil];
    NSLog(@"%@", error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取内购信息失败，请重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

/**
 *  用户决定购买商品
 */
- (void)buyProduct:(NSString *)productID {
    SKProduct *product = self.productDict[productID];
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

/**
 *  监测购买队列的变化
 */
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        if (SKPaymentTransactionStatePurchased == transaction.transactionState) {
            if(self.checkAfterPay){
                //需要向苹果服务器验证一下
                [self.delegate beginCheckingdWithProductID:transaction.payment.productIdentifier];
                // 验证购买凭据
                [self verifyPruchaseWithID:transaction.payment.productIdentifier];
            }else{
                //不需要向苹果服务器验证
                [self.delegate boughtProductSuccessedWithProductID:transaction.payment.productIdentifier
                                                           andInfo:nil];
            }
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        }
        else if (SKPaymentTransactionStateRestored == transaction.transactionState) {
            [self.delegate restoredProductID:transaction.payment.productIdentifier];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        }
        else if (SKPaymentTransactionStateFailed == transaction.transactionState) {
            NSLog(@"交易失败");
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            [self.delegate canceldWithProductID:transaction.payment.productIdentifier];
        }
        else if (SKPaymentTransactionStatePurchasing == transaction.transactionState) {
            NSLog(@"正在购买");
        }
        else {
            NSLog(@"已经购买");
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        }
    }
}

/**
 *  验证购买凭据
 *
 *  @param productID 商品ID
 */
- (void)verifyPruchaseWithID:(NSString *)productID {
    // 验证凭据，获取到苹果返回的交易凭据
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    // 从沙盒中获取到购买凭据
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    
    NSURL *url = [NSURL URLWithString:ItunesCheckURL];
    
    // 国内访问苹果服务器比较慢，timeoutInterval需要长一点
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0f];
    
    request.HTTPMethod = @"POST";
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodeStr];
    NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = payloadData;
    
    // 提交验证请求，并获得官方的验证JSON结果
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // 官方验证结果为空
    if (result == nil) {
        [self.delegate checkFailedWithProductID:productID andInfo:result];
    }
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result
                                                         options:NSJSONReadingAllowFragments error:nil];
    if (dict != nil) {
        // 验证成功
        [self.delegate boughtProductSuccessedWithProductID:productID andInfo:dict];
    } else {
        // 验证失败
        [self.delegate checkFailedWithProductID:productID andInfo:result];
    }
}

@end
