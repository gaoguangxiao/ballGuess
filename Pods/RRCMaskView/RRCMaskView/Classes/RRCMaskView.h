//
//  AlertView.h
//  GGAlertAction
//
//  Created by 吉祥 on 2017/8/21.
//  Copyright © 2017年 jixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AlertBottomStyle) {
    RRCMaskViewStyleBottom = 0, // 默认风格，下方
    RRCMaskViewStyleTop,        // 黑色风格，上方 默认导航栏
};

@interface RRCMaskView : UIView

@property (nonatomic, assign) BOOL hideAfterTouchOutside; ///< 是否开启点击外部隐藏弹窗, 默认为YES.
@property (nonatomic, assign) BOOL showShade; ///< 是否显示阴影, 如果为YES则弹窗背景为半透明的阴影层, 否则为透明, 默认为NO.
@property (nonatomic, strong) UIView *actionsView;//内容视图
@property (nonatomic, assign) AlertBottomStyle alertType;//弹出类型

@property (nonatomic, assign) CGFloat actionsViewOffy;//视图距离顶部

@property (nonatomic, strong) void(^hiddenView)(BOOL isEnd);//视图隐藏触发block

+ (instancetype)popoverView;


/// 隐藏
- (void)hide;

- (void)showWithActionView:(UIView *)actionsView andAlertType:(AlertBottomStyle)alertType;

@end
