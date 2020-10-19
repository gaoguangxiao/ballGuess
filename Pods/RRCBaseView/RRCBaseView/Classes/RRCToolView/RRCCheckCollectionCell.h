//
//  RRCLeagueCoViewCell.h
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/7/13.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "RRCCollectionViewCell.h"

@class RRCLeaguesModel;
NS_ASSUME_NONNULL_BEGIN

@interface RRCCheckCollectionCell : RRCCollectionViewCell

@property (nonatomic,strong) UILabel *nameLab;

/// 设置筛选标题
@property (nonatomic , strong) NSString *choseTitle;
/// 设置筛选右边内容
@property (nonatomic , strong) NSString *choseContent;

@property (nonatomic,strong) UILabel *yzLab;//亚指胜率

@property (nonatomic,strong) UILabel *dxqLab;//大小球胜率

@property (nonatomic,strong) UILabel *bdLab;//波胆胜率

@property (nonatomic,strong) UILabel *jcLab;//竞彩胜率

//设置数据
-(void)setLeagueModelData:(RRCLeaguesModel *)leagueModel;

/// 设置默认背景
@property (nonatomic,strong) UIImage *choseNormalBackImage;
// 设置选中背景
@property (nonatomic,strong) UIImage *choseSelectBackImage;
///设置选中状态
@property (nonatomic,assign) BOOL selectStatus;

@end

NS_ASSUME_NONNULL_END
