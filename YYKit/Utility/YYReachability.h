//
//  YYReachability.h
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 15/2/6.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YYReachabilityStatus) {
    YYReachabilityStatusNone  = 0, ///< 无网络
    YYReachabilityStatusWWAN  = 1, ///< WWAN (2G/3G/4G/5G)
    YYReachabilityStatusWiFi  = 2, ///< WiFi
};

typedef NS_ENUM(NSUInteger, YYReachabilityWWANStatus) {
    YYReachabilityWWANStatusNone  = 0, ///< Not Reachable vis WWAN
    YYReachabilityWWANStatus2G = 2, ///< Reachable via 2G (GPRS/EDGE)       10~100Kbps
    YYReachabilityWWANStatus3G = 3, ///< Reachable via 3G (WCDMA/HSDPA/...) 1~10Mbps
    YYReachabilityWWANStatus4G = 4, ///< Reachable via 4G (eHRPD/LTE)       100Mbps
    YYReachabilityWWANStatus5G = 5, ///< Reachable via 5G (5G NSA/5G)
};


/**
 `YYReachability` 可以用来监测iOS设备的网络状态。
 
 其他参考：<https://github.com/tonymillion/Reachability>
 */
@interface YYReachability : NSObject

@property (nonatomic, readonly) SCNetworkReachabilityFlags flags;                           ///< Current flags.
@property (nonatomic, readonly) YYReachabilityStatus status;                                ///< Current status.
@property (nonatomic, readonly) YYReachabilityWWANStatus wwanStatus NS_AVAILABLE_IOS(7_0);  ///< Current WWAN status.
@property (nonatomic, readonly, getter=isReachable) BOOL reachable;                         ///< Current reachable status.

/// 当网络发生变化时，将在主线程上调用该通知 block。
@property (nullable, nonatomic, copy) void (^notifyBlock)(YYReachability *reachability);

/// 创建一个对象来检查默认路由的网络状况
+ (instancetype)reachability;

/// Create an object to check the reachability of the local WI-FI.
+ (instancetype)reachabilityForLocalWifi DEPRECATED_MSG_ATTRIBUTE("unnecessary and potentially harmful");

/// 创建一个对象来检查给定的主机名的网络状况
+ (nullable instancetype)reachabilityWithHostname:(NSString *)hostname;

/// 创建一个对象来检查给定 IP 地址的网络状况
/// @param hostAddress You may pass `struct sockaddr_in` for IPv4 address or `struct sockaddr_in6` for IPv6 address.
+ (nullable instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress;

@end

NS_ASSUME_NONNULL_END
