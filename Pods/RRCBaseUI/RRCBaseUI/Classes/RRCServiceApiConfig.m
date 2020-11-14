//
//  RRCServiceApiConfig.m
//  MXSFramework
//
//  Created by gaoguangxiao on 2020/4/15.
//  Copyright © 2020 MXS. All rights reserved.
//

#import "RRCServiceApiConfig.h"

@implementation RRCServiceApiConfig

NSString * const WXAppid = @"wx3a424dc6c2ad5fdf";
NSString * const WXAppSerect = @"8dba3dcd881e155778c5a6edbcd1ab42";

NSString * const QQAppid = @"101574139";
NSString * const QQAppSerect = @"bb56ea4d3225c94bc2561ca73cef69e2";

NSString * const XLAppid = @"2028732810";
NSString * const XLAppSerect = @"3ee0891819a6b225c456ab90bb516a6e";
NSString * const XLRedirectURL = @"http://open.weibo.com/apps/2028732810/privilege/oauth";

NSString * const BugglyAppKey = @"980a5518c8";
NSString * const UMAppKey = @"5bbaf8a9b465f5da0b000059";

NSString * const JPushKey = @"00c808f243b9113f33388c72";

NSString * const RRC_Method = @"POST";

#pragma mark - APP配置
NSString * const RRCAPPDateTimeUrl = @"v11/datetime/getDatetime";
NSString * const RRCAPPCheckUrl = @"webop/switch/query";
NSString * const RRCCodeUpdate  = @"v2/appversion";
NSString * const RRCVersionUpdateInfo = @"v6/version/updateInfo";
NSString * const RRCAlertInfo   = @"v7/alert/info";
NSString * const RRCResetUserPassword = @"user/chgpwd";
NSString * const RRCFindPassword = @"user/findpwd";
NSString * const RRCThirdLogin = @"thirdlogin";
NSString * const RRCSendCode = @"sendcode";
NSString * const RRCBindphone = @"user/bindphone";
NSString * const RRCCheckphone = @"checkphone";
NSString * const RRCBindthird = @"user/bindthird";
NSString * const RRCinfoUpdate = @"user/update";//更新用户信息
NSString * const RRCQiniutoken = @"qiniutoken";//获取七牛上传token
NSString * const RRClogin = @"login";//用户名或手机号密码登录接口
NSString * const RRClogincode = @"logincode";//手机号验证码登录接口

#pragma mark - 首页
NSString * const RRCHomeApp = @"v8/banner/info";
NSString * const RRCMainartlist = @"v5/art/artlist";
NSString * const RRCMainHissearch    = @"art/hissearch";
NSString * const RRCMainhotsearch    = @"art/hotsearch";
NSString * const RRCMainSearch       = @"art/search";
NSString * const RRCMaindelHissearch = @"art/delhissearch";
NSString * const RRCUserPostHotsearch    = @"v5/post/hotsearch";
NSString * const RRCUserPostHissearch    = @"v5/post/hissearch";
NSString * const RRCPostUserSearch       = @"v5/post/search";
NSString * const RRCDelUserPostHissearch = @"v5/post/delhissearch";
NSString * const RRCAllHotsearch    = @"v10/search/hotSearch";
NSString * const RRCAllHissearch    = @"v10/search/historySearch";
NSString * const RRCAllSearch       = @"v10/search/index";
NSString * const RRCDelAllHissearch = @"v10/search/clearHistorySearch";
NSString * const RRCArticleCollection = @"v5/user/collectart";
NSString * const RRCArticleAndTopicMore = @"v7/articleAndTopic/more";
NSString * const RRCArticleAndTopicDetails = @"v7/articleAndTopic/details";
NSString * const RRCSearchMorePost = @"v5/post/morePost";
NSString * const RRCSearchMoreUser = @"v5/post/moreUser";

#pragma mark - 文章详情
NSString * const RRCIsfollow = @"user/isfollow";
NSString * const RRCArtShare = @"v10/art/share";
NSString * const RRCArtOperationCount = @"v11/article/analysis";
NSString * const RRCArticleDetailCommentList = @"v11/articleAndDiscuss/commentList";
NSString * const RRCArticleComment = @"v10/articleAndDiscuss/comment";
NSString * const RRCcheckAricleComment = @"match/v12/post/authenticationForArticleAndUser";
NSString * const RRCcheckArticleCommentLimit = @"match/v12/post/articleReplyAuth";
NSString * const RRCArticleLevel_1 = @"v10/articleAndDiscuss/getCommentPage";
NSString * const RRCArticleChildcommentlist = @"v10/articleAndDiscuss/childCommentList";
NSString * const RRCArticleClickList = @"v10/articleAndDiscuss/clickLikeForArticle";
NSString * const RRCArticleDetailFocusStatus = @"v10/articleAndDiscuss/isClickLikeForArticle";
NSString * const RRCArticleCommentList = @"v10/articleAndDiscuss/discussList";
NSString * const RRCArticleChildComment = @"v10/articleAndDiscuss/childComment";

#pragma mark - 用户
NSString * const RRCUserReport        = @"v7/user/report";
NSString * const RRCUserInfoMessage   = @"v10/user/info";
NSString * const RRCUserRates         = @"v10/user/rates";
NSString * const RRCMYDynamic         = @"v11/post/userPostList";
NSString * const RRCV3UserCommentlist = @"v10/user/commentlist";
NSString * const RRCUsercollectlist   = @"user/collectlist";
NSString * const RRCMYArcticle        = @"user/artlist";

NSString * const RRCCarePerple = @"/v10/user/attention";
NSString * const RRCPostDelFollow = @"/v6/post/delFollow";
NSString * const RRCV3VoteTicket = @"match/v12/post/vote/ticket";
NSString * const RRCVotePerple = @"v10/user/cast";
NSString * const RRCBoleUserList = @"v10/user/boleUserList";
NSString * const RRCAddBlackPerple = @"v8/user/addBlacklist";
NSString * const RRCShieldUser = @"v10/user/screened";
NSString * const RRCShieldUserPermiss = @"/v10/post/checkHasPost";
NSString * const RRCUserScreenedlist = @"v10/user/screenedlist";
NSString * const RRCV3Feedbacklist = @"/v3/user/feedbacklist";
NSString * const RRCV3Feedback = @"/v3/user/feedback";
NSString * const RRCV3Fdnoread = @"/v3/user/fdnoread";
NSString * const RRCLogout = @"/logout";

#pragma mark - 赛事
NSString * const RRCAllGameLeagues     = @"v11/game/todayGameLeagues";
NSString * const RRCAllGamePK          = @"v11/game/todayGamePK";
NSString * const RRCMiddleGameLeagues  = @"v11/game/openLeagues";
NSString * const RRCMiddleGamePK       = @"v11/game/openGamePK";
NSString * const RRCScheduleGameLeagues= @"v11/game/scheduleLeagues";
NSString * const RRCScheduleGamePK     = @"v11/game/scheduleGamePK";
NSString * const RRCResultGameLeagues  = @"v11/game/amidithionLeagues";
NSString * const RRCResultGamePK       = @"v11/game/amidithionGamePK";

NSString * const RRCMatchAllScoreGame      = @"v12/game/todayGame";
NSString * const RRCMatchMiddleScoreGame   = @"v12/game/openGame";
NSString * const RRCMatchScheduleScoreGame = @"v11/game/scheduleGame";
NSString * const RRCMatchResultScoreGame   = @"v11/game/amidithionGame";
NSString * const RRCMatchFocusScoreGame    = @"v12/user/attentionGameList";
NSString * const RRCMatchScoreDateList     = @"v11/game/getDateList";

NSString * const RRCAttentionGame      = @"v11/user/attentionGame";
NSString * const RRCCloseAttentionGame = @"v11/user/closeAttentionGame";
NSString * const RRCAttentionGameCount = @"v6/user/countUserAttentionGame";
NSString * const FRRCAttentionGameId   = @"v11/user/userAttentionGameId";

NSString * const RRCSetEquipPush = @"v7/setting/equipment";
NSString * const RRCGetEquipPush = @"v7/setting/equipmentSetInfo";
NSString * const RRCGetUserSPush = @"v7/setting/userSetInfo";
NSString * const RRCSetUserSPush = @"v7/setting/user";

NSString * const RRCFoucsList      = @"v8/index/focusList";
NSString * const RRCMatchAdeptGame = @"v7/user/adeptGame";

NSString * const RRCMatchRuleForSend = @"match/v12/post/postNumber";//@"v10/postRecommend/matchRuleForSend";
NSString * const RRCPostJcDatelist   = @"v11/post/jcDateList";
NSString * const RRCPostYpDatelist   = @"v11/post/ypDateList";
NSString * const RRCPostLqDatelist   = @"v11/post/lqDateList";

NSString * const RRCJcMatchList      = @"v10/postRecommend/jc";
NSString * const RRCPostJcleaguelist = @"v4/post/jcleaguelist";
NSString * const RRCPostRecommendYP  = @"v11/postRecommend/yp";
NSString * const RRCPostYzleaguelist = @"v11/postRecommend/ypLeagueList";
NSString * const RRCPostRecommendLQ  = @"v11/postRecommend/lq";
NSString * const RRCPostLqleaguelist = @"v11/postRecommend/lqLeagueList";

NSString * const MatchStatistical = @"v6/post/forecast";
NSString * const RRCSaveGameDraft = @"v10/post/saveGameDraft";
NSString * const RRCGetGameDraft  = @"v10/post/getGameDraft";
NSString * const RRCDeleteGame    = @"v10/post/deleteGame";

NSString * const RRCUserAdeptGameList = @"v8/user/adeptGameList";
NSString * const RRCPostAllResult = @"v6/post/allResult";
NSString * const RRCPostJcResult = @"v6/post/jcResult";
NSString * const RRCPostYzResult = @"v6/post/yzResult";
NSString * const RRCPostLqResult = @"v6/post/lqResult";

NSString * const RRCExponentGameLeagues = @"match/v11/indexNumber/indexGameLeagues";

NSString * const RRCMatchEvents         = @"v11/game/getRealTimeCompetitionEvents";
NSString * const RRCMatchSideSquad      = @"v11/game/getRealTimeTwoSidesLineup";
NSString * const RRCMatchDataStatistics = @"v11/game/getRealTimeDataStatistics";
NSString * const RRCMatchLiveIndex      = @"match/v11/game/getRealTimeIndexNumber";
NSString * const RRCMatchChooseCompany  = @"match/v11/game/chooseCompany";

NSString * const LiveMatchDetail        = @"v10/real/time/getOneGameAllInfo";
NSString * const LiveGameHead           = @"v11/real/time/getOneGameInfo";
NSString * const LiveExponentPlate      = @"match/v11/asian/list";
NSString * const LiveExponentCompete    = @"match/v11/ball/list";
NSString * const LiveExponentCompensate = @"match/v12/europe/list";
NSString * const LiveExponentLetBall = @"match/v12/rq/list/query";
NSString * const LiveExponentCompensateRealTime = @"v11/europe/timeLoopList";
NSString * const LiveExponentCornerBall = @"match/v12/game/cornerKick";
NSString * const LiveExponentHalfullRate = @"match/v12/indexbqc";
NSString * const LiveExponentTotalScoreRate = @"match/v12/indexzjq";
NSString * const LiveFocusOnList        = @"v8/index/focusFollowList";
NSString * const LiveIntelligence       = @"v12/information/list";
NSString * const LiveSecretInfo         = @"match/v12/news/topSecret";
NSString * const LiveSecretPrise        = @"match/v12/news/thumbUp";
NSString * const LiveAnalysis           = @"v11/analysis/list";
NSString * const LiveAnalysisRealTime   = @"match/v11/analysis/matchBefore";
NSString * const LiveMatchAnAlysisRecord= @"v11/analysis/record";
NSString * const LiveMatchcountGameLive = @"v7/game/countGameLive";

///
NSString * const LiveRecommendFocusTop          = @"match/v12/recommend/recommendTop";
NSString * const LiveRecommendNewList           = @"match/v12/recommend/newestRecommend";
//NSString * const LiveRecommendReturnRateList    = @"match/v12/recommend/returnRate";
//NSString * const LiveRecommendVictoryRateList   = @"match/v12/recommend/victoryRate";
NSString * const LiveRecommendListRulesContent  = @"match/v12/recommend/ruleRateContent";
NSString * const LiveRecommendFocusRulesContent = @"match/v12/recommend/worldCupruleContent";


@end
