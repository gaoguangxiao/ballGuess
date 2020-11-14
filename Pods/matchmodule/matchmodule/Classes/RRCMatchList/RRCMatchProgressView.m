//
//  RRCMatchProgressView.m
//  MXSFramework
//
//  Created by 人人彩 on 2020/4/13.
//  Copyright © 2020 MXS. All rights reserved.
//

#import "RRCMatchProgressView.h"
#import "DYUIViewExt.h"
#import "RRCDeviceConfigure.h"
#import "UIImage+MatchmoduleImg.h"
@interface RRCMatchProgressView ()
@property (nonatomic,strong) RRCMatchProgressItem *halfItem;
@property (nonatomic,strong) UIImageView *pauseImg;
@end
@implementation RRCMatchProgressView

-(void)setUpView{
    [self addSubview:self.halfItem];
    [self addSubview:self.pauseImg];
}

-(void)setProgressDic:(NSDictionary *)progressDic{
    _progressDic = progressDic;
    if (![self isEmpty:progressDic[@"time"]]) {
        self.halfItem.progressRate = [progressDic[@"time"] floatValue]/90.;
    }
    NSArray *homeTeamIncidentList = progressDic[@"homeTeamIncidentList"];
    NSArray *visitingTeamIncidentList = progressDic[@"visitingTeamIncidentList"];
    
    for (id object in self.subviews) {
        if ([object isKindOfClass:[UIImageView class]] && object != _pauseImg) {
            UIImageView *img = (UIImageView *)object;
            [img removeFromSuperview];
        }
    }

    if ([homeTeamIncidentList isKindOfClass:[NSArray class]]) {
        for (NSInteger i = 0; i < homeTeamIncidentList.count; i++) {
            NSDictionary * dict = homeTeamIncidentList[i];
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13*Device_Ccale, 13*Device_Ccale)];
            img.left = [self getX:dict[@"incidentTime"]];
            [self getY:img MasterGuest:YES incidentType:kSafeString(dict[@"incidentType"])];
            [self addSubview:img];
        }
    }
    if ([visitingTeamIncidentList isKindOfClass:[NSArray class]]) {
        for (NSInteger i = 0; i < visitingTeamIncidentList.count; i++) {
            NSDictionary * dict = visitingTeamIncidentList[i];
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13*Device_Ccale, 13*Device_Ccale)];
            img.left = [self getX:dict[@"incidentTime"]];
            [self getY:img MasterGuest:NO incidentType:kSafeString(dict[@"incidentType"])];
            [self addSubview:img];
        }
    }
}

//获取X
-(float)getX:(NSString *)time{
    float itemWidth = kScreenWidth - 60*Device_Ccale;
    if (![self isEmpty:time]) {
        float xRate = [time floatValue]/90.;
        float leftX = xRate > .5 ?itemWidth*xRate + 36*Device_Ccale:itemWidth*xRate;
        return leftX - 6.5*Device_Ccale;
    }
    return 0;
}

//获取Y 【事件类型】1:入球，2:红牌，3:黄牌，7:点球，8:乌龙，9:两黄变红，11:换人，13:射失点球,14:角球
-(void)getY:(UIImageView *)img MasterGuest:(BOOL)isMaster incidentType:(NSString *)incidentType{
    if (isMaster) {
        //主队
        if ([incidentType intValue] == 1) {//乌龙球和点球按进球算
            img.top = 12*Device_Ccale;
            img.image = [UIImage matchModuleImageNamed:@"matchmoduleMasterEnterBall"];
        }else if ([incidentType intValue] == 2){
            img.top = 12*Device_Ccale;
            img.image = [UIImage matchModuleImageNamed:@"matchmoduleRedBrand"];
        }else if ([incidentType intValue] == 14){
            img.top = 8*Device_Ccale;
            img.image = [UIImage matchModuleImageNamed:@"matchmoduleMasterCorner"];
        }
    }else{
        //客队
        if ([incidentType intValue] == 1) {
            img.top = 19*Device_Ccale;
            img.image = [UIImage matchModuleImageNamed:@"matchmoduleGuestEnterBall"];
        }else if ([incidentType intValue] == 2){
            img.top = 19*Device_Ccale;
            img.image = [UIImage matchModuleImageNamed:@"matchmoduleRedBrand"];
        }else if ([incidentType intValue] == 14){
            img.top = 23*Device_Ccale;
            img.image = [UIImage matchModuleImageNamed:@"matchmoduleGuestCorner"];
        }
    }
}

#pragma mark ----GET----
-(RRCMatchProgressItem *)halfItem{
    if (!_halfItem) {
        _halfItem = [[RRCMatchProgressItem alloc] initWithFrame:CGRectMake(0, 16*Device_Ccale, kScreenWidth - 24*Device_Ccale, 12*Device_Ccale)];
    }
    return _halfItem;
}

-(UIImageView *)pauseImg{
    if (!_pauseImg) {
        _pauseImg = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 60*Device_Ccale)/2., 12*Device_Ccale, 36*Device_Ccale, 20*Device_Ccale)];
        _pauseImg.image = [UIImage matchModuleImageNamed:@"matchmoduleHt"];
    }
    return _pauseImg;
}

-(BOOL)isEmpty:(id)objc{
    if ([objc isEqual:[NSNull null]] || objc == nil) {
        return YES;
    }
    return NO;
}

@end

#pragma mark------RRCMatchProgressItem-------
@interface RRCMatchProgressItem ()
@property (nonatomic,strong) NSMutableArray *layerArr;
@end

@implementation RRCMatchProgressItem

-(void)setProgressRate:(float)progressRate{
    _progressRate = progressRate;
    for (CAShapeLayer *layer in self.layerArr) {
        [layer removeFromSuperlayer];
    }
    [self.layerArr removeAllObjects];
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect{

    float itemHeight = 12*Device_Ccale;
    UIBezierPath *path=[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.width, itemHeight)];
    CAShapeLayer *_shapeLayer=[CAShapeLayer layer];
    _shapeLayer.lineWidth = .5*Device_Ccale;
    _shapeLayer.path = path.CGPath;
    _shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:_shapeLayer];
    [self.layerArr addObject:_shapeLayer];
    
    float itemWidth = kScreenWidth - 60*Device_Ccale;
    UIBezierPath *path1=[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, _progressRate > .5?itemWidth *_progressRate+36*Device_Ccale:itemWidth *_progressRate, itemHeight)];
    CAShapeLayer *contentLayer=[CAShapeLayer layer];
    contentLayer.lineWidth = .5*Device_Ccale;
    contentLayer.path = path1.CGPath;
    contentLayer.strokeColor = [UIColor clearColor].CGColor;
    contentLayer.fillColor = RRC258940Color.CGColor;
    [self.layer addSublayer:contentLayer];
    [self.layerArr addObject:contentLayer];
    
    float itemSpace = itemWidth / 18;
    for (int i = 1 ; i < 18; i++) {
        if (i == 9) {
            continue;
        }
        UIBezierPath *bPath = [UIBezierPath bezierPath];
        float y = (i%2 != 0)?8:5;
        [bPath moveToPoint:CGPointMake(i >=10?itemSpace *i+36*Device_Ccale :itemSpace*i, y*Device_Ccale)];
        [bPath addLineToPoint:CGPointMake(i >=10?itemSpace *i+36*Device_Ccale :itemSpace*i,12*Device_Ccale)];
        
        CAShapeLayer *lineshapeLayer=[CAShapeLayer layer];
        lineshapeLayer.lineWidth = .5*Device_Ccale;
        lineshapeLayer.path = bPath.CGPath;
        lineshapeLayer.strokeColor = [UIColor blackColor].CGColor;
        lineshapeLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:lineshapeLayer];
        [self.layerArr addObject:lineshapeLayer];
    }
}

-(NSMutableArray *)layerArr{
    if (!_layerArr) {
        _layerArr = [NSMutableArray array];
    }
    return _layerArr;
}

@end
