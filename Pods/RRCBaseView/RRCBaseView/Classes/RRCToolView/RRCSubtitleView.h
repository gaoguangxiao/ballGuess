//
//  RRCSubtitleView.h
//  MXSFramework
//
//  Created by gaoguangxiao on 2020/4/16.
//  Copyright © 2020 MXS. All rights reserved.
//

#import "RRCTitleView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RRCSubtitleView : RRCTitleView

@property(nonatomic ,strong) UILabel *detailLabel;//详情
@property(nonatomic ,strong) UIImageView *nextImageView;

//设置左边数值 detailText nextImage
-(void)setDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
