//
//  RRCTeamStadiumView.m
//  matchscoremodule
//
//  Created by gaoguangxiao on 2020/5/19.
//

#import "RRCMatchStadiumView.h"
#import "UIImage+MatchmoduleImg.h"
#import "NSString+URL.h"
#import "RRCNetWorkManager.h"
#import "RRCAlertManager.h"
#import "WeakWebScriptMessageDelegate.h"
#import "RRCLiveUnusualView.h"
#import "RRCLiveGifLoad.h"
@interface RRCMatchStadiumView ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,UIScrollViewDelegate>

@property (nonatomic , strong) UIImageView *stadiumImage;

@property(nonatomic ,strong)WKWebView *webView;
@property(nonatomic ,strong)UIView *webPlaceView;
@property (nonatomic,strong) RRCLiveGifLoad *stateGIFImageView;
@property(nonatomic, strong)RRCLiveUnusualView *webAbnormalView;
@property(nonatomic, assign)NSInteger changeUrlIndex;
@end

@implementation RRCMatchStadiumView

-(void)setUpView{
    //    [self addSubview:self.stadiumImage];
    self.backgroundColor = [UIColor blackColor];
    
    [self addSubview:self.webView];
    [self addSubview:self.webPlaceView];
    [self addSubview:self.webAbnormalView];
    [self addSubview:self.compressionImageBtn];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
    [self.webPlaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_offset(0);
    }];
    
    UITapGestureRecognizer *webTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stadiumWebUserAction:)];
    [self.webPlaceView addGestureRecognizer:webTap];
    
    [self.webAbnormalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.height.mas_offset(68*Device_Ccale);
        make.left.right.mas_offset(0);
    }];
    
    [self.compressionImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0* Device_Ccale);
        make.bottom.mas_equalTo(0*Device_Ccale);
        //        make.width.height.mas_equalTo(50 * Device_Ccale);
    }];
    
    [self addSubview:self.stateGIFImageView];
    [self.stateGIFImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(88, 88));
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self).mas_offset(5*Device_Ccale);
    }];
    
    _isOpenStadiumAll = YES;//默认yes
}

//动画直播后缀
-(void)setStadiumUrl:(NSString *)stadiumUrl{
    _stadiumUrl = stadiumUrl;
    
    _webAbnormalView.hidden = YES;
    _webView.hidden = YES;
    _compressionImageBtn.hidden = YES;
    if (_showLoading) {
        [self.stateGIFImageView startLoadingAnimation];
    }
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:stadiumUrl]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0]];
}

-(void)setStadiumUrlTypeArr:(NSArray *)stadiumUrlTypeArr{
    
    _stadiumUrlTypeArr = stadiumUrlTypeArr;
    
    _changeUrlIndex = 0;//每次赋值索引位置重置
    
}
#pragma mark - Event Response
-(void)stadiumWebUserAction:(UITapGestureRecognizer *)tap{
    
    if (self.stadiumDelegate && [self.stadiumDelegate respondsToSelector:@selector(stadiumWebActionUrlFail:)]) {
        [self.stadiumDelegate stadiumWebActionUrlFail:!_webAbnormalView.hidden];
    }
}

-(void)stadiumSizeChange:(UIButton *)sender{
    BOOL stadiumSizeStatus = !self.isOpenStadiumAll;
    if (self.SizeChangeBlock) {
        self.SizeChangeBlock(stadiumSizeStatus);
    }
    
    self.isOpenStadiumAll  = stadiumSizeStatus;
    
}

-(void)setIsOpenStadiumAll:(BOOL)isOpenStadiumAll{
    
    _isOpenStadiumAll = isOpenStadiumAll;
    
    if (isOpenStadiumAll) {
        //全屏
        [self.stateGIFImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(56 * Device_Ccale, 56 * Device_Ccale));
        }];
        
        self.webAbnormalView.titleLab.font = [UIFont systemFontOfSize:16 * Device_Ccale];
        self.webAbnormalView.retryBtn.titleLabel.font = [UIFont systemFontOfSize:14 * Device_Ccale];
        self.webAbnormalView.switchPlay.titleLabel.font = [UIFont systemFontOfSize:14 * Device_Ccale];
        
        [self.webAbnormalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(68*Device_Ccale);
        }];
        
        [self.webAbnormalView.retryBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.webAbnormalView.titleLab.mas_bottom).with.mas_offset(20*Device_Ccale);
            make.size.mas_offset(CGSizeMake(92*Device_Ccale, 32*Device_Ccale));
            if (self.stadiumUrlArr.count > 1) {
                make.centerX.mas_equalTo(self.mas_centerX).mas_offset(-54*Device_Ccale);//(92+16)/2
            }else{
                make.centerX.mas_equalTo(self.mas_centerX).mas_offset(0*Device_Ccale);
            }
        }];
        
        [self.webAbnormalView.switchPlay mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(92*Device_Ccale, 32*Device_Ccale));
        }];
       
    }else{

        [self.webAbnormalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(56*Device_Ccale);
        }];
        
        [self.stateGIFImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(44 * Device_Ccale, 44 * Device_Ccale));
        }];
        
        self.webAbnormalView.titleLab.font = [UIFont systemFontOfSize:13 * Device_Ccale];
        self.webAbnormalView.retryBtn.titleLabel.font = [UIFont systemFontOfSize:12 * Device_Ccale];
        self.webAbnormalView.switchPlay.titleLabel.font = [UIFont systemFontOfSize:12 * Device_Ccale];
        
        [self.webAbnormalView.retryBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.webAbnormalView.titleLab.mas_bottom).with.mas_offset(15*Device_Ccale);
            make.size.mas_offset(CGSizeMake(72*Device_Ccale, 25*Device_Ccale));
            if (self.stadiumUrlArr.count > 1) {
                make.centerX.mas_equalTo(self.mas_centerX).mas_offset(-44*Device_Ccale);
            }else{
                make.centerX.mas_equalTo(self.mas_centerX).mas_offset(0*Device_Ccale);
            }
        }];
        
        [self.webAbnormalView.switchPlay mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(72*Device_Ccale, 25*Device_Ccale));
        }];
        
    }
    
    if (self.stadiumUrlArr.count > 1) {
        self.webAbnormalView.switchPlay.hidden = NO;
    }else{
        self.webAbnormalView.switchPlay.hidden = YES;
    }
}

-(void)changeStadiumUrl{
    
    NSString *curUrl = _stadiumUrl;
    if (self.stadiumUrlArr.count > 1) {
        //遍历下一个地址0 2
        _changeUrlIndex += 1;
        if (_changeUrlIndex == self.stadiumUrlArr.count) {
            _changeUrlIndex = 0;
        }
        curUrl = self.stadiumUrlArr[_changeUrlIndex];
        
        _stadiumUrlType = _changeUrlIndex + 1;
        
    }
    
    //    NSLog(@"直播源：%@",curUrl);
    
    if (self.stadiumDelegate && [self.stadiumDelegate respondsToSelector:@selector(stadiumWebFailChangeUrlAction:andCurrentIndex:)]) {
        
        [self.stadiumDelegate stadiumWebFailChangeUrlAction:curUrl andCurrentIndex:_changeUrlIndex];
        
    }
    
    self.stadiumUrl = curUrl;
    
}
#pragma mark - WKUserContentController
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if ([message.name isEqualToString:@"registerCompanyInfo"]) {
        
    }else if ([message.name isEqualToString:@"stopLoading"]){
//        NSLog(@"停止了啊");
        _stadiumUrlType = [self getStopTypeUrl];
        
        if (self.stadiumDelegate && [self.stadiumDelegate respondsToSelector:@selector(stadiumViewWebView:)]) {
            [self.stadiumDelegate stadiumViewWebView:self.webView];
        }
        
        if (self.stadiumUrlType == 1) {
            
            _webView.hidden = NO;
           
            _compressionImageBtn.hidden = NO;
            
            [self.stateGIFImageView stopLoadingAnimation];
            
            self.webAbnormalView.hidden = YES;
            
            [self setIsOpenStadiumAll:_isOpenStadiumAll];
        }
    }
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
//    NSLog(@"自带加载完毕");
    _stadiumUrlType = [self getStopTypeUrl];
    
    if (self.stadiumUrlType != 1) {
        
        if (self.stadiumDelegate && [self.stadiumDelegate respondsToSelector:@selector(stadiumViewWebView:)]) {
            [self.stadiumDelegate stadiumViewWebView:webView];
        }
        
        _webView.hidden = NO;
        
        _compressionImageBtn.hidden = NO;
        
        [self.stateGIFImageView stopLoadingAnimation];
        
        self.webAbnormalView.hidden = YES;
        
        [self setIsOpenStadiumAll:_isOpenStadiumAll];
    }
//    [self.stateGIFImageView stopLoadingAnimation];
}

-(NSInteger)getStopTypeUrl{
    NSInteger stopUrlType = 0;
    if (self.stadiumUrlTypeArr.count > 0) {
        stopUrlType = [self.stadiumUrlTypeArr[_changeUrlIndex] integerValue];
    }else{
        stopUrlType = _stadiumUrlType;
    }
    return stopUrlType;
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    if (error.code == NSURLErrorCancelled) {
        return;
    }
    
    if (self.stadiumDelegate && [self.stadiumDelegate respondsToSelector:@selector(stadiumViewWebView:didFailProvisionalNavigation:withError:)]) {
        [self.stadiumDelegate stadiumViewWebView:webView didFailProvisionalNavigation:navigation withError:error];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.stateGIFImageView stopLoadingAnimation];
        
        self->_webAbnormalView.hidden = NO;
                
        [self setIsOpenStadiumAll:self->_isOpenStadiumAll];
        
//        NSLog(@"error:%@",error);
        
    });
    
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
    [self.stateGIFImageView stopLoadingAnimation];
    [[RRCAlertManager sharedRRCAlertManager] showPostingWithtitle:@"加载失败"];
}

//代理
-(void)dealloc{
    
    
    [_webView.configuration.userContentController removeScriptMessageHandlerForName:@"registerCompanyInfo"];
    [_webView.configuration.userContentController removeScriptMessageHandlerForName:@"stopLoading"];
}

// 显示一个按钮。点击后调用completionHandler回调
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    
}

-(void)reloadWebUrl{
    [self setStadiumUrl:_stadiumUrl];
    
    if (self.stadiumDelegate && [self.stadiumDelegate respondsToSelector:@selector(stadiumWebFailReloadActionUrlAction:andCurrentIndex:)]) {
        [self.stadiumDelegate stadiumWebFailReloadActionUrlAction:_stadiumUrl andCurrentIndex:_changeUrlIndex];
    }
}

#pragma mark - Getter
-(UIImageView *)stadiumImage{
    if (!_stadiumImage) {
        _stadiumImage = [[UIImageView alloc]initWithImage:[UIImage matchModuleImageNamed:@"matchmodulestadium"]];
    }
    return _stadiumImage;
}

-(UIButton *)compressionImageBtn{
    if (!_compressionImageBtn) {
        _compressionImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_compressionImageBtn addTarget:self action:@selector(stadiumSizeChange:) forControlEvents:UIControlEventTouchUpInside];
        //        _compressionImageBtn.backgroundColor = RRCHighLightTitleColor;
    }
    return _compressionImageBtn;
}

-(WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        
        WeakWebScriptMessageDelegate *weakScript = [[WeakWebScriptMessageDelegate alloc] initWithDelegate:self];
        [config.userContentController addScriptMessageHandler:weakScript name:@"registerCompanyInfo"];
        [config.userContentController addScriptMessageHandler:weakScript name:@"stopLoading"];
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kHeightNavigation, kScreenWidth, 0) configuration:config];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.scrollView.bounces = NO;
        _webView.scrollView.scrollEnabled = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.opaque = NO;
        _webView.hidden = YES;
        _webView.backgroundColor = [UIColor blackColor];
    }
    return _webView;
}

-(UIView *)webPlaceView{
    if (!_webPlaceView) {
        _webPlaceView = [[UIView alloc]init];
    }
    return _webPlaceView;
}

-(RRCLiveUnusualView *)webAbnormalView{
    if (!_webAbnormalView) {
        _webAbnormalView = [[RRCLiveUnusualView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        _webAbnormalView.hidden = YES;
        kWeakSelf;
        _webAbnormalView.UnusualBlock = ^(BOOL isTouch) {
            [weakSelf reloadWebUrl];
            weakSelf.webAbnormalView.hidden = YES;
        };
        _webAbnormalView.swithPlayBlock = ^(BOOL isTouch) {
            [weakSelf changeStadiumUrl];
            weakSelf.webAbnormalView.hidden = YES;
        };
    }
    return _webAbnormalView;
}

-(RRCLiveGifLoad *)stateGIFImageView{
    if (!_stateGIFImageView) {
        _stateGIFImageView = [[RRCLiveGifLoad alloc] init];
//        kWeakSelf;
        _stateGIFImageView.TimeOutBlock = ^(BOOL timeOut) {
//            weakSelf.webAbnormalView.hidden = NO;
        };
    }
    return _stateGIFImageView;
}

@end
