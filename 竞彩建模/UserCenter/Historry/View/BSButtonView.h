//
//  BSButtonView.h
//  CPetro
//
//  Created by ggx on 2017/3/9.
//  Copyright © 2017年 高广校. All rights reserved.
//

#import "RRCView.h"

@protocol BSButtonViewDelegate <NSObject>

-(void)didActionBottomIndex:(NSInteger)index;

@end

@interface BSButtonView : RRCView
-(id)initItemWithFram:(CGRect)frame andData:(NSArray *)paramData;

//引入代理
@property(nonatomic)id<BSButtonViewDelegate>delegate;



//-(void)updataUserStatus;
@end
