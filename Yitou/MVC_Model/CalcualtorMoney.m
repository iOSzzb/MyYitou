//
//  CalcualtorMoney.m
//  Yitou
//
//  Created by Xiaohui on 15/8/28.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "CalcualtorMoney.h"

@implementation CalcualtorMoney{
    float rate;
    float orignRate;
    NSInteger repaymentType;
    NSInteger borrowDurateion;
    NSArray *actJiaxi;
}

- (void)loadTouziquanActivity:(NSArray *)ary{
    actJiaxi = ary;
}

- (void)loadDataSource:(NSDictionary *)dataSource coupon:(double)coupon{
    _investMoney = 0;
    repaymentType = [[dataSource objectForKey:@"repayment_type"] integerValue];
    borrowDurateion = [[dataSource objectForKey:@"borrow_duration"] integerValue];
    orignRate = [[dataSource objectForKey:@"borrow_lilv"] floatValue] + coupon;
    [self calculatorRate];
}

- (double)getMonthMoney:(double)monthRate{
    double _monthRate = monthRate;
    double monthMoney=_investMoney*_monthRate* [self math_cube:1+_monthRate power:borrowDurateion]/([self math_cube:1+_monthRate power:borrowDurateion]-1);
    return monthMoney;
}

- (float)calculatorRate{
    rate = orignRate;
    _actID = @"";
    if (repaymentType == 2 || repaymentType == 3){
        for (NSDictionary *dict in actJiaxi){
            float min = [[dict objectForKey:@"min"] floatValue];
            if (_investMoney >= min){
                rate = [[dict objectForKey:@"details"] floatValue] + orignRate;
                _actID = [dict objectForKey:@"id"];
            }
        }
    }
    return rate;
}

- (float)calculatorEarn{
    double  repay_lixi	= 0;
    if(repaymentType == 1){
        borrowDurateion = 1;			//如果还款类型是按天限制为1
    }
    //年利利率设置
    if(repaymentType==1||repaymentType==4){
        rate= rate/365;				//将年利率转化成天利率 ，按365天计算
    }else{
        rate =rate/12;				//将年利率转化成月利率，按12个月计算
    }
    for(int number=1;number<= borrowDurateion;number++){
        if(repaymentType==1)	{
            repay_lixi+= (rate/100*_investMoney* borrowDurateion);
        }else if(repaymentType==4|| repaymentType==3){
            repay_lixi+=(rate/100*_investMoney);
        }else if(repaymentType==2){
            double lilv_month= rate/100;
            double monthMoney= [self getMonthMoney:lilv_month];
            double monthLixi = [self get_month_lixi:lilv_month :monthMoney :number];
            repay_lixi += monthLixi;

        }
    }
    NSLOG(@"计算出来的利息:%.2f",repay_lixi);
    return repay_lixi;
}

- (double)get_month_lixi:(double)monthRate :(double)monthMoney :(NSInteger)number{
    return (_investMoney* monthRate- monthMoney)*[self math_cube:1+monthRate power:number-1]+monthMoney;
}

- (double)math_cube:(double)cardinalNum power:(double)power{
    double sum = 1;
    for (int i = 0; i<power ; i++){
        sum = sum *cardinalNum;
    }
    return sum;
}

@end
