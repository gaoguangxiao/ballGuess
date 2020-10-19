//
//  RRCMatchSetModel.h
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/7/12.
//  Copyright © 2019 MXS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RRCMatchSetModel : NSObject

@property (nonatomic, strong) NSArray *tipArr;

@property (nonatomic, strong) NSString *tipRange;

/**全部比赛 0、关注比赛：1*/
@property (nonatomic, assign) NSInteger selectIndex;

/**比赛类型：赛事比分列表的数据 */
@property (nonatomic, strong) NSArray *matchScoreListArr;

/// 置顶的赛事
//@property (nonatomic , strong) NSMutableSet *matchTopListSet;

@property (nonatomic , strong) NSMutableDictionary *matchTopLisDict;

#pragma mark - 推送设置
/**进球声音 */
@property (nonatomic, strong) NSString *voice_open;

/**进球震动 */
@property (nonatomic, strong) NSString *vibration_open;

/**关注比赛 进球声音 */
@property (nonatomic, strong) NSString *focus_voice_open;

/**关注比赛 进球震动 */
@property (nonatomic, strong) NSString *focus_vibration_open;

/**所有的推送设置 */
@property (nonatomic, strong) NSString *all_push;

/**赛事五分钟 */
@property (nonatomic, strong) NSString *push_match_start;

/**进球推送 */
@property (nonatomic, strong) NSString *push_enter_ball;

/**点赞 */
@property (nonatomic, strong) NSString *push_like_open;

/**新增关注 */
@property (nonatomic, strong) NSString *push_focus_open;

/**评论 */
@property (nonatomic, strong) NSString *push_comment_open;

/**新增投票 */
@property (nonatomic, strong) NSString *push_vote_open;

/**关注人发帖 */
@property (nonatomic, strong) NSString *push_post_open;

#pragma mark - APP本身
/**APP是否在前台运行 1是，0否*/
@property (nonatomic, strong) NSString *applicationIsActive;

@end

NS_ASSUME_NONNULL_END
