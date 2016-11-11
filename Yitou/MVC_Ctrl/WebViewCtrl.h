//
//  WebViewCtrl.h
//  Yitou
//
//  Created by mac on 15/11/27.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import "BaseController.h"

//typedef enum{
//    Click_LiJiTouBiao,
//    Click_WoDeLiQuan
//} WebViewClickBtnIndex;
//
//@protocol WebViewCtrlDelegate <NSObject>
//
//- (void)returnWebViewCtrlIndex:(WebViewClickBtnIndex)index Parameter:(NSString *)parameter;//1是立即投标,2是
//
//@end

@interface WebViewCtrl : BaseController

@property (nonatomic,copy)NSString *url;

@property (nonatomic,copy)NSString *name;

//@property (nonatomic,assign) id<WebViewCtrlDelegate> delegate;

//- (void)webViewBlock:(ValueIntegerBlock)block;

@end
