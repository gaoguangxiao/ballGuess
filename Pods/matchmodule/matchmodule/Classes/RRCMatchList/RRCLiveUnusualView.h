//
//  RRCLiveUnusualView.h
//  MXSFramework
//
//  Created by 人人彩 on 2019/7/19.
//  Copyright © 2019 MXS. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface RRCLiveUnusualView : UIView

@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIButton *retryBtn;
@property (nonatomic,strong) UIButton *switchPlay;

/// 是否全屏异常
@property (nonatomic , assign) BOOL isCloseFullScreen;

@property (nonatomic,assign) BOOL isShowSwitch;//是否显示切换按钮
@property (nonatomic,copy) void (^UnusualBlock)(BOOL isTouch);//重加载
@property (nonatomic,copy) void (^swithPlayBlock)(BOOL isTouch);//切换源
@end

NS_ASSUME_NONNULL_END
