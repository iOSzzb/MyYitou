//
//  BankCardDetailCtrl.m
//  Yitou
//
//  Created by Xiaohui on 15/9/16.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "BankCardDetailCtrl.h"

@implementation BankCardDetailCtrl{
    float   orignY;
    CustomNavigation *customNav;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:BG_BLUEColor];
    self.title = @"银行卡管理";
    [self loadAllView];
}

- (void)loadAllView{
    orignY = 75;
    NSString *cardNum =[_dataSource objectForKey:@"cardnumber"];
    NSString *bankNum = [cardNum substringToIndex:4];
    bankNum = [NSString stringWithFormat:@"%@****%@",bankNum,[cardNum substringFromIndex:[cardNum length] - 4]];

    [self loadTitle:@"银行卡号" andValue:bankNum];
    [self loadTitle:@"银行卡状态" andValue:[_dataSource objectForKey:@"bankstatus_unit"]];
    [self loadTitle:@"开户名" andValue:[_dataSource objectForKey:@"real_name"]];
    [self loadTitle:@"所在地" andValue:[_dataSource objectForKey:@"provname"]];
    [self loadTitle:@"开户行" andValue:[_dataSource objectForKey:@"bankname_unit"]];
    [self loadTitle:@"实名认证" andValue:@"已认证"];
    [self loadButton];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadButton{
    orignY += 16;
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWidth/6, orignY, SCREENWidth/3*2, 40)];
    [loginBtn setBackgroundColor:[UIColor redColor]];
    [loginBtn setTitle:@"删除银行卡" forState:UIControlStateNormal];
    [loginBtn setTitleColor:COLORWithRGB(62, 158, 245, 1) forState:UIControlStateHighlighted];
    [self.view addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(clickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickDeleteButton:(id)sender{
    UserModel *usrModel = [UserModel shareUserManager];
    NSMutableDictionary *paraDict = [NSMutableDictionary new];
    [paraDict setObject:@"drop_bank_card" forKey:@"cmdid"];
    [paraDict setObject:@{@"client_id":KEY_CLIENTID,@"bank_card_id":[_dataSource objectForKey:@"cardnumber"],@"user_name":usrModel.userName,@"password":usrModel.password} forKey:@"data"];

    [HttpManager hmRequestWithPara:paraDict Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        if (rqCode != rqSuccess) {
            [SVProgressHUD showErrorWithStatus:describle];
            return ;
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"删除成功" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];
    }];
}

- (void)loadTitle:(NSString *)title andValue:(NSString *)values{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, 45)];
    [view setBackgroundColor:[UIColor whiteColor]];
    UILabel *lfLB = [FastFactory loadLabelWith:NSTextAlignmentLeft Frame:CGRectMake(10, 0, SCREENWidth/2, VIEWFSH(view)) TextColor:[UIColor blackColor] fontSize:16];
    lfLB.text = title;
    [view addSubview:lfLB];

    UILabel *rtLB = [FastFactory loadLabelWith:NSTextAlignmentRight Frame:CGRectMake(SCREENWidth/2, 0, SCREENWidth/2-10, VIEWFSH(view)) TextColor:[UIColor blackColor] fontSize:16];
    rtLB.text = values;
    [view addSubview:rtLB];
    [self.view addSubview:view];
    orignY = VIEWFH_Y(view)+2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
