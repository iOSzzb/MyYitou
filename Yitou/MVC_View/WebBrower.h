//
//  WebBrower.h
//  Analysize
//
//  Created by Xiaohui on 15/7/27.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SUCCESS_REGISTER        @"成功！"
#define SUCCESS_PAY             @"充值成功"


@interface WebBrower : UIView<UIWebViewDelegate>


typedef void(^WebBrowerBlock)(NSInteger rtCode,NSString *newUrlStr);

/**
 *  加载webView
 *
 *  @param postStr 网址
 *  @param block   用来回调 当检测到有成功两个字时会执行操作成功的block
 */
- (id)loadWebBrowerWithPostStr:(NSString*)postStr andBlock:(WebBrowerBlock)block;

@end
