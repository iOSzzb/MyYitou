//
//  CLLockVC.m
//  CoreLock
//
//  Created by 成林 on 15/4/21.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "CLLockVC.h"
#import "CoreLockConst.h"
#import "CoreArchive.h"
#import "CLLockLabel.h"
#import "CLLockNavVC.h"
#import "CLLockView.h"
#import "CLLockInfoView.h"
#import <UIImageView+AFNetworking.h>

@interface CLLockVC ()

#define PWD_MAX_TRY 4
#define PWD_EXIST_TRY @"EXIST_TRY"

/** 操作成功：密码设置成功、密码验证成功 */
@property (nonatomic,copy) void (^successBlock)(CLLockVC *lockVC,NSString *pwd);

@property (nonatomic,copy) void (^forgetPwdBlock)();

@property (weak, nonatomic) IBOutlet CLLockLabel *label;

@property (nonatomic,copy) NSString *msg;

@property (weak, nonatomic) IBOutlet CLLockView *lockView;

@property (nonatomic,weak) UIViewController *vc;

@property (nonatomic,strong) UIBarButtonItem *resetItem;

@property (nonatomic,strong) UIBarButtonItem *leftItem;

@property (nonatomic,copy) NSString *modifyCurrentTitle;

@property (weak, nonatomic) IBOutlet UIView *actionView;

@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;

@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;

/** 直接进入修改页面的 */
@property (nonatomic,assign) BOOL isDirectModify;

@property (nonatomic,strong)UIImageView *userHaed;

@property (nonatomic,strong)IBOutlet CLLockInfoView *infoView;

@end

@implementation CLLockVC

- (void)viewDidLoad {
    
    [super viewDidLoad];

    //控制器准备
    [self vcPrepare];
    
    //数据传输
    [self dataTransfer];
    if (self.type != CoreLockTypeVeryfiPwd){
        [self performSelector:@selector(removeButton) withObject:nil afterDelay:0.2];
    }
    else{
        [self loadUserHeadImageView];
    }

    [self performSelector:@selector(checkLockInfoView) withObject:nil afterDelay:0.2];
    //事件
    [self event];
}

- (void)checkLockInfoView{
    if (self.type == CoreLockTypeVeryfiPwd){
        [self.infoView setAlpha:0.01];
    }
}

- (void)removeButton{
    [self.modifyBtn removeFromSuperview];
    [self.forgetBtn removeFromSuperview];
}

- (void)updateButtonFrame{
    [self.modifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.forgetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [self.modifyBtn setFrame:CGRectMake(VIEWFOX(self.modifyBtn), VIEWFOY(self.modifyBtn) - 25, VIEWFSW(self.modifyBtn), VIEWFSH(self.modifyBtn)+10)];
    [self.forgetBtn setFrame:CGRectMake(VIEWFOX(self.forgetBtn), VIEWFOY(self.forgetBtn) - 25, VIEWFSW(self.forgetBtn), VIEWFSH(self.forgetBtn)+10)];
}

- (void)loadUserHeadImageView{
    [self performSelector:@selector(updateButtonFrame) withObject:nil afterDelay:0.2];
    float orignY = 70;
    float width = 50;
    if (SCREENHeight > 481){
        orignY = 80;
        width = 60;
    }
    if (SCREENHeight > 570){
        orignY = 110;
        width = 60;
    }

    [self.userHaed removeFromSuperview];
    self.userHaed = [[UIImageView alloc] initWithFrame:CGRectMake((SCREENWidth - width)/2, orignY, width, width)];
    [self.userHaed setImageWithURL:[NSURL URLWithString:USERDefineGet(KEY_USER_HEAD)] placeholderImage:IMAGENAMED(@"DefaultHead")];
    [self.userHaed.layer setMasksToBounds:YES];
    [self.userHaed.layer setCornerRadius:width/2];
    [self.label showNormalMsg:[UserModel mosaicString:USERDefineGet(KEY_LOGIN_NAME)]];
    [self.view addSubview:self.userHaed];
}

/*
 *  事件
 */
-(void)event{
    /*
     *  设置密码
     */
    
    /** 开始输入：第一次 */
    self.lockView.setPWBeginBlock = ^(){
        
        [self.label showNormalMsg:CoreLockPWDTitleFirst];
    };
    
    /** 开始输入：确认 */
    self.lockView.setPWConfirmlock = ^(){
        
        [self.label showNormalMsg:CoreLockPWDTitleConfirm];
    };
    
    
    /** 密码长度不够 */
    self.lockView.setPWSErrorLengthTooShortBlock = ^(NSUInteger currentCount){
      
        [self.label showWarnMsg:[NSString stringWithFormat:@"请连接至少%@个点",@(CoreLockMinItemCount)]];
    };
    
    /** 两次密码不一致 */
    self.lockView.setPWSErrorTwiceDiffBlock = ^(NSString *pwd1,NSString *pwdNow){
        
        [self.label showWarnMsg:CoreLockPWDDiffTitle];
        
        self.navigationItem.rightBarButtonItem = self.resetItem;
    };

    /** 第一次输入密码：正确 */
    self.lockView.setPWFirstRightBlock = ^(){
        [self.infoView setShowPwd:self.lockView.firstRightPWD];
        [self.label showNormalMsg:CoreLockPWDTitleConfirm];
    };

    /** 再次输入密码一致 */
    self.lockView.setPWTwiceSameBlock = ^(NSString *pwd){
        [self.label showNormalMsg:CoreLockPWSuccessTitle];
        //存储密码
        [CoreArchive setStr:pwd key:CoreLockPWDKey];
        //禁用交互
        self.view.userInteractionEnabled = NO;
        [CoreArchive setStr:@"4" key:PWD_EXIST_TRY];
        [self canLogin];
    };
    
    /*
     *  验证密码
     */
    
    /** 开始 */
    self.lockView.verifyPWBeginBlock = ^(){
        
        [self.label showNormalMsg:CoreLockVerifyNormalTitle];
    };
    
    /** 验证 */
    self.lockView.verifyPwdBlock = ^(NSString *pwd){
        //取出本地密码
        NSString *pwdLocal = [CoreArchive strForKey:CoreLockPWDKey];
        
        BOOL res = [pwdLocal isEqualToString:pwd];
        
        if(res){//密码一致
            
            [self.label showNormalMsg:CoreLockVerifySuccesslTitle];
            [CoreArchive setStr:@"4" key:PWD_EXIST_TRY];
            if(CoreLockTypeVeryfiPwd == _type){
                
                //禁用交互
                self.view.userInteractionEnabled = NO;
                
            }else if (CoreLockTypeModifyPwd == _type){//修改密码
                
                [self.label showNormalMsg:CoreLockPWDTitleFirst];
                
                self.modifyCurrentTitle = CoreLockPWDTitleFirst;
            }
            
            if(CoreLockTypeVeryfiPwd == _type) {
                [self canLogin];
            }

        }else{//密码不一致
            NSInteger surTime = [[self existTry] integerValue];
            surTime --;
            [CoreArchive setStr:[NSString stringWithFormat:@"%tu",surTime] key:PWD_EXIST_TRY];
            NSString *showMsg = [NSString stringWithFormat:@"手势错误,还可以再输入%tu次",surTime];
            [self.label showWarnMsg:showMsg];
//            [self.label showWarnMsg:CoreLockVerifyErrorPwdTitle];
            if (surTime == 0){
                [CLLockVC cleanPwd];
//                [[UserModel shareUserManager] logout];
                self.successBlock(self,@"999");
            }
        }
        
        return res;
    };

    /*
     *  修改
     */
    
    /** 开始 */
    self.lockView.modifyPwdBlock =^(){
      
        [self.label showNormalMsg:self.modifyCurrentTitle];
    };
    
    
}



- (NSString *)existTry{
    return [CoreArchive strForKey:PWD_EXIST_TRY];
}


/*
 *  数据传输
 */
-(void)dataTransfer{
    
    [self.label showNormalMsg:self.msg];
    
    //传递类型
    self.lockView.type = self.type;
}




/*
 *  控制器准备
 */
-(void)vcPrepare{

    //设置背景色
    self.view.backgroundColor = [UIColor colorWithRed:0.16 green:0.55 blue:0.88 alpha:1];

    
    //初始情况隐藏
    self.navigationItem.rightBarButtonItem = nil;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.leftBarButtonItem = self.leftItem;
    //默认标题
    self.modifyCurrentTitle = CoreLockModifyNormalTitle;
    
    if(CoreLockTypeModifyPwd == _type) {
        
        _actionView.hidden = YES;
        
        [_actionView removeFromSuperview];

        if(_isDirectModify) return;
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    }
    
    if(![self.class hasPwd]){
        [_modifyBtn removeFromSuperview];
    }
}

-(void)dismiss{
    [self dismiss:0];
}

/*
 *  密码重设
 */
-(void)setPwdReset{
    
    [self.label showNormalMsg:CoreLockPWDTitleFirst];
    [self.infoView setShowPwd:@""];
    //隐藏
    self.navigationItem.rightBarButtonItem = nil;
    
    //通知视图重设
    [self.lockView resetPwd];
}


/*
 *  忘记密码
 */
-(void)forgetPwd{
    
}



/*
 *  修改密码
 */
-(void)modiftyPwd{
    
}


/*
 *  是否有本地密码缓存？即用户是否设置过初始密码？
 */
+(BOOL)hasPwd{
    
    NSString *pwd = [CoreArchive strForKey:CoreLockPWDKey];
    if ([pwd length] > 3 && pwd != nil)
        return YES;
    return NO;
}

/**
 *  移除手势密码
 */
+ (void)cleanPwd{
    [CoreArchive setStr:@"" key:CoreLockPWDKey];
}

/*
 *  展示设置密码控制器
 */
+(instancetype)showSettingLockVCInVC:(UIViewController *)vc successBlock:(void(^)(CLLockVC *lockVC,NSString *pwd))successBlock{
    
    CLLockVC *lockVC = [self lockVC:vc];
    
    lockVC.title = @"设置密码";
    
    //设置类型
    lockVC.type = CoreLockTypeSetPwd;
    
    //保存block
    lockVC.successBlock = successBlock;
    
    return lockVC;
}




/*
 *  展示验证密码输入框
 */
+(instancetype)showVerifyLockVCInVC:(UIViewController *)vc forgetPwdBlock:(void(^)())forgetPwdBlock successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock{
    
    
    CLLockVC *lockVC = [self lockVC:vc];
    
    lockVC.title = @"手势解锁";
    
    //设置类型
    lockVC.type = CoreLockTypeVeryfiPwd;
    
    //保存block
    lockVC.successBlock = successBlock;
    lockVC.forgetPwdBlock = forgetPwdBlock;

    return lockVC;
}




/*
 *  展示修改密码输入框
 */
+(instancetype)showModifyLockVCInVC:(UIViewController *)vc successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock{
    
    CLLockVC *lockVC = [self lockVC:vc];
    
    lockVC.title = @"修改密码";

    //设置类型
    lockVC.type = CoreLockTypeModifyPwd;
    
    //记录
    lockVC.successBlock = successBlock;


    return lockVC;
}

+(instancetype)lockVC:(UIViewController *)vc{
    
    CLLockVC *lockVC = [[CLLockVC alloc] init];

    lockVC.vc = vc;
    
    CLLockNavVC *navVC = [[CLLockNavVC alloc] initWithRootViewController:lockVC];
    
    [vc presentViewController:navVC animated:YES completion:nil];

    
    return lockVC;
}

-(void)setType:(CoreLockType)type{
    
    _type = type;
    
    //根据type自动调整label文字
    [self labelWithType];
}

/*
 *  根据type自动调整label文字
 */
-(void)labelWithType{
    
    if(CoreLockTypeSetPwd == _type){//设置密码
        
        self.msg = CoreLockPWDTitleFirst;
        
    }else if (CoreLockTypeVeryfiPwd == _type){//验证密码
        
        self.msg = [UserModel mosaicString:USERDefineGet(KEY_LOGIN_NAME)];
        
    }else if (CoreLockTypeModifyPwd == _type){//修改密码
        
        self.msg = CoreLockModifyNormalTitle;
    }
}


/*
 *  消失
 */
-(void)dismiss:(NSTimeInterval)interval{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}


/*
 *  重置
 */
-(UIBarButtonItem *)resetItem{
    
    if(_resetItem == nil){
        //添加右按钮
        _resetItem= [[UIBarButtonItem alloc] initWithTitle:@"重设" style:UIBarButtonItemStylePlain target:self action:@selector(setPwdReset)];
    }
    
    return _resetItem;
}

-(UIBarButtonItem *)leftItem{

    if(_leftItem == nil){
        //添加右按钮
        _leftItem= [[UIBarButtonItem alloc] initWithTitle:@"跳过" style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftButton)];
    }

    return _leftItem;
}

- (void)checkPassword{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入登录密码" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:@"登录密码"];
        [textField setSecureTextEntry:YES];
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *putPwd = [[[alert textFields] objectAtIndex:0] text];
        if (STRCMP(putPwd, [UserModel shareUserManager].password)&&[putPwd length] > 0){
            [self changeSetPasswordType];
        }
        else{
            [alert setTitle:@"密码输入错误,请重新输入"];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)changeSetPasswordType{
    [CLLockVC cleanPwd];
    [self setType:CoreLockTypeSetPwd];
    self.title = @"设置密码";
    [_userHaed removeFromSuperview];

    [self.infoView setAlpha:1.0];
    [self.infoView setShowPwd:@""];
    [self viewDidLoad];
}

- (void)clickLeftButton{
    NSLOG(@"click left button");
    self.successBlock(self,@"999");
}


- (IBAction)forgetPwdAction:(id)sender {
//    self.successBlock(self,@"111");
    [self checkPassword];
}


- (IBAction)modifyPwdAction:(id)sender {
    self.successBlock(self,@"999");
//    if(_forgetPwdBlock != nil) _forgetPwdBlock();
}

- (void)canLogin{
    UserModel *usr = [UserModel shareUserManager];
    [SVProgressHUD showWithStatus:@"正在登录" maskType:SVProgressHUDMaskTypeBlack];
    [HttpManager loginWithUserName:usr.userName password:usr.password Block:^(RequestResult rqCode, NSString *describle) {
        [SVProgressHUD dismiss];
        if (rqCode == rqSuccess){
            [HttpManager getUserInformationByUserName:usr.userName pwd:usr.password Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {

            }];
            [HttpManager getHFInformationWithUserName:usr.userName pwd:usr.password Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {

            }];
            self.successBlock(self,@"0");
        }
        else{
            self.successBlock(self,@"1");
            [SVProgressHUD showErrorWithStatus:describle];
        }
    }];
}

@end
