//
//  ROPayOrderInfo.h
//  RenrenSDKDemo
//
//  Created by xiawenhai on 11-10-19.
//  Copyright 2011 renren.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ROPayOrderInfo : NSObject {
	__strong NSString *_appID;
	__strong NSString *_tradingVolume;
	__strong NSString *_orderNum;
    __strong NSString *_orderTime;
    __strong NSString *_serialNum;
    __strong NSString *_userID;
    __strong NSString *_localOrderStatus;
    __strong NSString *_description;
    __strong NSString *_serverOrderStatus;
    __strong NSString *_payment;
    __strong NSString *_payEncode;
    __strong NSString *_orderCheckCode;
    __strong NSString *_isTestOrder;
    __strong NSString *_payStatusCode;
}

/**
 * 应用的AppID
 */
@property (nonatomic, strong) NSString *appID;

/**
 * 订单金额
 */
@property (nonatomic, retain) NSString *tradingVolume;

/**
 * 订单号
 */
@property (nonatomic, retain) NSString *orderNum;

/**
 * 订单时间
 */
@property (nonatomic, retain) NSString *orderTime;

/**
 * 订单流水号
 */
@property (nonatomic, retain) NSString *serialNum;

/**
 * 用户ID
 */
@property (nonatomic, retain) NSString *userID;

/**
 * 本地订单状态
 */
@property (nonatomic, retain) NSString *localOrderStatus;

/**
 * 服务器的订单状态
 */
@property (nonatomic, retain) NSString *serverOrderStatus;

/**
 * 订单描述
 */
@property (nonatomic, retain) NSString *description;

/**
 * 订单信息中第三方开发者自定义内容
 */
@property (nonatomic, retain) NSString *payment;

/**
 * 订单信息的校验码
 */
@property (nonatomic, retain) NSString *payEncode;

/**
 * 是否为测试订单
 */
@property (nonatomic, retain) NSString *isTestOrder;

/**
 * 订单信息校验码
 */
@property (nonatomic, retain) NSString *orderCheckCode;

/**
 * 订单状态码
 */
@property (nonatomic, retain) NSString *payStatusCode;

@end
