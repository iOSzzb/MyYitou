//
//  AQCenterCtrl.m
//  Yitou
//
//  Created by Xiaohui on 15/9/10.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "AQCenterCtrl.h"
#import "UpdataPasswordCtrl.h"
#import "UpdateMobileCtrl.h"
#import "UpdateEmailCtrl.h"
#import "BankListCtrl.h"
#import "WebViewCtrl.h"
#import "GesturePwdCtrl.h"

#define CELLHeight      45

@interface AQCenterCtrl ()

@end

@implementation AQCenterCtrl{
    float orignY;
    NSInteger indx;
    UIButton *selectBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BG_BLUEColor];
    self.title = @"安全中心";
    [self loadAllView];
}

- (void)loadAllView{
    orignY = 80;
    indx = 0;
    NSString *status;

    [self loadViewWithImgName:@"icon_aq_0" title:@"我的汇付" status:@">"];
    [self loadViewWithImgName:@"icon_aq_1" title:@"我的银行卡" status:@"添加/删除>"];
    [self loadViewWithImgName:@"icon_aq_2" title:@"登录密码" status:@"修改>"];
    [self loadViewWithImgName:@"icon_aq_3" title:@"手势密码" status:@"修改>"];
    [self loadViewWithImgName:@"icon_aq_4" title:@"我的手机" status:@"修改>"];
    status = [[UserModel shareUserManager].userEmail length]>3?@"修改>":@"设置>";
    [self loadViewWithImgName:@"icon_aq_5" title:@"我的邮箱" status:status];

    [self loadLogoutBtn];
}

- (void)loadLogoutBtn{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, orignY+20, SCREENWidth - 20, 40)];
    [btn setBackgroundColor:[UIColor colorWithRed:0.16 green:0.54 blue:0.88 alpha:1]];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickLogoutBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)clickLogoutBtn{
    UserModel *usrModel =[UserModel shareUserManager];
    [usrModel logout];
    USERDefineSet(@"0", KEY_USER_isLogin);
    [usrModel logout];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadViewWithImgName:(NSString *)imgName title:(NSString *)title status:(NSString *)status{
    UIButton *baseView = [[UIButton alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, CELLHeight)];
    [baseView setBackgroundColor:[UIColor whiteColor]];
    UIImageView *imgv = [[UIImageView alloc] initWithImage:IMAGENAMED(imgName)];
    [imgv setFrame:CGRectMake(20, 10, CELLHeight-20, CELLHeight - 20)];
    [baseView addSubview:imgv];

    UILabel *titleLB = [FastFactory loadLabelWith:NSTextAlignmentLeft Frame:CGRectMake(VIEWFW_X(imgv)+4, 0, [title length]*19, CELLHeight) TextColor:[UIColor blackColor] fontSize:18 ];
    titleLB.text = title;
    [baseView addSubview:titleLB];

    UILabel *statusLB = [FastFactory loadLabelWith:NSTextAlignmentRight Frame:CGRectMake(0, 0, SCREENWidth-15, CELLHeight) TextColor:COLORWithRGB(154, 154, 154, 1) fontSize:14];
    statusLB.text = status;
    [baseView addSubview:statusLB];

    [baseView setTag:indx];
    indx ++;
    [baseView addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:baseView];
    orignY = VIEWFH_Y(baseView)+8;
    if (STRCMP(title, @"我的汇付")){
        UILabel *hfName = [FastFactory loadLabelWith:NSTextAlignmentLeft Frame:CGRectMake(VIEWFW_X(titleLB)+5, 0, 140, VIEWFSH(baseView)) TextColor:[UIColor grayColor] fontSize:13];
        [hfName setText:[UserModel shareUserManager].hfAccount];
        [baseView addSubview:hfName];
        NSLOG(@"%@",hfName.text);
        if ([hfName.text length] <3)
            hfName.text = @"未开通";
    }
}

- (void)clickButton:(id)btn{
    selectBtn = btn;
    [btn setBackgroundColor:self.view.backgroundColor];
    [self performSelector:@selector(changeColorForBtn:) withObject:nil afterDelay:0.2];

    indx = [btn tag];

    if (indx == 0){
        UserModel *usrModel = [UserModel shareUserManager];
        NSDictionary *para = @{@"client_id":KEY_CLIENTID,@"user_name":usrModel.userName,@"password":usrModel.password};
        para = @{@"cmdid":@"login_user_chinapnr",@"data":para};
        [SVProgressHUD showWithStatus:@"正在获取汇付账户信息" maskType:SVProgressHUDMaskTypeBlack];
        [HttpManager hmRequestWithPara:para Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
            if (rqCode != rqSuccess){
                [SVProgressHUD showErrorWithStatus:describle];
                return ;
            }
            [SVProgressHUD dismiss];
            NSString *url = [[receiveData objectForKey:@"data"] objectForKey:@"r_url"];
            WebViewCtrl *webCtrl = [[WebViewCtrl alloc] init];
            [webCtrl setUrl:url];
            [webCtrl setName:@"我的汇付"];
            [self.navigationController pushViewController:webCtrl animated:YES];
        }];
    }
    if (indx == 1){
        BankListCtrl *bankList = [[BankListCtrl alloc] init];
        [self.navigationController pushViewController:bankList animated:YES];
    }//银行卡
    if (indx == 2){
        UpdataPasswordCtrl *updatePwd = [[UpdataPasswordCtrl alloc] init];
        [self.navigationController pushViewController:updatePwd animated:YES];
    }
    if (indx == 3){
        GesturePwdCtrl *gesturePwd = [[GesturePwdCtrl alloc] init];
        [self.navigationController pushViewController:gesturePwd animated:YES];
    }
    if (indx == 4){
        UpdateMobileCtrl *updateMobile = [[UpdateMobileCtrl alloc] init];
        [self.navigationController pushViewController:updateMobile animated:YES];
    }
    if (indx == 5){
        UpdateEmailCtrl *emailCtrl = [[UpdateEmailCtrl alloc] init];
        [self.navigationController pushViewController:emailCtrl animated:YES];
    }
}

- (void)changeColorForBtn:(UIButton *)btn{
    [selectBtn setBackgroundColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
