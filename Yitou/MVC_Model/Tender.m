//
//  Tender.m
//  Yitou
//
//  Created by Xiaohui on 15/8/11.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "Tender.h"
#import "LXHTimer.h"

@implementation Tender

- (void)createTenderModel:(NSDictionary *)tenDict{
    _title = [tenDict objectForKey:@"borrow_title"];
    _balance = [tenDict objectForKey:@"surplus_money"];
    _balanceUnit = [tenDict objectForKey:@"surplus_money_unit"];
    _tenderCount = [tenDict objectForKey:@"finished_money"];
    _tenderCountUnit = @"元";

    _tenderSum = [tenDict objectForKey:@"borrow_money"];
    _tenderSumUnit = [tenDict objectForKey:@"borrow_money_unit"];
    _schedule = [tenDict objectForKey:@"rateall"];
    _minEarn = [tenDict objectForKey:@"borrow_lilv_min"];
    _maxEarn = [tenDict objectForKey:@"borrow_lilv_max"];

    _timeCount = [tenDict objectForKey:@"borrow_duration"];
    _timeCountUnit = [tenDict objectForKey:@"borrow_duration_unit"];
    _tenderID = [tenDict objectForKey:@"borrowid"];
    _payStyle = [self getRepayTypeByType:[tenDict objectForKey:@"repayment_type"]];
    _createTime = [tenDict objectForKey:@"borrow_posttime"];

    _status = [tenDict objectForKey:@"borrow_status"];
    _startTime = [tenDict objectForKey:@"valid_invest_time"];
    _isExp = STRCMP([tenDict objectForKey:@"borrow_type_remark"], @"体验标");
    _endTime = [tenDict objectForKey:@"borrow_overdue"];
    _typeName = [tenDict objectForKey:@"borrow_type_remark"];
    
    _minInvest = [tenDict objectForKey:@"borrow_min"];
    _maxInvest = [tenDict objectForKey: @"borrow_max"];
    _type = [tenDict objectForKey:@"borrow_reservation_status"];
    _belongTimeout = [tenDict objectForKey:@"borrow_resoverdue_time"];

    _belongUserID = [tenDict objectForKey:@"borrow_standard_userid"];
    _belongUserName = [tenDict objectForKey:@"borrow_standard_username"];
    _borrowPassword = [tenDict objectForKey:@"borrow_pwd"];
    _statusDesc = [self getTenderStatusDescrible];
}

- (BOOL)canInvestStatus{
    if (STRCMP(self.status, @"0"))
        return NO;//不用判断了 不是可投的状态
    LXHTimer *timer = [LXHTimer shareTimerManager];
    if (!timer.isValid)
        return NO;//服务器时间无效,直接返回NO
    if ([timer companyTime:self.createTime] > 0)
        return NO;//未开始
    return YES;
}

- (BOOL)checkBelongValid{
    if (STRCMP(self.type, @"0"))
        return NO;//非预约标
    LXHTimer *timer = [LXHTimer shareTimerManager];
    return [timer companyTime:self.belongTimeout] > 0;
}

-(NSString *)getTenderStatusDescrible{
    switch ([_status integerValue]) {
        case -1: return @"审核未通过";break;
        case 0: return @"审核中";break;
        case 1: return @"投标中";break;
        case 2: return @"复审中";break;
        case 3: return @"还款中";break;
        case 4: return @"已完成";break;
        default:return @"unknown"; break;
    }
}

- (NSString *)getRepayTypeByType:(NSString *)type{
    switch ([type integerValue]) {
        case 1: return @"按天到期还款";break;
        case 2: return @"按月分期还款";break;
        case 3: return @"每月还息到期还本";break;
        case 4: _isExp = YES;return @"体验标每日还息";break;
        default:return @"unknown"; break;
    }
}

- (NSString *)showBelongName{
    NSString *name = self.belongUserName;
    if (name == nil||[name length] == 0||STRCMP(self.type, @"0"))
        return @"";
    if ([name length] < 4){
        return [NSString stringWithFormat:@"%@**专属",[name substringToIndex:1]];
    }
    if ([name length] == 4){
        return [NSString stringWithFormat:@"%@**专属",[name substringToIndex:2]];
    }
    return [NSString stringWithFormat:@"%@**%@专属",[name substringToIndex:2],[name substringFromIndex:[name length] - 2]];
}

@end
