//
//  TenderView.m
//  Yitou
//
//  Created by mac on 16/2/17.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "TenderView.h"

@implementation TenderView{
    UILabel *lbProductName;  //产品名称
    UILabel *lbProductReturn;//收益回报
    UILabel *lbProductSum;   //借款总额
    UILabel *lbProductTime;  //还款时间
    float   offX;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self loadAllView];
    }
    return self;
}

- (void)loadAllView{
    offX = VIEWFSW(self) - SCREENWidth;
    offX /= 2;
    [self loadtenderView];
}

- (void)setTender:(Tender *)tender{
    if (tender == nil){
        lbProductName.text = @"";
        lbProductSum.text = @"";
        lbProductTime.text = @"";
        lbProductReturn.text = @"";
    }
    else{
        lbProductName.text = tender.title;
        lbProductSum.text = [NSString stringWithFormat:@"%@%@",tender.tenderSum,tender.tenderSumUnit];
        lbProductTime.text = [NSString stringWithFormat:@"%@%@",tender.timeCount,tender.timeCountUnit];
        NSString *str = [tender.maxEarn length]>0?tender.maxEarn:tender.minEarn;
        str = [str stringByAppendingString:@"%"];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];
        [attri addAttribute:NSForegroundColorAttributeName value:COLORWithRGB(13, 161, 255, 1) range:NSMakeRange(0, [str length])];
        [attri addAttribute:NSFontAttributeName value:[UIFont fontWithName:SYSTEMFONTName size:42] range:NSMakeRange(0, [str length]-1)];
        [lbProductReturn setTextAlignment:NSTextAlignmentCenter];
        lbProductReturn.attributedText = attri;
    }
}

//标的信息页
- (void)loadtenderView{
    float adHeight = SCREENWidth*257/410;

    [self setBackgroundColor:[UIColor clearColor]];

    UIImageView *circle = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, VIEWFSW(self), VIEWFSH(self))];
    [circle setImage:IMAGENAMED(@"homePageRound")];
    [self addSubview:circle];

    adHeight = adHeight*8/39;

    lbProductName = [[UILabel alloc]initWithFrame:CGRectMake(10+offX, (adHeight-20)/2 + 4, VIEWFSW(self), 20)];
    [lbProductName setText:@"汽车抵押贷SZDB20151011"];
    [lbProductName setFont:[UIFont fontWithName:SYSTEMFONTName size:14]];
    [self addSubview:lbProductName];

    lbProductReturn = [[UILabel alloc]initWithFrame:CGRectMake((SCREENWidth)/2-80+offX, VIEWFSH(self)/2, 160, 40)];

    [self addSubview:lbProductReturn];

    [self loadProductData];
    [self loadProductMessage];
}

//加载标信息页的 投资总额 期限 最高年化收益 三个Label
- (void)loadProductMessage{
    UILabel *proSum = [[UILabel alloc]initWithFrame:CGRectMake(10+offX, VIEWFOY(lbProductSum)+VIEWFSH(lbProductSum)+4, VIEWFSW(lbProductSum), 16)];
    [proSum setText:@"投资总额(元)"];
    [proSum setFont:[UIFont fontWithName:SYSTEMFONTName size:12]];
    [self addSubview:proSum];

    UILabel *proDay = [[UILabel alloc]initWithFrame:CGRectMake(0, VIEWFOY(proSum), VIEWFSW(self) - offX - 10, VIEWFSH(proSum))];
    [proDay setText:@"期限"];
    [proDay setFont:proSum.font];
    [proDay setTextAlignment:NSTextAlignmentRight];
    [self addSubview:proDay];

    UILabel *proReturnMsg = [[UILabel alloc]initWithFrame:CGRectMake(0, VIEWFOY(lbProductReturn)+VIEWFSH(lbProductReturn)+15, VIEWFSW(self), 16)];
    [proReturnMsg setText:@"年化收益"];//cw 原来是 最高年化收益
    [proReturnMsg setTextAlignment:NSTextAlignmentCenter];
    [proReturnMsg setFont:[UIFont fontWithName:SYSTEMFONTName size:13]];
    [self addSubview:proReturnMsg];
}

//加载标信息页的 投资总额数据 期限数据 两个Label
- (void)loadProductData{
    UIColor *blueColor = COLORWithRGB(14, 161, 255, 1.0);
    float adHeight = SCREENWidth*257/410;
    if (SCREENWidth >320){
        adHeight *= 1.1;
    }
    adHeight = adHeight*71/195;

    lbProductSum = [[UILabel alloc]initWithFrame:CGRectMake(10+offX, VIEWFSH(self) - (adHeight + 20)/2, 140, 20)];
    [lbProductSum setText:@"18万"];
    [lbProductSum setTextColor:blueColor];
    [self addSubview:lbProductSum];

    lbProductTime = [[UILabel alloc]initWithFrame:CGRectMake(0+offX, VIEWFOY(lbProductSum), SCREENWidth-10, VIEWFSH(lbProductSum))];
    [lbProductTime setText:@"30天"];
    [lbProductTime setFont:lbProductSum.font];
    [lbProductTime setTextColor:lbProductSum.textColor];
    [lbProductTime setTextAlignment:NSTextAlignmentRight];
    [self addSubview:lbProductTime];
}

@end
