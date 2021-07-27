//
//  YYTimer.h
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 15/2/7.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 YYTimer 是一个基于 GCD 的线程安全的定时器。它的 API 与 `NSTimer` 相似。
 YYTimer 对象在几个方面与 NSTimer 不同：
 
 * 它使用 GCD 来产生定时器刻度，并且不会受到 runLoop 的影响。
 * 它对目标有一个弱引用，所以它可以避免引用循环。
 * 它总是在主线程上启动。
 
 */
@interface YYTimer : NSObject

+ (YYTimer *)timerWithTimeInterval:(NSTimeInterval)interval
                            target:(id)target
                          selector:(SEL)selector
                           repeats:(BOOL)repeats;

- (instancetype)initWithFireTime:(NSTimeInterval)start
                        interval:(NSTimeInterval)interval
                          target:(id)target
                        selector:(SEL)selector
                         repeats:(BOOL)repeats NS_DESIGNATED_INITIALIZER;

@property (readonly) BOOL repeats;
@property (readonly) NSTimeInterval timeInterval;
@property (readonly, getter=isValid) BOOL valid;

- (void)invalidate;

- (void)fire;

@end

NS_ASSUME_NONNULL_END
