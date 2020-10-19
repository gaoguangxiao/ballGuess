//
//  MGRootViewController.m
//  觅购
//
//  Created by ycicd on 2019*Device_Ccale/10/31.
//  Copyright © 2019*Device_Ccale年 migou. All rights reserved.
//

#import "RRCRootViewController.h"
#import "DYUIViewExt.h"
#import "YBColorConfigure.h"
#import "RRCDeviceConfigure.h"
#import "Masonry.h"
#import "RRCAlertManager.h"
#import "UIViewController+ThroughMehod.h"
#import "Reachability.h"
#import "RRCThemeManager.h"
#import "UIImage+FIXbaseModule.h"
@interface RRCRootViewController ()<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
}
@property (copy, nonatomic) btnBlock block;
@property (nonatomic,strong) btnBlock leftActionBlock;
@property (strong, nonatomic) UILabel *nodataLabel;
@property (strong, nonatomic) UIImageView *noDataImage;
@property (strong, nonatomic) UIButton *loginBtn;

@property (strong, nonatomic) UILabel *nologinLabel;
@property (strong, nonatomic) UIImageView *nologinImage;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIImageView *zuqiucaifuLabel;
@property (strong, nonatomic) UIView *loadingView;
@end

@implementation RRCRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpVC];
    [self setVCViewColor];
    
}

-(void)setUpVC{
    
}
/// 控件颜色设置
-(void)setVCViewColor{
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self showViewhandlestatusBarStyle];
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    //改变导航栏背景颜色
    [self setVCViewColor];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self disViewhandlestatusBarStyle];
    
}

-(void)showViewhandlestatusBarStyle{
    //改状态栏
    if ([[RRCThemeManager sharedRRCThemeManager]getThemeState] == 1)  {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }else{
        //排行榜，用户中心
        NSArray *viewCoutroller = @[@"RRCMyViewController",@"RRCMyListSViewController"];
        [viewCoutroller enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:NSStringFromClass([self class])]) {
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            }else{
                if (@available(iOS 13.0, *)) {
                    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
                } else {
                    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
                }
            }
        }];
    }
}

-(void)disViewhandlestatusBarStyle{

}

-(void)dealloc{
//    NSLog(@"%@--dealloc",self.class);
}

#pragma mark - 配置导航栏
//常规导航
-(void)configureBarWithTtitle:(NSString *)title{
    
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.titlelabel];
    [self.topView addSubview:self.leftButton];
    [self.topView addSubview:self.bottomLine];
    
    self.titlelabel.text = (title && title.length > 0) ? title : @"";
}

//常规导航 + 左边按钮图片
-(void)configureBarWithTtitle:(NSString *)title leftImage:(UIImage *)image{
    
    [self configureBarWithTtitle:title];
    
    [self.leftButton setImage:image forState:UIControlStateNormal];
}

//常规导航 + 左边按钮触发
-(void)configureBarWithTtitle:(NSString *)title andLeftClick:(btnBlock)btnblock{
    
    [self configureBarWithTtitle:title];
    [self.topView addSubview:self.rightButton];
    self.leftActionBlock = btnblock;
}

//常规导航 + 右边按钮图片
-(void)configureBarHaveBackWithTtitle:(NSString *)title rightBtnimageName:(NSString *)imageName andClick:(btnBlock)btnblock{
    
    [self configureBarWithTtitle:title];
    [self.topView addSubview:self.rightButton];
    self.block = btnblock;
    
    [self.rightButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

//常规导航 + 右边按钮文字
- (void)configureBarWithTtitle:(NSString *)title rightBtnTilte:(NSString *)rightBtnTiltle andClick:(btnBlock)btnblock{
    
    [self configureBarWithTtitle:title];
    [self.topView addSubview:self.rightButton];
    self.block = btnblock;
    
    [self.rightButton setTitle:rightBtnTiltle forState:UIControlStateNormal];
}

-(void)rightClick:(UIButton *)btn{
    self.block(btn);
}

-(void)backClick:(UIButton*)sender{
    if (self.leftActionBlock) {
        self.leftActionBlock(sender);
    }else{
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
}

#pragma mark - 缺省页
-(UIView *)nodataWithText:(NSString *)text imageName:(NSString *)imageName withY:(CGFloat)Y andSuperViewWidth:(CGFloat)width{
    if (!self.noDataView) {
        self.noDataView = [[UIView alloc]initWithFrame:CGRectMake(0, Y, width, 200)];
        self.noDataView.backgroundColor = RRCUnitViewColor;
        //        self.noDataView.userInteractionEnabled = NO;
        self.noDataImage = [[UIImageView alloc]init];
        [self.noDataView addSubview:self.noDataImage];
        [self.noDataImage sizeToFit];
        [self.noDataImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(-20);
        }];
        
        self.nodataLabel = [[UILabel alloc]init];
        self.nodataLabel.font = [UIFont systemFontOfSize:15*Device_Ccale];
        self.nodataLabel.textColor = RRCGrayTextColor;
        self.nodataLabel.textAlignment = NSTextAlignmentCenter;
        self.nodataLabel.numberOfLines = 0;
        [self.noDataView addSubview:self.nodataLabel];
        [self.nodataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.noDataImage.mas_bottom).offset(25);
        }];
    }else{
        self.noDataView.frame = CGRectMake(0, Y, width, 200);
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10.0];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    self.nodataLabel.attributedText = attributedString;
    if (imageName.length > 0) {
        self.noDataImage.image = [UIImage fixbaseModuleImageNamed:imageName];
    }
    if (text.length > 0) {
        self.noDataView.hidden = NO;
        self.noDataImage.hidden = NO;
    }else{
        self.noDataView.hidden = YES;
        self.noDataImage.hidden = YES;
    }
    return self.noDataView;
}
-(UIView *)nodataWithText:(NSString *)text imageName:(NSString *)imageName withY:(CGFloat)Y{
    return [self nodataWithText:text imageName:imageName withY:Y andSuperViewWidth:kScreenWidth];
}

-(void)nodataViewWithText:(NSString *)text imageName:(NSString *)imageName{
    UIView *listArrZeroView = [self nodataWithText:text imageName:imageName withY:0 andSuperViewWidth:kScreenWidth];
    [self.view addSubview:listArrZeroView];
    [listArrZeroView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(200);
    }];
    
    if (text.length > 0) {
        listArrZeroView.hidden = NO;
    }else{
        listArrZeroView.hidden = YES;
    }
}

-(void)listZeroViewText:(NSString *)text andImageName:(NSString *)imageName andView:(UIView *)contentView{
    [self nodataWithText:text imageName:imageName withY:0 andSuperViewWidth:contentView.width];
    [contentView addSubview:self.noDataView];
    //如果缺省页加载到self.view。那么需要减去导航栏高度。其他父视图加载，直接采用父视图高度
    if (self.view == contentView) {
        self.noDataView.frame = CGRectMake(0, kHeightNavigation, contentView.width, contentView.height - kHeightNavigation);
    }else{
        self.noDataView.frame = CGRectMake(0, 0, contentView.width, contentView.height);
    }
}

#pragma mark - 无网络
-(void)loginBtnClick:(UIButton *)sender{
    if ([[self getNetWorkStates] isEqualToString:@""]) {
        [[RRCAlertManager sharedRRCAlertManager] showPostingWithtitle:@"网络不好，请检查您的网络设置"];
    }else{
        //        [[MGLoginManager sharedMGLoginManager] checkLoginStatus];
    }
}

//断网重新加载
- (void)reloadDataClick:(UIButton *)reloadBtn{
    if ([[self getNetWorkStates] isEqualToString:@""]) {
        [[RRCAlertManager sharedRRCAlertManager] showPostingWithtitle:@"网络不好，请检查您的网络设置"];
    }else{
        [self hiddenNoDataView];//先隐藏网络
        [self reloadNetWorking:reloadBtn];
    }
}

//其他事件回调
-(void)otherDataModelBlock:(UIButton *)sender{
    if (self.reloadBlock) {
        self.reloadBlock(sender);
    }
}

-(UIView *)loadNoNetWorkingWithY:(CGFloat)Y{
    RRCNoDataModel *nodataModel = self.noDataType;
    self.nologinView = [self nodataViewModel:nodataModel withY:Y reloadBtn:^(UIButton *btnBlock) {
        if (self.reloadBlock) {
            self.reloadBlock(btnBlock);
        }else{
            if ([[self getNetWorkStates] isEqualToString:@""]) {
                [[RRCAlertManager sharedRRCAlertManager] showPostingWithtitle:@"网络不好，请检查您的网络设置"];
            }else{
                [self hiddenNoDataView];//先隐藏网络
                [self reloadNetWorking:btnBlock];
                
            }
        }
    }];
    self.nologinView.hidden = NO;
    self.noDataView.hidden = YES;
    return self.nologinView;
}
-(void)hiddenNoDataView{
    self.nologinView.hidden = YES;
    
    [self.nologinView removeFromSuperview];
    self.nologinView = nil;
    
    self.noDataView.hidden = YES;
    [self.noDataView removeFromSuperview];
    self.noDataView = nil;
}
-(void)showNoNetViewWithY:(CGFloat)Y andCount:(NSInteger)count{
    if (count) {
        //        1、隐藏无网络视图
        [self hiddenNoDataView];
        
        //        2、显示无网络提示
        [[RRCAlertManager sharedRRCAlertManager] showPostingWithtitle:@"网络不好，请检查您的网络设置"];
        
    }else{
        [self showNoDataViewWithY:Y];
    }
}
-(void)showNoDataViewWithY:(CGFloat)Y{
    if (!self.nologinView) {
        if (Y > 0) {
            self.nologinView = [self loadNoNetWorkingWithY:Y];
        }else{
            self.nologinView = [self loadNoNetWorkingWithY:(kScreenHeight - 300)/2];
        }
        [self.view addSubview:self.nologinView];
    }
    //没有数据时，网络断开时
    if (!self.noDataView.hidden) {
        self.noDataView.hidden = YES;
    }
    self.nologinView.hidden = NO;
}

-(void)showErrorNetViewHeight:(CGFloat)height andNetViewOffy:(CGFloat)y{
    self.noDataType.emptyContentHeight = height;
    [self loadNoNetWorkingWithY:y];
    [self.view addSubview:self.nologinView];
}

-(UIView *)nodataViewModel:(RRCNoDataModel *)dataModel withY:(CGFloat)Y reloadBtn:(reloadNetBlock)reloaBtnBlock{
    
    
    self.nologinView = [[UIView alloc]initWithFrame:CGRectMake(0, Y, kScreenWidth, dataModel.emptyContentHeight)];
    self.nologinView.backgroundColor = dataModel.backViewColor;
    
    if (dataModel.noDataType == RRCEmptyTypeImage) {
        
    }else if (dataModel.noDataType == RRCEmptyTypeImageAndText){
        
    }else if (dataModel.noDataType == RRCEmptyTypeAll){
        
        [self.nologinView addSubview:self.nologinImage];
        [self.nologinImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(-60);//300 31 高度118
            
        }];
        if (dataModel.imageName.length > 0) {
            self.nologinImage.image = [UIImage fixbaseModuleImageNamed:dataModel.imageName];
        }
        
        [self.nologinView addSubview:self.nologinLabel];
        [self.nologinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.nologinImage.mas_bottom).offset(8);
            
        }];
        self.nologinLabel.text = dataModel.text;
        
        [self.nologinView addSubview:self.loginBtn];
        [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.nologinLabel.mas_bottom).offset(20);
            make.width.mas_equalTo(dataModel.buttonWidth);
            make.height.mas_equalTo(dataModel.buttonHeight);
        }];
        
        self.loginBtn.tag = dataModel.responseType;
        [self.loginBtn setTitle:dataModel.responseText forState:UIControlStateNormal];
        
        if (dataModel.responseType == 1) {
            [self.loginBtn addTarget:self action:@selector(reloadDataClick:) forControlEvents:UIControlEventTouchUpInside];
        }else if (dataModel.responseType == 2){
            //事件block回调
            self.reloadBlock = reloaBtnBlock;
            [self.loginBtn addTarget:self action:@selector(otherDataModelBlock:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [self.loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    self.noDataView.hidden = YES;
    return self.nologinView;
}

- (NSString *)getNetWorkStates{
    
    Reachability *reachability   = [Reachability reachabilityWithHostname:@"www.apple.com"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    NSString *net = nil;
    switch (internetStatus) {
        case ReachableViaWiFi:
            net = @"WIFI";
            break;
            
        case ReachableViaWWAN:
            net = @"蜂窝数据";
            //net = [self getNetType ];   //判断具体类型
            break;
            
        case NotReachable:
            net = @"";
            
        default:
            break;
    }
    return net;
}

- (BaseTableView *)baseTable {
    if (!_baseTable) {
        _baseTable = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenSafeAreaHeight) style:UITableViewStylePlain];
        _baseTable.delegate = self;
        _baseTable.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _baseTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _baseTable;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[UITableViewCell alloc] init];
}

#pragma mark - Getter
-(NSMutableArray *)dataArrayList{
    if (!_dataArrayList) {
        _dataArrayList = [NSMutableArray new];
    }
    return _dataArrayList;
}
-(RRCNoDataModel *)noDataType{
    if (!_noDataType) {
        _noDataType = [RRCNoDataModel new];
        _noDataType.noDataType = RRCEmptyTypeAll;
        _noDataType.text = @"请检查您的网络连接";
        _noDataType.imageName = @"无网络连接";
        _noDataType.responseText = @"重新连接";
        _noDataType.responseType = 1;
    }
    return _noDataType;
}

//导航栏头部视图
-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeightNavigation)];
        _topView.backgroundColor = RRCUnitViewColor;
    }
    return _topView;
}

//导航栏左边按钮
-(UIButton *)leftButton{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.frame = CGRectMake(0, kHeightNavigationStatusBar, KNavHeight, KNavHeight);
        [_leftButton setImage:[UIImage fixbaseModuleImageNamed:@"fixbaseModule_backImg"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

//导航栏右边按钮
-(UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(kScreenWidth - KNavHeight - 12 * Device_Ccale, kHeightNavigationStatusBar, KNavHeight, KNavHeight);
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:18*Device_Ccale];
        [_rightButton setTitleColor:RRCGrayTextColor forState:UIControlStateNormal];
        [_rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_rightButton addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
//导航栏标题
-(UILabel *)titlelabel{
    if (!_titlelabel) {
        _titlelabel = [[UILabel alloc]init];
        _titlelabel.frame = CGRectMake(self.leftButton.right, kHeightNavigationStatusBar, self.topView.frame.size.width - self.leftButton.right-30, KNavHeight);
        _titlelabel.center = CGPointMake(self.topView.center.x, self.titlelabel.center.y);
        _titlelabel.textAlignment = NSTextAlignmentCenter;
        _titlelabel.font = [UIFont systemFontOfSize:19 * Device_Ccale];
    }
    return _titlelabel;
}

//导航栏分割线
-(UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc]init];
        _bottomLine.frame = CGRectMake(0, kHeightNavigation - 1, kScreenWidth, 1);
        _bottomLine.backgroundColor = RRCLineViewColor;
    }
    return _bottomLine;
}

-(UIImageView *)nologinImage{
    if (!_nologinImage) {
        _nologinImage = [[UIImageView alloc]init];
    }
    return _nologinImage;
}
-(UILabel *)nologinLabel{
    if (!_nologinLabel) {
        _nologinLabel = [[UILabel alloc]init];
        _nologinLabel.font = [UIFont systemFontOfSize:14*Device_Ccale];
        _nologinLabel.textAlignment = NSTextAlignmentCenter;
        _nologinLabel.numberOfLines = 0;
        _nologinLabel.textColor = RRCGrayTextColor;
        [_loginBtn setTitleColor:RRCWhiteTextColor forState:UIControlStateNormal];
    }
    return _nologinLabel;
}

-(UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:16 * Device_Ccale];
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.layer.cornerRadius = 3.0f;
        _loginBtn.backgroundColor = RRCThemeViewColor;
    }
    return _loginBtn;
}

-(UILabel *)nodataLabel{
    if (!_nodataLabel) {
        _nodataLabel = [[UILabel alloc]init];
        _nodataLabel.font = [UIFont systemFontOfSize:15*Device_Ccale];
        _nodataLabel.textAlignment = NSTextAlignmentCenter;
        _nodataLabel.numberOfLines = 0;
        _nodataLabel.textColor = RRCGrayTextColor;
    }
    return _nodataLabel;
}

-(UIImageView *)noDataImage{
    if (!_noDataImage) {
        _noDataImage = [[UIImageView alloc]init];
    }
    return _noDataImage;
}

@end


