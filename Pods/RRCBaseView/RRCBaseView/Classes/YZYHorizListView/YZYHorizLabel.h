//
//  YZYHorizView.h
//  AutoScrollDemo
//
//  Created by gaoguangxiao on 2019/6/20.
//  Copyright © 2019 YZY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YZYHorizLabelDelegate <NSObject>


-(void)textRunviewDistance:(CGFloat)x;

@end

@interface YZYHorizLabel : UILabel


@property (nonatomic, weak)id<YZYHorizLabelDelegate>delegate;

/**
 文本跑马 间距
 */
@property (nonatomic, assign) CGFloat separationMargin;


-(void)setText:(NSString *)text andLastOffx:(CGFloat)offx;


/**
 destruction run label
 */
-(void)destructionRunlbel;


-(void)startRunlbel;
@end

NS_ASSUME_NONNULL_END
