//
//  AlertView.m
//  GGAlertAction
//
//  Created by 吉祥 on 2017/8/21.
//  Copyright © 2017年 jixiang. All rights reserved.
//

#import "RRCAlertBottomView.h"
#import "YBColorConfigure.h"

@interface RRCAlertBottomView ()

#pragma mark - UI
@property (nonatomic, weak) UIWindow *keyWindow; ///< 当前窗口

@property (nonatomic, strong) UIView *shadeView; ///< 遮罩层
@property (nonatomic, weak) UITapGestureRecognizer *tapGesture; ///< 点击背景阴影的手
#pragma mark - Data
@property (nonatomic, assign) CGFloat windowWidth; ///< 窗口宽度
@property (nonatomic, assign) CGFloat windowHeight; ///< 窗口高度
@property (nonatomic, strong) UIView *actionsView;
@property (nonatomic, assign)NSIndexPath * selectIndexPath;
@end

@implementation RRCAlertBottomView

#pragma mark - Lift Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) return nil;
    [self initialize];
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Setter
- (void)setHideAfterTouchOutside:(BOOL)hideAfterTouchOutside {
    _hideAfterTouchOutside = hideAfterTouchOutside;
    _tapGesture.enabled = _hideAfterTouchOutside;
}

- (void)setShowShade:(BOOL)showShade {
    _showShade = showShade;
    _shadeView.backgroundColor = _showShade ? [UIColor colorWithRed:68/255 green:68/255 blue:68/255 alpha:0.6] : [UIColor clearColor];
}


#pragma mark - Private
/*! @brief 初始化相关 */
- (void)initialize {
    // data
    // current view
    self.backgroundColor = RRCUnitViewColor;
    // keyWindow
    _keyWindow = [UIApplication sharedApplication].keyWindow;
    _windowWidth = CGRectGetWidth(_keyWindow.bounds);
    _windowHeight = CGRectGetHeight(_keyWindow.bounds);
    // shadeView
    _shadeView = [[UIView alloc] initWithFrame:_keyWindow.bounds];
    [self setShowShade:NO];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [_shadeView addGestureRecognizer:tapGesture];
    _tapGesture = tapGesture;
    
}
#pragma mark - Public
+ (instancetype)popoverView {
    return [[self alloc] init];
}
/*! @brief 指向指定的View来显示弹窗 */
- (void)showWithActionView:(UIView *)actionView{
    
    _actionsView = actionView;
    
    _shadeView.alpha = 0.f;
    [_keyWindow addSubview:_shadeView];
    
    CGFloat currentH = actionView.frame.size.height;//高度需要计算，自动获取不可以了
    // 限制最高高度, 免得选项太多时超出屏幕
    if (currentH > _windowHeight) {
        currentH = _windowHeight;
    }
    
    self.frame = CGRectMake(0, _windowHeight, _windowWidth, currentH);
    [_keyWindow addSubview:self];
    //弹出动画
    [UIView animateWithDuration:0.25f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = CGRectMake(0, self->_windowHeight - currentH, self->_windowWidth, currentH);
        self->_shadeView.alpha = 1.f;
    } completion:^(BOOL finished) {
        
    }];
}
/*! @brief 点击外部隐藏弹窗 */
- (void)hide {
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0.f;
        self->_shadeView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.actionsView removeFromSuperview];
        self.actionsView = nil;
        [self->_shadeView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

@end
