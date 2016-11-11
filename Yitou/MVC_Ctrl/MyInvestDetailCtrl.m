//
//  MyInvestDetailCtrl.m
//  Yitou
//
//  Created by Xiaohui on 15/11/20.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import "MyInvestDetailCtrl.h"
#import "contractVC.h"
#define CELLHeight   (SCREENHeight>481?45:41.55)

@interface MyInvestDetailCtrl ()

@end

@implementation MyInvestDetailCtrl{
    float   orignY;
    UIScrollView *scrollview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看明细";
    [self loadScrollview];
    [self loadAllView];
    if (self.isReceivingInvest) {
        [self loadContractItem];
    }
}

- (void)loadScrollview{
    scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
    [self.view addSubview:scrollview];
}

- (void)loadAllView{
    orignY = 0;
    [self loadTitle:@"借款标题" content:[_dataSource objectForKey:@"borrow_title"]];
    [self loadTitle:@"借款时间" content:[self getTime:[_dataSource objectForKey:@"income_submittime"]]];
    [self loadTitle:@"还款时间" content:[self getTime:[_dataSource objectForKey:@"income_overdue_time"]]];
    NSString *lilv = [_dataSource objectForKey:@"borrow_lilv"];
    lilv = [lilv stringByAppendingString:@"%"];
    [self loadTitle:@"年利率" content:lilv];
    [self loadTitle:@"期数" content:[_dataSource objectForKey:@"allnumber"]];
    [self loadTitle:@"投标总金额" content:[NSString stringWithFormat:@"¥%@",[_dataSource objectForKey:@"invest_money"]]];
    [self loadTitle:@"应收本金" content:[NSString stringWithFormat:@"¥%@",[_dataSource objectForKey:@"income_principal"]]];
    [self loadTitle:@"应收利息" content:[_dataSource objectForKey:@"income_interest"]];
    [self loadTitle:@"投资奖励" content:[_dataSource objectForKey:@"income_prize"]];
    [self loadTitle:@"居间费" content:[_dataSource objectForKey:@"income_fee"]];
    [self loadTitle:@"实收利息" content:[_dataSource objectForKey:@"income_real_interest"]];
}

- (NSString *)getTime:(NSString *)timeStr{
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    return [[timeStr componentsSeparatedByString:@" "] objectAtIndex:0];
}

- (void)loadTitle:(NSString *)title content:(NSString *)text{
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, CELLHeight)];
    [baseView setBackgroundColor:[UIColor whiteColor]];
    [scrollview addSubview:baseView];
    orignY = VIEWFH_Y(baseView);

    UILabel *lfLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREENWidth/2, CELLHeight)];
    [lfLb setTextAlignment:NSTextAlignmentLeft];
    [lfLb setFont:[UIFont systemFontOfSize:16]];
    [lfLb setTextColor:[UIColor blackColor]];
    [lfLb setText:title];
    [baseView addSubview:lfLb];

    UILabel *rtLb = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, SCREENWidth - 120, CELLHeight)];
    [rtLb setTextAlignment:NSTextAlignmentRight];
    [rtLb setFont:[UIFont systemFontOfSize:16]];
    [rtLb setTextColor:[UIColor grayColor]];
    [rtLb setText:text];
    [baseView addSubview:rtLb];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CELLHeight-1, SCREENWidth, 1)];
    [line setBackgroundColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:0.86]];
    [baseView addSubview:line];

    [scrollview setContentSize:CGSizeMake(SCREENWidth, VIEWFH_Y(baseView))];
}

- (void)loadContractItem {
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, CELLHeight)];
    [baseView setBackgroundColor:[UIColor whiteColor]];
    [scrollview addSubview:baseView];
    orignY = VIEWFH_Y(baseView);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewContract)];
    [baseView addGestureRecognizer:tap];
    
    UILabel *lfLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREENWidth/2, CELLHeight)];
    [lfLb setTextAlignment:NSTextAlignmentLeft];
    [lfLb setFont:[UIFont systemFontOfSize:16]];
    [lfLb setTextColor:[UIColor blackColor]];
    [lfLb setText:@"查看合同"];
    [baseView addSubview:lfLb];
    
    UILabel *rtLb = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, SCREENWidth - 120, CELLHeight)];
    [rtLb setTextAlignment:NSTextAlignmentRight];
    [rtLb setFont:[UIFont systemFontOfSize:16]];
    [rtLb setTextColor:[UIColor blueColor]];
    [rtLb setText:@"查看"];
    [baseView addSubview:rtLb];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CELLHeight-1, SCREENWidth, 1)];
    [line setBackgroundColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:0.86]];
    [baseView addSubview:line];
    
    [scrollview setContentSize:CGSizeMake(SCREENWidth, VIEWFH_Y(baseView))];
}

- (void)viewContract {
    ContractVC *cvc = [[ContractVC alloc] init];
    cvc.dataSource = _dataSource;
    cvc.title = @"查看合同";
    [self.navigationController pushViewController:cvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
