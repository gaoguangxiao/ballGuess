//
//  RRCTScoreModel.h
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/7/9.
//  Copyright © 2019 MXS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRCMatchEventModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RRCTScoreModel : NSObject

@property (nonatomic, strong) NSString *leagueId; //
@property (nonatomic, strong) NSString *jc_id;
/**比赛类型：全部0 、精简1 */
@property (nonatomic, strong) NSString *gameType;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *bc2;
@property (nonatomic, strong) NSString *corner1;
@property (nonatomic, strong) NSString *hhmm;

@property (nonatomic, strong) NSString *time2;
@property (nonatomic, strong) NSString *corner2;
@property (nonatomic, strong) NSString *bc1;
@property (nonatomic, strong) NSString *mmdd;

@property (nonatomic, strong) NSString *JSPKDesc;


@property (nonatomic, strong) NSString *awayScore;
@property (nonatomic, strong) NSString *ID;

/**0：未开、1：上半场、2：中场、3：下半场、4：加时、5：点球、-1：完场、-10:取消、-11:待定、-12:腰斩、-13:中断、-14:推迟 */
@property (nonatomic, strong) NSString *state;

@property (nonatomic , strong) NSString *sortState;//用于排序使用

@property (nonatomic, strong) NSString *homeScore;

@property (nonatomic, strong) NSString *stateDesc;
@property (nonatomic, strong) NSString *league;
@property (nonatomic, strong) NSString *DXQ_HJSPL;
@property (nonatomic, strong) NSString *DXQDesc;
@property (nonatomic, strong) NSString *DXQ_WJSPL;

@property (nonatomic, strong) NSString *yellow1;
@property (nonatomic, strong) NSString *yellow2;
@property (nonatomic, strong) NSString *home;//主队名字
@property (nonatomic , assign) CGFloat layoutHomeNameWidth;
@property (nonatomic , strong) NSString *firstHomeString;
@property (nonatomic , strong) NSString *secondHomeString;

@property (nonatomic, strong) NSString *away;//客队名字
@property (nonatomic , assign) CGFloat layoutAwayNameWidth;
@property (nonatomic , strong) NSString *firstAwayString;
@property (nonatomic , strong) NSString *secondAwayString;

@property (nonatomic, strong) NSString *WJSPL;

/**大小球是否封盘 0否 1封 */
@property (nonatomic, strong) NSString *IS_DX_F;
@property (nonatomic, strong) NSString *red2;
@property (nonatomic, strong) NSString *red1;

@property (nonatomic, strong) NSString *time;

/**格式：07-25 08:30 */
@property (nonatomic, strong) NSString *hmd;

/**亚盘是否封盘 0否 1封 */
@property (nonatomic, strong) NSString *IS_YP_F;

@property (nonatomic, strong) NSString *recommendNum; //分析推荐数目

@property (nonatomic , assign) BOOL isShowCollectStatusBtn;
@property (nonatomic, strong) NSString *collectStatus;//收藏状态 1收藏

/**0没有视频 1视频正常 2视频不正常 */
@property (nonatomic, strong) NSString *live;

//该场次是否进球
@property (nonatomic, strong) NSNumber *enterballNumber;

@property (nonatomic, assign) NSInteger enterBallCount;

/**进球客队 1主队：2客队 */
@property (nonatomic, assign) NSInteger enterballMember;

/**1 主队进球 2客队进球 */
@property (nonatomic,strong) NSString *flag;

@property (nonatomic, strong) NSString *HJSPL;//亚盘主队盘口
/**亚盘主队变化 0 不变 1上升 2下降 列表中只会为0 */
@property (nonatomic,strong) NSString *HJSPLFlag;
/**亚盘主队变化 消失时间 默认 10S*/
@property (nonatomic,assign) NSInteger HJSPLFlagTimer;

/**亚盘盘口变化 0 不变 1上升 2下降 列表中只会为0 赛程赛中列表也有（赛果不会有） */
@property (nonatomic,strong) NSString *JSPKFlag;
/**亚盘盘口变化 消失时间 默认 10S */
@property (nonatomic,assign) NSInteger JSPKFlagTimer;

/**亚盘客队变化 0 不变 1上升 2下降 列表中只会为0 */
@property (nonatomic,strong) NSString *WJSPLFlag;

/**亚盘客队变化 消失时间 默认 10S*/
@property (nonatomic,assign) NSInteger WJSPLFlagTimer;

/**大小球盘口变化 0 不变 1上升 2下降 列表中只会为0 */
@property (nonatomic,strong) NSString *DXQ_JSPKFlag;

/**大小球盘口变化 消失时间 默认 10S*/
@property (nonatomic,assign) NSInteger DXQ_JSPKFlagTimer;

/**大小球大球变化 0 不变 1上升 2下降 列表中只会为0 */
@property (nonatomic,strong) NSString *DXQ_HJSPLFlag;

/**大小球大球变化 消失时间 默认 10S*/
@property (nonatomic,assign) NSInteger DXQ_HJSPLFlagTimer;

/**大小球小球变化 0 不变 1上升 2下降 列表中只会为0 */
@property (nonatomic,strong) NSString *DXQ_WJSPLFlag;

/**大小球小球变化 消失时间 默认 10S*/
@property (nonatomic,assign) NSInteger DXQ_WJSPLFlagTimer;

//客队图标
@property (nonatomic,copy) NSString *awayFlag;
//主队图标
@property (nonatomic,copy) NSString *homeFlag;
//不用在意
@property (nonatomic,copy) NSString *streamName;
@property (nonatomic,copy) NSString *streamNameState;

@property (nonatomic,copy) NSString *NameOrNum;//竞足

//是否显示半角和全角
@property (nonatomic , assign) BOOL isShowHalf;

//本地自动
@property (nonatomic,assign) BOOL isLocalData;//是否是本地数据

//v3.5新增
@property (nonatomic , assign) CGFloat cellScoreHeight;//高度预先处理，交由scoreViewModel计算
@property (nonatomic , assign) BOOL enableTop;//是否能够置顶 默认NO
@property (nonatomic , assign) NSInteger topStatus;//置顶状态 1置顶 0未

@property (nonatomic , assign) NSInteger overTimeShowStatus;//加时状态
@property (nonatomic , strong) NSString *overTimeContent;//加时内容
/** 文本滚动偏移*/
@property (nonatomic,assign) CGFloat offx;

@property (nonatomic , assign) NSInteger cellIndex;//赛事处于的位置

@property (nonatomic , assign) NSInteger time_stamp;//比赛时间戳
@property (nonatomic , strong) NSString *homeTeamRanking;//主球队联赛排名
@property (nonatomic , strong) NSString *awayTeamRanking;//客 球队联赛排名 有值:[1] 没有值

//是否具备进球事件 进球事件展开否
@property (nonatomic , assign) BOOL isOpenEvent;         //进球事件闭合
@property (nonatomic , assign) BOOL isShowOpenEvent;   //进球事件闭合
@property (nonatomic , assign) BOOL isOpenStadium;       //球场视图打开与否
@property (nonatomic , assign) BOOL isUpdateStadiumHeight;//球场视图打开与否
@property (nonatomic , assign) BOOL isContainsMatchEvent;//具备比赛事件

@property (nonatomic , strong) NSDictionary *comepetitionEvents;//比赛进程
@property (nonatomic , strong) NSArray *shotsStatisModelArr;//比赛事件

@property (nonatomic , strong) RRCMatchEventModel *technicalDetails;

@property (nonatomic , strong) NSString *dhUrl1;//动画URL源1 动画1 opta 有进球事件
@property (nonatomic , strong) NSString *dhUrl2;//动画直播源2 动画2 懂球帝
@property (nonatomic , assign) NSInteger dhlive;//动画源 3直播源两个 2动画2 1动画有 0没

//视频地址
@property (nonatomic,copy) NSString *url;//破晓直播
@property (nonatomic,copy) NSString *url_sec;//凯旋直播

-(RRCTScoreModel *)replaceMJDataByNewModel:(RRCTScoreModel *)m;

@end

NS_ASSUME_NONNULL_END
