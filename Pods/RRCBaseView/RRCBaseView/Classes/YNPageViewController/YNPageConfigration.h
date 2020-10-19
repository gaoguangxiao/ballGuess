//
//  YNPageConfigration.h
//  YNPageViewController
//
//  Created by ZYN on 2018/4/22.
//  Copyright © 2018年 yongneng. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 YNPage样式

 - YNPageStyleTop: MenuView在顶部
 - YNPageStyleNavigation: MenuView在系统导航条
 - YNPageStyleSuspensionTop: MenuView悬浮，刷新控件在HeaderView顶部
 - YNPageStyleSuspensionCenter: MenuView悬浮，刷新控件在HeaderView底部
 - YNPageStyleSuspensionTopPause: MenuView悬浮，刷新控件在HeaderView顶部 停顿 类似QQ联系人页面
   SuspensionTopPause 需要继承YNPageTableView或YNPageCollectionView 实现那个手势 YES,如果有自己的集成体系，则单独实现那个方法
 */
typedef NS_ENUM(NSInteger, YNPageStyle) {
    YNPageStyleTop = 0,
    YNPageStyleNavigation = 1,
    YNPageStyleSuspensionTop = 2,
    YNPageStyleSuspensionCenter = 3,
    YNPageStyleSuspensionTopPause = 4,
};

typedef NS_ENUM(NSUInteger, YNPageViewControllerPreloadPolicy) {
    YNPageViewControllerPreloadPolicyNever     = 0, // Never pre-load controller.
    YNPageViewControllerPreloadPolicyNeighbour = 1, // Pre-load the controller next to the current.
    YNPageViewControllerPreloadPolicyNear      = 2,  // Pre-load 2 controllers near the current.
    YNPageViewControllerPreloadPolicyAll      = 3  // Pre-load all controllers near the current.
    
};

/**
 头部放大效果

 - YNPageHeaderViewScaleModeTop: Top固定
 - YNPageHeaderViewScaleModeCenter: Center固定
 */
typedef NS_ENUM(NSInteger, YNPageHeaderViewScaleMode) {
    YNPageHeaderViewScaleModeTop = 0,
    YNPageHeaderViewScaleModeCenter = 1,
};

@interface YNPageConfigration : NSObject

#pragma mark - YNPage Config
/** 是否显示导航条 YES */
@property (nonatomic, assign) BOOL showNavigation;
/** 是否显示Tabbar NO */
@property (nonatomic, assign) BOOL showTabbar;
/** tabbar自定义高度*/
@property (nonatomic, assign) CGFloat tabbarHeight;
/** 裁剪内容高度 用来添加最上层控件 添加在父类view上 */
@property (nonatomic, assign) CGFloat cutOutHeight;
/** 菜单位置风格 默认 YNPageStyleTop */
@property (nonatomic, assign) YNPageStyle pageStyle;
/** 悬浮ScrollMenu偏移量 默认 0 */
@property (nonatomic, assign) CGFloat suspenOffsetY;
/** 页面是否可以滚动 默认 YES */
@property (nonatomic, assign) BOOL pageScrollEnabled;
/** 头部是否能伸缩效果   要伸缩效果最好不要有下拉刷新控件 NO */
@property (nonatomic, assign) BOOL headerViewCouldScale;
/** 头部伸缩效果 */
@property (nonatomic, assign) YNPageHeaderViewScaleMode headerViewScaleMode;
/** 头部是否可以滚页面 NO */
@property (nonatomic, assign) BOOL headerViewCouldScrollPage;
/** 头部是否可以将页面滚动失败  */
@property (nonatomic, assign) BOOL headerViewCouldFailScrollPage;
/** headerView + menu height */
@property (nonatomic, assign, readonly) CGFloat pageHeaderViewOriginHeight;
/** 预加载机制，在停止滑动的时候预加载 n 页 */
@property (nonatomic, assign) YNPageViewControllerPreloadPolicy preloadPolicy;
#pragma mark - UIScrollMenuView Config
/** 是否显示遮盖*/
@property (nonatomic, assign) BOOL showConver;
/** 是否显示线条 YES */
@property (nonatomic, assign) BOOL showScrollLine;
/** 是否显示顶部线条 NO ，菜单滑动顶部时，就会显示*/
@property (nonatomic, assign) BOOL showTopLine;
/** 是否显示底部线条 NO */
@property (nonatomic, assign) BOOL showBottomLine;
/** 颜色是否渐变 YES */
@property (nonatomic, assign) BOOL showGradientColor;
/** 是否显示按钮 NO */
@property (nonatomic, assign) BOOL showAddButton;
/** 按钮图片是否居左*/
@property (nonatomic, assign) BOOL addButtonImageRight;
/** 菜单是否滚动 YES */
@property (nonatomic, assign) BOOL scrollMenu;
/** 菜单弹簧效果 NO */
@property (nonatomic, assign) BOOL bounces;
/** 线width 默认等于字体宽度，默认YES */
@property (nonatomic, assign) CGFloat lineWidth;
/// 展示菜单角标
@property (nonatomic, assign) BOOL showItemBadge;
/**
 *  是否是居中 (当所有的Item+margin的宽度小于ScrollView宽度)  默认 YES
 *  scrollMenu = NO,aligmentModeCenter = NO 会变成平分
 */
@property (nonatomic, assign) BOOL aligmentModeCenter;
/** 当aligmentModeCenter 变为平分时 是否需要线条宽度等于字体宽度 默认 NO */
@property (nonatomic, assign) BOOL lineWidthEqualFontWidth;
/** 自定义Item 加图片 图片间隙 ... */
@property (nonatomic, copy) NSArray<UIButton *> *buttonArray;
/** 按钮tag*/
@property (nonatomic, assign) NSInteger addButtonTag;
/** 按钮宽度 */
@property (nonatomic, assign)CGFloat addButtonNormalWidth;
/** 添加按钮文字*/
@property (nonatomic, copy) NSString *addButtonNormalTitle;
/** 按钮文字颜色*/
@property (nonatomic, strong) UIColor *addButtonTitleColor;
/** 按钮文字Font*/
@property (nonatomic, strong) UIFont *addButtonTitleFont;
/** 按钮图片 */
@property (nonatomic, strong) UIImage *addButtonNormalImage;
/** 按钮高亮图片 */
@property (nonatomic, strong) UIImage *addButtonHightImage;
/** 按钮背景 */
@property (nonatomic, strong) UIColor *addButtonBackgroundColor;
/** 线条color */
@property (nonatomic, strong) UIColor *lineColor;
/** 遮盖color */
@property (nonatomic, strong) UIColor *converColor;
/** 菜单背景color */
@property (nonatomic, strong) UIColor *scrollViewBackgroundColor;
/** 选项正常color */
@property (nonatomic, strong) UIColor *normalItemColor;
/** 选项选中color */
@property (nonatomic, strong) UIColor *selectedItemColor;
/** 底部线条颜色 */
@property (nonatomic, strong) UIColor *bottomLineBgColor;
/** 底部线条左右偏移量 0 */
@property (nonatomic, assign) CGFloat bottomLineLeftAndRightMargin;
/** 线条圆角 0 */
@property (nonatomic, assign) CGFloat bottomLineCorner;
/** 线height 2 */
@property (nonatomic, assign) CGFloat lineHeight;
/** 线条底部距离 0*/
@property (nonatomic, assign) CGFloat lineBottomMargin;
/** 线条左右偏移量 0 */
@property (nonatomic, assign) CGFloat lineLeftAndRightMargin;
/** 线条圆角 0 */
@property (nonatomic, assign) CGFloat lineCorner;
/** 线条左右增加 0  默认线条宽度是等于 item宽度 */
@property (nonatomic, assign) CGFloat lineLeftAndRightAddWidth;
/** 底部线height 2 */
@property (nonatomic, assign) CGFloat bottomLineHeight;
/** 遮盖height 28 */
@property (nonatomic, assign) CGFloat converHeight;
/** 菜单height 默认 44 */
@property (nonatomic, assign) CGFloat menuHeight;
/** 菜单widht 默认是 屏幕宽度 */
@property (nonatomic, assign) CGFloat menuWidth;
/** 遮盖圆角 14 */
@property (nonatomic, assign) CGFloat coverCornerRadius;
/** 选项相邻间隙 15 */
@property (nonatomic, assign) CGFloat itemMargin;
/** 选项左边或者右边间隙 15 */
@property (nonatomic, assign) CGFloat itemLeftAndRightMargin;
/** 选项字体 14 */
@property (nonatomic, strong) UIFont *itemFont;
/** 选中字体 */
@property (nonatomic, strong) UIFont *selectedItemFont;
/** 缩放系数 */
@property (nonatomic, assign) CGFloat itemMaxScale;
/** 临时Top高度 */
@property (nonatomic, assign) CGFloat tempTopHeight;
/** 内容区域 */
@property (nonatomic, assign) CGFloat contentHeight;
/**剩余的高度 */
@property (nonatomic, assign) CGFloat remainHeight;

+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

+ (instancetype)init UNAVAILABLE_ATTRIBUTE;

+ (instancetype)defaultConfig;


//##################################无需关注##########################################

@property (nonatomic, assign) CGFloat deltaScale;

@property (nonatomic, assign) CGFloat deltaNorR;

@property (nonatomic, assign) CGFloat deltaNorG;

@property (nonatomic, assign) CGFloat deltaNorB;

@property (nonatomic, assign) CGFloat deltaSelR;

@property (nonatomic, assign) CGFloat deltaSelG;

@property (nonatomic, assign) CGFloat deltaSelB;

- (void)setRGBWithProgress:(CGFloat)progress;

@end
