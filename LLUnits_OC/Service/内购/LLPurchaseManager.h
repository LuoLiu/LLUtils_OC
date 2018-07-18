//
//  LLPurchaseManager.h
//  LLUnits_OC
//
//  Created by mac on 2018/6/10.
//  Copyright © 2018年 luoliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

/**
 *  内购工具的代理
 */
@protocol LLPurchaseManagerDelegate <NSObject>

/**
 *  代理：已刷新可购买商品
 *
 *  @param products 商品数组
 */
- (void)gotProducts:(NSMutableArray *)products;

/**
 *  代理：购买成功
 *
 *  @param productID 购买成功的商品ID
 */
- (void)boughtProductSuccessedWithProductID:(NSString *)productID
                                    andInfo:(NSDictionary *)infoDic;;

/**
 *  代理：取消购买
 *
 *  @param productID 商品ID
 */
- (void)canceldWithProductID:(NSString *)productID;

/**
 *  代理：购买成功，开始验证购买
 *
 *  @param productID 商品ID
 */
- (void)beginCheckingdWithProductID:(NSString *)productID;

/**
 *  代理：重复验证
 *
 *  @param productID 商品ID
 */
- (void)checkRedundantWithProductID:(NSString *)productID;

/**
 *  代理：验证失败
 *
 *  @param productID 商品ID
 */
- (void)checkFailedWithProductID:(NSString *)productID
                         andInfo:(NSData *)infoData;

/**
 *  恢复了已购买的商品（永久性商品）
 *
 *  @param productID 商品ID
 */
- (void)restoredProductID:(NSString *)productID;


@end

#pragma mark - 内购工具

@interface LLPurchaseManager : NSObject

typedef void(^boolBlock)(BOOL successed,BOOL result);

typedef void(^dicBlock)(BOOL successed, NSDictionary *result);

@property (nonatomic,weak) id <LLPurchaseManagerDelegate> delegate;

// 是否去广告
- (BOOL)isPurchase;

/**
 *  单例
 *
 *  @return YQInLLPurchaseManager
 */
+ (LLPurchaseManager *)sharedManager;

/**
 *  购买完后是否在iOS端向服务器验证一次,默认为YES
 */
@property (nonatomic, assign) BOOL checkAfterPay;

/**
 *  询问苹果的服务器能够销售哪些商品
 *
 *  @param products 商品ID的数组
 */
- (void)requestProductsWithProductArray:(NSArray *)products;

/**
 *  用户决定购买商品
 *
 *  @param productID 商品ID
 */
- (void)buyProduct:(NSString *)productID;


/**
 *  恢复商品（仅限永久有效商品）
 */
- (void)restorePurchase;

@end
