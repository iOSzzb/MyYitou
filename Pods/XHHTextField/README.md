# XHHTextField 效果如图
 ![image](https://raw.githubusercontent.com/Xiaohui666/XHHTextField/master/XHHTextField/Resource/ScreenShot01.png)
这是一个 icon+UITextField组成的小控件



导入方法:pod 'XHHTextField' ,:git => 'https://github.com/Xiaohui666/XHHTextField.git'

也可以直接down下来,然后使用class里面的两个文件


#使用方法

import <XHHTextField.h>


初始化方法:XHHTextField *textField = [[XHHTextField alloc] initWithFrame:CGRectMake(100, 100, SCREEN_WIDTH - 200, 35) image:[UIImage imageNamed:@"mobile"]];//image可以为nil



//下面的方法根据自己的需要来调用就可以了  都可以不设置
//如果注意设置颜色,不然可能因为颜色导致添加成功了但看不见

[textField setBackgroundColor:[UIColor grayColor]]; //设置背景颜色

[textField setBorderColor:[UIColor whiteColor]];    //设置textField的边框颜色

[textField setMaxLength:4]; //设置输入的文本长度

[textField setSecureTextEntry:YES];//是否以密码的方式显示

[textField.textField setTextColor:[UIColor whiteColor]];

[textField setFilletHeight:textField.frame.size.height/2]; //设置圆角  最大为textField高度的1/2

请不要去设置textField.textField的delegate,不然maxLength和isCheck将会失效

maxLength代表textField接受输入的最大长度

isCheck用来表示文本是否发生过变化textField.isCheck设置为YES后如果textField.text的值与设置为YES时的值不一样了则isCheck == NO 






