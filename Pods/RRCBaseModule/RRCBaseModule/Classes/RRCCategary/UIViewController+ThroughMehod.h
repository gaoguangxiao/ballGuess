//
//  UIViewController+ThroughMehod.h
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/7/30.
//  Copyright © 2019 MXS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ThroughMehod)

/**
 socket收到信息
 
 @param data 收到的数据
 @param code 命令类型：1-比分变化 2-进球信息 3状态(开赛多久，60秒一次推送) 4详情 5指数（盘口）
 */
-(void)connectsocketDidReceiveMsgWithArr:(id)data AndCommandType:(NSInteger)code;

/**
 网络加载失败，点击重新加载执行的方法

 @param sender <#sender description#>
 */
-(void)reloadNetWorking:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
