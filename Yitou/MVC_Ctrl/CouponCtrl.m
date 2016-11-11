//
//  CouponCtrl.m
//  Yitou
//
//  Created by Xiaohui on 15/11/4.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import "CouponCtrl.h"

//#define COUPONHeight  (SCREENWidth - 40)*166/388

#define COUPONHeight  120

@interface CouponCtrl ()

@end

@implementation CouponCtrl{
    NSArray         *jiaxiAry;
    NSArray         *xianjinAry;
    NSArray         *hongbaoAry;
    UIScrollView    *scrollview;
    NSInteger       jiaxiIndex;
    NSInteger       xianjinIndex;
    NSInteger       hongbaoIndex;
    double          orignY;
    UIImageView     *imgvJiaxi;
    UIImageView     *imgvXianjin;
    UIImageView     *imgvHongbao;
    CustomNavigation *customNav;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.view tag] != 1024){
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
        [self.view setTag:1024];
    }
    [self.view setBackgroundColor:BG_BLUEColor];
    self.title = @"立即投资";

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (jiaxiIndex != -1){
        _addCoupon = [[[jiaxiAry objectAtIndex:jiaxiIndex] objectForKey:@"details"] floatValue];
        _jiaxiID = [[jiaxiAry objectAtIndex:jiaxiIndex] objectForKey:@"log_id"];
    }
    else{
        _addCoupon = 0.0;
        _jiaxiID = @"";
    }
    if (xianjinIndex != -1){
        _xianjinID = [[xianjinAry objectAtIndex:xianjinIndex] objectForKey:@"log_id"];
        _addMoney = [[[xianjinAry objectAtIndex:xianjinIndex] objectForKey:@"details"] floatValue];
        _mininvest = [[[xianjinAry objectAtIndex:xianjinIndex] objectForKey:@"mininvest"] floatValue];
        _hongbaoID = @"";
    }
    else{
        _xianjinID = @"";
        if (hongbaoIndex != -1) {
            _hongbaoID = [[hongbaoAry objectAtIndex:hongbaoIndex] objectForKey:@"log_id"];
            _addMoney = [[[hongbaoAry objectAtIndex:hongbaoIndex] objectForKey:@"details"] floatValue];
            _mininvest = [[[hongbaoAry objectAtIndex:hongbaoIndex] objectForKey:@"mininvest"] floatValue];
        }
        else {
            _hongbaoID = @"";
            _addMoney = 0.0;
        }
    }
    
}

- (void)loadAllView{
    [scrollview removeFromSuperview];
    orignY = 20;
    jiaxiIndex = -1;
    xianjinIndex = -1;
    hongbaoIndex = -1;
    scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
    [scrollview setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:scrollview];
    [self loadCouponInformation];
    [self loadImageView];
}

- (void)loadImageView{
    if ([jiaxiAry count]>0){
        imgvJiaxi = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 42, 42)];
        [imgvJiaxi setImage:IMAGENAMED(@"icon_selected")];
        [scrollview addSubview:imgvJiaxi];
        [imgvJiaxi setAlpha:0.0];
    }
    if ([xianjinAry count] > 0){
        imgvXianjin = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 42, 42)];
        [imgvXianjin setImage:IMAGENAMED(@"icon_selected")];
        [scrollview addSubview:imgvXianjin];
        [imgvXianjin setAlpha:0.0];
    }
    if ([hongbaoAry count] > 0){
        imgvHongbao = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 42, 42)];
        [imgvHongbao setImage:IMAGENAMED(@"icon_selected")];
        [scrollview addSubview:imgvHongbao];
        [imgvHongbao setAlpha:0.0];
    }
    
}

- (void)loadCouponInformation{
    NSInteger indx = 0;
    for (NSDictionary *dict in jiaxiAry){
        [self loadJiaxiCouponWith:dict index:indx];
        indx ++;
    }
    indx = 0;
    for (NSDictionary *dict in xianjinAry){
        [self loadXianjinCouponWith:dict index:indx];
        indx ++;
    }
    indx = 0;
    for (NSDictionary *dict in hongbaoAry){
        [self loadHongBaoCouponWith:dict index:indx];
        indx ++;
    }
    [scrollview setContentSize:CGSizeMake(0, orignY)];
}

/**
 *  加载加息券的UI
 *
 *  @param quanDict 单个加息券的信息
 */
- (void)loadJiaxiCouponWith:(NSDictionary *)quanDict index:(NSInteger)indx{

    UIButton *quanView = [[UIButton alloc] initWithFrame:CGRectMake(20, orignY, SCREENWidth - 40, COUPONHeight)];
    [quanView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, VIEWFSW(quanView), 12)];
    [backView setImage:IMAGENAMED(@"quan_bg_type1")];
    [quanView addSubview:backView];
    
    UILabel *infoLb = [[UILabel alloc] initWithFrame:CGRectMake(10, VIEWFSH(backView)+20, VIEWFSW(backView)/2, 30)];
    infoLb.text = [quanDict objectForKey:@"details"];
    infoLb.text = [infoLb.text stringByAppendingString:@"%"];
    [infoLb setTextAlignment:NSTextAlignmentLeft];
    [infoLb setFont:[UIFont systemFontOfSize:30]];
    [infoLb setTextColor:[UIColor colorWithRed:0.18 green:0.71 blue:0.92 alpha:1.00]];
    [quanView addSubview:infoLb];
    [quanView setTag:indx];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEWFOY(infoLb), VIEWFSW(backView)-20, 30)];
    NSString *prizeTypeId = [quanDict objectForKey:@"prize_type_id"];
    if ([prizeTypeId isEqualToString:@"52"]) {//黄金加息券
        nameLab.text = @"黄金加息券";
    }
    else {
        nameLab.text = @"加息券";
    }
    [nameLab setTextColor:[UIColor colorWithRed:0.18 green:0.71 blue:0.92 alpha:1.00]];
    [nameLab setFont:[UIFont systemFontOfSize:30]];
    [nameLab setTextAlignment:NSTextAlignmentRight];
    [quanView addSubview:nameLab];
    
    UILabel *markLab = [[UILabel alloc] initWithFrame:CGRectMake(10, VIEWFH_Y(nameLab)+20, VIEWFSW(backView)-20, 14)];
    if ([prizeTypeId isEqualToString:@"52"]) {//黄金加息券
        markLab.text = @"备注:可用于1丶2丶3月标";
    }
    else {
        markLab.text = @"备注:只能用于2丶3月标";
    }
    [markLab setTextColor:[UIColor grayColor]];
    [markLab setFont:[UIFont systemFontOfSize:14]];
    [markLab setTextAlignment:NSTextAlignmentLeft];
    [quanView addSubview:markLab];
    
    NSString *str = [NSString stringWithFormat:@"使用期限:%@-%@",[quanDict objectForKey:@"create_time"],[quanDict objectForKey:@"overdue_time"]];
    UILabel *lbTime = [[UILabel alloc] initWithFrame:CGRectMake(10, VIEWFH_Y(markLab)+5, VIEWFSW(quanView)-20, 14)];
    [lbTime setText:str];
    [lbTime setTextColor:[UIColor grayColor]];
    [lbTime setFont:[UIFont systemFontOfSize:14]];
    [lbTime setTextAlignment:NSTextAlignmentLeft];
    [quanView addSubview:lbTime];
    [quanView setTag:indx];
    [scrollview addSubview:quanView];
    orignY = VIEWFH_Y(quanView)+20;

    

    [quanView addTarget:self action:@selector(clickJiaxiCoupon:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)clickJiaxiCoupon:(id)sender{
    if (jiaxiIndex == [sender tag]){
        jiaxiIndex = -1;
        [imgvJiaxi setAlpha:0.0];
        _jiaxiID = @"";
        return;
    }
    [imgvJiaxi setFrame:CGRectMake(SCREENWidth - 70, [sender tag]*(COUPONHeight +20)+COUPONHeight - 20, 42, 42)];

    jiaxiIndex = [sender tag];
    [imgvJiaxi setAlpha:0.0];

    [UIView animateWithDuration:1.0 animations:^{
        [imgvJiaxi setAlpha:1.0];
        [imgvXianjin setAlpha:0.0];
        [imgvHongbao setAlpha:0.0];
        xianjinIndex = -1;
        _xianjinID = @"";
        hongbaoIndex = -1;
        _hongbaoID = @"";
    } completion:nil];
}

/**
 *  加载新手红包UI
 */
- (void)loadXianjinCouponWith:(NSDictionary *)quanDict index:(NSInteger)indx{
    
    UIButton *quanView = [[UIButton alloc] initWithFrame:CGRectMake(20, orignY, SCREENWidth - 40, COUPONHeight)];
    [quanView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, VIEWFSW(quanView), 12)];
    [backView setImage:IMAGENAMED(@"quan_bg_type2")];
    [quanView addSubview:backView];
    
    UILabel *infoLb = [[UILabel alloc] initWithFrame:CGRectMake(10, VIEWFSH(backView)+20, VIEWFSW(backView)/2, 30)];
    infoLb.text = [quanDict objectForKey:@"details"];
    infoLb.text = [infoLb.text stringByAppendingString:@"元"];
    [infoLb setTextAlignment:NSTextAlignmentLeft];
    [infoLb setFont:[UIFont systemFontOfSize:30]];
    [infoLb setTextColor:[UIColor colorWithRed:0.95 green:0.48 blue:0.52 alpha:1.00]];
    [quanView addSubview:infoLb];
    [quanView setTag:indx];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEWFOY(infoLb), VIEWFSW(backView)-20, 30)];
    nameLab.text = @"现金券";
    [nameLab setTextColor:[UIColor colorWithRed:0.95 green:0.48 blue:0.52 alpha:1.00]];
    [nameLab setFont:[UIFont systemFontOfSize:30]];
    [nameLab setTextAlignment:NSTextAlignmentRight];
    [quanView addSubview:nameLab];
    
    NSString *mininvestStr = [NSString stringWithFormat:@"备注:单笔投资%@元可用",[quanDict objectForKey:@"mininvest"]];
    UILabel *markLab = [[UILabel alloc] initWithFrame:CGRectMake(10, VIEWFH_Y(nameLab)+20, VIEWFSW(backView)-20, 14)];
    markLab.text = mininvestStr;
    [markLab setTextColor:[UIColor grayColor]];
    [markLab setFont:[UIFont systemFontOfSize:14]];
    [markLab setTextAlignment:NSTextAlignmentLeft];
    [quanView addSubview:markLab];
    
    NSString *str = [NSString stringWithFormat:@"使用期限:%@-%@",[quanDict objectForKey:@"create_time"],[quanDict objectForKey:@"overdue_time"]];
    UILabel *lbTime = [[UILabel alloc] initWithFrame:CGRectMake(10, VIEWFH_Y(markLab)+5, VIEWFSW(quanView)-20, 14)];
    [lbTime setText:str];
    [lbTime setTextColor:[UIColor grayColor]];
    [lbTime setFont:[UIFont systemFontOfSize:14]];
    [lbTime setTextAlignment:NSTextAlignmentLeft];
    [quanView addSubview:lbTime];
    [quanView setTag:indx];
    [scrollview addSubview:quanView];
    orignY = VIEWFH_Y(quanView)+20;
    
    [quanView addTarget:self action:@selector(clickXianjinCoupon:) forControlEvents:UIControlEventTouchUpInside];
    
}



- (void)clickXianjinCoupon:(id)sender{
    if (xianjinIndex == [sender tag]){
        xianjinIndex = -1;
        [imgvXianjin setAlpha:0.0];
        _xianjinID = @"";
        return;
    }
    [imgvXianjin setFrame:CGRectMake(SCREENWidth - 70, ([sender tag]+[jiaxiAry count])*(COUPONHeight +20)+COUPONHeight - 20, 42, 42)];

    xianjinIndex = [sender tag];
    [imgvXianjin setAlpha:0.0];

    [UIView animateWithDuration:1.0 animations:^{
        [imgvXianjin setAlpha:1.0];
        [imgvJiaxi setAlpha:0.0];
        [imgvHongbao setAlpha:0.0];
        jiaxiIndex = -1;
        _jiaxiID = @"";
        hongbaoIndex = -1;
        _hongbaoID = @"";
    } completion:nil];
}

/**
 *  加载新手红包UI
 */
- (void)loadHongBaoCouponWith:(NSDictionary *)quanDict index:(NSInteger)indx{
    
    UIButton *quanView = [[UIButton alloc] initWithFrame:CGRectMake(20, orignY, SCREENWidth - 40, COUPONHeight)];
    [quanView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, VIEWFSW(quanView), 12)];
    [backView setImage:IMAGENAMED(@"quan_bg_type2")];
    [quanView addSubview:backView];
    
    UILabel *infoLb = [[UILabel alloc] initWithFrame:CGRectMake(10, VIEWFSH(backView)+20, VIEWFSW(backView)/2, 30)];
    infoLb.text = [quanDict objectForKey:@"details"];
    infoLb.text = [infoLb.text stringByAppendingString:@"元"];
    [infoLb setTextAlignment:NSTextAlignmentLeft];
    [infoLb setFont:[UIFont systemFontOfSize:30]];
    [infoLb setTextColor:[UIColor colorWithRed:0.95 green:0.48 blue:0.52 alpha:1.00]];
    [quanView addSubview:infoLb];
    [quanView setTag:indx];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEWFOY(infoLb), VIEWFSW(backView)-20, 30)];
    nameLab.text = @"现金红包";
    [nameLab setTextColor:[UIColor colorWithRed:0.95 green:0.48 blue:0.52 alpha:1.00]];
    [nameLab setFont:[UIFont systemFontOfSize:30]];
    [nameLab setTextAlignment:NSTextAlignmentRight];
    [quanView addSubview:nameLab];
    
    NSString *mininvestStr = [NSString stringWithFormat:@"备注:单笔投资%@元可用",[quanDict objectForKey:@"mininvest"]];
    UILabel *markLab = [[UILabel alloc] initWithFrame:CGRectMake(10, VIEWFH_Y(nameLab)+20, VIEWFSW(backView)-20, 14)];
    markLab.text = mininvestStr;
    [markLab setTextColor:[UIColor grayColor]];
    [markLab setFont:[UIFont systemFontOfSize:14]];
    [markLab setTextAlignment:NSTextAlignmentLeft];
    [quanView addSubview:markLab];
    
    NSString *str = [NSString stringWithFormat:@"使用期限:%@-%@",[quanDict objectForKey:@"create_time"],[quanDict objectForKey:@"overdue_time"]];
    UILabel *lbTime = [[UILabel alloc] initWithFrame:CGRectMake(10, VIEWFH_Y(markLab)+5, VIEWFSW(quanView)-20, 14)];
    [lbTime setText:str];
    [lbTime setTextColor:[UIColor grayColor]];
    [lbTime setFont:[UIFont systemFontOfSize:14]];
    [lbTime setTextAlignment:NSTextAlignmentLeft];
    [quanView addSubview:lbTime];
    [quanView setTag:indx];
    [scrollview addSubview:quanView];
    orignY = VIEWFH_Y(quanView)+20;
    
    [quanView addTarget:self action:@selector(clickHongbaoCoupon:) forControlEvents:UIControlEventTouchUpInside];
    
}



- (void)clickHongbaoCoupon:(id)sender{
    if (hongbaoIndex == [sender tag]){
        hongbaoIndex = -1;
        [imgvHongbao setAlpha:0.0];
        _hongbaoID = @"";
        return;
    }
    [imgvHongbao setFrame:CGRectMake(SCREENWidth - 70, ([sender tag]+[xianjinAry count] + [jiaxiAry count])*(COUPONHeight +20)+COUPONHeight - 20, 42, 42)];
    
    hongbaoIndex = [sender tag];
    [imgvHongbao setAlpha:0.0];
    
    [UIView animateWithDuration:1.0 animations:^{
        [imgvHongbao setAlpha:1.0];
        [imgvJiaxi setAlpha:0.0];
        [imgvXianjin setAlpha:0.0];
        jiaxiIndex = -1;
        _jiaxiID = @"";
        xianjinIndex = -1;
        _xianjinID = @"";
    } completion:nil];
}


/**
 *  设置加息信息的attributedstring
 */
- (NSMutableAttributedString *)loadJiaxiAttriWithString:(NSString *)str{
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:34] range:NSMakeRange(0, [str length]-3)];
    [attri addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [str length])];
    return  attri;
}

- (void)loadCouponWithJiaxiData:(NSArray *)jiaxi xianjin:(NSArray *)xianjin hongbao:(NSArray *)hongbao{
    if ([self.view tag] != 1024){
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
        [self.view setTag:1024];
    }
    jiaxiAry = jiaxi;
    xianjinAry = xianjin;
    hongbaoAry = hongbao;
    [self loadAllView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
