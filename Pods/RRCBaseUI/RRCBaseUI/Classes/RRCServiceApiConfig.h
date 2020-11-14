//
//  RRCServiceApiConfig.h
//  MXSFramework
//
//  Created by gaoguangxiao on 2020/4/15.
//  Copyright © 2020 MXS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RRCServiceApiConfig : NSObject

#pragma mark-  SDK相关的key
//微信
UIKIT_EXTERN NSString * const WXAppid;
UIKIT_EXTERN NSString * const WXAppSerect;
//qq
UIKIT_EXTERN NSString * const QQAppid;
UIKIT_EXTERN NSString * const QQAppSerect;
//新浪
UIKIT_EXTERN NSString * const XLAppid;
UIKIT_EXTERN NSString * const XLAppSerect;
UIKIT_EXTERN NSString * const XLRedirectURL;
//BugglyAppKey
UIKIT_EXTERN NSString * const BugglyAppKey;
UIKIT_EXTERN NSString * const UMAppKey;
//极光
UIKIT_EXTERN NSString * const JPushKey;
#define isProduct       YES

UIKIT_EXTERN NSString * const RRC_Method;

#pragma mark - APP配置
UIKIT_EXTERN NSString * const RRCAPPDateTimeUrl;   //服务器时间删除
UIKIT_EXTERN NSString * const RRCAPPCheckUrl;      //版本
UIKIT_EXTERN NSString * const RRCCodeUpdate;       //获取版本信息接口
UIKIT_EXTERN NSString * const RRCVersionUpdateInfo;//版本更新信息【图片，以及网址介绍】
UIKIT_EXTERN NSString * const RRCAlertInfo;        //用户初次安装APP所弹广告信息
UIKIT_EXTERN NSString * const RRCResetUserPassword;//修改密码
UIKIT_EXTERN NSString * const RRCFindPassword;     //找回密码
UIKIT_EXTERN NSString * const RRCThirdLogin;       //三方登录
UIKIT_EXTERN NSString * const RRCSendCode;         //发送验证码
UIKIT_EXTERN NSString * const RRCBindphone;        //绑定手机号接口
UIKIT_EXTERN NSString * const RRCCheckphone;       //验证手机号接口
UIKIT_EXTERN NSString * const RRCBindthird;        //绑定微信
UIKIT_EXTERN NSString * const RRCinfoUpdate;       //更新用户信息
UIKIT_EXTERN NSString * const RRCQiniutoken;       //获取七牛上传token
UIKIT_EXTERN NSString * const RRClogin;            //用户名或手机号密码登录接口
UIKIT_EXTERN NSString * const RRClogincode;        //手机号验证码登录接口

#pragma mark - 首页
UIKIT_EXTERN NSString * const RRCHomeApp;//首页列表接口
UIKIT_EXTERN NSString * const RRCMainartlist;//首页根据栏目ID获取文章列表接口
UIKIT_EXTERN NSString * const RRCMainHissearch;//首页历史搜索
UIKIT_EXTERN NSString * const RRCMainhotsearch;//首页热门搜索：
UIKIT_EXTERN NSString * const RRCMainSearch;//首页搜索接口
UIKIT_EXTERN NSString * const RRCMaindelHissearch;//首页删除历史搜索
UIKIT_EXTERN NSString * const RRCUserPostHotsearch;   //帖子，用户的热门搜索
UIKIT_EXTERN NSString * const RRCUserPostHissearch;   //用户和帖子的历史搜索
UIKIT_EXTERN NSString * const RRCPostUserSearch;      //搜索用户、帖子
UIKIT_EXTERN NSString * const RRCDelUserPostHissearch;//删除用户、帖子的历史搜索
UIKIT_EXTERN NSString * const RRCAllHotsearch;//搜索文章，帖子，用户
UIKIT_EXTERN NSString * const RRCAllHissearch;//搜索文章，帖子，用户
UIKIT_EXTERN NSString * const RRCAllSearch;//首页搜索所有接口
UIKIT_EXTERN NSString * const RRCDelAllHissearch;//删除所有历史搜索
UIKIT_EXTERN NSString * const RRCArticleCollection;//文章收藏接口
UIKIT_EXTERN NSString * const RRCArticleAndTopicMore;//干货文章上拉
UIKIT_EXTERN NSString * const RRCArticleAndTopicDetails;//干货文章详情
UIKIT_EXTERN NSString * const RRCSearchMorePost;//搜索查看更多帖子
UIKIT_EXTERN NSString * const RRCSearchMoreUser;//搜索查看更多用户

#pragma mark - 文章详情
UIKIT_EXTERN NSString * const RRCIsfollow;//文章是否关注
UIKIT_EXTERN NSString * const RRCArtShare;//文章分享
UIKIT_EXTERN NSString * const RRCArtOperationCount;//分享数、评论数、点赞数
UIKIT_EXTERN NSString * const RRCArticleDetailCommentList;//评论列表
UIKIT_EXTERN NSString * const RRCArticleComment;//文章评论
UIKIT_EXTERN NSString * const RRCcheckAricleComment;//评论权限
UIKIT_EXTERN NSString * const RRCcheckArticleCommentLimit;//回复评论权限
UIKIT_EXTERN NSString * const RRCArticleLevel_1;//文章一级评论详情
UIKIT_EXTERN NSString * const RRCArticleChildcommentlist;//分页二级评论接口
UIKIT_EXTERN NSString * const RRCArticleClickList;//文章喜欢
UIKIT_EXTERN NSString * const RRCArticleDetailFocusStatus;//获取文章详情关注状态
UIKIT_EXTERN NSString * const RRCArticleCommentList;//消息评论列表
UIKIT_EXTERN NSString * const RRCArticleChildComment;//文章详情：对一级评论的回复 返回数据

#pragma mark - 用户
UIKIT_EXTERN NSString * const RRCUserReport;        //举报
UIKIT_EXTERN NSString * const RRCUserInfoMessage;   //个人中心接口
UIKIT_EXTERN NSString * const RRCUserRates;         //个人中心胜率
UIKIT_EXTERN NSString * const RRCMYDynamic;         //我的帖子列表
UIKIT_EXTERN NSString * const RRCV3UserCommentlist; //我的评论列表
UIKIT_EXTERN NSString * const RRCMYArcticle;        //我的文章列表
UIKIT_EXTERN NSString * const RRCUsercollectlist;   //我的收藏列表

UIKIT_EXTERN NSString * const RRCCarePerple;//关注取消关注别人
UIKIT_EXTERN NSString * const RRCPostDelFollow;//删除关注关系
UIKIT_EXTERN NSString * const RRCV3VoteTicket;//投票剩余次数接口
UIKIT_EXTERN NSString * const RRCVotePerple;//投票
UIKIT_EXTERN NSString * const RRCBoleUserList;//获奖名单
UIKIT_EXTERN NSString * const RRCAddBlackPerple;//拉黑用户
UIKIT_EXTERN NSString * const RRCShieldUser;//屏蔽用户
UIKIT_EXTERN NSString * const RRCShieldUserPermiss;//屏蔽用户前判断被屏蔽用户是否有发帖权限
UIKIT_EXTERN NSString * const RRCUserScreenedlist;//用户屏蔽列表
UIKIT_EXTERN NSString * const RRCV3Feedbacklist;//意见反馈列表
UIKIT_EXTERN NSString * const RRCV3Feedback;//意见反馈发表操作
UIKIT_EXTERN NSString * const RRCV3Fdnoread;//意见反馈未读消息数
UIKIT_EXTERN NSString * const RRCLogout;//退出登录

#pragma mark - 赛事
//-赛事比分筛选
UIKIT_EXTERN NSString *const RRCAllGameLeagues;     //全部赛事筛选
UIKIT_EXTERN NSString *const RRCAllGamePK;          //全部盘路筛选
UIKIT_EXTERN NSString *const RRCMiddleGameLeagues;  //赛中赛事筛选
UIKIT_EXTERN NSString *const RRCMiddleGamePK;       //赛中盘路筛选
UIKIT_EXTERN NSString *const RRCScheduleGameLeagues;//赛程赛事筛选
UIKIT_EXTERN NSString *const RRCScheduleGamePK;     //赛程盘路筛选
UIKIT_EXTERN NSString *const RRCResultGameLeagues;  //赛果赛事筛选
UIKIT_EXTERN NSString *const RRCResultGamePK;       //赛果盘路筛选

//-赛事比分
UIKIT_EXTERN NSString * const RRCMatchAllScoreGame;     //全部比分
UIKIT_EXTERN NSString * const RRCMatchMiddleScoreGame;  //赛中比分
UIKIT_EXTERN NSString * const RRCMatchScheduleScoreGame;//赛程比分
UIKIT_EXTERN NSString * const RRCMatchResultScoreGame;  //赛果比分
UIKIT_EXTERN NSString * const RRCMatchFocusScoreGame;   //关注比分
UIKIT_EXTERN NSString * const RRCMatchScoreDateList;    //赛程赛果比分日期

//-赛事关注
UIKIT_EXTERN NSString * const RRCAttentionGame;     //关注某场赛事
UIKIT_EXTERN NSString * const RRCCloseAttentionGame;//取消关注某场赛事
UIKIT_EXTERN NSString * const RRCAttentionGameCount;//用户关注赛事数量
UIKIT_EXTERN NSString * const FRRCAttentionGameId;  //用户关注赛事的数组ID

UIKIT_EXTERN NSString * const RRCGetEquipPush;  //获取赛事设备推送
UIKIT_EXTERN NSString * const RRCSetEquipPush;  //更新赛事设备推送
UIKIT_EXTERN NSString * const RRCGetUserSPush;  //获取用户设置推送
UIKIT_EXTERN NSString * const RRCSetUserSPush;  //更新用户设置推送

UIKIT_EXTERN NSString * const RRCFoucsList;     //焦点赛事列表
UIKIT_EXTERN NSString * const RRCMatchAdeptGame;//联赛详情

//-添加赛事
UIKIT_EXTERN NSString * const RRCMatchRuleForSend;//可发赛事限制数量
UIKIT_EXTERN NSString * const RRCPostJcDatelist;  //竞彩日期
UIKIT_EXTERN NSString * const RRCPostYpDatelist;  //亚盘日期
UIKIT_EXTERN NSString * const RRCPostLqDatelist;  //篮球日期

UIKIT_EXTERN NSString * const RRCJcMatchList;      //竞彩
UIKIT_EXTERN NSString * const RRCPostJcleaguelist; //竞彩筛选条件
UIKIT_EXTERN NSString * const RRCPostRecommendYP;  //亚盘
UIKIT_EXTERN NSString * const RRCPostYzleaguelist; //亚盘筛选条件
UIKIT_EXTERN NSString * const RRCPostRecommendLQ;  //篮球
UIKIT_EXTERN NSString * const RRCPostLqleaguelist; //篮球筛选条件

UIKIT_EXTERN NSString * const MatchStatistical;  //发帖时 对用户添加赛事统计
UIKIT_EXTERN NSString * const RRCSaveGameDraft;  //保存赛事草稿
UIKIT_EXTERN NSString * const RRCGetGameDraft;   //获取赛事草稿
UIKIT_EXTERN NSString * const RRCDeleteGame;     //删除赛事草稿

UIKIT_EXTERN NSString * const RRCUserAdeptGameList;//联赛战绩
UIKIT_EXTERN NSString * const RRCPostAllResult;//战绩列表 总场次
UIKIT_EXTERN NSString * const RRCPostJcResult; //战绩列表 竞彩
UIKIT_EXTERN NSString * const RRCPostYzResult; //战绩列表 亚盘
UIKIT_EXTERN NSString * const RRCPostLqResult; //战绩列表 篮球

//指数
UIKIT_EXTERN NSString * const RRCExponentGameLeagues;       //指数赛事筛选

//赛事详情
UIKIT_EXTERN NSString * const RRCMatchEvents;        //赛事详情-直播-比赛事件接口
UIKIT_EXTERN NSString * const RRCMatchLiveIndex;     //即时比分接口
UIKIT_EXTERN NSString * const RRCMatchDataStatistics;//赛事数据统计
UIKIT_EXTERN NSString * const RRCMatchSideSquad;     //赛事双方阵容
UIKIT_EXTERN NSString * const RRCMatchChooseCompany; //欧指筛选公司

UIKIT_EXTERN NSString * const LiveMatchDetail;        //赛事详情[3.5弃用]
UIKIT_EXTERN NSString * const LiveGameHead;           //赛事详情头部
UIKIT_EXTERN NSString * const LiveMatchcountGameLive; //直播统计
UIKIT_EXTERN NSString * const LiveAnalysis;           //直播分析
UIKIT_EXTERN NSString * const LiveMatchAnAlysisRecord;//赛事分析近10场近20场
UIKIT_EXTERN NSString * const LiveAnalysisRealTime;   //直播分析轮询
UIKIT_EXTERN NSString * const LiveExponentPlate;      //直播指数亚盘
UIKIT_EXTERN NSString * const LiveExponentCompensate; //直播指数欧赔
UIKIT_EXTERN NSString * const LiveExponentCompensateRealTime;//直播指数欧赔轮询
UIKIT_EXTERN NSString * const LiveExponentLetBall;       //指数让球
UIKIT_EXTERN NSString * const LiveExponentCornerBall;    //角球
UIKIT_EXTERN NSString * const LiveExponentHalfullRate;   //指数半全场
UIKIT_EXTERN NSString * const LiveExponentTotalScoreRate;//指数总进球
UIKIT_EXTERN NSString * const LiveExponentCompete;    //直播指数大小球
UIKIT_EXTERN NSString * const LiveIntelligence;       //直播情报
UIKIT_EXTERN NSString * const LiveSecretInfo;         //绝密情报
UIKIT_EXTERN NSString * const LiveSecretPrise;        //绝密情报点赞
UIKIT_EXTERN NSString * const LiveFocusOnList;        //直播赛事推荐

UIKIT_EXTERN NSString * const LiveRecommendFocusTop;         //直播赛事推荐关注以及擅长联赛
UIKIT_EXTERN NSString * const LiveRecommendNewList;          //直播赛事最新推荐
UIKIT_EXTERN NSString * const LiveRecommendFocusRulesContent;//直播赛事关注规则
UIKIT_EXTERN NSString * const LiveRecommendListRulesContent; //直播赛事胜率以及返还率规则


@end

NS_ASSUME_NONNULL_END
