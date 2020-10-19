//
//  RRCMatchEnterBallView.m
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/7/10.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "RRCMatchEnterBallView.h"
#import "RRCEnterBallView.h"
#import "RRCTScoreModel.h"
#import "RRCNetWorkManager.h"
#import "RRCConfigManager.h"
#import "NSBundle+Resources.h"
@interface RRCMatchEnterBallView ()
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger img_tag;
@property (nonatomic, strong) NSMutableArray *focuMatchIdArr;
@end

@implementation RRCMatchEnterBallView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.disappearTime = 5.0;
        self.appearBottomMargin = 10;
        self.layer.masksToBounds = YES;//将多余的剪切掉
        //        self.userInteractionEnabled = NO;//禁止交互
        NSString *pathStr = [[NSBundle bundleName:@"matchscoremodule" andResourcesBundleName:@""] pathForResource:@"enterBall" ofType:@"mp3"];
        self.playUrl = pathStr;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RequestMatchFocusCount) name:@"RRCCountUpdateForMatchFouces" object:nil];
        
        [self RequestMatchFocusCount];
        
    }
    
    return self;
}
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    //    CGRect frame = self.frame;
    BOOL isContainsPoint = NO;//默认NO
    
    for (UIView * subview in self.subviews) {
        if ([subview isKindOfClass:[RRCEnterBallView class]]) {
            isContainsPoint = CGRectContainsPoint(subview.frame, point);
            if (isContainsPoint) {
                return YES;
            }
        }
    }
    
    return NO;//返回NO，视图不接受响应
}
-(void)setUpNewEnterBall:(NSArray *)arr{
    
    RRCMatchSetModel *configModel = [[RRCConfigManager sharedRRCConfigManager]loadPushLocalSet];
    if ([configModel.applicationIsActive integerValue] == 0) {
        return;
    }
    
    //更新收藏状态
    NSMutableArray *newEnterArr = [NSMutableArray new];
    [arr enumerateObjectsUsingBlock:^(RRCTScoreModel * _Nonnull score_obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //判断是否需要谈进球提示
        RRCTScoreModel *m = score_obj;
        //检测本进球事件是否被关注
        [self.focuMatchIdArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:m.ID]) {
                m.collectStatus = @"1";
            }
        }];
        
        
        //判断视图是否展示
        if (configModel.selectIndex == 1 && [m.collectStatus integerValue]) {//在关注比赛选项，当比赛关注，执行进球事件
            [newEnterArr addObject:score_obj];
        }else if (configModel.selectIndex == 0){
            //在全部比赛选项，进球比赛需要和比赛类型匹配废弃的业务
            //在全部比赛选项，进球比赛需要和当前比赛列表匹配，当没有包含关系就不会弹框
            for (NSInteger i = 0;i < configModel.matchScoreListArr.count; i++) {
                NSDictionary *matchScoreDict = configModel.matchScoreListArr[i];
                if (matchScoreDict && matchScoreDict[@"ID"]) {
                    if ([matchScoreDict[@"ID"] isEqualToString:m.ID]) {
                        [newEnterArr addObject:score_obj];
                        break;
                    }
                }
            }
        }
    }];
    
    if (newEnterArr.count == 0) {
        return;
    }
    
    
    
    //需要依次移动
    [self.dataArr addObjectsFromArray:newEnterArr];
    
    [newEnterArr enumerateObjectsUsingBlock:^(RRCTScoreModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //当产生新的时候 向数组中加
        [self startNewView:obj];
    }];
    
    
}

-(void)startNewView:(RRCTScoreModel *)m{
    
    self.img_tag++;
    RRCEnterBallView * imgv = [[RRCEnterBallView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64 * Device_Ccale)];;
    [self addSubview:imgv];
    //    imgv.frame = CGRectMake(0, self.height, self.width, 64);
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(64);
        make.bottom.mas_equalTo(self);
    }];
    imgv.layer.cornerRadius = 4;
    imgv.layer.masksToBounds = YES;
    imgv.hidden = self.isHiddenEnterView;
    
//    m.awayScore = [NSString stringWithFormat:@"%ld",self.img_tag];
    [imgv setupBrandscoreMode:m];
    [self layoutIfNeeded];
    if (self.isPlayerVoice) {
        if (self.enterBallVoicePlayer == RRCEnterBallVoicePlayerBefore) {
            [imgv playUrl:self.playUrl];
            //需要用代理执行，未完成
        }else if (self.enterBallVoicePlayer == RRCEnterBallVoicePlayerTogether) {
            [imgv playUrl:self.playUrl];
            [self startAnimation];
        }
    }else{
        [self startAnimation];
    }
    //    NSLog(@"进球了");
    //开始对新添加的计时，如果超过一定时间就移除,移除动画时间
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.disappearTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.dataArr.count == 0) {
            [self.dataArr removeObjectAtIndex:0];
        }
        [imgv removeFromSuperview];
    });
}

- (void)startAnimation{
    
    NSMutableArray *results = [NSMutableArray arrayWithArray:[[self.subviews reverseObjectEnumerator]allObjects]];
    
    for (NSInteger i = 0; i < results.count; i++) {
        RRCEnterBallView * imgg = results[i];
        [imgg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self).offset( - i * (imgg.frame.size.height + self.appearBottomMargin));
        }];
        
    }
    
}
//请求赛事关注的数量
-(void)RequestMatchFocusCount{
    [[RRCNetWorkManager sharedTool]loadRequestWithURLString:@"v11/user/userAttentionGameId" parameters:@{} success:^(CGDataResult * _Nonnull result) {
        if (result.status.boolValue && [result.data isKindOfClass:[NSArray class]]) {
            [self.focuMatchIdArr removeAllObjects];//移除所有的
            [self.focuMatchIdArr addObjectsFromArray:result.data];
        }
    }];
}

#pragma mark - Getter
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
-(NSMutableArray *)focuMatchIdArr{
    if (!_focuMatchIdArr) {
        _focuMatchIdArr = [NSMutableArray new];
    }
    return _focuMatchIdArr;
}
@end
