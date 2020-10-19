//
//  RRCNetFailView.h
//  MXSFramework
//
//  Created by renrencai on 2019/5/8.
//  Copyright © 2019 MXS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRCNoDataModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^reloadNetFailBlock)(UIButton *btnBlock);

@interface RRCNetFailView : UIView

@property (nonatomic , strong) reloadNetFailBlock reloadNetBlock;


/// 添加无网络视图
-(void)loadAlertNetFailView;

-(void)alertViewModel:(RRCNoDataModel *)dataModel withY:(CGFloat)Y reloadBtn:(reloadNetFailBlock)reloaBtnBlock;

/// 隐藏视图
-(void)hiddenNetFailView;
@end

NS_ASSUME_NONNULL_END
