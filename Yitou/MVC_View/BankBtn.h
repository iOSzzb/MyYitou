//
//  BankBtn.h
//  Yitou
//
//  Created by Xiaohui on 15/8/21.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankBtn : UIButton

@property (nonatomic,copy)NSString *bankCode;//银行代号

@property (nonatomic,copy)NSString *bsCode;//业务代号

@property (nonatomic,copy)NSString *bankName;//银行名

- (void)setBankCode:(NSString *)bankCode_ andBusinessCode:(NSString *)bsCode_ bankName:(NSString *)bankName_;

@end
