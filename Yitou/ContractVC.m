//
//  contractVC.m
//  Yitou
//
//  Created by 张振波 on 2016/10/12.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "ContractVC.h"

@interface ContractVC ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *contractNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *borrowNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *borrowIdNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *borrowMobeleLabel;
@property (weak, nonatomic) IBOutlet UILabel *borrowAddress;
@property (weak, nonatomic) IBOutlet UILabel *investNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *investIdNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *investMobileLabel;




@end

@implementation ContractVC {
    //    "contract_no" ;合同编号：
    //    "borrow_name" ;甲方 借款人 ：
    //    "borrow_idnumber" ;身份证号码：
    //    "borrow_mobile" ;"联系电话：
    //    "bororw_address" ;联系地址：
    //    "invest_name" ;乙方 出借人 ：
    //    "invest_idnumber" ;"身份证号码：
    //    "invest_mobile" ;"联系电话： "
    //    "words_invest_money" ;"（大写）："
    //    "invest_money" ;"（小写）："
    //    "borrow_duration_string" ;借款期限
    //    "borrow_start_date" ;借款起始日
    //    "borrow_start_end" ;借款终止日
    //    "borrow_use" ;// 借款用途
    //    "repayment_type" ;// "\t3、还款方式：" + repayment_type还款方式
    //    "borrow_basics_lilv" ;// 借款月利率   + "%"
    NSString *contract_no;
    NSString *borrow_name;
    NSString *borrow_idnumber;
    NSString *borrow_mobile;
    NSString *bororw_address;
    NSString *invest_name;
    NSString *invest_idnumber;
    NSString *invest_mobile;
    NSString *words_invest_money;
    NSString *invest_money;
    NSString *borrow_duration_string;
    NSString *borrow_start_date;
    NSString *borrow_start_end;
    NSString *borrow_use;
    NSString *repayment_type;
    NSString *borrow_basics_lilv;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [leftBtn setImage:IMAGENAMED(@"nav_back") forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftItemClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    for (int i = 101; i <= 106; i++) {
        UILabel *label = [self.view viewWithTag:i];
        label.layer.borderColor = [UIColor blackColor].CGColor;
        label.layer.borderWidth = 1;
    }
    for (int i = 201; i <= 206; i++) {
        UILabel *label = [self.view viewWithTag:i];
        label.layer.borderColor = [UIColor blackColor].CGColor;
        label.layer.borderWidth = 1;
    }
    if (!self.isDemo) {
        [SVProgressHUD showWithStatus:@"正在加载"];
        [self.bgView setHidden:YES];
        [self fetchData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftItemClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)fetchData {
    UserModel *usrModel = [UserModel shareUserManager];
    NSString *ordId = _dataSource[@"income_invest_ordid"];
    NSString *borrowId = _dataSource[@"borrowid"];
    if (ordId == nil || borrowId == nil) {
        return;
    }
    NSDictionary *dict1 = @{@"client_id":KEY_CLIENTID,@"user_name":usrModel.userName,@"password":usrModel.password,@"ord_id":ordId,@"borrow_id":borrowId};
    NSDictionary *para = @{@"cmdid":@"borrow_contract_info",
                           @"data":dict1,
                           };
    [HttpManager hmRequestWithPara:para Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        if (rqCode != rqSuccess){
            [SVProgressHUD showErrorWithStatus:describle];
            return ;
        }
        NSDictionary *info = [receiveData objectForKey:@"borrow_info"];
        if (([[receiveData objectForKey:@"is_borrow"] integerValue] == 0)) {
            contract_no = receiveData[@"contract_no"];
            borrow_name = info[@"borrow_name"];
            borrow_idnumber = info[@"borrow_idnumber"];
            borrow_mobile = info[@"borrow_mobile"];
            bororw_address = info[@"bororw_address"];
            invest_name = info[@"invest_name"];
            invest_idnumber = info[@"invest_idnumber"];
            invest_mobile = info[@"invest_mobile"];
            words_invest_money = info[@"words_invest_money"];
            invest_money = info[@"invest_money"];
            borrow_duration_string = info[@"borrow_duration_string"];
            borrow_start_date = info[@"borrow_start_date"];
            borrow_start_end = info[@"borrow_start_end"];
            borrow_use = info[@"borrow_use"];
            repayment_type = info[@"repayment_type"];
            borrow_basics_lilv = [NSString stringWithFormat:@"%0.2f",[[info objectForKey:@"borrow_basics_lilv"] floatValue]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateLabelText];
                [SVProgressHUD dismiss];
                [self.bgView setHidden:NO];
            });
        }
        
    }];
}

- (void)updateLabelText {
    self.contractNoLabel.text = [NSString stringWithFormat:@"合同编号：%@",contract_no];
    self.borrowNameLabel.text = [NSString stringWithFormat:@"甲方(借款人):%@",borrow_name];
    self.borrowIdNoLabel.text = [NSString stringWithFormat:@"身份证号码:%@",borrow_idnumber];
    self.borrowMobeleLabel.text = [NSString stringWithFormat:@"联系电话：%@",borrow_mobile];
    self.investNameLabel.text = [NSString stringWithFormat:@"乙方(出借人)：%@",invest_name];
    self.investIdNoLabel.text = [NSString stringWithFormat:@"身份证号码：%@",invest_idnumber];
    self.investMobileLabel.text = [NSString stringWithFormat:@"联系电话：%@",invest_mobile];
    UILabel *daxiaoxie = [self.view viewWithTag:201];
    daxiaoxie.text = [NSString stringWithFormat:@"大写：%@\n\n小写%@",words_invest_money,invest_money];
    UILabel *durationLabel = [self.view viewWithTag:202];
    durationLabel.text = borrow_duration_string;
    UILabel *startDateLabel = [self.view viewWithTag:203];
    startDateLabel.text = borrow_start_date;
    UILabel *endDateLabel = [self.view viewWithTag:204];
    endDateLabel.text = borrow_start_end;
    UILabel *useLabel = [self.view viewWithTag:206];
    useLabel.text = borrow_use;
    
}


@end
