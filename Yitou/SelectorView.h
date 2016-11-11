//
//  SelectorView.h
//  Yitou
//
//  Created by imac on 16/3/14.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ORDER_SELECTOR,   //选中了预约按钮
    RECORD_SELECTOR   //选中了记录按钮
} SELECTOR_Btn;

@protocol SelectorViewDelegate <NSObject>

- (void)selectorButtontag:(SELECTOR_Btn)buttontag;

@end

@interface SelectorView : UIView

@property (nonatomic,assign) id<SelectorViewDelegate> delegate;

- (void)LoadSelectorView;

- (void)showSelectorRecord;

@end
