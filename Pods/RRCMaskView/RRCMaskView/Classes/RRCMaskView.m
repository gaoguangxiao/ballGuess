//
//  AlertView.m
//  GGAlertAction
//
//  Created by 吉祥 on 2017/8/21.
//  Copyright © 2017年 jixiang. All rights reserved.
//

#import "RRCMaskView.h"

@interface RRCMaskView ()

#pragma mark - UI
@property (nonatomic, weak) UIWindow *keyWindow; ///< 当前窗口
@property (nonatomic, strong) UIView *shadeFillView; ///遮罩补充层
@property (nonatomic, strong) UIView *shadeView; ///< 遮罩层
@property (nonatomic, weak) UITapGestureRecognizer *tapGesture; ///< 点击背景阴影的手
#pragma mark - Data
@property (nonatomic, assign) CGFloat windowWidth; ///< 窗口宽度
@property (nonatomic, assign) CGFloat windowHeight; ///< 窗口高度
@property (nonatomic, assign)NSIndexPath * selectIndexPath;
@end

@implementation RRCMaskView

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
    // keyWindow
    _keyWindow = [UIApplication sharedApplication].keyWindow;
    _windowWidth = CGRectGetWidth(_keyWindow.bounds);
    _windowHeight = CGRectGetHeight(_keyWindow.bounds);
    // shadeView
    _shadeView = [[UIView alloc] initWithFrame:_keyWindow.bounds];
    _shadeFillView = [[UIView alloc] initWithFrame:CGRectZero];
    [self setShowShade:NO];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [_shadeView addGestureRecognizer:tapGesture];
    UITapGestureRecognizer *tapFillGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [_shadeFillView addGestureRecognizer:tapFillGesture];
    
    _tapGesture = tapGesture;
    
}
#pragma mark - Public
+ (instancetype)popoverView {
    return [[self alloc] init];
}
/*! @brief 指向指定的View来显示弹窗 */
- (void)showWithActionView:(UIView *)actionView andAlertType:(AlertBottomStyle)alertType{
    
    _actionsView = actionView;
    self.alpha = 1.0;
    _shadeView.alpha = 0.f;
    [_keyWindow addSubview:_shadeView];
    [_keyWindow addSubview:_shadeFillView];
    CGFloat currentH = actionView.frame.size.height;//高度需要计算，自动获取不可以了
    // 限制最高高度, 免得选项太多时超出屏幕
    if (currentH > _windowHeight) {
        currentH = _windowHeight;
    }
    
    [_keyWindow addSubview:self];
    [self addSubview:actionView];
    
    if (alertType == RRCMaskViewStyleBottom) {
        _shadeView.frame = CGRectMake(0, 0, _windowWidth, _windowHeight);
        self.frame = CGRectMake(0, _windowHeight, _windowWidth, currentH);
        //弹出动画
        [UIView animateWithDuration:0.25f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.frame = CGRectMake(0, self->_windowHeight - currentH, self->_windowWidth, currentH);
            self->_shadeView.alpha = 1.f;
        } completion:^(BOOL finished) {
            
        }];
    }else{
        CGFloat topMargin = self.actionsViewOffy;
        
        _shadeFillView.frame = CGRectMake(0, 0, _windowWidth, topMargin);
        _shadeView.frame = CGRectMake(0, topMargin, _windowWidth, _windowHeight - topMargin);
        
        self.frame = CGRectMake(0, topMargin, _windowWidth, 0);
        [UIView animateWithDuration:0.25f animations:^{
            self.frame = CGRectMake(0, topMargin, self->_windowWidth, currentH);
            
            self->_shadeView.alpha = 1.f;
        } completion:^(BOOL finished) {
        }];
    }
}
/*! @brief 点击外部隐藏弹窗 */
- (void)hide {
    
    [UIView animateWithDuration:0.25f animations:^{
        
        //消失动画
        if (self.alertType == RRCMaskViewStyleBottom) {
            
            self.frame = CGRectMake(0, self.windowHeight, self.windowWidth, self.frame.size.height);
          
        }else{

//            [UIView animateWithDuration:0.25f animations:^{
//                self.frame = CGRectMake(0, -self -> _windowHeight, self->_windowWidth, self.frame.size.height);
//                self->_shadeView.alpha = 0.f;
//            } completion:^(BOOL finished) {
//            }];
        }
        
        self.alpha = 0.f;
        self->_shadeView.alpha = 0.f;
    } completion:^(BOOL finished) {
        
        if (self.hiddenView) {
            self.hiddenView(finished);
        }
        
        [self.actionsView removeFromSuperview];
        self.actionsView = nil;
        [self.shadeView removeFromSuperview];
        [self.shadeFillView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

@end
