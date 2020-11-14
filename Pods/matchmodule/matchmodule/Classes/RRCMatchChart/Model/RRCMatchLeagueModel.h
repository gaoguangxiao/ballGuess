//
//  RRCMatchLeagueModel.h
//  MXSFramework
//
//  Created by renrencai on 2019/4/19.
//  Copyright © 2019年 MXS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RRCMatchLeagueModel : NSObject

///** 比赛名字*/
@property (nonatomic , strong) NSString *league;

/** 比赛名字 + 场数 添加比赛筛选*/
@property (nonatomic , strong) NSString *league_str;

@property (nonatomic , copy) NSString *isSelect;//0未选择1选中

@property (nonatomic,assign) NSInteger indexNum;//比赛筛选

/**推荐数 */
@property (nonatomic, strong) NSString *recommend;
/**胜率 */
@property (nonatomic, strong) NSString *win_prob;

/**联赛类型 */
@property (nonatomic, strong) NSString *type;


@end

NS_ASSUME_NONNULL_END
