//
//  FeedbackCtrl.m
//  Yitou
//
//  Created by mac on 15/11/27.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import "FeedbackCtrl.h"

#define DEFULTText @"感谢您对益投网贷的反馈,请填写4-200字的反馈内容"

@interface FeedbackCtrl ()<UITextViewDelegate>

@end

@implementation FeedbackCtrl{
    CustomNavigation *customNav;
    UITextView *textview;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [textview resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    [self.view setBackgroundColor:BG_BLUEColor];
    [self loadAllView];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (STRCMP(textView.text, DEFULTText)){
        textview.text = @"";
        [textview setTextColor:[UIColor blackColor]];
    }
}

- (void)loadAllView{
    NSInteger h = SCREENHeight>569?200:120;
    textview = [[UITextView alloc] initWithFrame:CGRectMake(10, 74, SCREENWidth-20, h)];

    [textview setContentMode:UIViewContentModeTop];
    [textview setTextAlignment:NSTextAlignmentLeft];
    [textview setBackgroundColor:[UIColor whiteColor]];
    [textview setDelegate:self];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    textView.contentInset = UIEdgeInsetsMake(-60, -6, 0, 0);
    [textview setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:textview];
    [self nullStatus];

    [self loadButton];
}

- (void)loadButton{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, VIEWFH_Y(textview) + 10, SCREENWidth-20, 45)];
    [btn setBackgroundColor:[UIColor colorWithRed:0.16 green:0.55 blue:0.88 alpha:1]];
    [btn setTitle:@"马上反馈" forState:UIControlStateNormal];
    [FastFactory convertViewToImage:btn color:[UIColor colorWithRed:0.16 green:0.55 blue:0.88 alpha:0.78]];
    [btn addTarget:self action:@selector(clickSendBtn) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEWFH_Y(btn)+10, SCREENWidth, 30)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setTextColor:[UIColor blackColor]];
    [label setText:@"客服热线 : 4008-650-760"];
    [self.view addSubview:label];
}

- (void)clickSendBtn{
    if (textview.text.length >200||textview.text.length<4||STRCMP(textview.text, DEFULTText)){
        [SVProgressHUD showErrorWithStatus:@"请输入4-200字的反馈内容"];
        return;
    }
    UserModel *usrModel = [UserModel shareUserManager];
    NSDictionary *dat = @{@"user_name":usrModel.userName,@"password":usrModel.password,@"client_id":KEY_CLIENTID,@"tickling_msg":textview.text};
    NSDictionary *para = @{@"cmdid":@"user_tickling",@"data":dat};
    [HttpManager hmRequestWithPara:para Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {

        if (rqCode != rqSuccess){
            [SVProgressHUD showErrorWithStatus:describle];
            return ;
        }
        [self showSuccess];

    }];
}

- (void)showSuccess{
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"发送成功" message:@"您的反馈内容已提交成功" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertCtrl addAction:cancel];
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

- (void)nullStatus{
    [textview setTextColor:[UIColor grayColor]];
    textview.text = DEFULTText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
