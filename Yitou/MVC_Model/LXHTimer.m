//
//  LXHTimer.m
//  Yitou
//
//  Created by mac on 15/11/24.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import "LXHTimer.h"

@implementation LXHTimer{
    NSInteger countAdd;
    NSInteger timeGap;
    NSDate *dateNet;
}

+ (LXHTimer *)shareTimerManager{
    static LXHTimer *timer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timer = [[LXHTimer alloc]init];
    });
    return timer;
}

- (NSString *)calculatorWaitTimeFromSecond:(NSInteger)second{
    if (second == 0)
        return @"00:00:00";
    else{
        NSInteger seconds = second % 60;
        NSInteger minutes = (second / 60) % 60;
        NSInteger hours = second / 3600;
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours, (long)minutes, (long)seconds];
    }
}

- (NSInteger)companyTime:(NSString *)comTime{
    return [[self dateFromString:comTime] timeIntervalSinceDate:[self date]];
}

- (NSDate *)dateFromString:(NSString *)dateString{
    dateString = [dateString stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"]];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate = [dateFormatter dateFromString:dateString];
    destDate = [[NSDate alloc] initWithTimeInterval:60*60*8 sinceDate:destDate];
    NSLOG(@"orign time:%@ \n transce to date :%@",dateString,destDate);
    return destDate;
}

- (void)reGetTimeWithBlock:(TimerBlock)block{
    NSMutableDictionary *paraDict = [NSMutableDictionary new];
    [paraDict setObject:@"borrowinglist" forKey:@"cmdid"];
    [paraDict setObject:@{@"pageindex":@"1",@"client_id":KEY_CLIENTID,@"pagesize":@"1"} forKey:@"data"];
    [HttpManager hmRequestWithPara:paraDict Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        if (rqCode != rqSuccess){
            NSLOG(@"%@",describle);
            _isValid = NO;
            return ;
        }
        NSArray *ary = [receiveData objectForKey:@"data"];
        [self loadTimeWithTimeStr:[[ary objectAtIndex:0] objectForKey:@"system_time_stamp"]];
        countAdd = 0;

        if (block != nil){
            block(1);
        }
    }];
}

- (void)loadTimeWithTimeStr:(NSString *)timeStamp{

    NSInteger timeSt = [timeStamp integerValue];
    timeSt += 60*60*8;
    dateNet = [NSDate dateWithTimeIntervalSince1970:timeSt];
    NSLOG(@"orign time:%@ \n transce to date :%@",timeStamp,dateNet);
    _isValid = YES;
    
    timeGap = [dateNet timeIntervalSinceDate:[self mobileCurrentTime]];
}

- (NSDate *)mobileCurrentTime{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}

+ (NSString *)changeTime:(NSString *)time byFormat:(NSString *)format{
    NSString *dateString = [time stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];

    NSDate *destDate = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:format];
    NSString *timeStr = [dateFormatter stringFromDate:destDate];
    NSLOG(@"orign time:%@ \n transce to date :%@",dateString,timeStr);
    return timeStr;
}

- (NSDate *)date{
    NSLOG(@"现在时间是:%@",[[self mobileCurrentTime] dateByAddingTimeInterval:timeGap]);
    if (_isValid)
        return [[self mobileCurrentTime] dateByAddingTimeInterval:timeGap];
    return [self mobileCurrentTime];
}

- (void)applicationWillEnterForeground{
    NSInteger tempGap = [[self mobileCurrentTime] timeIntervalSinceDate:dateNet];
    if (tempGap < 600){
        timeGap = tempGap;
    }
    [self reGetTimeWithBlock:nil];
}

- (void)applicationWillEnterBackground{
    _isValid = NO;
//    dateNet = nil;
}

@end
