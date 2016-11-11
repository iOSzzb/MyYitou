//
//  MineTopView.m
//  Yitou
//
//  Created by Xiaohui on 15/8/4.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "MineTopView.h"

@implementation MineTopView{
    UserModel *userModel;
    UIImageView *imgvUserHead;
    UILabel *lbEarnCount;
    UILabel *lbExistMoney;
    UILabel *lbWaitInterest;
    UIButton *earnButton;
    float whiteLineH;
    TouchIndexBlock block;
}

- (void)loadObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadNewHead:) name:@"didDownloadUserHead" object:nil];
}

- (void)downloadNewHead:(NSNotification *)note{
    dispatch_async(dispatch_get_main_queue(), ^{
        [imgvUserHead setImage:[UIImage imageWithContentsOfFile:note.object]];
    });
}

- (void)loadTopViewInfo{
    if (!userModel.isLogin){
        lbWaitInterest.text = @"￥0.00";
        lbEarnCount.text = @"0.00";
        lbExistMoney.text = @"0.00";
        return;
    }
    lbEarnCount.text = [userModel.didEarn length]>2?userModel.didEarn:@"0.00";
    lbWaitInterest.text = [userModel.waitInterest length]>2?[@"￥" stringByAppendingString:userModel.waitInterest]:@"￥0.00";
    lbExistMoney.text = [userModel.balance length]>2?userModel.balance:@"0.00";
}

- (void)loadAllViewWithBlock:(TouchIndexBlock)blocks{
    userModel = [UserModel shareUserManager];
    block = blocks;
    whiteLineH = SCREENWidth*211/1244;
    UIImageView *imgv = [[UIImageView alloc]initWithFrame:self.frame];
    [imgv setImage:IMAGENAMED(@"MineTopBackground")];
    [self addSubview:imgv];
    [self loadObserver];
    [self loadTopLabel];
    [self loadUserHeadImgv];
    [self loadOtherLabel];
    [self loadEarnMoneyButton];
}

- (void)loadEarnMoneyButton{
    float orignY = VIEWFSH(lbWaitInterest) + VIEWFOY(lbWaitInterest);
    float existH = VIEWFSH(self) - orignY;
    existH = (existH -  30)/2;
    orignY += existH;
    earnButton = [[UIButton alloc]initWithFrame:CGRectMake((SCREENWidth-SCREENWidth/1.4)/2, orignY, SCREENWidth/1.4, 30)];
    [earnButton setBackgroundColor:COLORWithRGB(4, 127, 228, 1)];
    [earnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [earnButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];

    [earnButton.layer setMasksToBounds:YES];
    [earnButton.layer setCornerRadius:VIEWFSH(earnButton)/2];

    [earnButton setTitle:@"立即投标" forState:UIControlStateNormal];
    [earnButton.titleLabel setFont:[UIFont fontWithName:SYSTEMFONTName size:20]];
    [earnButton addTarget:self action:@selector(clickEarnButton:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:earnButton];
}

- (void)clickEarnButton:(id)sender{
    block(0);
}

- (void)loadOtherLabel{
    float orignY = VIEWFSH(self)/2;
    UILabel *lbMsgEarnDay = [[UILabel alloc]initWithFrame:CGRectMake(10, orignY, SCREENWidth - 10, 16)];
    [lbMsgEarnDay setText:@"待收收益"];
    [lbMsgEarnDay setTextAlignment:NSTextAlignmentCenter];
    [lbMsgEarnDay setFont:[UIFont fontWithName:SYSTEMFONTName size:12]];
    [lbMsgEarnDay setTextColor:[UIColor whiteColor]];
    [self addSubview:lbMsgEarnDay];

    orignY += VIEWFSH(lbMsgEarnDay);
    orignY += 5;
    lbWaitInterest = [[UILabel alloc]initWithFrame:CGRectMake(0, orignY, SCREENWidth, 32)];

    NSString *money = userModel.isLogin?[@"￥" stringByAppendingString:userModel.waitInterest]:@"￥0.00";
    [lbWaitInterest setText:money];

    [lbWaitInterest setTextAlignment:NSTextAlignmentCenter];
    [lbWaitInterest setFont:[UIFont fontWithName:SYSTEMFONTName size:32]];
    [lbWaitInterest setTextColor:[UIColor whiteColor]];
    [self addSubview:lbWaitInterest];
}

- (void)loadUserHeadImgv{
    float imgvWidth = 60;
    imgvUserHead = [[UIImageView alloc]initWithFrame:CGRectMake((SCREENWidth-imgvWidth)/2, whiteLineH - imgvWidth/2, imgvWidth, imgvWidth)];
    [imgvUserHead setImage:IMAGENAMED(@"DefaultHead")];
    [imgvUserHead.layer setMasksToBounds:YES];
    [imgvUserHead.layer setCornerRadius:imgvWidth/2];
    [self addSubview:imgvUserHead];
    _headFrame = imgvUserHead.frame;

    UIButton *btn = [[UIButton alloc] initWithFrame:imgvUserHead.frame];
    [btn setTag:10];
    [btn setBackgroundColor:[UIColor clearColor]];
    [self addSubview:btn];

    UITapGestureRecognizer *longPress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserHead:)];
    [btn addGestureRecognizer:longPress];
    if (userModel.isLogin&&[userModel.userHead length]>10){
        NSString *imgPath = NSHomeDirectory();
        imgPath = [imgPath stringByAppendingPathComponent:@"Documents"];
        imgPath = [imgPath stringByAppendingPathComponent:[userModel.userHead lastPathComponent]];
        if (CHECKFileExist(imgPath))
            [imgvUserHead setImage:[UIImage imageWithContentsOfFile:imgPath]];
    }
}

- (void)clickUserHead:(id)sender{
    block(10);
}

- (void)loadUserHead:(NSString *)imgPath{
    NSLOG(@"%@",imgPath);
    if (imgPath == nil)
        [imgvUserHead setImage:IMAGENAMED(@"DefaultHead")];
    else
        [imgvUserHead setImage:[UIImage imageWithContentsOfFile:imgPath]];
}

-(void)loadTopLabel{

    UILabel *lbMsgEarnCount;

    lbMsgEarnCount = [[UILabel alloc]initWithFrame:CGRectMake(0, whiteLineH-18, SCREENWidth/2-30, 16)];
    [lbMsgEarnCount setText:@"累计收益"];
    [lbMsgEarnCount setTextAlignment:NSTextAlignmentCenter];
    [lbMsgEarnCount setFont:[UIFont fontWithName:SYSTEMFONTName size:12]];
    [lbMsgEarnCount setTextColor:[UIColor whiteColor]];
    [self addSubview:lbMsgEarnCount];

    lbEarnCount = [[UILabel alloc]initWithFrame:CGRectMake(0, whiteLineH+2, SCREENWidth/2-30, 24)];
    [lbEarnCount setText:@"0.00"];
    [lbEarnCount setTextAlignment:NSTextAlignmentCenter];
    [lbEarnCount setFont:[UIFont fontWithName:SYSTEMFONTName size:22]];
    [lbEarnCount setTextColor:[UIColor whiteColor]];
    [self addSubview:lbEarnCount];

    UILabel *lbMsgExistMoney;

    lbMsgExistMoney = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWidth/2+30, whiteLineH-18, SCREENWidth/2-30, 16)];
    [lbMsgExistMoney setText:@"可用余额"];
    [lbMsgExistMoney setTextAlignment:NSTextAlignmentCenter];
    [lbMsgExistMoney setFont:[UIFont fontWithName:SYSTEMFONTName size:12]];
    [lbMsgExistMoney setTextColor:[UIColor whiteColor]];
    [self addSubview:lbMsgExistMoney];

    lbExistMoney = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWidth/2+30, whiteLineH+2, SCREENWidth/2-30, 24)];
    [lbExistMoney setText:@"0.00"];
    [lbExistMoney setTextAlignment:NSTextAlignmentCenter];
    [lbExistMoney setFont:[UIFont fontWithName:SYSTEMFONTName size:22]];
    [lbExistMoney setTextColor:[UIColor whiteColor]];
    [self addSubview:lbExistMoney];
}

@end
