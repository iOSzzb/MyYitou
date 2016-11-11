//
//  BankBtn.m
//  Yitou
//
//  Created by Xiaohui on 15/8/21.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "BankBtn.h"

@implementation BankBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setBankCode:(NSString *)bankCode_ andBusinessCode:(NSString *)bsCode_ bankName:(NSString *)bankName_{
    _bankCode = bankCode_;
    _bsCode = bsCode_;
    _bankName = bankName_;
}

@end
