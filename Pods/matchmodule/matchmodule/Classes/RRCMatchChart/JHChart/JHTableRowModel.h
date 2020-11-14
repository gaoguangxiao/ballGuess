//
//  JHContentModel.h
//  MXSFramework
//
//  Created by gaoguangxiao on 2020/3/10.
//  Copyright © 2020 MXS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHTableRowModel : NSObject

@property (nonatomic, strong) NSString *ball_str;// 单元格内容 胜
@property (nonatomic, strong) NSString *ball_num;//单元格 数 @0.76

@property (nonatomic, assign) NSInteger unitSelect;//单元格显示状态 1选中 0未选中单元格是否触摸状态 1不可触摸 0可触摸
@property (nonatomic, assign) NSInteger unitDisTouch;//单元格是否触摸状态 1不可触摸 0可触摸

@property (nonatomic, assign) NSInteger unitbackImageisHidden;//单元格背景图片是否显示隐藏 1隐藏 0显示
//                第一个元素 string ：显示于顶部
//                第二个元素 string ：显示底部
//                第三个元素 选中状态 1选中 0 未选中
//                第四个元素 是否可以点击交互 1可交互 0不可交互
//                第五个元素 底部图片显示 1不显示 0显示

@end

NS_ASSUME_NONNULL_END
