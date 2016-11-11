//
//  GesturePwdCtrl.m
//  Yitou
//
//  Created by mac on 16/1/25.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "GesturePwdCtrl.h"
#import "CLLockVC.h"

@interface GesturePwdCtrl ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation GesturePwdCtrl{
    CustomNavigation *customNav;
    UITableView *tableview;
    UISwitch *switchBtn;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [tableview reloadData];
    [switchBtn setOn:[CLLockVC hasPwd]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BG_WHITEColor];
    self.title = @"手势密码";
    [self loadAllView];
}

- (void)loadAllView{
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 175) style:UITableViewStylePlain];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENHeight, 10)];
    tableview.tableHeaderView = headView;
    [headView setBackgroundColor:self.view.backgroundColor];
    tableview.tableFooterView = nil;
    [tableview setDelegate:self];
    [tableview setDataSource:self];
    [tableview setScrollEnabled:NO];
    [self.view addSubview:tableview];
}

- (void)clickSwitchButton{
    [self resetSwitchButton];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入登录密码" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:@"登录密码"];
        [textField setSecureTextEntry:YES];
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *putPwd = [[[alert textFields] objectAtIndex:0] text];
        if (STRCMP(putPwd, [UserModel shareUserManager].password)){
            [self canChangeGestureType];
        }
        else{
            [alert setTitle:@"密码输入错误,请重新输入"];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self resetSwitchButton];
    }];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)canChangeGestureType{
    BOOL hasPwd = [CLLockVC hasPwd];
    if (hasPwd){
        [CLLockVC cleanPwd];
        [self resetSwitchButton];
    }
    else{
        [CLLockVC showSettingLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            [lockVC dismiss:0];
            [self resetSwitchButton];
        }];
    }
}

- (void)reloadTableview{
    [tableview reloadData];
}

- (void)resetSwitchButton{
    BOOL hasPwd = [CLLockVC hasPwd];
    [switchBtn setOn:hasPwd];
    [tableview reloadData];
}

- (void)gesturePasswordError{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableview deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1)
        [self checkPassword];
}

- (void)updatePassword{
    [CLLockVC showSettingLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
        [lockVC dismiss:0];
        if ([pwd length]>3)
            [SVProgressHUD showSuccessWithStatus:@"修改成功!"];
        if (STRCMP(@"333", pwd)){
            [CLLockVC cleanPwd];
        }
    }];
}

- (void)checkPassword{
    [self resetSwitchButton];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入登录密码" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:@"登录密码"];
        [textField setSecureTextEntry:YES];
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *putPwd = [[[alert textFields] objectAtIndex:0] text];
        if (STRCMP(putPwd, [UserModel shareUserManager].password)){
            [self updatePassword];
        }
        else{
            [alert setTitle:@"密码输入错误,请重新输入"];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self resetSwitchButton];
    }];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    BOOL hasPwd = [CLLockVC hasPwd];
    float h = 125;
    if (hasPwd){
        h = 175;
    }
    [tableview setFrame:CGRectMake(0, 0, SCREENWidth, h)];
    return hasPwd?2:1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identi = @"biubiubiu";
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:identi];
    if (!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identi];
        if (indexPath.row == 0)
            [self loadFirstSetCell:cell];
        else
            [self loadUpdateCell:cell];
    }
    return cell;
}

- (UITableViewCell *)loadUpdateCell:(UITableViewCell *)cell{
    cell.textLabel.text = @"修改手势密码";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (UITableViewCell *)loadFirstSetCell:(UITableViewCell *)cell{
    cell.textLabel.text = @"手势密码";
    [switchBtn removeFromSuperview];
    switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(SCREENWidth - 69, 10, 49, 31)];
    [cell.contentView addSubview:switchBtn];
    [switchBtn setOn:[CLLockVC hasPwd]];
    [switchBtn addTarget:self action:@selector(clickSwitchButton) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
