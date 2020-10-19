//
//  RRCTitleView.h
//  MXSFramework
//
//  Created by gaoguangxiao on 2020/4/16.
//  Copyright © 2020 MXS. All rights reserved.
//

#import "RRCView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RRCTitleView : RRCView

@property (nonatomic,strong) UILabel *titleLab;

@property(nonatomic)        NSTextAlignment    textPositionAlignment;//默认居左
@end

NS_ASSUME_NONNULL_END
