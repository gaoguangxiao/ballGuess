//
//  RRCPostDraftModel.h
//  MXSFramework
//
//  Created by gaoguangxiao on 2020/3/7.
//  Copyright © 2020 MXS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RRCPostDraftModel : NSObject

//已发布推荐数量
@property (nonatomic , assign) NSInteger totalRecommended;

//可发布总数
@property (nonatomic , assign) NSInteger totalRecommend;

//草稿数量
@property (nonatomic , assign) NSInteger totalDraft;
@end

NS_ASSUME_NONNULL_END
