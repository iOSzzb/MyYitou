//
//  UserCenterCtrl.m
//  Yitou
//
//  Created by Xiaohui on 15/7/28.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "UserCenterCtrl.h"
#import "MineTopView.h"
#import "LoginCtrl.h"
#import "MineCenterView.h"
#import "MineTableView.h"
#import "RechargeCtrl.h"
#import "WithdrawCtrl.h"
#import "MoneyRecordCtrl.h"
#import "AQCenterCtrl.h"
#import "SetAndHelpCtrl.h"
#import "MyInvestRecordCtrl.h"
#import "MyBoxCtrl.h"
#import "MyMessageCtrl.h"
#import <AFNetworking.h>
#import <UIImageView+AFNetworking.h>
#import "MyIntegralCtrl.h"
#import "WebBrower.h"
#import "DataInvestCtrl.h"

@interface UserCenterCtrl ()<UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic)MineTopView *topView;
@property (nonatomic)WebBrower *webBrower;
@property (nonatomic)NSString *tempUrl;
@property (nonatomic)UserModel *userModel;

@end

@implementation UserCenterCtrl{
    UIButton *loginBtn;
    MineCenterView *centerView;
    MineTableView *tableView;
    UIScrollView *scrollView;
    UIView   *webTool;
}

@synthesize topView,tempUrl,userModel,webBrower;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    if (userModel.isLogin){
        __weak typeof(self) weakSelf = self;
        [HttpManager getUserInformationByUserName:userModel.userName pwd:userModel.password Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
            if (rqCode == rqSuccess){
                NSLOG(@"获取用户信息成功");
                [weakSelf.topView loadTopViewInfo];
            }
            else
                [SVProgressHUD showErrorWithStatus:describle];
        }];
    }else{
        [self performSelector:@selector(pushToUnLoginView) withObject:nil afterDelay:0.2];
    }
    if ([userModel.userHead length]<5||!userModel.isLogin){
        [topView loadUserHead:nil];
        [topView loadTopViewInfo];
    }
    [webBrower removeFromSuperview];
    [self loadUnreadMsg];
}

- (void)pushToUnLoginView{
    LoginCtrl *login = [[LoginCtrl alloc] initWithNibName:@"LoginCtrl" bundle:nil];
    [login setHidesBottomBarWhenPushed:NO];
    [self.navigationController pushViewController:login animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    userModel = [UserModel shareUserManager];
    [self loadAllView];
}

#pragma mark 加载界面

- (void)loadAllView{
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -20, SCREENWidth, SCREENHeight- self.tabBarController.tabBar.frame.size.height+20)];
    [scrollView setBackgroundColor:COLORWithRGB(221, 241, 248, 1.0)];
    [scrollView setDelaysContentTouches:NO];
    [self.view addSubview:scrollView];
    [self loadTopView];
    [self loadCenterView];
    [self loadTableView];
}

- (void)loadTableView{
    NSArray *dataAry = [NSArray arrayWithObjects:@"我的投资",@"我要预约",@"站内信息",@"安全中心",@"我的积分",@"我的益宝箱",@"问题与帮助", nil];

    tableView = [[MineTableView alloc]initWithFrame:CGRectMake(0, VIEWFSH(centerView)+VIEWFOY(centerView)+10, SCREENWidth, dataAry.count*45)];
    tableView.cellHeight = 45;
    tableView.tableData = dataAry;

    __weak typeof(self) weakSelf = self;
    [tableView loadAllViewWithBlock:^(int index) {
        [weakSelf tableViewDidSelectAtIndex:index];
    }];
    [scrollView addSubview:tableView];
    [scrollView setContentSize:CGSizeMake(0, VIEWFSH(tableView)+VIEWFOY(tableView))];
    [scrollView setShowsVerticalScrollIndicator:NO];
}

- (void)loadTopView{
    float height = SCREENWidth*206/311;
    topView = [[MineTopView alloc]initWithFrame:CGRectMake(0, 0, SCREENWidth, height)];
    __weak typeof(self) weakSelf = self;
    [topView loadAllViewWithBlock:^(int index) {
        if (index == 0)
            [weakSelf clickTopButton:index];
        if (index == 10)
            [weakSelf loadChangeUserHead];
    }];
    [topView setUserInteractionEnabled:YES];
    [scrollView addSubview:topView];
}

- (void)loadCenterView{
    float height = SCREENWidth/10;
    centerView = [[MineCenterView alloc]initWithFrame:CGRectMake(20, VIEWFSH(topView)+10, SCREENWidth-40, height)];
    __weak typeof(self) weakSelf = self;
    [centerView loadAllViewWithBlock:^(int index) {
        [weakSelf clickCenterButtonAtIndex:index];
    }];
    [scrollView addSubview:centerView];
}

#pragma mark 交互事件

- (void)tableViewDidSelectAtIndex:(int)index{
    switch (index) {
        case 0:{
            MyInvestRecordCtrl *myInvest = [[MyInvestRecordCtrl alloc] init];
            [myInvest setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:myInvest animated:YES];
            break;
        }
        case 1:{
            DataInvestCtrl *dataCtrl = [[DataInvestCtrl alloc] init];
            [dataCtrl setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:dataCtrl animated:YES];
            break;
        }
        case 2:{
            MyMessageCtrl *myMsg = [[MyMessageCtrl alloc] init];
            [myMsg setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:myMsg animated:YES];
            break;
        }
        case 3:{
            AQCenterCtrl *aqCtrl = [[AQCenterCtrl alloc]init];
            [aqCtrl setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:aqCtrl animated:YES];
            break;
        }
        case 4:{
            MyIntegralCtrl *integral = [[MyIntegralCtrl alloc] init];
            [integral setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:integral animated:YES];
            break;
        }
        case 5:{
            MyBoxCtrl *myBox = [[MyBoxCtrl alloc] init];
            [myBox setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:myBox animated:YES];
            break;
        }
        case 6:{
            SetAndHelpCtrl *setCtrl = [[SetAndHelpCtrl alloc] init];
            [setCtrl setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:setCtrl animated:YES];
            break;
        }
        default:break;
    }
}

- (void)clickCenterButtonAtIndex:(NSInteger)indx{
    if (indx == 0){
        [HttpManager userMarkWithUsrID:userModel.userID Block:^(RequestResult rqCode, NSString *describle, NSString *msgCode) {
            if (rqCode == 0){
                [SVProgressHUD showSuccessWithStatus:msgCode];
            }
            else
                [SVProgressHUD showErrorWithStatus:describle];
        }];
    }
    if (indx == 1){//充值
        [SVProgressHUD showWithStatus:@"正在加载数据" maskType:SVProgressHUDMaskTypeBlack];
        __weak typeof(self) weakSelf = self;
        [HttpManager getHFInformationWithUserName:userModel.userName pwd:userModel.password Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
            [SVProgressHUD dismiss];
            if (rqCode != rqSuccess){
                [SVProgressHUD showErrorWithStatus:describle];
                return ;
            }

            NSInteger result = [[receiveData objectForKey:@"result_code"] integerValue];
            [SVProgressHUD dismiss];
            if (result == 0){
                [weakSelf clickPayBtn:receiveData];
            }
            else if (result == 58){
                weakSelf.tempUrl = [[receiveData objectForKey:@"data"] objectForKey:@"r_url"];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法充值" message:@"请先在汇付天下开户后才能进行充值" delegate:weakSelf cancelButtonTitle:@"先不充值" otherButtonTitles:@"立即开户", nil];
                [alertView setTag:1024];
                [alertView show];
            }
        }];
    }
    if (indx == 2){//提现
        WithdrawCtrl *withdraw = [[WithdrawCtrl alloc] initWithNibName:nil bundle:nil];
        [withdraw setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:withdraw animated:YES];
    }
    if (indx == 3){ //明细
        MoneyRecordCtrl *moneyRecord = [[MoneyRecordCtrl alloc] init];
        [moneyRecord setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:moneyRecord animated:YES];
    }
}

- (void)clickCloseWebview{
    [webTool removeFromSuperview];
    [webBrower removeFromSuperview];
    webBrower = nil;
    webTool = nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView tag] == 1024){//汇付开户提示
        if (buttonIndex == 1){
            webTool = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 64)];
            [webTool setBackgroundColor:NAVIGATIONColor];
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 80, 44)];
            [btn addTarget:self action:@selector(clickCloseWebview) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:@"关闭" forState:UIControlStateNormal];
            [self.view addSubview:webTool];
            [webTool addSubview:btn];
            webBrower = [[WebBrower alloc]initWithFrame:CGRectMake(0, 64, SCREENWidth, SCREENHeight-50-64)];
            __weak typeof(self) weakSelf = self;
            [webBrower loadWebBrowerWithPostStr:tempUrl andBlock:^(NSInteger rtCode, NSString *newUrlStr) {
                NSString *desc;
                if (rtCode == 0){
                    desc = @"注册成功";
                }
                if (rtCode == 11){
                    desc = @"注册失败";
                }
                [weakSelf.webBrower removeFromSuperview];
                weakSelf.webBrower = nil;
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:desc delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alertView show];
            }];
            [weakSelf.view addSubview:weakSelf.webBrower];
        }
    }
}

- (void)clickPayBtn:(NSDictionary *)HFInfo{
    RechargeCtrl *rech = [[RechargeCtrl alloc] initWithNibName:nil bundle:nil];
    rech.HFData = HFInfo;
    [rech setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:rech animated:YES];
}

- (void)clickTopButton:(int)indx{
    if (indx == 0){
        [self.tabBarController setSelectedIndex:YES];
    }
    else if (indx == 1){
        [self pushToLoginView];
    }
}

- (void)pushToLoginView{
    LoginCtrl *login = [[LoginCtrl alloc] initWithNibName:@"LoginCtrl" bundle:nil];
    [login setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:login animated:YES];
}

#pragma mark 更改头像

- (void)loadChangeUserHead{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"更改头像" message:@"选择照片来源" preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    UIAlertAction *newImgActon = [UIAlertAction actionWithTitle:@"拍照获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf loadImageWithChangeType:UIImagePickerControllerSourceTypeCamera];

    }];
    UIAlertAction *selectActon = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf loadImageWithChangeType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];

    UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.userModel logout];
        [weakSelf viewWillAppear:YES];
    }];

    [alert addAction:newImgActon];
    [alert addAction:selectActon];
    [alert addAction:logoutAction];
    [alert addAction:cancelAction];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage* userHead = [info objectForKey:UIImagePickerControllerEditedImage];
    [self uploadImage:userHead];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadImage:(UIImage *)userHead{
    NSString *imgPath = IMAGE_FOLDER;
    if ([[NSFileManager defaultManager] fileExistsAtPath:imgPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:imgPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    imgPath = [imgPath stringByAppendingString:@"waitFowUpload.png"];
    NSData *data = UIImageJPEGRepresentation(userHead, 0.65);
    [data writeToFile:imgPath atomically:YES];
    [topView loadUserHead:imgPath];

        NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:@"client_id",KEY_CLIENTID,@"user_name",userModel.userName,@"password",userModel.password, nil];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    __weak typeof(self) weakSelf = self;
    [manager POST:SERVERURL_FILE parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFormData:[KEY_CLIENTID dataUsingEncoding:NSUTF8StringEncoding] name:@"client_id"];
        [formData appendPartWithFormData:[weakSelf.userModel.userName dataUsingEncoding:NSUTF8StringEncoding] name:@"user_name"];
        [formData appendPartWithFormData:[weakSelf.userModel.password dataUsingEncoding:NSUTF8StringEncoding] name:@"password"];
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:imgPath] name:@"fileImg" error:nil];
        [SVProgressHUD showWithStatus:@"正在上传" maskType:SVProgressHUDMaskTypeBlack];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLOG(@"%lli",[uploadProgress totalUnitCount]);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        [SVProgressHUD dismiss];
        NSLOG(@"上传成功: %@", dict);
        if (STRCMP([dict objectForKey:@"result_code"], @"000")){
            [SVProgressHUD showSuccessWithStatus:@"上传成功!"];
            weakSelf.userModel.userHead = [dict objectForKey:@"head_img"];
            [weakSelf viewWillAppear:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLOG(@"上传失败: %@", error);
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"上传失败"];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadImageWithChangeType:(UIImagePickerControllerSourceType)pickType{
    UIImagePickerController *imagepicker = [[UIImagePickerController alloc]init];
    imagepicker.sourceType = pickType;
    imagepicker.allowsEditing = YES;
    [imagepicker setDelegate:self];
    [self presentViewController:imagepicker animated:YES completion:nil];
}

- (void)loadUnreadMsg{
    NSString *pageStr = @"1";
    NSString *typeStr = @"1";
    UserModel *usrModel = [UserModel shareUserManager];
    NSDictionary *para = @{@"client_id":KEY_CLIENTID,@"user_name":usrModel.userName,@"password":usrModel.password,@"type":typeStr,@"pageindex":pageStr};
    para = @{@"cmdid":@"get_letter_list",@"data":para};
    __weak typeof(self) weakSelf = self;
    [HttpManager hmRequestWithPara:para Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        [SVProgressHUD dismiss];
        if (rqCode != rqSuccess){
            return ;
        }
        NSArray *unreadMeg = [receiveData objectForKey:@"data"];
        if (unreadMeg.count > 0) {
            [weakSelf tagNewMsg];
        }
        else {
            [weakSelf removeTag];
        }
    }];
}

- (void)tagNewMsg {
    [tableView tagNewForCellAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
}
- (void)removeTag {
    [tableView removeTagForCellAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
