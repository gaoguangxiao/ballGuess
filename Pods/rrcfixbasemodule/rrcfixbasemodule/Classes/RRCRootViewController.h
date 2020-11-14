//
//  MGRootViewController.h
//  觅购
//
//  Created by ycicd on 2017/10/31.
//  Copyright © 2017年 migou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

#import "BaseTableView.h"
#import "RRCNoDataModel.h"
typedef void(^btnBlock)(UIButton *btn);
typedef void(^reloadBlock)(UIButton *reloadBtnBlock);
typedef void(^reloadNetBlock)(UIButton *btnBlock);

@interface RRCRootViewController : UIViewController{
}

/// 界面跳转所需要的扩展信息
@property (nonatomic, strong) NSDictionary *extensionDict;

/// tableView的数组元素
@property (nonatomic, strong) NSMutableArray *dataArrayList;

@property (nonatomic,strong) BaseTableView *baseTable;

@property (nonatomic,strong) UIView * topView;
@property (nonatomic, strong) UIButton * leftButton;
@property (nonatomic, strong) UIButton * rightButton;
@property (nonatomic, strong) UILabel * titlelabel;
@property (nonatomic, strong) UIView * bottomLine;

@property (strong, nonatomic) UIView *noDataView;//没数据时加载的view
@property (strong, nonatomic) UIView *nologinView;//网络断/未登录

@property (nonatomic,copy)reloadBlock reloadBlock;

/// v3.4.1 裁剪内容y显示开始位置，默认导航栏高度
@property (nonatomic, assign) CGFloat cutContentOffY;

@property (nonatomic , strong)RRCNoDataModel  *noDataType;
#pragma mark - 缺省页
-(UIView *)nodataWithText:(NSString *)text imageName:(NSString *)imageName withY:(CGFloat)Y;

-(void)nodataViewWithText:(NSString *)text imageName:(NSString *)imageName;

/// list为空时 有导航栏、导航栏 + 菜单
/// @param text 文本描述
/// @param imageName 图片描述
/// @param contentView 父视图
-(void)listZeroViewText:(NSString *)text andImageName:(NSString *)imageName andView:(UIView *)contentView;

#pragma mark - 配置导航栏
/// 常规导航栏
/// @param title 控制器标题
-(void)configureBarWithTtitle:(NSString *)title;

-(void)configureBarWithTtitle:(NSString *)title leftImage:(UIImage *)image;


/// 返回触发事件
/// @param title 标题
/// @param btnblock 返回触发
-(void)configureBarWithTtitle:(NSString *)title andLeftClick:(btnBlock)btnblock;

-(void)configureBarWithTtitle:(NSString *)title rightBtnTilte:(NSString *)rightBtnTiltle  andClick:(btnBlock)btnblock;

-(void)configureBarHaveBackWithTtitle:(NSString *)title rightBtnimageName:(NSString *)imageName andClick:(btnBlock)btnblock;

-(void)backClick:(UIButton*)sender;

/**
 加载网络失败的图层

 @param Y Y值
 @return 返回视图
 */
-(UIView *)loadNoNetWorkingWithY:(CGFloat)Y;


-(void)hiddenNoDataView;

/**
 展示无网络

 @param Y 0：视图显示中央
 */
-(void)showNoDataViewWithY:(CGFloat)Y;

/// 展示无网络视图 加载self.view上、需要传入，高度。y位置
/// @param height 网络图高度
/// @param y 起始位置
-(void)showErrorNetViewHeight:(CGFloat)height andNetViewOffy:(CGFloat)y;

/**
 展示无网络视图，根据数据

 @param Y <#Y description#>
 @param count <#count description#>
 */
-(void)showNoNetViewWithY:(CGFloat)Y andCount:(NSInteger)count;


- (NSString *)getNetWorkStates;
@end
