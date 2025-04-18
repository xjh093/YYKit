//
//  YYReachability.m
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 15/2/6.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "YYReachability.h"
#import <objc/message.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

// 将 flag 转换成对应的网络状态
static YYReachabilityStatus YYReachabilityStatusFromFlags(SCNetworkReachabilityFlags flags, BOOL allowWWAN) {
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
        return YYReachabilityStatusNone;
    }
    
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) &&
        (flags & kSCNetworkReachabilityFlagsTransientConnection)) {
        return YYReachabilityStatusNone;
    }
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) && allowWWAN) {
        return YYReachabilityStatusWWAN;
    }
    
    return YYReachabilityStatusWiFi;
}

static void YYReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info) {
    YYReachability *self = ((__bridge YYReachability *)info);
    if (self.notifyBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.notifyBlock(self);
        });
    }
}

@interface YYReachability ()
@property (nonatomic, assign) SCNetworkReachabilityRef ref; // 网络句柄指针
@property (nonatomic, assign) BOOL scheduled;
@property (nonatomic, assign) BOOL allowWWAN; // 该参数只对 Wi-Fi 网络有用
@property (nonatomic, strong) CTTelephonyNetworkInfo *networkInfo; // 网络信息
@end

@implementation YYReachability

+ (dispatch_queue_t)sharedQueue {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.ibireme.yykit.reachability", DISPATCH_QUEUE_SERIAL);
    });
    return queue;
}

- (instancetype)init {
    /*
     See Apple's Reachability implementation and readme:
     The address 0.0.0.0, which reachability treats as a special token that 
     causes it to actually monitor the general routing status of the device, 
     both IPv4 and IPv6.
     https://developer.apple.com/library/ios/samplecode/Reachability/Listings/ReadMe_md.html#//apple_ref/doc/uid/DTS40007324-ReadMe_md-DontLinkElementID_11
     
     IP 地址 0.0.0.0 会被 reachability 视为一个特殊标记，使其能同时监控 IPv4 和 IPv6 的一般路由状态。
     */
    struct sockaddr_in zero_addr;
    bzero(&zero_addr, sizeof(zero_addr)); // bzero() 函数将 zero_addr 全部清 0
    zero_addr.sin_len = sizeof(zero_addr);
    zero_addr.sin_family = AF_INET; // AF_INET 是 IPv4 协议族
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)&zero_addr);
    return [self initWithRef:ref];
}

// 指定初始化方法
- (instancetype)initWithRef:(SCNetworkReachabilityRef)ref {
    if (!ref) return nil;
    self = super.init;
    if (!self) return nil;
    _ref = ref;
    _allowWWAN = YES;
    if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0) {
        _networkInfo = [CTTelephonyNetworkInfo new];
    }
    return self;
}

- (void)dealloc {
    self.notifyBlock = nil;
    self.scheduled = NO;
    CFRelease(self.ref);
}

- (void)setScheduled:(BOOL)scheduled {
    if (_scheduled == scheduled) return;
    _scheduled = scheduled;
    if (scheduled) {
        SCNetworkReachabilityContext context = { 0, (__bridge void *)self, NULL, NULL, NULL };
        SCNetworkReachabilitySetCallback(self.ref, YYReachabilityCallback, &context);
        SCNetworkReachabilitySetDispatchQueue(self.ref, [self.class sharedQueue]);
    } else {
        SCNetworkReachabilitySetDispatchQueue(self.ref, NULL);
    }
}

// Lazy Loading ，通过 SCNetworkReachabilityGetFlags() 函数获取网络状态
- (SCNetworkReachabilityFlags)flags {
    SCNetworkReachabilityFlags flags = 0;
    SCNetworkReachabilityGetFlags(self.ref, &flags);
    return flags;
}

- (YYReachabilityStatus)status {
    return YYReachabilityStatusFromFlags(self.flags, self.allowWWAN);
}

- (YYReachabilityWWANStatus)wwanStatus {
    if (!self.networkInfo) return YYReachabilityWWANStatusNone;
    NSString *status = self.networkInfo.currentRadioAccessTechnology;
    if (!status) return YYReachabilityWWANStatusNone;
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 14.1, *)) {
            dic = @{CTRadioAccessTechnologyGPRS : @(YYReachabilityWWANStatus2G),  // 2.5G   171Kbps
                    CTRadioAccessTechnologyEdge : @(YYReachabilityWWANStatus2G),  // 2.75G  384Kbps
                    CTRadioAccessTechnologyWCDMA : @(YYReachabilityWWANStatus3G), // 3G     3.6Mbps/384Kbps
                    CTRadioAccessTechnologyHSDPA : @(YYReachabilityWWANStatus3G), // 3.5G   14.4Mbps/384Kbps
                    CTRadioAccessTechnologyHSUPA : @(YYReachabilityWWANStatus3G), // 3.75G  14.4Mbps/5.76Mbps
                    CTRadioAccessTechnologyCDMA1x : @(YYReachabilityWWANStatus3G), // 2.5G
                    CTRadioAccessTechnologyCDMAEVDORev0 : @(YYReachabilityWWANStatus3G),
                    CTRadioAccessTechnologyCDMAEVDORevA : @(YYReachabilityWWANStatus3G),
                    CTRadioAccessTechnologyCDMAEVDORevB : @(YYReachabilityWWANStatus3G),
                    CTRadioAccessTechnologyeHRPD : @(YYReachabilityWWANStatus3G),
                    CTRadioAccessTechnologyLTE : @(YYReachabilityWWANStatus4G),// LTE:3.9G 150M/75M  LTE-Advanced:4G 300M/150M
                    CTRadioAccessTechnologyNRNSA: @(YYReachabilityWWANStatus5G),
                    CTRadioAccessTechnologyNR: @(YYReachabilityWWANStatus5G)};
        } else {
            dic = @{CTRadioAccessTechnologyGPRS : @(YYReachabilityWWANStatus2G),  // 2.5G   171Kbps
                    CTRadioAccessTechnologyEdge : @(YYReachabilityWWANStatus2G),  // 2.75G  384Kbps
                    CTRadioAccessTechnologyWCDMA : @(YYReachabilityWWANStatus3G), // 3G     3.6Mbps/384Kbps
                    CTRadioAccessTechnologyHSDPA : @(YYReachabilityWWANStatus3G), // 3.5G   14.4Mbps/384Kbps
                    CTRadioAccessTechnologyHSUPA : @(YYReachabilityWWANStatus3G), // 3.75G  14.4Mbps/5.76Mbps
                    CTRadioAccessTechnologyCDMA1x : @(YYReachabilityWWANStatus3G), // 2.5G
                    CTRadioAccessTechnologyCDMAEVDORev0 : @(YYReachabilityWWANStatus3G),
                    CTRadioAccessTechnologyCDMAEVDORevA : @(YYReachabilityWWANStatus3G),
                    CTRadioAccessTechnologyCDMAEVDORevB : @(YYReachabilityWWANStatus3G),
                    CTRadioAccessTechnologyeHRPD : @(YYReachabilityWWANStatus3G),
                    CTRadioAccessTechnologyLTE : @(YYReachabilityWWANStatus4G)}; // LTE:3.9G 150M/75M  LTE-Advanced:4G 300M/150M
        }
    });
    NSNumber *num = dic[status];
    if (num != nil) return num.unsignedIntegerValue;
    else return YYReachabilityWWANStatusNone;
}

- (BOOL)isReachable {
    return self.status != YYReachabilityStatusNone;
}

+ (instancetype)reachability {
    return self.new;
}

+ (instancetype)reachabilityForLocalWifi {
    struct sockaddr_in localWifiAddress;
    bzero(&localWifiAddress, sizeof(localWifiAddress));
    localWifiAddress.sin_len = sizeof(localWifiAddress);
    localWifiAddress.sin_family = AF_INET;
    localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
    YYReachability *one = [self reachabilityWithAddress:(const struct sockaddr *)&localWifiAddress];
    one.allowWWAN = NO;
    return one;
}

+ (instancetype)reachabilityWithHostname:(NSString *)hostname {
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithName(NULL, [hostname UTF8String]);
    return [[self alloc] initWithRef:ref];
}

+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress {
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)hostAddress);
    return [[self alloc] initWithRef:ref];
}

- (void)setNotifyBlock:(void (^)(YYReachability *reachability))notifyBlock {
    _notifyBlock = [notifyBlock copy];
    self.scheduled = (self.notifyBlock != nil);
}

@end
