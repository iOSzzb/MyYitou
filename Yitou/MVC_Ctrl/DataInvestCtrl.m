//
//  DataInvestCtrl.m
//  Yitou
//
//  Created by Xiaohui on 16/3/14.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "DataInvestCtrl.h"
#import "SelectorView.h"
#import "RecordView.h"
#import "Record.h"
#import "InverstTextField.h"
#import "CustomPickerView.h"


@interface DataInvestCtrl ()<UITextFieldDelegate,SelectorViewDelegate>

@end

@implementation DataInvestCtrl{
    InverstTextField *usernameTF;
    InverstTextField *timeTF;
    InverstTextField *moneyTF;
    
    SelectorView *selectorView;
    RecordView *recordView;
    
    UIView *orderBackView;
    UIScrollView *scrollView;
    
    NSMutableArray *dataSourceAry;//预约记录
    
    Record *applyOrder;//申请约标参数集合
    NSMutableArray *aryApply;//标期集合
    NSMutableArray *aryType; //类型标集合
    
    CustomPickerView *customPickerView;
    
    NSTimer *timer;
    
    NSArray *arrayDate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约投资";
    
    selectorView = [[SelectorView alloc] initWithFrame:CGRectMake(0, 64, SCREENWidth, 45)];
    selectorView.delegate = self;
    [selectorView LoadSelectorView];
    [self.view addSubview:selectorView];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 109, SCREENWidth, SCREENHeight-109)];
    scrollView.pagingEnabled = YES; //是否翻页
    scrollView.scrollEnabled = NO; //是否可以滚动
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator =NO;
    [scrollView setContentSize:CGSizeMake(2*SCREENWidth, SCREENWidth-109)];
    [self.view addSubview:scrollView];
    
    [self getDates];
    [self loadDataRequest];
    [self loadDataRecordList];
    
}

/**
 *  获取不能预约的时间
 */
- (void)getDates{
    [SVProgressHUD showWithStatus:@"正在预约" maskType:SVProgressHUDMaskTypeBlack];
    NSDictionary *para = @{@"client_id":KEY_CLIENTID};
    para = @{@"cmdid":@"getapplynotime",@"data":para};
    NSLog(@"para = %@",para);
    [HttpManager hmRequestWithPara:para Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        NSLog(@"receiveData = %@",receiveData);
        if (rqCode == rqSuccess) {
            NSLog(@" - - - %@",receiveData);
            NSString *string = [[receiveData objectForKey:@"data"] objectForKey:@"notime"];
            arrayDate = [NSArray new];
            arrayDate = [string componentsSeparatedByString:@","]; //从字符,中分隔成2个元素的数组
//            [SVProgressHUD showSuccessWithStatus:nil];
            [SVProgressHUD dismiss];
            NSLog(@"%@",arrayDate);
        }else{
            [SVProgressHUD showErrorWithStatus:describle];
        }
    }];

}

#pragma mark SelectorViewDelegate
- (void)selectorButtontag:(SELECTOR_Btn)buttontag{
    if (buttontag == ORDER_SELECTOR) {
        [UIView animateWithDuration:0.3 animations:^{
            [scrollView setContentOffset:CGPointMake(0, 0)];
        }];
    }
    
    if (buttontag == RECORD_SELECTOR) {
        [UIView animateWithDuration:0.3 animations:^{
            [scrollView setContentOffset:CGPointMake(SCREENWidth, 0)];
            [recordView beginRefreshTableView];
        }];
    }
}

/**
 *  加载约标申请页面
 */
- (void)loadDataRequest{
    
    applyOrder = [[Record alloc] init];
    
    orderBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-109)];
    [scrollView addSubview:orderBackView];
    
    UILabel *nameLab = [self showLabelWithFrame:CGRectMake(20, 20, 50, 30) Content:@"用 户 名"];
    [orderBackView addSubview:nameLab];
    usernameTF = [[InverstTextField alloc] initWithFrame:CGRectMake(VIEWFW_X(nameLab)+5, VIEWFOY(nameLab), VIEWFSW(orderBackView)-VIEWFW_X(nameLab)-25, 30)];
    [usernameTF loadTextFieldWithFPlaceholder:nil];
    usernameTF.textField.delegate = self;
    usernameTF.textField.text = [UserModel shareUserManager].userName;
    usernameTF.textField.enabled = NO;
    [orderBackView addSubview:usernameTF];
    
    UILabel *monthLab = [self showLabelWithFrame:CGRectMake(VIEWFOX(nameLab), VIEWFH_Y(nameLab)+20, 50, 30) Content:@"标    期"];
    [orderBackView addSubview:monthLab];
    [self showRequestButtonWithFrame:CGRectMake(VIEWFW_X(monthLab)+5, VIEWFOY(monthLab)+(VIEWFSH(monthLab)-20)/2, 20, 20) Tag:301 Content:@"1月标"];
    [self showRequestButtonWithFrame:CGRectMake(VIEWFW_X(monthLab)+65, VIEWFOY(monthLab)+(VIEWFSH(monthLab)-20)/2, 20, 20) Tag:302 Content:@"2月标"];
    [self showRequestButtonWithFrame:CGRectMake(VIEWFW_X(monthLab)+65*2, VIEWFOY(monthLab)+(VIEWFSH(monthLab)-20)/2, 20, 20) Tag:303 Content:@"3月标"];
    [self showRequestButtonWithFrame:CGRectMake(VIEWFW_X(monthLab)+65*3, VIEWFOY(monthLab)+(VIEWFSH(monthLab)-20)/2, 20, 20) Tag:304 Content:@"随机"];
    
    NSString *strContent = @"多选项,如约1月标或2月标可同时勾选,无需重复提交";
    UILabel *labContent = [self showLabelWithFrame:CGRectMake(VIEWFW_X(monthLab)+5, VIEWFH_Y(monthLab), VIEWFSW(orderBackView)-VIEWFW_X(monthLab)-25, 14) Content:strContent];
    labContent.numberOfLines = 0;
    [labContent setTextColor:[UIColor colorWithRed:0.21 green:0.56 blue:0.89 alpha:1]];
    labContent.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize sizeContent = [labContent sizeThatFits:CGSizeMake(labContent.frame.size.width, MAXFLOAT)];
    labContent.frame = CGRectMake(VIEWFW_X(monthLab)+5, VIEWFH_Y(monthLab), VIEWFSW(orderBackView)-VIEWFW_X(monthLab)-25, sizeContent.height);
    [orderBackView addSubview:labContent];
    
    UILabel *typeLab = [self showLabelWithFrame:CGRectMake(VIEWFOX(nameLab), VIEWFH_Y(labContent)+20, 50, 30) Content:@"标 类 型"];
    [orderBackView addSubview:typeLab];
    [self showRequestButtonWithFrame:CGRectMake(VIEWFW_X(typeLab)+5, VIEWFOY(typeLab)+(VIEWFSH(typeLab)-20)/2, 20, 20) Tag:305 Content:@"车益贷"];
    [self showRequestButtonWithFrame:CGRectMake(VIEWFW_X(typeLab)+65, VIEWFOY(typeLab)+(VIEWFSH(typeLab)-20)/2, 20, 20) Tag:306 Content:@"楼益贷"];
    [self showRequestButtonWithFrame:CGRectMake(VIEWFW_X(typeLab)+65*2, VIEWFOY(typeLab)+(VIEWFSH(typeLab)-20)/2, 20, 20) Tag:307 Content:@"生益贷"];
    [self showRequestButtonWithFrame:CGRectMake(VIEWFW_X(typeLab)+65*3, VIEWFOY(typeLab)+(VIEWFSH(typeLab)-20)/2, 20, 20) Tag:308 Content:@"随机"];
    
    UILabel *timeLab = [self showLabelWithFrame:CGRectMake(VIEWFOX(typeLab), VIEWFH_Y(typeLab)+20, 50, 30) Content:@"时     间"];
    [orderBackView addSubview:timeLab];
    timeTF = [[InverstTextField alloc] initWithFrame:CGRectMake(VIEWFW_X(timeLab)+5, VIEWFOY(timeLab), VIEWFSW(orderBackView)-VIEWFW_X(timeLab)-25, 30)];
    [timeTF loadTextFieldWithFPlaceholder:nil];
//    timeTF.textField.text = [self loadCurrentDate];
    timeTF.textField.delegate = self;
    [orderBackView addSubview:timeTF];
    
    NSString *strTime = @"周末和节假日不可预约";
    UILabel *labprompt = [self showLabelWithFrame:CGRectMake(VIEWFW_X(timeLab)+5, VIEWFH_Y(timeLab)+5, VIEWFSW(orderBackView)-VIEWFW_X(timeLab)-25, 14) Content:strTime];
    [labprompt setTextColor:[UIColor colorWithRed:0.21 green:0.56 blue:0.89 alpha:1]];
    [labprompt setTextAlignment:NSTextAlignmentLeft];
    [orderBackView addSubview:labprompt];
    
    UILabel *moneyLab = [self showLabelWithFrame:CGRectMake(VIEWFOX(timeLab), VIEWFH_Y(labprompt)+10, 50, 30) Content:@"金     额"];
    [orderBackView addSubview:moneyLab];
    
    moneyTF = [[InverstTextField alloc] initWithFrame:CGRectMake(VIEWFW_X(moneyLab)+5, VIEWFOY(moneyLab), VIEWFSW(orderBackView)-VIEWFW_X(moneyLab)-25, 30)];
    [moneyTF loadTextFieldWithFPlaceholder:@"最低预约金额50000元,且以万元为单位"];
    moneyTF.textField.delegate = self;
    moneyTF.textField.keyboardType = UIKeyboardTypePhonePad;
    [orderBackView addSubview:moneyTF];
    
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setFrame:CGRectMake(20, VIEWFH_Y(moneyLab)+20, SCREENWidth-40, 30)];
    [confirmBtn setBackgroundColor:[UIColor colorWithRed:0.26 green:0.6 blue:0.91 alpha:1]];
    [confirmBtn setTitle:@"确定预约" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = FONT_14;
    confirmBtn.layer.cornerRadius = 5;
    confirmBtn.layer.masksToBounds = YES;
    [confirmBtn addTarget:self action:@selector(selectorConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    [orderBackView addSubview:confirmBtn];
    
}

- (void)loadPickerViewStar{
    customPickerView = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, SCREENHeight-300, SCREENWidth, 300)];
    [self.view addSubview:customPickerView];
    
    [customPickerView CustomPickerViewDoneBlock:^(NSString *time,NSString *timeStr){
        NSLog(@"time = %@ timeStr = %@",time,timeStr);
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps;

        // 年月日获得
        NSDate *curtentdate= [NSDate date];
        
        comps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | kCFCalendarUnitHour |kCFCalendarUnitMinute)
                            fromDate:curtentdate];
        NSInteger year = [comps year];
        NSInteger month = [comps month];
        NSInteger day = [comps day];

        NSString *str = [NSString stringWithFormat:@"%ld%02ld%02ld", year, month, day];//得到输出的年月日
 
        
        //获取半年后的今天
        NSCalendar *calendarnow = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

        NSDateComponents *adcomps = [[NSDateComponents alloc] init];
        [adcomps setYear:0];
        [adcomps setMonth:+6];
        [adcomps setDay:0];
        NSDate *newdate = [calendarnow dateByAddingComponents:adcomps toDate:curtentdate options:0];//得到半年后今天的日期
//        NSDate *newdate =[self getNowDateFromatAnDate:newdatei];//转换标准时间
        NSDateComponents *newcomps = [calendarnow components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |kCFCalendarUnitHour |kCFCalendarUnitMinute)
                            fromDate:newdate];
        NSInteger newyear = [newcomps year];
        NSInteger newmonth = [newcomps month];
        NSInteger newday = [newcomps day];
        NSString *newstr = [NSString stringWithFormat:@"%ld%02ld%02ld", newyear, newmonth, newday];//得到6个月后输出的年月日
        
        int currentTime = [str intValue];
        int selectTime = [time intValue];
        int newTime = [newstr intValue];
        if (selectTime > currentTime && newTime > selectTime) {
            
            for (int i = 0; i < arrayDate.count; i ++) {
                if ([time isEqualToString:arrayDate[i]]) {
                    [customPickerView removeFromSuperview];
                    [SVProgressHUD showErrorWithStatus:@"周末和节假日不能预约"];
                    return ;
                }
                timeTF.textField.text = timeStr;
            }
        }else{
            //                timeTF.textField.text = @"";
            [customPickerView removeFromSuperview];
            [SVProgressHUD showErrorWithStatus:@"抱歉,只能预约当天以后的日期"];
            return;
        }
        [customPickerView removeFromSuperview];
        
    }];
    
    [customPickerView CustomPickerViewCancelBlock:^{

        [customPickerView removeFromSuperview];
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == timeTF.textField) {
        [usernameTF.textField resignFirstResponder];
        [moneyTF.textField resignFirstResponder];
        [self loadPickerViewStar];
        return NO;
    }
    [customPickerView removeFromSuperview];
    return YES;
}

/**
 *  确定预约
 */
- (void)selectorConfirmBtn:(UIButton *)sender{
    [usernameTF.textField resignFirstResponder];
//    [timeTF.textField resignFirstResponder];
     [customPickerView removeFromSuperview];
    [moneyTF.textField resignFirstResponder];
    
    [SVProgressHUD showWithStatus:@"正在预约" maskType:SVProgressHUDMaskTypeBlack];
    
    UIButton *btn01 = (UIButton *)[orderBackView viewWithTag:301];
    UIButton *btn02 = (UIButton *)[orderBackView viewWithTag:302];
    UIButton *btn03 = (UIButton *)[orderBackView viewWithTag:303];
    UIButton *btn04 = (UIButton *)[orderBackView viewWithTag:304];
    
    UIButton *btn1 = (UIButton *)[orderBackView viewWithTag:305];
    UIButton *btn2 = (UIButton *)[orderBackView viewWithTag:306];
    UIButton *btn3 = (UIButton *)[orderBackView viewWithTag:307];
    UIButton *btn4 = (UIButton *)[orderBackView viewWithTag:308];
    
    NSString *strOneMonth = @"1月标";
    NSString *strTwoMonth = @"2月标";
    NSString *strThreeMonth = @"3月标";
    NSString *strOtherMonth = @"随机";
    
    NSString *strOneType = @"车益贷";
    NSString *strTwoType = @"楼益贷";
    NSString *strThreeType = @"生益贷";
    NSString *strOtherType = @"随机";

    
    aryApply = [NSMutableArray new];
    
    if (btn01.selected) {
        [aryApply addObject:strOneMonth];
    }
    if (btn02.selected) {
        [aryApply addObject:strTwoMonth];
    }
    if (btn03.selected) {
        [aryApply addObject:strThreeMonth];
    }
    if (btn04.selected) {
        [aryApply addObject:strOtherMonth];
    }
    
    aryType = [NSMutableArray new];
    if (btn1.selected) {
        [aryType addObject:strOneType];
    }
    if (btn2.selected) {
        [aryType addObject:strTwoType];
    }
    if (btn3.selected) {
        [aryType addObject:strThreeType];
    }
    if (btn4.selected) {
        [aryType addObject:strOtherType];
    }
    
    if (aryApply.count < 1) {
        [SVProgressHUD showErrorWithStatus:@"请选择标期~"];
        return;
    }
    
    if (aryType.count <1) {
        [SVProgressHUD showErrorWithStatus:@"请选择标类型~"];
        return;
    }
    
    if ([timeTF.textField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请填写时间~"];
        return;
    }
    
    if ([moneyTF.textField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请填写金额~"];
        return;
    }
    
    if (![self isPureInt:moneyTF.textField.text]) {
        [SVProgressHUD showErrorWithStatus:@"输入金额格式不对"];
        return;
    }
    

    int x = [moneyTF.textField.text intValue];
    int y = x % 10000;
    if ([moneyTF.textField.text intValue] < 50000 || y != 0) {
        [SVProgressHUD showErrorWithStatus:@"最低预约金额50000元,且以万元为单位"];
        return;
    }
    
    //标期
    NSString *monthStr =  @"";
    for (NSString *str in aryApply) {
        monthStr = [monthStr stringByAppendingFormat:@",%@",str];
    }
    applyOrder.monthStr = [monthStr substringFromIndex:1];
    
    //时间
    applyOrder.timeStr = timeTF.textField.text;
    
    //类型标
    NSString *typeStr = @"";
    for (NSString *type in aryType) {
        typeStr = [typeStr stringByAppendingFormat:@",%@",type];
    }
    
    applyOrder.typeStr = [typeStr substringFromIndex:1];
    
    //金额取整
    int moneyint = [moneyTF.textField.text intValue];
    applyOrder.moneyStr = [NSString stringWithFormat:@"%d",moneyint];
    
    UserModel *userModel = [UserModel shareUserManager];
    NSDictionary *para = @{@"client_id":KEY_CLIENTID,@"user_name":userModel.userName,@"password":userModel.password,@"apply_toterm":applyOrder.monthStr,@"borrowing_type":applyOrder.typeStr,@"apply_time":applyOrder.timeStr,@"money":applyOrder.moneyStr};
    para = @{@"cmdid":@"set_borrow",@"data":para};
    NSLog(@"para = %@",para);
    [HttpManager hmRequestWithPara:para Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        NSLog(@"receiveData = %@",receiveData);
        if (rqCode == rqSuccess) {
            NSString *strPrompt = [NSString stringWithFormat:@"恭喜您已登记预约项目，益投网贷客服将在%@ 12:00 前通知您是否预约成功，请保持联系方式的畅通",timeTF.textField.text];
            [SVProgressHUD showSuccessWithStatus:strPrompt];
            
            timer = [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(timerFired) userInfo:nil repeats:NO];
            
        }else{
            [SVProgressHUD showErrorWithStatus:describle];
        }
    }];
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

/**
 *  跳转到预约记录
 */
- (void)timerFired{
    [timer invalidate];
    
    [selectorView showSelectorRecord];
    [recordView beginRefreshTableView];
}

- (NSString *)loadCurrentDate{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];//设置显示的日期
    NSString *currentDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:currentDate]];
    return currentDateString;
}

- (UILabel *)showLabelWithFrame:(CGRect)frame Content:(NSString *)content{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [label setTextColor:[UIColor blackColor]];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setText:content];
    [label setFont:FONT_14];
    
    return label;
}

- (void)showRequestButtonWithFrame:(CGRect)frame Tag:(NSInteger)tag Content:(NSString *)content{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setBackgroundImage:IMAGENAMED(@"login_unCheck") forState:UIControlStateNormal];
    [button setBackgroundImage:IMAGENAMED(@"login_checked") forState:UIControlStateSelected];
    [button setTag:tag];
    [button addTarget:self action:@selector(selectorRequestButton:) forControlEvents:UIControlEventTouchUpInside];
    [orderBackView addSubview:button];
    
    UILabel *requestLab = [self showLabelWithFrame:CGRectMake(VIEWFW_X(button), VIEWFOY(button)+(VIEWFSH(button)-14)/2, 50, 14) Content:content];
    [orderBackView addSubview:requestLab];
    
}

- (void)selectorRequestButton:(UIButton *)sender{
    
    if (sender.selected) {
        sender.selected = NO;
    }else{
        sender.selected = YES;
    }
    
    UIButton *btn01 = (UIButton *)[orderBackView viewWithTag:301];
    UIButton *btn02 = (UIButton *)[orderBackView viewWithTag:302];
    UIButton *btn03 = (UIButton *)[orderBackView viewWithTag:303];
    UIButton *btn04 = (UIButton *)[orderBackView viewWithTag:304];
    
    UIButton *btn1 = (UIButton *)[orderBackView viewWithTag:305];
    UIButton *btn2 = (UIButton *)[orderBackView viewWithTag:306];
    UIButton *btn3 = (UIButton *)[orderBackView viewWithTag:307];
    UIButton *btn4 = (UIButton *)[orderBackView viewWithTag:308];

    switch (sender.tag) {
        case 301:
            btn04.selected = NO;
            break;
        case 302:
            btn04.selected = NO;
            break;
        case 303:
            btn04.selected = NO;
            break;
        case 304:
            btn01.selected = NO;
            btn02.selected = NO;
            btn03.selected = NO;
            break;
        case 305:
            btn4.selected = NO;
            break;
        case 306:
            btn4.selected = NO;
            break;
        case 307:
            btn4.selected = NO;
            break;
        case 308:
            btn1.selected = NO;
            btn2.selected = NO;
            btn3.selected = NO;
            break;
            
        default:
            break;
    }
}

/**
 *  加载约标记录页
 */
- (void)loadDataRecordList{
    recordView = [[RecordView alloc] initWithFrame:CGRectMake(SCREENWidth, 0, SCREENWidth, SCREENHeight-109)];
    [recordView setBackgroundColor:[UIColor whiteColor]];
    [scrollView addSubview:recordView];
    
    [recordView beginRefreshTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
