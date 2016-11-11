//
//  LXHTimer.h
//  Yitou
//
//  Created by mac on 15/11/24.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TimerBlock)(NSInteger checkedResult);


/**
 *  全局的计时器  用来确保时间的相对准确性
 */
@interface LXHTimer : NSObject

+ (LXHTimer *)shareTimerManager;


/**
 *  应用进入后台,由appDelegate调用
 */
- (void)applicationWillEnterBackground;


/**
 *  应用从后台进入前台运行
 */
- (void)applicationWillEnterForeground;


/**
 *  从服务器获取当前的服务器时间
 *
 *  @param block 获取到时间后的callBack 0代表未获取到 1代表获取到了
 */
- (void)reGetTimeWithBlock:(TimerBlock)block;


/**
 *  比较comTime与当前时间的时间差值
 *
 *  @param comTime 用来比较的时间
 *
 *  @return 时间差
 */
- (NSInteger)companyTime:(NSString *)comTime;


/**
 *  将一个时间的显示方式改成另一种format的显示方式
 *
 *  @param time   时间
 *  @param format timeFormat
 *
 *  @return 新的时间
 */
+ (NSString *)changeTime:(NSString *)time byFormat:(NSString *)format;


/**
 *  倒计时计算
 *
 *  @param second 剩余的秒数
 *
 *  @return 一个时间样式为:hh:mm:ss 
 */
- (NSString *)calculatorWaitTimeFromSecond:(NSInteger)second;


/**
 *  当前的时间 PS由于不是很精确的统计方法,算上网络延迟可能会有约1秒的时间差
 */
@property (nonatomic,readonly)NSDate *date;


/**
 *  是否是有效时间 PS应用进入后台后为NO 进入前台后会自动获取服务器时间后重新为YES
 */
@property (assign,readonly)BOOL isValid;

@end
