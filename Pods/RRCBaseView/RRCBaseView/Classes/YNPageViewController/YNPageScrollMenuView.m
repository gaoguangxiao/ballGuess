//
//  YNPageScrollMenuView.m
//  YNPageViewController
//
//  Created by ZYN on 2018/4/22.
//  Copyright © 2018年 yongneng. All rights reserved.
//

#import "YNPageScrollMenuView.h"
#import "YNPageConfigration.h"
#import "YNPageScrollView.h"
#import "UIView+YNPageExtend.h"
#import "YBColorConfigure.h"
#define kYNPageScrollMenuViewConverMarginX 5

#define kYNPageScrollMenuViewConverMarginW 10

@interface YNPageScrollMenuView ()
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
/// line指示器
@property (nonatomic, strong) UIView *lineView;
/// 蒙层
@property (nonatomic, strong) UIView *converView;
/// ScrollView
@property (nonatomic, strong) YNPageScrollView *scrollView;
/// 底部线条
@property (nonatomic, strong) UIView *bottomLine;
/// 配置信息
@property (nonatomic, strong) YNPageConfigration *configration;
/// 代理
@property (nonatomic, weak) id<YNPageScrollMenuViewDelegate> delegate;
/// 上次index
@property (nonatomic, assign) NSInteger lastIndex;
/// 当前index
@property (nonatomic, assign) NSInteger currentIndex;
/// items 按钮
@property (nonatomic, strong) NSMutableArray<UIButton *> *itemsArrayM;
/// itemsBadge label
@property (nonatomic, strong) NSMutableArray *itemsBadgeArrayM;
/// item宽度
@property (nonatomic, strong) NSMutableArray *itemsWidthArraM;

@end

@implementation YNPageScrollMenuView

#pragma mark - Init Method

+ (instancetype)pagescrollMenuViewWithFrame:(CGRect)frame
                                     titles:(NSMutableArray *)titles
                               configration:(YNPageConfigration *)configration
                                   delegate:(id<YNPageScrollMenuViewDelegate>)delegate
                               currentIndex:(NSInteger)currentIndex {
    
    frame.size.height = configration.menuHeight;
    frame.size.width = configration.menuWidth;
    
    YNPageScrollMenuView *menuView = [[YNPageScrollMenuView alloc] initWithFrame:frame];
    menuView.titles = titles;
    menuView.delegate = delegate;
    menuView.configration = configration ?: [YNPageConfigration defaultConfig];
    menuView.currentIndex = currentIndex;
    menuView.itemsArrayM = @[].mutableCopy;
    menuView.itemsWidthArraM = @[].mutableCopy;
    
    [menuView setupSubViews];
    return menuView;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark - Private Method
- (void)setupSubViews {
    
    [self setupItems];
    [self setupOtherViews];
}

- (void)setupItems {
    
    if (self.configration.buttonArray.count > 0 && self.titles.count == self.configration.buttonArray.count) {
        [self.configration.buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull itemButton, NSUInteger idx, BOOL * _Nonnull stop) {
            [self setupButton:itemButton title:self.titles[idx] idx:idx];
        }];
    } else {
        [self.titles enumerateObjectsUsingBlock:^(id  _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self setupButton:itemButton title:title idx:idx];
        }];
    }
    
}

- (void)setupButton:(UIButton *)itemButton title:(NSString *)title idx:(NSInteger)idx {
    itemButton.titleLabel.font = self.configration.selectedItemFont;
    [itemButton setTitleColor:self.configration.normalItemColor forState:UIControlStateNormal];
    [itemButton setTitle:title forState:UIControlStateNormal];
    itemButton.tag = idx;
    
    [itemButton addTarget:self action:@selector(itemButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [itemButton sizeToFit];
    
    [self.itemsWidthArraM addObject:@(itemButton.yn_width)];
    [self.itemsArrayM addObject:itemButton];
    [self.scrollView addSubview:itemButton];
    
}

- (void)setupOtherViews {
    self.backgroundColor = self.configration.scrollViewBackgroundColor;
    //    self.scrollView.frame = CGRectMake(0, 0, self.configration.showAddButton ? self.yn_width - self.yn_height : self.yn_width, self.yn_height);
    self.scrollView.frame = CGRectMake(0, 0, self.configration.showAddButton ? self.yn_width : self.yn_width, self.yn_height);
    [self addSubview:self.scrollView];
    
    if (self.configration.showAddButton) {
        CGFloat addWidth = self.configration.addButtonNormalWidth;
        self.addButton.frame = CGRectMake(self.yn_width - addWidth, 0, addWidth, self.yn_height);
        [self addSubview:self.addButton];
    }
    
    /// item
    __block CGFloat itemX = 0;
    __block CGFloat itemY = 0;
    __block CGFloat itemW = 0;
    __block CGFloat itemH = self.yn_height - self.configration.lineHeight;
    
    [self.itemsArrayM enumerateObjectsUsingBlock:^(UIButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            itemX += self.configration.itemLeftAndRightMargin;
        }else{
            itemX += self.configration.itemMargin + [self.itemsWidthArraM[idx - 1] floatValue];
        }
        
        button.frame = CGRectMake(itemX, itemY, [self.itemsWidthArraM[idx] floatValue], itemH);
        if (self.configration.showItemBadge && self.titlesBadge.count == self.itemsArrayM.count) {
            NSInteger badge = [self.titlesBadge[idx] integerValue];
            
            if (badge != 0) {
                UILabel *itemBadgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.size.width, 6, 14, 14)];
                [self.itemsBadgeArrayM addObject:itemBadgeLabel];
                
                itemBadgeLabel.textAlignment = NSTextAlignmentCenter;
                itemBadgeLabel.layer.cornerRadius = 7;
                itemBadgeLabel.layer.masksToBounds = YES;
                itemBadgeLabel.font = [UIFont systemFontOfSize:10];
                itemBadgeLabel.backgroundColor = RRCThemeViewColor;
                itemBadgeLabel.textColor = RRCWhiteTextColor;
                
                [button addSubview:itemBadgeLabel];
                
                if (badge > 99) {
                    itemBadgeLabel.text = @"99+";
                }else{
                    itemBadgeLabel.text = [NSString stringWithFormat:@"%ld",badge];
                }
                
                if (itemBadgeLabel.text.length == 1) {
                    itemBadgeLabel.yn_width = 14;
                }else if (itemBadgeLabel.text.length == 2){
                    itemBadgeLabel.yn_width = 17;
                }else{
                    itemBadgeLabel.yn_width = 22;
                }
            }else{
                
            }
            
        }
    }];
    
    CGFloat scrollSizeWidht = self.configration.itemLeftAndRightMargin + CGRectGetMaxX([[self.itemsArrayM lastObject] frame]);
    if (scrollSizeWidht < self.scrollView.yn_width) {//不超出宽度
        itemX = 0;
        itemY = 0;
        itemW = 0;
        
        CGFloat left = 0;
        
        for (NSNumber *width in self.itemsWidthArraM) {
            left += [width floatValue];
        }
        
        left = (self.scrollView.yn_width - left - self.configration.itemMargin * (self.itemsWidthArraM.count-1)) * 0.5;
        /// 居中且有剩余间距
        if (self.configration.aligmentModeCenter && left >= 0) {
            [self.itemsArrayM enumerateObjectsUsingBlock:^(UIButton  * button, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (idx == 0) {
                    itemX += left;
                }else{
                    itemX += self.configration.itemMargin + [self.itemsWidthArraM[idx - 1] floatValue];
                }
                button.frame = CGRectMake(itemX, itemY, [self.itemsWidthArraM[idx] floatValue], itemH);
            }];
            
            self.scrollView.contentSize = CGSizeMake(left + CGRectGetMaxX([[self.itemsArrayM lastObject] frame]), self.scrollView.yn_height);
            
        } else { /// 否则按原来样子
            /// 不能滚动则平分
            if (!self.configration.scrollMenu) {
                [self.itemsArrayM enumerateObjectsUsingBlock:^(UIButton  * button, NSUInteger idx, BOOL * _Nonnull stop) {
                    itemW = self.scrollView.yn_width / self.itemsArrayM.count;
                    itemX = itemW *idx;
                    button.frame = CGRectMake(itemX, itemY, itemW, itemH);
                }];
                
                self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX([[self.itemsArrayM lastObject] frame]), self.scrollView.yn_height);
                
            } else {
                self.scrollView.contentSize = CGSizeMake(scrollSizeWidht, self.scrollView.yn_height);
            }
        }
    } else { /// 大于scrollView的width·
        self.scrollView.contentSize = CGSizeMake(scrollSizeWidht, self.scrollView.yn_height);
    }
    
    CGFloat lineX = [(UIButton *)[self.itemsArrayM firstObject] yn_x];
    CGFloat lineY = self.scrollView.yn_height - self.configration.lineHeight;
    CGFloat lineW = [[self.itemsArrayM firstObject] yn_width];
    CGFloat lineH = self.configration.lineHeight;
    
    if (!self.configration.scrollMenu &&
        !self.configration.aligmentModeCenter &&
        self.configration.lineWidthEqualFontWidth) { ///处理Line宽度等于字体宽度
        lineX = [(UIButton *)[self.itemsArrayM firstObject] yn_x] + ([[self.itemsArrayM firstObject] yn_width]  - ([self.itemsWidthArraM.firstObject floatValue])) / 2;
        lineW = [self.itemsWidthArraM.firstObject floatValue];
    }
    if (self.configration.showTopLine) {
        [self insertSubview:self.topLine atIndex:0];
        self.topLine.backgroundColor = self.configration.bottomLineBgColor;
        self.topLine.frame = CGRectMake(self.configration.bottomLineLeftAndRightMargin, 0, self.scrollView.yn_width - 2 * self.configration.bottomLineLeftAndRightMargin, self.configration.bottomLineHeight);
        self.topLine.layer.cornerRadius = self.configration.bottomLineCorner;
    }
    /// conver
    if (self.configration.showConver) {
        self.converView.frame = CGRectMake(lineX - kYNPageScrollMenuViewConverMarginX, (self.scrollView.yn_height - self.configration.converHeight - self.configration.lineHeight) * 0.5, lineW + kYNPageScrollMenuViewConverMarginW, self.configration.converHeight);
        [self.scrollView insertSubview:self.converView atIndex:0];
    }
    /// bottomline
    if (self.configration.showBottomLine) {
        self.bottomLine = [[UIView alloc] init];
        self.bottomLine.backgroundColor = self.configration.bottomLineBgColor;
        self.bottomLine.frame = CGRectMake(self.configration.bottomLineLeftAndRightMargin, self.yn_height - self.configration.bottomLineHeight, self.scrollView.yn_width - 2 * self.configration.bottomLineLeftAndRightMargin, self.configration.bottomLineHeight);
        self.bottomLine.layer.cornerRadius = self.configration.bottomLineCorner;
        [self insertSubview:self.bottomLine atIndex:0];
    }
    
    if (self.configration.showScrollLine) {
        self.lineView.frame = CGRectMake(lineX - self.configration.lineLeftAndRightAddWidth + self.configration.lineLeftAndRightMargin, lineY - self.configration.lineBottomMargin, lineW + self.configration.lineLeftAndRightAddWidth * 2 - 2 * self.configration.lineLeftAndRightMargin, lineH);
        self.lineView.layer.cornerRadius = self.configration.lineCorner;
        [self.scrollView addSubview:self.lineView];
    }
    
    if (self.configration.itemMaxScale > 1) {
        ((UIButton *)self.itemsArrayM[self.currentIndex]).transform = CGAffineTransformMakeScale(self.configration.itemMaxScale, self.configration.itemMaxScale);
    }
    
    [self setDefaultTheme];
    
    [self selectedItemIndex:self.currentIndex animated:NO];
    
}

- (void)setDefaultTheme {
    
    UIButton *currentButton = self.itemsArrayM[self.currentIndex];
    
    /// 缩放
    if (self.configration.itemMaxScale > 1) {
        currentButton.transform = CGAffineTransformMakeScale(self.configration.itemMaxScale, self.configration.itemMaxScale);
    }
    
    /// 颜色
    currentButton.selected = YES;
    [currentButton setTitleColor:self.configration.selectedItemColor forState:UIControlStateNormal];
    currentButton.titleLabel.font = self.configration.selectedItemFont;
    /// 线条
    if (self.configration.showScrollLine) {
        self.lineView.yn_x = currentButton.yn_x - self.configration.lineLeftAndRightAddWidth + self.configration.lineLeftAndRightMargin;
        self.lineView.yn_width = currentButton.yn_width + self.configration.lineLeftAndRightAddWidth *2 - self.configration.lineLeftAndRightMargin * 2;
        
        
        if (!self.configration.scrollMenu &&
            !self.configration.aligmentModeCenter &&
            self.configration.lineWidthEqualFontWidth) { /// 处理Line宽度等于字体宽度
            self.lineView.yn_x = currentButton.yn_x + ([currentButton yn_width]  - ([self.itemsWidthArraM[currentButton.tag] floatValue])) / 2 - self.configration.lineLeftAndRightAddWidth - self.configration.lineLeftAndRightAddWidth;
            self.lineView.yn_width = [self.itemsWidthArraM[currentButton.tag] floatValue] + self.configration.lineLeftAndRightAddWidth *2;
        }
    }
    /// 遮盖
    if (self.configration.showConver) {
        self.converView.yn_x = currentButton.yn_x - kYNPageScrollMenuViewConverMarginX;
        self.converView.yn_width = currentButton.yn_width +kYNPageScrollMenuViewConverMarginW;
        
        if (!self.configration.scrollMenu &&
            !self.configration.aligmentModeCenter &&
            self.configration.lineWidthEqualFontWidth) { ///处理conver宽度等于字体宽度
            
            self.converView.yn_x = currentButton.yn_x + ([currentButton yn_width]  - ([self.itemsWidthArraM[currentButton.tag] floatValue])) / 2 - kYNPageScrollMenuViewConverMarginX;
            self.converView.yn_width = [self.itemsWidthArraM[currentButton.tag] floatValue] + kYNPageScrollMenuViewConverMarginW;
        }
    }
    
    self.lastIndex = self.currentIndex;
}

- (void)adjustItemAnimate:(BOOL)animated {
    
    UIButton *lastButton = self.itemsArrayM[self.lastIndex];
    UIButton *currentButton = self.itemsArrayM[self.currentIndex];
    
    [UIView animateWithDuration:animated ? 0.3 : 0 animations:^{
        /// 缩放
        if (self.configration.itemMaxScale > 1) {
            lastButton.transform = CGAffineTransformMakeScale(1, 1);
            currentButton.transform = CGAffineTransformMakeScale(self.configration.itemMaxScale, self.configration.itemMaxScale);
        }
        /// 颜色
        [self.itemsArrayM enumerateObjectsUsingBlock:^(UIButton  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.selected = NO;
            [obj setTitleColor:self.configration.normalItemColor forState:UIControlStateNormal];
            obj.titleLabel.font = self.configration.itemFont;
            if (idx == self.itemsArrayM.count - 1) {
                currentButton.selected = YES;
                [currentButton setTitleColor:self.configration.selectedItemColor forState:UIControlStateNormal];
                currentButton.titleLabel.font = self.configration.selectedItemFont;
            }
        }];
        
        /// 线条
        if (self.configration.showScrollLine) {
            self.lineView.yn_x = currentButton.yn_x - self.configration.lineLeftAndRightAddWidth + self.configration.lineLeftAndRightMargin;
            self.lineView.yn_width = currentButton.yn_width + self.configration.lineLeftAndRightAddWidth * 2 - 2 * self.configration.lineLeftAndRightMargin;
            
            if (!self.configration.scrollMenu &&
                !self.configration.aligmentModeCenter &&
                self.configration.lineWidthEqualFontWidth) {//处理Line宽度等于字体宽度
                
                self.lineView.yn_x = currentButton.yn_x + ([currentButton yn_width]  - ([self.itemsWidthArraM[currentButton.tag] floatValue])) / 2 - self.configration.lineLeftAndRightAddWidth;
                self.lineView.yn_width = [self.itemsWidthArraM[currentButton.tag] floatValue] + self.configration.lineLeftAndRightAddWidth *2;
            }
            
            if (!self.configration.lineWidthEqualFontWidth && self.configration.lineWidth > 0) {
                self.lineView.yn_x = currentButton.yn_x + ([currentButton yn_width]  - self.configration.lineWidth )/ 2 - self.configration.lineLeftAndRightAddWidth;
                self.lineView.yn_width = self.configration.lineWidth + self.configration.lineLeftAndRightAddWidth *2;
            }
            
        }
        /// 遮盖
        if (self.configration.showConver) {
            self.converView.yn_x = currentButton.yn_x - kYNPageScrollMenuViewConverMarginX;
            self.converView.yn_width = currentButton.yn_width +kYNPageScrollMenuViewConverMarginW;
            
            if (!self.configration.scrollMenu&&!self.configration.aligmentModeCenter&&self.configration.lineWidthEqualFontWidth) { /// 处理conver宽度等于字体宽度
                
                self.converView.yn_x = currentButton.yn_x + ([currentButton yn_width]  - ([self.itemsWidthArraM[currentButton.tag] floatValue])) / 2  - kYNPageScrollMenuViewConverMarginX;
                self.converView.yn_width = [self.itemsWidthArraM[currentButton.tag] floatValue] +kYNPageScrollMenuViewConverMarginW;
            }
        }
        
        self.lastIndex = self.currentIndex;
        
        
    }completion:^(BOOL finished) {
        [self adjustItemPositionWithCurrentIndex:self.currentIndex];
    }];
    
    
}
#pragma mark - Public Method

- (void)updateTitle:(NSString *)title index:(NSInteger)index {
    if (index < 0 || index > self.titles.count - 1) return;
    if (title.length == 0) return;
    [self reloadView];
}

- (void)updateTitles:(NSArray *)titles {
    if (titles.count != self.titles.count) return;
    [self reloadView];
}

-(void)updateTitlesBagde:(NSArray *)titlesBadge{
    if (self.configration.showItemBadge && self.titles.count == titlesBadge.count) {
        
        [self.itemsBadgeArrayM removeAllObjects];
        [self.titlesBadge removeAllObjects];
        
        [self.titlesBadge addObjectsFromArray:titlesBadge];
        [self reloadView];
    }
}

- (void)adjustItemPositionWithCurrentIndex:(NSInteger)index {
    
    if (self.scrollView.contentSize.width != self.scrollView.yn_width + 20) {
        
        UIButton *button = self.itemsArrayM[index];
        
        CGFloat offSex = button.center.x - self.scrollView.yn_width * 0.5;
        
        offSex = offSex > 0 ? offSex : 0;
        
        CGFloat maxOffSetX = self.scrollView.contentSize.width - self.scrollView.yn_width;
        
        maxOffSetX = maxOffSetX > 0 ? maxOffSetX : 0;
        
        offSex = offSex > maxOffSetX ? maxOffSetX : offSex;
        
        [self.scrollView setContentOffset:CGPointMake(offSex, 0) animated:YES];
        
    }
}

- (void)adjustItemWithProgress:(CGFloat)progress
                     lastIndex:(NSInteger)lastIndex
                  currentIndex:(NSInteger)currentIndex {
    self.lastIndex = lastIndex;
    self.currentIndex = currentIndex;
    
    if (lastIndex == currentIndex) return;
    UIButton *lastButton = self.itemsArrayM[self.lastIndex];
    UIButton *currentButton = self.itemsArrayM[self.currentIndex];
    
    /// 缩放系数
    if (self.configration.itemMaxScale > 1) {
        CGFloat scaleB = self.configration.itemMaxScale - self.configration.deltaScale * progress;
        CGFloat scaleS = 1 + self.configration.deltaScale * progress;
        lastButton.transform = CGAffineTransformMakeScale(scaleB, scaleB);
        currentButton.transform = CGAffineTransformMakeScale(scaleS, scaleS);
    }
    
    if (self.configration.showGradientColor) {
        
        /// 颜色渐变
        [self.configration setRGBWithProgress:progress];
        UIColor *norColor = [UIColor colorWithRed:self.configration.deltaNorR green:self.configration.deltaNorG blue:self.configration.deltaNorB alpha:1];
        UIColor *selColor = [UIColor colorWithRed:self.configration.deltaSelR green:self.configration.deltaSelG blue:self.configration.deltaSelB alpha:1];
        [lastButton setTitleColor:norColor forState:UIControlStateNormal];
        
        [currentButton setTitleColor:selColor forState:UIControlStateNormal];
    } else{
        if (progress > 0.5) {
            lastButton.selected = NO;
            currentButton.selected = YES;
            [lastButton setTitleColor:self.configration.normalItemColor forState:UIControlStateNormal];
            [currentButton setTitleColor:self.configration.selectedItemColor forState:UIControlStateNormal];
            currentButton.titleLabel.font = self.configration.selectedItemFont;
            
        } else if (progress < 0.5 && progress > 0){
            lastButton.selected = YES;
            [lastButton setTitleColor:self.configration.selectedItemColor forState:UIControlStateNormal];
            lastButton.titleLabel.font = self.configration.selectedItemFont;
            
            currentButton.selected = NO;
            [currentButton setTitleColor:self.configration.normalItemColor forState:UIControlStateNormal];
            currentButton.titleLabel.font = self.configration.itemFont;
            
        }
    }
    
    if (progress > 0.5) {
        lastButton.titleLabel.font = self.configration.itemFont;
        currentButton.titleLabel.font = self.configration.selectedItemFont;
    } else if (progress < 0.5 && progress > 0){
        lastButton.titleLabel.font = self.configration.selectedItemFont;
        currentButton.titleLabel.font = self.configration.itemFont;
    }
    CGFloat xD = 0;
    CGFloat wD = 0;
    if (!self.configration.scrollMenu &&
        !self.configration.aligmentModeCenter &&
        self.configration.lineWidthEqualFontWidth) {
        xD = currentButton.titleLabel.yn_x + currentButton.yn_x -( lastButton.titleLabel.yn_x + lastButton.yn_x );
        
        wD = currentButton.titleLabel.yn_width - lastButton.titleLabel.yn_width;
    } else {
        xD = currentButton.yn_x - lastButton.yn_x;
        wD = currentButton.yn_width - lastButton.yn_width;
    }
    
    /// 线条
    if (self.configration.showScrollLine) {
        
        if (!self.configration.scrollMenu &&
            !self.configration.aligmentModeCenter &&
            self.configration.lineWidthEqualFontWidth) { /// 处理Line宽度等于字体宽度
            self.lineView.yn_x = lastButton.yn_x + ([lastButton yn_width]  - ([self.itemsWidthArraM[lastButton.tag] floatValue])) / 2 - self.configration.lineLeftAndRightAddWidth + xD *progress;
            
            self.lineView.yn_width = [self.itemsWidthArraM[lastButton.tag] floatValue] + self.configration.lineLeftAndRightAddWidth *2 + wD *progress;
            
        } else {
            self.lineView.yn_x = lastButton.yn_x + xD *progress - self.configration.lineLeftAndRightAddWidth + self.configration.lineLeftAndRightMargin;
            self.lineView.yn_width = lastButton.yn_width + wD *progress + self.configration.lineLeftAndRightAddWidth *2 - 2 * self.configration.lineLeftAndRightMargin;
        }
    }
    /// 遮盖
    if (self.configration.showConver) {
        self.converView.yn_x = lastButton.yn_x + xD *progress - kYNPageScrollMenuViewConverMarginX;
        self.converView.yn_width = lastButton.yn_width  + wD *progress + kYNPageScrollMenuViewConverMarginW;
        
        if (!self.configration.scrollMenu &&
            !self.configration.aligmentModeCenter &&
            self.configration.lineWidthEqualFontWidth) { /// 处理cover宽度等于字体宽度
            self.converView.yn_x = lastButton.yn_x + ([lastButton yn_width]  - ([self.itemsWidthArraM[lastButton.tag] floatValue])) / 2 -  kYNPageScrollMenuViewConverMarginX + xD *progress;
            self.converView.yn_width = [self.itemsWidthArraM[lastButton.tag] floatValue] + kYNPageScrollMenuViewConverMarginW + wD *progress;
        }
        
    }
}

- (void)selectedItemIndex:(NSInteger)index
                 animated:(BOOL)animated {
    
    self.currentIndex = index;
    
    [self adjustItemAnimate:animated];
}

- (void)adjustItemWithAnimated:(BOOL)animated {
    if (self.lastIndex == self.currentIndex) return;
    
    [self adjustItemAnimate:animated];
}


#pragma mark - Lazy Method

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = self.configration.lineColor;
    }
    return _lineView;
}
- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [[UIView alloc]init];
        _topLine.backgroundColor = self.configration.lineColor;
    }
    return _topLine;
}

- (UIView *)converView {
    if (!_converView) {
        _converView = [[UIView alloc] init];
        _converView.layer.backgroundColor = self.configration.converColor.CGColor;
        _converView.layer.cornerRadius = self.configration.coverCornerRadius;
        _converView.layer.masksToBounds = YES;
        _converView.userInteractionEnabled = NO;
    }
    return _converView;
    
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[YNPageScrollView alloc] init];
        _scrollView.pagingEnabled = NO;
        _scrollView.bounces = self.configration.bounces;;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = self.configration.scrollMenu;
    }
    return _scrollView;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [[UIButton alloc] init];
        [_addButton setTitle:self.configration.addButtonNormalTitle forState:UIControlStateNormal];
        [_addButton setTitleColor:self.configration.addButtonTitleColor forState:UIControlStateNormal];
        _addButton.titleLabel.font = self.configration.addButtonTitleFont;
        [_addButton setImage:self.configration.addButtonNormalImage forState:UIControlStateNormal];
        [_addButton setImage:self.configration.addButtonHightImage forState:UIControlStateSelected];
        _addButton.tag = self.configration.addButtonTag;
        if (self.configration.addButtonImageRight) {
            _addButton.imageEdgeInsets = UIEdgeInsetsMake(0, 52, 0, -52);
            _addButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 20);
        }
        [_addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

#pragma mark - itemButtonTapOnClick

- (void)itemButtonOnClick:(UIButton *)button {
    
    self.currentIndex= button.tag;
    
    [self adjustItemWithAnimated:YES];
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(pagescrollMenuViewItemOnClick:index:)]) {
        [self.delegate pagescrollMenuViewItemOnClick:button index:self.lastIndex];
    }
    
}

- (void)reloadView {
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    [self.itemsArrayM removeAllObjects];
    [self.itemsWidthArraM removeAllObjects];
    [self setupSubViews];
    
}
#pragma mark -  addButtonAction

- (void)addButtonAction:(UIButton *)button {
    if(self.delegate && [self.delegate respondsToSelector:@selector(pagescrollMenuViewAddButtonAction:)]){
        [self.delegate pagescrollMenuViewAddButtonAction:button];
    }
}

-(NSMutableArray *)titlesBadge{
    if (!_titlesBadge) {
        _titlesBadge = [NSMutableArray new];
    }
    return _titlesBadge;
}
-(NSMutableArray *)itemsBadgeArrayM{
    if (!_itemsBadgeArrayM) {
        _itemsBadgeArrayM = [NSMutableArray new];
    }
    return _itemsBadgeArrayM;
}
@end
