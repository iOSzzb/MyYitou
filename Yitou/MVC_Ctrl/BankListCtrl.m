//
//  BankListCtrl.m
//  Yitou
//
//  Created by Xiaohui on 15/9/15.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "BankListCtrl.h"

#import "WebViewCtrl.h"
#import "BankCell.h"
#import "BankCardDetailCtrl.h"

#define CELLHeight      70

@interface BankListCtrl ()

@end

@implementation BankListCtrl{
    UIButton    *addBtn;
    NSArray     *dataSource;
    UserModel   *usrModel;
    float       orignY;
    UIScrollView *scrollview;
    CustomNavigation *customNav;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BG_BLUEColor];
    self.title = @"银行卡管理";
    usrModel = [UserModel shareUserManager];
    [self loadAllView];
}

- (void)loadAllView{
    scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREENWidth, SCREENHeight)];
    [scrollview setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:scrollview];

    addBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 15, 170, 35)];
    [addBtn addTarget:self action:@selector(clickAddCardBtn) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [imgv setImage:IMAGENAMED(@"update_add")];
    [addBtn addSubview:imgv];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(VIEWFW_X(imgv)+20, 0, 120, VIEWFSH(addBtn))];
    [lb setText:@"添加银行卡"];
    [lb setTextColor:COLORWithRGB(49, 139, 222, 1)];
    [lb setTextAlignment:NSTextAlignmentLeft];
    [addBtn addSubview:lb];
    [scrollview addSubview:addBtn];
}

- (void)clickAddCardBtn{
    usrModel = [UserModel shareUserManager];
    NSMutableDictionary *paraDict = [NSMutableDictionary new];
    [paraDict setObject:@"user_bind_bank" forKey:@"cmdid"];
    [paraDict setObject:@{@"client_id":KEY_CLIENTID,@"user_name":usrModel.userName,@"password":usrModel.password} forKey:@"data"];

    [HttpManager hmRequestWithPara:paraDict Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {

        if (rqCode != rqSuccess){
            [SVProgressHUD showErrorWithStatus:describle];
            return ;
        }
        [self loadWebBrowerWithUrl:[[receiveData objectForKey:@"data"] objectForKey:@"r_url"]];
    }];
}

- (void)loadWebBrowerWithUrl:(NSString *)urlStr{
    WebViewCtrl *webBrower = [[WebViewCtrl alloc] init];
    [webBrower setUrl:urlStr];
    [webBrower setName:@"绑定银行卡"];
    [self.navigationController pushViewController:webBrower animated:YES];
}

- (void)requestData{
    NSMutableDictionary *paraDict = [NSMutableDictionary new];
    [paraDict setObject:@"bank_card_list" forKey:@"cmdid"];
    [paraDict setObject:@{@"client_id":KEY_CLIENTID,@"type":@"update",@"user_name":usrModel.userName,@"password":usrModel.password} forKey:@"data"];

    [HttpManager hmRequestWithPara:paraDict Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        if (rqCode != rqSuccess) {
            [SVProgressHUD showErrorWithStatus:describle];
            return ;
        }
        dataSource = [[NSArray alloc] initWithArray:[receiveData objectForKey:@"data"]];
        [self reloadBankList];
    }];
}

- (void)reloadBankList{
    [scrollview removeFromSuperview];
    [addBtn removeFromSuperview];
    scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREENWidth, SCREENHeight)];
    [scrollview setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:scrollview];
    [scrollview addSubview:addBtn];
    if ([dataSource count] == 0){
        [SVProgressHUD showErrorWithStatus:@"当前未绑定银行卡或者绑定的银行卡还在审核"];
        return;
    }
    orignY = 15;
    NSInteger indx = 0;
    for (NSDictionary *dict in dataSource){
        BankCell *bankCell = [[BankCell alloc] initWithFrame:CGRectMake(15, orignY, SCREENWidth-30, CELLHeight)];
        [bankCell setDataSource:dict];
        [bankCell loadBankCell];
        [bankCell setTag:indx];
        [bankCell addTarget:self action:@selector(clickBankCard:) forControlEvents:UIControlEventTouchUpInside];
        [bankCell setBackgroundImage:IMAGENAMED(@"login_btn_bg") forState:UIControlStateHighlighted];
        [scrollview addSubview:bankCell];
        orignY = VIEWFH_Y(bankCell)+15;
        indx ++;
    }
    [addBtn setFrame:CGRectMake(VIEWFOX(addBtn), orignY, VIEWFSW(addBtn), VIEWFSH(addBtn))];
    [scrollview setContentSize:CGSizeMake(0, VIEWFH_Y(addBtn))];
}

- (void)clickBankCard:(id)sender{
    BankCardDetailCtrl *cardCtrl = [[BankCardDetailCtrl alloc] init];
    cardCtrl.dataSource = [dataSource objectAtIndex:[sender tag]];

    [self.navigationController pushViewController:cardCtrl animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
