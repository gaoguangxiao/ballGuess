//
//  AlertView.m
//  GGAlertAction
//
//  Created by 吉祥 on 2017/8/21.
//  Copyright © 2017年 jixiang. All rights reserved.
//

#import "RRCAlertView.h"
#import "RRCAlertViewCell.h"
static float const kPopoverViewCellHeight = 58.f; ///< cell指定高度

@interface RRCAlertView () <UITableViewDelegate, UITableViewDataSource>

#pragma mark - UI
@property (nonatomic, weak) UIWindow *keyWindow; ///< 当前窗口
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *shadeView; ///< 遮罩层
@property (nonatomic, weak) UITapGestureRecognizer *tapGesture; ///< 点击背景阴影的手
#pragma mark - Data
@property (nonatomic, copy) NSMutableArray<RRCAlertAction *> *actions;
@property (nonatomic, assign) CGFloat windowWidth; ///< 窗口宽度
@property (nonatomic, assign) CGFloat windowHeight; ///< 窗口高度
@property (nonatomic, strong)NSMutableArray *actionArr;
@property (nonatomic, assign)NSIndexPath * selectIndexPath;
@end

@implementation RRCAlertView

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
    _tableView.frame = CGRectMake(0,  0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 1);
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

- (void)setStyle:(PopoverViewStyle)style {
    _style = style;
    if (_style == PopoverViewStyleDefault) {
        self.backgroundColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1.00];
    }
}

#pragma mark - Private
/*! @brief 初始化相关 */
- (void)initialize {
    // data
    _actions = [NSMutableArray array];
    _style = PopoverViewStyleDefault;
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
    // tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = RRCBackViewColor;
    [self addSubview:_tableView];
    
    _tableView.layer.cornerRadius = 4;
}
#pragma mark - Public
+ (instancetype)popoverView {
    return [[self alloc] init];
}
/*! @brief 指向指定的View来显示弹窗 */
- (void)showWithActions:(NSMutableArray<RRCAlertAction *> *)actions {
    _actions = [actions copy];
    _actionArr =_actions;
    NSAssert(_actions.count > 0, @"actions must not be nil or empty !");
    // 遮罩层
    _shadeView.alpha = 0.f;
    [_keyWindow addSubview:_shadeView];
    // 刷新数据以获取具体的ContentSize
    [_tableView reloadData];
    [_tableView layoutIfNeeded];
    CGFloat currentH = _actions.count * kPopoverViewCellHeight + 10;//高度需要计算，自动获取不可以了
    // 限制最高高度, 免得选项太多时超出屏幕
    if (currentH > _windowHeight) { // 如果弹窗高度大于最大高度的话则限制弹窗高度等于最大高度并允许tableView滑动.
        currentH = _windowHeight;
        _tableView.scrollEnabled = YES;
    }
    
    
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_tableView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(4*Device_Ccale, 4*Device_Ccale)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = _tableView.bounds;
//    maskLayer.path  = maskPath.CGPath;
//    [_tableView.layer addSublayer:maskLayer];
    
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
//    [UIView animateWithDuration:0.25f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0.f;
        self->_shadeView.alpha = 0.f;
        self.frame = CGRectMake(0, self->_windowHeight, self->_windowWidth, self->_tableView.contentSize.height);
//    } completion:^(BOOL finished) {
        [self->_shadeView removeFromSuperview];
        [self removeFromSuperview];
//    }];
}
#pragma mark  **UITABLEVIEWDELEGATE**
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 0 : 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return section == 1 ? [UIView new] : nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_actionArr[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kPopoverViewCellHeight;
}

static NSString *kPopoverCellIdentifier = @"kPopoverCellIdentifier";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RRCAlertViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPopoverCellIdentifier];
    if (!cell) {
        cell = [[RRCAlertViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPopoverCellIdentifier];
    }
    [cell setAction:_actionArr[indexPath.section][indexPath.row]];
    
    if (_actionArr.count > 2) {
        RRCAlertAction * Aaction =_actionArr[2];
        if (indexPath.section == 0) {
            if (indexPath.row == Aaction.selectRow) {
                cell.selectImage.hidden = NO;
                _selectIndexPath = indexPath;
                cell.titleLabel.textColor = RRCHighLightTitleColor;
            }else{
                cell.titleLabel.textColor = RRCGrayTextColor;
            }
        }
    }else{
        cell.selectImage.hidden = NO;
    }
        return cell;
}
//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RRCAlertViewCell *cell = [self.tableView cellForRowAtIndexPath:_selectIndexPath];
    cell.selectImage.hidden = YES;
    [UIView animateWithDuration:0.25f animations:^{
        RRCAlertViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.selectImage.hidden = NO;
        self.alpha = 0.f;
        self->_shadeView.alpha = 0.f;
    } completion:^(BOOL finished) {
        RRCAlertAction *action = self->_actionArr[indexPath.section][indexPath.row];
        action.handler ? action.handler(action) : NULL;
        self->_actions = nil;
        [self->_shadeView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

@end
