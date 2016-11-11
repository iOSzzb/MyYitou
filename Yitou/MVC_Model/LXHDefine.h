//
//  LXHDefine.h
//  Analysize
//
//  Created by Xiaohui on 15/7/23.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#ifndef Yitou_LXHDefine_h
#define Yitou_LXHDefine_h

#define VIEWFSH(View)  View.frame.size.height
#define VIEWFSW(View)  View.frame.size.width
#define VIEWFOX(View)  View.frame.origin.x
#define VIEWFOY(View)  View.frame.origin.y
#define VIEWFH_Y(View) (VIEWFSH(View)+VIEWFOY(View))
#define VIEWFW_X(View) (VIEWFOX(View)+VIEWFSW(View))

#define SCREENHeight  [UIScreen mainScreen].bounds.size.height
#define SCREENWidth   [UIScreen mainScreen].bounds.size.width

#define IMAGENAMED(imgName) [UIImage imageNamed:imgName]

/**
 *  生成二维码的URL 直接在text=后面加入要生成的内容
 */
#define QRCODE_URL    @"http://qr.liantu.com/api.php?text="

/**
 *  检查路径为pathStr的文件是否存在
 *
 *  @param pathStr 文件路径
 */
#define CHECKFileExist(pathStr) [[NSFileManager defaultManager] fileExistsAtPath:pathStr]

/**
 *  NavigationController的颜色
 */
#define NAVIGATIONColor  COLORWithRGB(41, 138, 225, 1)

/**
 *  比较两个string是否相等
 */
#define STRCMP(strA,strB)   [strA isEqualToString:strB]

/**
 *  通过不包含后缀的文件名name和后缀fileType来获取文件路径
 */
#define RESOURCE(name,fileType) [[NSBundle mainBundle] pathForResource:name ofType:fileType]

/**
 *  通过RGB值快速得到通过取色RGB的 返回UIColor  参数直接使用整形就可以了  没必要使用float类型
 */
#define COLORWithRGB(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A*1.0]

/**
 *  从userDefine中直接写入|读取数据
 */
#define USERDefineSet(Value,key)  [[NSUserDefaults standardUserDefaults] setObject:Value forKey:key]
#define USERDefineGet(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

/**
 *  比较正则表达式
 *
 *  @param regex 规则
 *  @param str   用来匹配是否符合规则的str
 */
#define REGEXStr(regex,str) [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex] evaluateWithObject:str]

/**
 *  检查是否是手机号 PS:这里只做了简单的开头为1&长度为11的匹配 不是很规范
 *
 *  @param Str 手机号
 */
#define CHECKMobile(Str)  REGEXStr(@"[1][0-9]{10}", Str)

/**
 *  默认使用的字体
 */
#define SYSTEMFONTName      @"AriaLMT"

/**
 *  NavigationController的字体大小
 */
#define NAV_FONTSize        20

#endif