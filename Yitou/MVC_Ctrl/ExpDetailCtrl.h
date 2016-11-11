//
//  ExpDetailCtrl.h
//  Yitou
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "BaseController.h"
#import "Tender.h"

@interface ExpDetailCtrl : BaseController<UITableViewDelegate,UITableViewDataSource>

/**
 *  标的源数据
 */
@property (nonatomic,copy)NSDictionary *detail;

//@property (nonatomic,strong)UIButton *investBtn;

@property (retain)Tender *tender;

@end
