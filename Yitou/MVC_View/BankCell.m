//
//  BankCell.m
//  Yitou
//
//  Created by Xiaohui on 15/9/16.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "BankCell.h"

@implementation BankCell{
    float orignX;
    UIColor *titleColor;
    UIColor *numColor;
}

- (void)loadBankCell{
    [self setBackgroundColor:[UIColor whiteColor]];
    [self getColorWithBankCode:[_dataSource objectForKey:@"bankname"]];
    [self loadBankLogo];
    [self loadLabel];
    [self loadRightImgv];
}

- (void)loadRightImgv{
    float imgY = VIEWFSH(self) - 20;
    imgY /= 2;
    UIImageView *rightImgv = [[UIImageView alloc]initWithFrame:CGRectMake(VIEWFSW(self)-20, imgY, 7, 20)];
    [rightImgv setImage:IMAGENAMED(@"towerRight")];
    [self addSubview:rightImgv];
}

- (void)loadLabel{
    UILabel *bankNameLB = [FastFactory loadLabelWith:NSTextAlignmentLeft Frame:CGRectMake(orignX+10, 16, 120, 20) TextColor:titleColor fontSize:20];
    [bankNameLB setText:[_dataSource objectForKey:@"bankname_unit"]];
    [self addSubview:bankNameLB];

    UILabel *numLB = [FastFactory loadLabelWith:NSTextAlignmentLeft Frame:CGRectMake(orignX+10, 42, 120, 20) TextColor:numColor fontSize:14];
    NSString *numStr = [_dataSource objectForKey:@"cardnumber"];
    numStr = [numStr substringFromIndex:[numStr length]-4];
    numStr = [NSString stringWithFormat:@"尾号%@",numStr];
    [numLB setText:numStr];
    [self addSubview:numLB];
}

- (void)loadBankLogo{
    float imgH = 51;
    float imgY = VIEWFSH(self);
    imgY = imgY -imgH;
    imgY /= 2;
    NSString *imgName = [@"bankCode_" stringByAppendingString:[_dataSource objectForKey:@"bankname"]];
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(10, imgY, 69, 51)];
    [imgv setImage:IMAGENAMED(imgName)];
    [self addSubview:imgv];
    orignX = VIEWFW_X(imgv);
}

- (void)getColorWithBankCode:(NSString *)bankCode{
    titleColor = [UIColor blackColor];
    numColor = [UIColor grayColor];
    if (STRCMP(bankCode, @"ABC")){
        titleColor = [UIColor colorWithRed:0 green:0.57 blue:0.43 alpha:1];
        numColor = [UIColor colorWithRed:0 green:0.57 blue:0.43 alpha:0.78];
//        return @"农业银行";
    }
    if (STRCMP(bankCode, @"BOC")){
        titleColor = [UIColor colorWithRed:0.64 green:0 blue:0.11 alpha:1];
        numColor = [UIColor colorWithRed:0.64 green:0 blue:0.11 alpha:0.78];
    }
    if (STRCMP(bankCode, @"BOCOM")){
//        return @"交通银行";
        titleColor = [UIColor colorWithRed:0 green:0.23 blue:0.47 alpha:1];
        numColor = [UIColor colorWithRed:0 green:0.23 blue:0.47 alpha:0.78];
    }
    if (STRCMP(bankCode, @"BOS")){
//        return @"上海银行";
        titleColor = [UIColor colorWithRed:0.02 green:0.34 blue:0.65 alpha:1];
        numColor = [UIColor colorWithRed:0.02 green:0.34 blue:0.65 alpha:0.78];
    }
    if (STRCMP(bankCode, @"CBHB")){
//        return @"渤海银行";
        titleColor = [UIColor colorWithRed:0.01 green:0.26 blue:0.56 alpha:1];
        numColor = [UIColor colorWithRed:0.01 green:0.26 blue:0.56 alpha:0.78];
    }
    if (STRCMP(bankCode, @"CCB")){
        titleColor = [UIColor colorWithRed:0.03 green:0.21 blue:0.56 alpha:1];
        numColor = [UIColor colorWithRed:0.03 green:0.21 blue:0.56 alpha:0.78];
    }
    if (STRCMP(bankCode, @"CEB")){
//        return @"光大银行";
        titleColor = [UIColor colorWithRed:0.38 green:0.11 blue:0.45 alpha:1];
        numColor = [UIColor colorWithRed:0.38 green:0.11 blue:0.45 alpha:0.78];
    }
    if (STRCMP(bankCode, @"CIB")){
//        return @"兴业银行";
        titleColor = [UIColor colorWithRed:0 green:0.25 blue:0.53 alpha:1];
        numColor = [UIColor colorWithRed:0 green:0.25 blue:0.53 alpha:0.78];
    }
    if (STRCMP(bankCode, @"CITIC")){
//        return @"中信银行";
        titleColor = [UIColor colorWithRed:0.77 green:0.15 blue:0.11 alpha:1];
        numColor = [UIColor colorWithRed:0.77 green:0.15 blue:0.11 alpha:0.78];
    }
    if (STRCMP(bankCode, @"CMB")){
//        return @"招商银行";
        titleColor = [UIColor colorWithRed:0.78 green:0.08 blue:0.18 alpha:1];
        numColor = [UIColor colorWithRed:0.78 green:0.08 blue:0.18 alpha:0.78];
    }
    if (STRCMP(bankCode, @"CMBC")){
//        return @"民生银行";
        titleColor = [UIColor colorWithRed:0 green:0.6 blue:0.35 alpha:1];
        numColor = [UIColor colorWithRed:0 green:0.6 blue:0.35 alpha:0.78];
    }
    if (STRCMP(bankCode, @"ICBC")){
//        return @"工商银行";
        titleColor = [UIColor colorWithRed:0.66 green:0.11 blue:0.16 alpha:1];
        numColor = [UIColor colorWithRed:0.66 green:0.11 blue:0.16 alpha:0.78];
    }
    if (STRCMP(bankCode, @"PINGAN")){
        titleColor = [UIColor colorWithRed:0.92 green:0.27 blue:0 alpha:1];
        numColor =[UIColor colorWithRed:0.92 green:0.27 blue:0 alpha:0.78];
//        return @"平安银行";
    }
    if (STRCMP(bankCode, @"PSBC")){
        titleColor = [UIColor colorWithRed:0 green:0.57 blue:0.25 alpha:1];
        numColor = [UIColor colorWithRed:0 green:0.57 blue:0.25 alpha:0.78];
//        return @"邮政储蓄银行";
    }
    if (STRCMP(bankCode, @"SPDB")){
//        return @"浦发银行";
        titleColor = [UIColor colorWithRed:0.01 green:0.22 blue:0.48 alpha:1];
        numColor = [UIColor colorWithRed:0.01 green:0.22 blue:0.48 alpha:0.78];
    }
}

@end
