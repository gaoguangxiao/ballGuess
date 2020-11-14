//
//  RRCTeamStadiumView.h
//  matchscoremodule
//
//  Created by gaoguangxiao on 2020/5/19.
//

#import "RRCView.h"
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol RRCMatchStadiumViewDelegate <NSObject>

@optional;

///  web视图加载完毕
/// @param webView <#webView description#>
-(void)stadiumViewWebView:(WKWebView *)webView;


/// web加载失败
/// @param webView <#webView description#>
/// @param navigation <#navigation description#>
/// @param error <#error description#>
- (void)stadiumViewWebView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error;

/// 球场视图点击触发
/// @param isUrlLoadFail <#uisUrlLoadFail description#>
-(void)stadiumWebActionUrlFail:(BOOL)isUrlLoadFail;


/// 球场重新加载触发
/// @param currentUrl <#currentUrl description#>
/// @param currentIndex <#currentIndex description#>
-(void)stadiumWebFailReloadActionUrlAction:(NSString *)currentUrl andCurrentIndex:(NSInteger)currentIndex;


/// 球场数据源切换触发
/// @param currentUrl <#currentUrl description#>
/// @param currentIndex <#currentIndex description#>
-(void)stadiumWebFailChangeUrlAction:(NSString *)currentUrl andCurrentIndex:(NSInteger)currentIndex;

/// 球场大小变化
/// @param isOpenStadiumEvent <#isOpenStadiumEvent description#>
-(void)stadiumViewSizeChange:(BOOL)isOpenStadiumEvent;
@end

@interface RRCMatchStadiumView : RRCView


@property (nonatomic , weak) id<RRCMatchStadiumViewDelegate> stadiumDelegate;

/// 默认隐藏
@property (nonatomic , strong) UIButton *compressionImageBtn;

@property (nonatomic , strong) void(^SizeChangeBlock) (BOOL isOpenStadiumEvent);

/// 是否展示赛场全部
@property (nonatomic , assign) BOOL isOpenStadiumAll;

/// 球场地址
@property (nonatomic , strong) NSString *stadiumUrl;

//当前球场停止类型
@property (nonatomic , assign , readonly) NSInteger stadiumUrlType;

/// 球场loading停止方法 1自定义停止方法 2系统自带停止方法
@property (nonatomic , strong) NSArray *stadiumUrlTypeArr;
//动画直播源切换
@property (nonatomic , strong) NSArray *stadiumUrlArr;
//是否展示菊花
@property (nonatomic, assign) BOOL showLoading;
/// 改变直播源
-(void)changeStadiumUrl;
@end

NS_ASSUME_NONNULL_END
