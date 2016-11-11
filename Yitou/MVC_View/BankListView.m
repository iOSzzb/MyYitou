//
//  BankListView.m
//  Yitou
//
//  Created by Xiaohui on 15/8/20.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "BankListView.h"
#import "TextCell.h"

@implementation BankListView{
    NSMutableArray *viewArray;
    UIButton    *cardDepost;
    UIButton    *cardFast;
    UIView      *listView;
    TextCell *bankName;
    TextCell *nameText;
    TextCell *accountText;
    TextCell *HFAccountText;
    BOOL    isLoaded;
}

- (void)loadBankList{
    isLoaded = NO;
    [self loadButton];
}

- (void)loadButton{
    float btnHeight = SCREENWidth/2*146/621;
    cardFast = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWidth/2, 10, SCREENWidth/2, btnHeight)];
    [cardFast addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cardFast];

    cardDepost = [[UIButton alloc] initWithFrame:CGRectMake(0, VIEWFOY(cardFast), SCREENWidth/2, btnHeight)];
    [cardDepost addTarget:self action:@selector(clickLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cardDepost];

    [cardDepost setTitle:@"借记卡" forState:UIControlStateNormal];
    [cardFast setTitle:@"快捷充值卡" forState:UIControlStateNormal];

    [cardFast.titleLabel setFont:[UIFont fontWithName:SYSTEMFONTName size:12]];
    [cardDepost.titleLabel setFont:[UIFont fontWithName:SYSTEMFONTName size:12]];
    [self clickRightBtn];
    isLoaded = YES;
}

- (void)clickLeftBtn{
    [cardDepost setBackgroundImage:IMAGENAMED(@"recharge_bg2") forState:UIControlStateNormal];
    [cardFast setBackgroundImage:IMAGENAMED(@"recharge_bg1") forState:UIControlStateNormal];
    [self loadSaveList];
    [self sendDelegate];
    [self loadUserInfo:_viewHeight+10];

    if ([_delegate respondsToSelector:@selector(bankListChangeHeight)]&& isLoaded)
        [_delegate bankListChangeHeight];
}

- (void)clickRightBtn{
    [cardDepost setBackgroundImage:IMAGENAMED(@"recharge_bg1") forState:UIControlStateNormal];
    [cardFast setBackgroundImage:IMAGENAMED(@"recharge_bg2") forState:UIControlStateNormal];
    [self loadFastList];
    [self sendDelegate];
    [self loadUserInfo:_viewHeight];
    if ([_delegate respondsToSelector:@selector(bankListChangeHeight)] && isLoaded)
        [_delegate bankListChangeHeight];
}

- (void)loadSaveList{
    [listView removeFromSuperview];
    listView = nil;
    listView = [[UIView alloc] initWithFrame:CGRectMake(0, VIEWFH_Y(cardDepost), SCREENWidth, VIEWFSH(self)- VIEWFH_Y(cardDepost)-10)];
    [listView setBackgroundColor:[UIColor clearColor]];

    [self addSubview:listView];
    [self loadSaveCardList];
}

- (void)loadFastList{
    [listView removeFromSuperview];
    listView = nil;
    listView = [[UIView alloc] initWithFrame:CGRectMake(0, VIEWFH_Y(cardDepost), SCREENWidth, VIEWFSH(self)- VIEWFH_Y(cardDepost)-10)];
    [listView setBackgroundColor:[UIColor clearColor]];

    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREENWidth, 14)];
    [topLabel setText:@"不需要开通银联在线支付"];
    [topLabel setTextColor:COLORWithRGB(85, 85, 85, 1)];
    [topLabel setFont:[UIFont fontWithName:SYSTEMFONTName size:12]];
    [topLabel setTextAlignment:NSTextAlignmentCenter];
    [listView addSubview:topLabel];
    [self addSubview:listView];
    [self loadFastBank1:VIEWFH_Y(topLabel)];
}

- (void)loadUserInfo:(float)orignY{
    [bankName removeFromSuperview];
    [nameText removeFromSuperview];
    [accountText removeFromSuperview];
    [HFAccountText removeFromSuperview];

    bankName = [[TextCell alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, 35)];
    [bankName loadCellWithContent:@"银行名称: 未选择"];
    [self addSubview:bankName];
    orignY = VIEWFH_Y(bankName)-1;

    UserModel *usrModel = [UserModel shareUserManager];
    nameText = [[TextCell alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, 35)];
    [nameText loadCellWithContent:[NSString stringWithFormat:@"真实姓名:%@",usrModel.hfRealName]];
    [self addSubview:nameText];
    orignY = VIEWFH_Y(nameText)-1;

    accountText = [[TextCell alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, 35)];
    [accountText loadCellWithContent:[NSString stringWithFormat:@"账号:%@",usrModel.hfUserName]];
    [self addSubview:accountText];
    orignY = VIEWFH_Y(accountText)-1;

    HFAccountText = [[TextCell alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, 35)];
    [HFAccountText loadCellWithContent:[NSString stringWithFormat:@"汇付天下账号:%@",usrModel.hfAccount]];
    [self addSubview:HFAccountText];
    orignY = VIEWFH_Y(HFAccountText)-1;
    _viewHeight = orignY;
}

- (void)loadFastBank1:(float)orignY{
    orignY += 10;
    float btnWidth = SCREENWidth/2;
    btnWidth -= 20;
    float btnHeight = btnWidth*136/547;
    _bank = nil;

    BankBtn *bank01 = [[BankBtn alloc] initWithFrame:CGRectMake(10, orignY, btnWidth, btnHeight)];
    [bank01 setTag:1];
    [bank01 setBackgroundImage:IMAGENAMED(@"logo_bank_11") forState:UIControlStateNormal];
    [listView addSubview:bank01];

    BankBtn *bank02 = [[BankBtn alloc] initWithFrame:CGRectMake(SCREENWidth/2+10, orignY, btnWidth, btnHeight)];
    [bank02 setTag:2];
    [bank02 setBackgroundImage:IMAGENAMED(@"logo_bank_12") forState:UIControlStateNormal];
    [listView addSubview:bank02];

    orignY = VIEWFH_Y(bank01)+10;

    BankBtn *bank03 = [[BankBtn alloc] initWithFrame:CGRectMake(10, orignY, btnWidth, btnHeight)];
    [bank03 setTag:3];
    [bank03 setBackgroundImage:IMAGENAMED(@"logo_bank_02") forState:UIControlStateNormal];
    [listView addSubview:bank03];

    BankBtn *bank04 = [[BankBtn alloc] initWithFrame:CGRectMake(SCREENWidth/2+10, orignY, btnWidth, btnHeight)];
    [bank04 setTag:4];
    [bank04 setBackgroundImage:IMAGENAMED(@"logo_bank_03") forState:UIControlStateNormal];
    [listView addSubview:bank04];

    orignY = VIEWFH_Y(bank04)+10;

    BankBtn *bank05 = [[BankBtn alloc] initWithFrame:CGRectMake(10, orignY, btnWidth, btnHeight)];
    [bank05 setTag:5];
    [bank05 setBackgroundImage:IMAGENAMED(@"logo_bank_04") forState:UIControlStateNormal];
    [listView addSubview:bank05];

    BankBtn *bank06 = [[BankBtn alloc] initWithFrame:CGRectMake(SCREENWidth/2+10, orignY, btnWidth, btnHeight)];
    [bank06 setTag:6];
    [bank06 setBackgroundImage:IMAGENAMED(@"logo_bank_05") forState:UIControlStateNormal];
    [listView addSubview:bank06];
    
    orignY = VIEWFH_Y(bank06)+10;
    
    BankBtn *bank001 = [[BankBtn alloc] initWithFrame:CGRectMake(10, orignY, btnWidth, btnHeight)];
    [bank001 setTag:7];
    [bank001 setBackgroundImage:IMAGENAMED(@"logo_bank_00") forState:UIControlStateNormal];
    [listView addSubview:bank001];
    
    BankBtn *bank002 = [[BankBtn alloc] initWithFrame:CGRectMake(SCREENWidth/2+10, orignY, btnWidth, btnHeight)];
    [bank002 setTag:8];
    [bank002 setBackgroundImage:IMAGENAMED(@"logo_bank_01") forState:UIControlStateNormal];
    [listView addSubview:bank002];
    
    orignY = VIEWFH_Y(bank002)+10;
    
    BankBtn *bank003 = [[BankBtn alloc] initWithFrame:CGRectMake(10, orignY, btnWidth, btnHeight)];
    [bank003 setTag:9];
    [bank003 setBackgroundImage:IMAGENAMED(@"logo_bank_06") forState:UIControlStateNormal];
    [listView addSubview:bank003];
    
    BankBtn *bank004 = [[BankBtn alloc] initWithFrame:CGRectMake(SCREENWidth/2+10, orignY, btnWidth, btnHeight)];
    [bank004 setTag:10];
    [bank004 setBackgroundImage:IMAGENAMED(@"logo_bank_13") forState:UIControlStateNormal];
    [listView addSubview:bank004];
    
    orignY = VIEWFH_Y(bank004)+10;
    
    BankBtn *bank005 = [[BankBtn alloc] initWithFrame:CGRectMake(10, orignY, btnWidth, btnHeight)];
    [bank005 setTag:11];
    [bank005 setBackgroundImage:IMAGENAMED(@"logo_bank_14") forState:UIControlStateNormal];
    [listView addSubview:bank005];

    orignY = VIEWFH_Y(bank005)+40;

    UILabel *centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, orignY-25, SCREENWidth, 14)];
    [centerLabel setText:@"需要开通银联在线支付"];
    [centerLabel setTextColor:COLORWithRGB(85, 85, 85, 1)];
    [centerLabel setFont:[UIFont fontWithName:SYSTEMFONTName size:12]];
    [centerLabel setTextAlignment:NSTextAlignmentCenter];
    [listView addSubview:centerLabel];
    
    BankBtn *bank11 = [[BankBtn alloc] initWithFrame:CGRectMake(10, orignY, btnWidth, btnHeight)];
    [bank11 setTag:12];
    [bank11 setBackgroundImage:IMAGENAMED(@"logo_bank_10") forState:UIControlStateNormal];
    [listView addSubview:bank11];

    BankBtn *bank08 = [[BankBtn alloc] initWithFrame:CGRectMake(SCREENWidth/2+10, orignY, btnWidth, btnHeight)];
    [bank08 setTag:13];
    [bank08 setBackgroundImage:IMAGENAMED(@"logo_bank_07") forState:UIControlStateNormal];
    [listView addSubview:bank08];

    orignY = VIEWFH_Y(bank08)+10;

    BankBtn *bank09 = [[BankBtn alloc] initWithFrame:CGRectMake(10, orignY, btnWidth, btnHeight)];
    [bank09 setTag:14];
    [bank09 setBackgroundImage:IMAGENAMED(@"logo_bank_08") forState:UIControlStateNormal];
    [listView addSubview:bank09];

    BankBtn *bank10 = [[BankBtn alloc] initWithFrame:CGRectMake(SCREENWidth/2+10, orignY, btnWidth, btnHeight)];
    [bank10 setTag:15];
    [bank10 setBackgroundImage:IMAGENAMED(@"logo_bank_09") forState:UIControlStateNormal];
    [listView addSubview:bank10];


    [bank01 addTarget:self action:@selector(clickFastPayButton:) forControlEvents:UIControlEventTouchUpInside];
    [bank02 addTarget:self action:@selector(clickFastPayButton:) forControlEvents:UIControlEventTouchUpInside];
    [bank03 addTarget:self action:@selector(clickFastPayButton:) forControlEvents:UIControlEventTouchUpInside];
    [bank04 addTarget:self action:@selector(clickFastPayButton:) forControlEvents:UIControlEventTouchUpInside];
    [bank05 addTarget:self action:@selector(clickFastPayButton:) forControlEvents:UIControlEventTouchUpInside];
    [bank06 addTarget:self action:@selector(clickFastPayButton:) forControlEvents:UIControlEventTouchUpInside];
//    [bank07 addTarget:self action:@selector(clickFastPayButton:) forControlEvents:UIControlEventTouchUpInside];
    [bank08 addTarget:self action:@selector(clickFastPayButton:) forControlEvents:UIControlEventTouchUpInside];
    [bank09 addTarget:self action:@selector(clickFastPayButton:) forControlEvents:UIControlEventTouchUpInside];
    [bank10 addTarget:self action:@selector(clickFastPayButton:) forControlEvents:UIControlEventTouchUpInside];
    [bank11 addTarget:self action:@selector(clickFastPayButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //-----2016.6.1
    [bank001 addTarget:self action:@selector(clickFastPayButton:) forControlEvents:UIControlEventTouchUpInside];
    [bank002 addTarget:self action:@selector(clickFastPayButton:) forControlEvents:UIControlEventTouchUpInside];
    [bank003 addTarget:self action:@selector(clickFastPayButton:) forControlEvents:UIControlEventTouchUpInside];
    [bank004 addTarget:self action:@selector(clickFastPayButton:) forControlEvents:UIControlEventTouchUpInside];
    [bank005 addTarget:self action:@selector(clickFastPayButton:) forControlEvents:UIControlEventTouchUpInside];


    [bank01 setBankCode:@"ABC" andBusinessCode:@"QP" bankName:@"中国农业银行"];
    [bank02 setBankCode:@"CCB" andBusinessCode:@"QP" bankName:@"中国建设银行"];
    [bank03 setBankCode:@"BOC" andBusinessCode:@"QP" bankName:@"中国银行"];
    [bank04 setBankCode:@"CEB" andBusinessCode:@"QP" bankName:@"中国光大银行"];
    [bank05 setBankCode:@"CIB" andBusinessCode:@"QP" bankName:@"兴业银行"];
    [bank06 setBankCode:@"CITIC" andBusinessCode:@"QP" bankName:@"中信银行"];
//    [bank07 setBankCode:@"PINGAN" andBusinessCode:@"QP" bankName:@"平安银行"];
    [bank08 setBankCode:@"BOS" andBusinessCode:@"QP" bankName:@"上海银行"];
    [bank09 setBankCode:@"CBHB" andBusinessCode:@"QP" bankName:@"渤海银行"];
    [bank10 setBankCode:@"PSBC" andBusinessCode:@"QP" bankName:@"中国邮政储蓄银行"];
    [bank11 setBankCode:@"SPDB" andBusinessCode:@"QP" bankName:@"浦发银行"];
    
    //----2016.6.1
    [bank001 setBankCode:@"ICBC" andBusinessCode:@"QP" bankName:@"中国工商银行"];
    [bank002 setBankCode:@"CMB" andBusinessCode:@"QP" bankName:@"招商银行"];
    [bank003 setBankCode:@"PINGAN" andBusinessCode:@"QP" bankName:@"平安银行"];
    [bank004 setBankCode:@"CMBC" andBusinessCode:@"QP" bankName:@"中国民生银行"];
    [bank005 setBankCode:@"BOCOM" andBusinessCode:@"QP" bankName:@"交通银行"];


    [listView setFrame:CGRectMake(VIEWFOX(listView), VIEWFOY(listView), VIEWFSW(listView), VIEWFH_Y(bank10)+10+VIEWFSH(bank10)+10)];
    _viewHeight = VIEWFH_Y(listView);
    _viewHeight -= VIEWFSH(bank10);

}

- (void)loadSaveCardList{
    int gap = 20;
    float orignY = gap;
    float rightOrignX = SCREENWidth/2+10;
    float btnWidth = SCREENWidth/2;
    btnWidth -= 20;
    _bank = nil;
    float btnHeight = btnWidth*136/547;

    BankBtn *bank03 = [[BankBtn alloc] initWithFrame:CGRectMake(10, orignY, btnWidth, btnHeight)];
    [bank03 setBackgroundImage:IMAGENAMED(@"logo_bank_12") forState:UIControlStateNormal];
    [listView addSubview:bank03];

    BankBtn *bank04 = [[BankBtn alloc] initWithFrame:CGRectMake(rightOrignX, orignY, btnWidth, btnHeight)];
    [bank04 setBackgroundImage:IMAGENAMED(@"logo_bank_01") forState:UIControlStateNormal];
    [listView addSubview:bank04];

    orignY = VIEWFH_Y(bank03) + gap;

//    BankBtn *bank07 = [[BankBtn alloc] initWithFrame:CGRectMake(10, orignY, btnWidth, btnHeight)];
//    [bank07 setTag:7];
//    [bank07 setBackgroundImage:IMAGENAMED(@"logo_bank_14") forState:UIControlStateNormal];
//    [listView addSubview:bank07];
    
    BankBtn *bank05 = [[BankBtn alloc] initWithFrame:CGRectMake(10, orignY, btnWidth, btnHeight)];
    [bank05 setBackgroundImage:IMAGENAMED(@"logo_bank_10") forState:UIControlStateNormal];
    [listView addSubview:bank05];

    BankBtn *bank11 = [[BankBtn alloc] initWithFrame:CGRectMake(rightOrignX, orignY, btnWidth, btnHeight)];
    [bank11 setBackgroundImage:IMAGENAMED(@"logo_bank_07") forState:UIControlStateNormal];
    [listView addSubview:bank11];

    orignY = VIEWFH_Y(bank05) + gap;

    BankBtn *bank01 = [[BankBtn alloc] initWithFrame:CGRectMake(10, orignY, btnWidth, btnHeight)];
    [bank01 setBackgroundImage:IMAGENAMED(@"logo_bank_02") forState:UIControlStateNormal];
    [listView addSubview:bank01];
    
    BankBtn *bank06 = [[BankBtn alloc] initWithFrame:CGRectMake(rightOrignX, orignY, btnWidth, btnHeight)];
    [bank06 setBackgroundImage:IMAGENAMED(@"logo_bank_04") forState:UIControlStateNormal];
    [listView addSubview:bank06];

//    BankBtn *bank02 = [[BankBtn alloc] initWithFrame:CGRectMake(rightOrignX, orignY, btnWidth, btnHeight)];
//    [bank02 setTag:11];
//    [bank02 setBackgroundImage:IMAGENAMED(@"logo_bank_03") forState:UIControlStateNormal];
//    [listView addSubview:bank02];
//
    orignY = VIEWFH_Y(bank01) + gap;
    
    BankBtn *bank001 = [[BankBtn alloc] initWithFrame:CGRectMake(10, orignY, btnWidth, btnHeight)];
    [bank001 setBackgroundImage:IMAGENAMED(@"logo_bank_03") forState:UIControlStateNormal];
    [listView addSubview:bank001];
    
    BankBtn *bank003 = [[BankBtn alloc] initWithFrame:CGRectMake(rightOrignX, orignY, btnWidth, btnHeight)];
    [bank003 setBackgroundImage:IMAGENAMED(@"logo_bank_09") forState:UIControlStateNormal];
    [listView addSubview:bank003];
    



    [bank01 addTarget:self action:@selector(clickSaveCardButton:) forControlEvents:UIControlEventTouchUpInside];
//    [bank02 addTarget:self action:@selector(clickSaveCardButton:) forControlEvents:UIControlEventTouchUpInside];
    [bank03 addTarget:self action:@selector(clickSaveCardButton:) forControlEvents:UIControlEventTouchUpInside];
    [bank04 addTarget:self action:@selector(clickSaveCardButton:) forControlEvents:UIControlEventTouchUpInside];
    [bank05 addTarget:self action:@selector(clickSaveCardButton:) forControlEvents:UIControlEventTouchUpInside];
    [bank06 addTarget:self action:@selector(clickSaveCardButton:) forControlEvents:UIControlEventTouchUpInside];
//    [bank07 addTarget:self action:@selector(clickSaveCardButton:) forControlEvents:UIControlEventTouchUpInside];
    [bank11 addTarget:self action:@selector(clickSaveCardButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //-----2016.6.1
    [bank001 addTarget:self action:@selector(clickSaveCardButton:) forControlEvents:UIControlEventTouchUpInside];
    [bank003 addTarget:self action:@selector(clickSaveCardButton:) forControlEvents:UIControlEventTouchUpInside];

    [bank01 setBankCode:@"BOC" andBusinessCode:@"B2C" bankName:@"中国银行"];
//    [bank02 setBankCode:@"CEB" andBusinessCode:@"B2C" bankName:@"中国光大银行"];
    [bank03 setBankCode:@"CCB" andBusinessCode:@"B2C" bankName:@"建设银行"];
    [bank04 setBankCode:@"CMB" andBusinessCode:@"B2C" bankName:@"招商银行"];
    [bank05 setBankCode:@"SPDB" andBusinessCode:@"B2C" bankName:@"浦发银行"];
    [bank06 setBankCode:@"CIB" andBusinessCode:@"B2C" bankName:@"兴业银行"];
//    [bank07 setBankCode:@"BOCOM" andBusinessCode:@"B2C" bankName:@"交通银行"];
    [bank11 setBankCode:@"BOS" andBusinessCode:@"B2C" bankName:@"上海银行"];
    
    [bank001 setBankCode:@"CEB" andBusinessCode:@"B2C" bankName:@"中国光大银行"];
    [bank003 setBankCode:@"PSBC" andBusinessCode:@"B2C" bankName:@"中国邮政储蓄银行"];

    [listView setFrame:CGRectMake(VIEWFOX(listView), VIEWFOY(listView), VIEWFSW(listView), VIEWFH_Y(bank003)+10)];
    _viewHeight = VIEWFH_Y(listView);
}

- (void)removeMarkAndAddMark:(BankBtn*)newObj{
    [_bank.layer setBorderWidth:0];
    [newObj.layer setBorderWidth:1.0];
    [newObj.layer setBorderColor:[COLORWithRGB(42, 138, 225, 1) CGColor]];
}

- (void)clickSaveCardButton:(id)sender{
    [self removeMarkAndAddMark:sender];
    _bank= sender;
    [self sendDelegate];
    
    [bankName loadCellWithContent:[NSString stringWithFormat:@"银行名称:%@",_bank.bankName]];
    NSLOG(@"%@__%@__%@",_bank.bankName,_bank.bankCode,_bank.bsCode);
}

- (void)clickFastPayButton:(id)sender{
    [self removeMarkAndAddMark:sender];
    _bank= sender;
    [self sendDelegate];
    [bankName loadCellWithContent:[NSString stringWithFormat:@"银行名称:%@",_bank.bankName]];
    NSLOG(@"%@__%@__%@",_bank.bankName,_bank.bankCode,_bank.bsCode);
}

- (void)sendDelegate{
    if ([_delegate respondsToSelector:@selector(bankListChangedBank)]){
        [_delegate bankListChangedBank];
    }
}

@end
