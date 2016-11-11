//
//  ProtocolWebCtrl.h
//  Yitou
//
//  Created by Xiaohui on 15/11/3.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProtocolWebCtrl : UIViewController

/**
 *  加载合同协议到WebView
 *
 *  @param path    协议存放的路径
 *  @param baseUrl 不需要baseUrl的时候请将baseUrl的值设置为@""
 */
- (void)loadWebViewWithProtocolPath:(NSString *)path baseUrl:(NSString *)baseUrl;

@end