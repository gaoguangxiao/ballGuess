//
//  RRCBallModel.h
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/6/18.
//  Copyright © 2019 MXS. All rights reserved.
//  单场赛事 [场次、主V客、类别、选项、赛果]

#import <Foundation/Foundation.h>
#import "RRCDeviceConfigure.h"
NS_ASSUME_NONNULL_BEGIN

@interface RRCBallModel : NSObject

/**场次【周一001，时间+日期】 */
@property (nonatomic, strong) NSString *match_name;

/** 比赛成员*/
@property (nonatomic, strong) NSString *matchMember;

/**类别 【亚指，大小，胜平负、让球胜平负】 */
@property (nonatomic, strong) NSMutableArray *play_Method;

/**选项 【猪手让、客受让】 */
@property (nonatomic, strong) NSMutableArray *odd_Arr;

/**赛果【无，胜，输、走水、取消】 */
@property (nonatomic, strong) NSMutableArray *match_tateArr;



/**
 处理赛事结果

 @param result 赛事int类型
 @return 赛事的结果 红，走水等等
 */
-(NSString *)imageNameByResult:(NSString *)result;

@end

NS_ASSUME_NONNULL_END
