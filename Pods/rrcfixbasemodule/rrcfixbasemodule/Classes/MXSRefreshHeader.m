//
//  MXSRefreshHeader.m
//  MXSFramework
//
//  Created by 晓松 on 2018/11/7.
//  Copyright © 2018年 MXS. All rights reserved.
//

#import "MXSRefreshHeader.h"
#import "RRCDeviceConfigure.h"
#import "YBColorConfigure.h"
#import "NSBundle+Resources.h"
#define BALLOON_GIF_DURATION 0.0030


@interface MXSRefreshHeader()
@property (strong, nonatomic) UIImageView *stateGIFImageView;
@property (strong, nonatomic) NSMutableDictionary *stateImages;
@end
@implementation MXSRefreshHeader
#pragma mark - 懒加载
- (UIImageView *)stateGIFImageView{
    if (!_stateGIFImageView) {
        _stateGIFImageView = [[UIImageView alloc] init];
        _stateGIFImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-100, 15, 27, 27);
        [self addSubview:_stateGIFImageView];
    }
    return _stateGIFImageView;
}

- (NSMutableDictionary *)stateImages {
    if (!_stateImages) {
        self.stateImages = [NSMutableDictionary dictionary];
    }
    return _stateImages;
}

#pragma mark - 公共方法
- (void)setImages:(NSArray *)images forState:(MJRefreshState)state {
    
    if (images == nil) {
        return;
    }
    self.stateImages[@(state)] = images;
    /* 根据图片设置控件的高度 */
    UIImage *image = [images firstObject];
    if (image.size.height > self.mj_h) {
        self.mj_h = image.size.height;
    }
}

#pragma mark - 实现父类的方法
- (void)prepare {
    
    [super prepare];
    // 初始化间距
    self.labelLeftInset = 20;
    // 资源数据（GIF每一帧）
    NSArray *idleImages = [self getRefreshingImageArrayWithStartIndex:0 endIndex:36];
    NSArray *refreshingImages = [self getRefreshingImageArrayWithStartIndex:0 endIndex:36];
    NSArray *PullingImages = [self getRefreshingImageArrayWithStartIndex:0 endIndex:0];
    
    // 普通状态
    [self setImages:idleImages forState:MJRefreshStateIdle];
    // 即将刷新状态
    [self setImages:PullingImages forState:MJRefreshStatePulling];
    // 正在刷新状态
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
}

- (void)setPullingPercent:(CGFloat)pullingPercent {
    
    [super setPullingPercent:pullingPercent];
    
    if (self.scrollView.dragging) {
        if (pullingPercent >= 1) {
            pullingPercent = 0.9999;
        }
    }
    
    NSArray *images = self.stateImages[@(MJRefreshStateIdle)];
    if (self.state != MJRefreshStateIdle || images.count == 0) {
        return;
    }
    [self.stateGIFImageView stopAnimating];
    NSUInteger index =  images.count * pullingPercent;
    if (index >= images.count) {
        index = images.count - 1;
    }
    self.stateGIFImageView.image = images[index];
}

- (void)placeSubviews{
    
    [super placeSubviews];
    if (self.stateGIFImageView.constraints.count) {
        return;
    }
    self.automaticallyChangeAlpha = NO;
    self.stateLabel.hidden = NO;
    // 设置文字
    [self setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [self setTitle:@"释放刷新" forState:MJRefreshStatePulling];
    [self setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    // 设置字体
    self.stateLabel.font = [UIFont systemFontOfSize:12*Device_Ccale];
    self.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:10*Device_Ccale];
    //    self.lastUpdatedTimeText = ^NSString *(NSDate *lastUpdatedTime) {
    //        NSDate *date=[NSDate date];
    //        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
    //        dateFormatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    //        return [dateFormatter stringFromDate:date];
    ////    };
    //    self.lastUpdatedTimeLabel.frame = CGRectMake(10, CGRectGetMaxY(self.stateLabel.frame) + 3, 100, 20);
    CGPoint center =  self.stateLabel.center;
    center.x = self.center.x+10;
    center.y += 8;
    self.stateLabel.center = center;
    
    
        CGPoint centertime =  self.lastUpdatedTimeLabel.center;
        centertime.x = self.center.x + 31.5 * Device_Ccale;
        centertime.y -=2;
        self.lastUpdatedTimeLabel.center = centertime;
    
    
    CGPoint centerimage =  self.stateGIFImageView.center;
    centerimage.x = self.center.x-45;
    self.stateGIFImageView.center = centerimage;
    // 设置颜色
    self.stateLabel.textColor = RRCB8C2CCColor;
    self.lastUpdatedTimeLabel.textColor = RRCB8C2CCColor;
    // 隐藏时间
    self.lastUpdatedTimeLabel.hidden = NO;
}

- (void)setState:(MJRefreshState)state{
    
    MJRefreshCheckState
    if (state == MJRefreshStatePulling || state == MJRefreshStateRefreshing) {
        NSArray *images = self.stateImages[@(state)];
        [self startGIFViewAnimationWithImages:images];
    } else if (state == MJRefreshStateIdle) {
        if (oldState == MJRefreshStateRefreshing && state == MJRefreshStateIdle) {
            NSArray *endImages = [self getRefreshingImageArrayWithStartIndex:8 endIndex:13];
            
            [self startGIFViewAnimationWithImages:endImages];
        }else{
            [self.stateGIFImageView stopAnimating];
        }
    }
}

-(void)startAnimationRefreshing{
    

//    NSLog(@"%d",self.stateGIFImageView.animating);
    
    [self.scrollView setContentOffset:CGPointMake(0, -57) animated:YES];
    
    NSArray *endImages = [self getRefreshingImageArrayWithStartIndex:8 endIndex:13];
    
    [self startGIFViewAnimationWithImages:endImages];
    
}

-(void)endAnimationsAndLoadData{

    self.state = MJRefreshStateRefreshing;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.state = MJRefreshStateIdle;
    });
    
}


#pragma mark - 开始动画
- (void)startGIFViewAnimationWithImages:(NSArray *)images{
    
    if (images.count <= 0){
        return;
    }
    [self.stateGIFImageView stopAnimating];
    // 单张
    if (images.count == 1) {
        self.stateGIFImageView.image = [images lastObject];
        return;
    }
    // 多张
    self.stateGIFImageView.animationImages = images;
    self.stateGIFImageView.animationDuration = images.count * BALLOON_GIF_DURATION;
    [self.stateGIFImageView startAnimating];
}

#pragma mark - 获取资源图片
- (NSArray *)getRefreshingImageArrayWithStartIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex{
    
    NSMutableArray *result = [NSMutableArray array];
    NSBundle *reBundle = [NSBundle bundleName:@"rrcfixbasemodule" andResourcesBundleName:@"RRCLoadingBall"];
    
    for (NSUInteger i = startIndex; i <= endIndex; i++) {
        NSString *imageName = [NSString stringWithFormat:@"拷贝 %ld",i];
        UIImage *image = [UIImage imageNamed:imageName inBundle:reBundle compatibleWithTraitCollection:nil];
        if (image) {
            [result addObject:image];
        }
    }
    return result;
    
}


#pragma mark key的处理
- (void)setLastUpdatedTimeKey:(NSString *)lastUpdatedTimeKey
{
    [super setLastUpdatedTimeKey:lastUpdatedTimeKey];
    
    // 如果label隐藏了，就不用再处理
    if (self.lastUpdatedTimeLabel.hidden) return;
    
    NSDate *lastUpdatedTime = [[NSUserDefaults standardUserDefaults] objectForKey:lastUpdatedTimeKey];
    
    // 如果有block
    if (self.lastUpdatedTimeText) {
        self.lastUpdatedTimeLabel.text = self.lastUpdatedTimeText(lastUpdatedTime);
        return;
    }
    
    if (lastUpdatedTime) {
        // 1.获得年月日
        NSCalendar *calendar = [self currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
        NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:lastUpdatedTime];
        NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
        
        // 2.格式化日期
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        BOOL isToday = NO;
        if ([cmp1 day] == [cmp2 day]) { // 今天
            formatter.dateFormat = @" HH:mm";
            isToday = YES;
        } else if ([cmp1 year] == [cmp2 year]) { // 今年
            formatter.dateFormat = @"MM-dd HH:mm";
        } else {
            formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        }
        NSString *time = [formatter stringFromDate:lastUpdatedTime];
        
        // 3.显示日期
        self.lastUpdatedTimeLabel.text = [NSString stringWithFormat:@"%@%@",
                                          @"上次刷新时间:",
                                          time];
    } else {
        self.lastUpdatedTimeLabel.text = [NSString stringWithFormat:@"%@%@",
                                          @"上次刷新时间:",
                                          [NSBundle mj_localizedStringForKey:MJRefreshHeaderNoneLastDateText]];
    }
}

#pragma mark - 日历获取在9.x之后的系统使用currentCalendar会出异常。在8.0之后使用系统新API。
- (NSCalendar *)currentCalendar {
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    return [NSCalendar currentCalendar];
}
@end
