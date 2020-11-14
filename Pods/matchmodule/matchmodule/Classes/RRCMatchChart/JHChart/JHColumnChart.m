//
//  JHColumnChart.m
//  JHChartDemo
//
//  Created by 简豪 on 16/5/10.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHColumnChart.h"
#import <objc/runtime.h>
#import "JHColumnItem.h"
#import "JHScrollView.h"
#import "DYUIViewExt.h"
#import "RRCDeviceConfigure.h"
@interface JHColumnChart ()<UIGestureRecognizerDelegate,CAAnimationDelegate,JHColumnItemActionDelegate>

/**绘制长按线条 */
@property (nonatomic,strong)JHScrollView *BGLineScrollView;
//背景图
@property (nonatomic,strong)UIScrollView *BGScrollView;

//峰值
@property (nonatomic,assign) CGFloat maxHeight;

//横向最大值
@property (nonatomic,assign) CGFloat maxWidth;

//Y轴辅助线数据源
@property (nonatomic,strong)NSMutableArray * yLineDataArr;

//所有的图层数组
@property (nonatomic,strong)NSMutableArray * layerArr;

//所有的柱状图数组
@property (nonatomic,strong)NSMutableArray * showViewArr;

@property (nonatomic,assign) CGFloat perHeight;

@property (nonatomic , strong) NSMutableArray * drawLineValue;

//移动的距离
@property (assign, nonatomic) CGPoint moveDistance;

@end

@implementation JHColumnChart

-(void)setBgVewBackgoundColor:(UIColor *)bgVewBackgoundColor{
    
    _bgVewBackgoundColor = bgVewBackgoundColor;
    self.BGScrollView.backgroundColor = _bgVewBackgoundColor;
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    
    if (self = [super initWithFrame:frame]) {
        
        _needXandYLine = YES;
        _isShowYLine = YES;
        _lineChartPathColor = [UIColor blueColor];
        _lineChartValuePointColor = [UIColor yellowColor];
        
        //长按手势
        [self addSubview:self.BGLineScrollView];
        
        
    }
    return self;
    
}
-(void)event_tapAction:(UITapGestureRecognizer *)sender{
    CGPoint location = [sender locationInView:self.BGLineScrollView];
    //相对于屏幕的位置
    CGPoint screenLoc = CGPointMake(location.x - _drawFromOriginX, location.y);
    
    //    if (ABS(location.x - _moveDistance.y) > self.BGLineScrollView.pointGap) { //不能长按移动一点点就重新绘图  要让定位的点改变了再重新绘图
    self.BGLineScrollView.isLongPress = YES;
    self.BGLineScrollView.currentLoc = screenLoc;
    [self.BGLineScrollView setNeedsDisplay];
    //    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    CGPoint location = [gestureRecognizer locationInView:self.BGLineScrollView];
    if (ABS(location.y - _moveDistance.y) > 20) {
        //当拖曳竖直距离大于30时，不执行此手势
        _moveDistance = location;//
        return NO;
    }else{
        _moveDistance = location;//
        return YES;
    }
}

- (void)event_panAction:(UIPanGestureRecognizer *)longPress {
    if(UIGestureRecognizerStateEnded != longPress.state) {
        CGPoint location = [longPress locationInView:self.BGLineScrollView];
        //相对于屏幕的位置
        CGPoint screenLoc = CGPointMake(location.x - _drawFromOriginX, location.y);
        
        if (ABS(location.x - _moveDistance.x) > self.BGLineScrollView.pointGap) {
            _moveDistance = screenLoc;
            //不能长按移动一点点就重新绘图  要让定位的点改变了再重新绘图
            self.BGLineScrollView.isLongPress = YES;
            self.BGLineScrollView.currentLoc = screenLoc;
            [self.BGLineScrollView setNeedsDisplay];
        }
    }else{
        _moveDistance = CGPointMake(0, 0);
        //        self.BGLineScrollView.isLongPress = NO;
        //        [self.BGLineScrollView setNeedsDisplay];
    }
    
}

-(void)setLineValueArray:(NSArray *)lineValueArray{
    
    if (!_isShowLineChart) {
        return;
    }
    
    _lineValueArray = lineValueArray;
}

-(void)setValueArr:(NSArray<NSArray *> *)valueArr{
    _valueArr = valueArr;;
}
-(void)setYLineArray:(NSArray *)yLineArray{
    _yLineArray = yLineArray;
}

-(void)showAnimation{
    
    [self clear];
    if (_valueArr.count == 0) {
        return;
    }
    _columnWidth = (_columnWidth<=0?30:_columnWidth);
    
    NSInteger count = _valueArr.count * [_valueArr[0] count];
    _typeSpace = (_typeSpace<=0?15:_typeSpace);
    _maxWidth = count * _columnWidth + _valueArr.count * _typeSpace + self.originSize.x + _drawFromOriginX;//右边留12的
    self.BGScrollView.contentSize = CGSizeMake(_maxWidth, 0);
    self.BGScrollView.backgroundColor = _bgVewBackgoundColor;
    self.BGLineScrollView.frame = CGRectMake(self.originSize.x, 0, self.width - self.originSize.x, self.height);
    self.BGLineScrollView.columnWidth = self.drawFromOriginX;
    self.BGLineScrollView.pointGap = _columnWidth + _typeSpace;
    self.BGLineScrollView.originSize = self.originSize;
    [self bringSubviewToFront:self.BGLineScrollView];//
    
    CGFloat chartTitleHeight   = 30;
    CGFloat chartContentHeight = CGRectGetHeight(self.frame) - self.originSize.y - chartTitleHeight;
    CGFloat chartContentWidth  = CGRectGetWidth(self.frame) - self.originSize.x - _drawFromEndX;//表格宽度
    
    _maxHeight = 100;
    _perHeight = (chartContentHeight - 3)/_maxHeight;//底部时间减去
    
    /*        绘制X、Y轴  可以在此改动X、Y轴字体大小       */
    if (_needXandYLine) {
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        
        [self.layerArr addObject:layer];
        
        UIBezierPath *bezier = [UIBezierPath bezierPath];
        
        if (self.isShowYLine) {
            [bezier moveToPoint:CGPointMake(self.originSize.x, self.height - self.originSize.y)];
            [bezier addLineToPoint:P_M(self.originSize.x, chartTitleHeight + 2)];
        }
        
        [bezier moveToPoint:CGPointMake(self.originSize.x, CGRectGetHeight(self.frame) - self.originSize.y)];
        [bezier addLineToPoint:P_M(self.width - _drawFromEndX , CGRectGetHeight(self.frame) - self.originSize.y)];
        layer.path = bezier.CGPath;
        
        layer.strokeColor = (_colorForXYLine==nil?([UIColor blackColor].CGColor):_colorForXYLine.CGColor);
        
        if (!self.isHiddenAnimations) {
            CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            basic.duration = self.isHiddenAnimations ? 0 :0.75;
            basic.fromValue = @(0);
            basic.toValue = @(1);
            basic.autoreverses = NO;
            basic.fillMode = kCAFillModeForwards;
            [layer addAnimation:basic forKey:nil];
        }
        
        //
        [self.BGScrollView.layer addSublayer:layer];
        
        //        _maxHeight += 4;
        
        /*        设置虚线辅助线         */
        UIBezierPath *second = [UIBezierPath bezierPath];
        for (NSInteger i = 0; i < 5; i++) {
            NSInteger pace = chartContentHeight / 5;
            CGFloat height =  (i + 1)*pace;
            [second moveToPoint:P_M(_originSize.x, CGRectGetHeight(self.frame) - _originSize.y -height)];
            [second addLineToPoint:P_M(self.width - _drawFromEndX, CGRectGetHeight(self.frame) - _originSize.y - height)];
        }
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = second.CGPath;
        shapeLayer.strokeColor = (_dashColor==nil?([UIColor darkGrayColor].CGColor):_dashColor.CGColor);
        shapeLayer.lineWidth = 0.5;
        [shapeLayer setLineDashPattern:@[@(3),@(3)]];
        
        if (!self.isHiddenAnimations) {
            CABasicAnimation *basic2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            basic2.duration =  1.5;
            basic2.fromValue = @(0);
            basic2.toValue = @(1);
            basic2.autoreverses = NO;
            basic2.fillMode = kCAFillModeForwards;
            [shapeLayer addAnimation:basic2 forKey:nil];
        }
        //
        [self.BGScrollView.layer addSublayer:shapeLayer];
        [self.layerArr addObject:shapeLayer];
        
        //绘制胜率,保持胜率居中
        CATextLayer *yTextLayer = [CATextLayer layer];
        yTextLayer.alignmentMode = kCAAlignmentCenter;
        yTextLayer.contentsScale = [UIScreen mainScreen].scale;
        NSString *text = @"胜率";
        CGFloat be = 48 * Device_Ccale;
        yTextLayer.frame = CGRectMake(self.originSize.x - 20 - 3,(chartTitleHeight - self.yDescTextFontSize)/2, be, chartTitleHeight);
        
        UIFont *font = [UIFont systemFontOfSize:self.yDescTextFontSize];
        CFStringRef fontName = (__bridge CFStringRef)font.fontName;
        CGFontRef fontRef = CGFontCreateWithFontName(fontName);
        yTextLayer.font = fontRef;
        yTextLayer.fontSize = font.pointSize;
        CGFontRelease(fontRef);
        yTextLayer.string = text;
        
        yTextLayer.foregroundColor = (_drawTextColorForX_Y==nil?[UIColor blackColor].CGColor:_drawTextColorForX_Y.CGColor);
        [_BGScrollView.layer addSublayer:yTextLayer];
        [self.layerArr addObject:yTextLayer];
        
        for (NSInteger i = 0; i < self.yLineArray.count; i++) {
            NSInteger pace = chartContentHeight / 5;//120/5
            CGFloat height =  (i)*pace;
            
            CATextLayer *textLayer = [CATextLayer layer];
            textLayer.alignmentMode = kCAAlignmentCenter;
            textLayer.contentsScale = [UIScreen mainScreen].scale;
            NSString *text =[NSString stringWithFormat:@"%@%%",self.yLineArray[i]];
            CGFloat be = 48 * Device_Ccale;
            textLayer.frame = CGRectMake(self.originSize.x - be - 3, CGRectGetHeight(self.frame) - _originSize.y - height - 5, be, 15);
            
            UIFont *font = [UIFont systemFontOfSize:self.yDescTextFontSize];
            CFStringRef fontName = (__bridge CFStringRef)font.fontName;
            CGFontRef fontRef = CGFontCreateWithFontName(fontName);
            textLayer.font = fontRef;
            textLayer.fontSize = font.pointSize;
            CGFontRelease(fontRef);
            
            textLayer.string = text;
            
            textLayer.foregroundColor = (_drawTextColorForX_Y==nil?[UIColor blackColor].CGColor:_drawTextColorForX_Y.CGColor);
            [_BGScrollView.layer addSublayer:textLayer];
            [self.layerArr addObject:textLayer];
            
        }
    }
    
    /*        绘制X轴提示语  不管是否设置了是否绘制X、Y轴 提示语都应有         */
    if (_xShowInfoText.count>0) {
        
        //        NSInteger count = [_valueArr[0] count];
        CGFloat wid =  chartContentWidth / _xShowInfoText.count;
        for (NSInteger i = 0; i<_xShowInfoText.count; i++) {
            
            CATextLayer *textLayer = [CATextLayer layer];
            
            CGSize size = [_xShowInfoText[i] boundingRectWithSize:CGSizeMake(wid, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.xDescTextFontSize]} context:nil].size;
            
            textLayer.frame = CGRectMake( i * wid  + _originSize.x, CGRectGetHeight(self.frame) - _originSize.y+5,wid, size.height);
            textLayer.string = _xShowInfoText[i];
            textLayer.contentsScale = [UIScreen mainScreen].scale;
            UIFont *font = [UIFont systemFontOfSize:self.xDescTextFontSize];
            
            textLayer.fontSize = font.pointSize;
            
            textLayer.foregroundColor = (_drawTextColorForX_Y==nil?[UIColor blackColor].CGColor:_drawTextColorForX_Y.CGColor);
            
            textLayer.alignmentMode = kCAAlignmentCenter;
            
            [_BGScrollView.layer addSublayer:textLayer];
            
            [self.layerArr addObject:textLayer];
            
            
        }
        
        
    }
    
    /*        动画展示         */
    for (NSInteger i = 0; i<_valueArr.count; i++) {
        
        
        NSArray *arr = _valueArr[i];
        id colors = nil;
        if (_columnBGcolorsArr.count == _valueArr.count) {
            if ([_columnBGcolorsArr isKindOfClass:[NSArray class]] && [_columnBGcolorsArr count] > 0) {
                colors = _columnBGcolorsArr[i];
            }
        }else{
            colors = _columnBGcolorsArr.firstObject;
        }
        
        for (NSInteger j = 0; j<arr.count; j++) {
            CGFloat height = 0;
            
            if ([arr[j] isKindOfClass:[NSArray class]]) {
                for (id obj in arr[j]) {
                    height += [obj floatValue];
                }
                height = height * _perHeight;
            }else{
                height = [arr[j] floatValue] *_perHeight;
                if (height < 0) {
                    height = 0;
                }else if (height == 0){
                    //高度为0 代表胜率为0
                    height = 2;
                }
            }
            JHColumnItem *itemsView = [[JHColumnItem alloc] initWithFrame:CGRectMake((i * arr.count + j)*_columnWidth + i*_typeSpace+_originSize.x, CGRectGetHeight(self.frame) - height - _originSize.y -1, _columnWidth, height) perHeight:_perHeight valueArray:arr[j] colors:colors];
            itemsView.clipsToBounds = YES;
            NSDictionary *itemTextDescDic = self.valueDescArr[i];
            if (itemTextDescDic.allKeys.count > 0) {
                //胜率 几中几
                itemsView.columnItemTextDesc = [NSString stringWithFormat:@"%@ %@中%@|%@",itemTextDescDic[@"sl"],itemTextDescDic[@"all"],itemTextDescDic[@"win"],itemTextDescDic[@"date"]];
            }
            
            
            itemsView.delegate = self;
            NSIndexPath *path = [NSIndexPath indexPathForRow:j inSection:i];
            itemsView.index = path;
            [self.showViewArr addObject:itemsView];
            itemsView.frame = CGRectMake((i * arr.count + j)*_columnWidth + i*_typeSpace+_originSize.x + _drawFromOriginX, CGRectGetHeight(self.frame) - _originSize.y-1, _columnWidth, 0);
            
            if (_isShowLineChart) {
                NSString *value = [NSString stringWithFormat:@"%@",_lineValueArray[i]];
                float valueFloat =[value floatValue];
                if (valueFloat >= 0) {
                    NSValue *lineValue = [NSValue valueWithCGPoint:P_M(CGRectGetMaxX(itemsView.frame) - _columnWidth / 2, CGRectGetHeight(self.frame) - valueFloat * _perHeight - _originSize.y - 1)];
                    [self.drawLineValue addObject:lineValue];
                }
            }
            [self.BGScrollView addSubview:itemsView];
            
            [UIView animateWithDuration:self.isHiddenAnimations ? 0 : 1.0 animations:^{
                
                itemsView.frame = CGRectMake((i * arr.count + j)*self->_columnWidth + i*self->_typeSpace+self->_originSize.x + _drawFromOriginX, CGRectGetHeight(self.frame) - height - _originSize.y, _columnWidth, height);
                
            } completion:^(BOOL finished) {
                /*        动画结束后添加提示文字         */
                if (finished) {
                    //添加折线图
                    if (i==self->_valueArr.count - 1&&j == arr.count-1 && self->_isShowLineChart) {
                        UIBezierPath *path = [UIBezierPath bezierPath];
                        for (int32_t m=0;m < self->_drawLineValue.count;m++) {
                            if (m != 0) {
                                [path addLineToPoint:[self->_drawLineValue[m] CGPointValue]];
                            }
                            [path moveToPoint:[self->_drawLineValue[m] CGPointValue]];
                        }
                        
                        CAShapeLayer *shaper = [CAShapeLayer layer];
                        shaper.path = path.CGPath;
                        shaper.frame = self.bounds;
                        shaper.lineWidth = 1.5;
                        shaper.strokeColor = self->_lineChartPathColor.CGColor;
                        
                        [self.layerArr addObject:shaper];
                        
                        if (!self.isHiddenAnimations) {
                            CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
                            
                            basic.fromValue = @0;
                            basic.toValue = @1;
                            basic.duration =  1;
                            basic.delegate = self;
                            [shaper addAnimation:basic forKey:@"stokentoend"];
                        }
                        [self.BGScrollView.layer addSublayer:shaper];
                        
                        //绘制圆点
                        for (int32_t m=0;m < self->_drawLineValue.count;m++) {
                            CAShapeLayer *roundLayer = [CAShapeLayer layer];
                            UIBezierPath *roundPath = [UIBezierPath bezierPathWithArcCenter:[self->_drawLineValue[m] CGPointValue] radius:2.5 startAngle:M_PI_2 endAngle:M_PI_2 + M_PI * 2 clockwise:YES];
                            roundLayer.path = roundPath.CGPath;
                            roundLayer.fillColor = [UIColor whiteColor].CGColor;
                            roundLayer.strokeColor = self->_lineChartPathColor.CGColor;
                            roundLayer.lineWidth = 1.5;
                            
                            [self.layerArr addObject:roundLayer];
                            [self.BGScrollView.layer addSublayer:roundLayer];
                        }
                        
                    }
                }
                
            }];
            
        }
        
    }
    
    
    self.BGLineScrollView.showViewArr = self.showViewArr;
}


- (void)itemClick:(UITapGestureRecognizer *)sender{
    if ([_delegate respondsToSelector:@selector(columnChart:columnItem:didClickAtIndexRow:)]) {
        [_delegate columnChart:self columnItem:sender.view didClickAtIndexRow:objc_getAssociatedObject(sender.view, "indexPath")];
    }
}

-(void)clear{
    
    
    for (CALayer *lay in self.layerArr) {
        [lay removeAllAnimations];
        [lay removeFromSuperlayer];
    }
    
    for (UIView *subV in self.showViewArr) {
        [subV removeFromSuperview];
    }
    
    [self.layerArr removeAllObjects];
    [self.drawLineValue removeAllObjects];
    
    [self.showViewArr removeAllObjects];
    
    self.BGLineScrollView.isLongPress = NO;
    //线条没有移除
    [self.BGLineScrollView setNeedsDisplay];
    //    for (UIGestureRecognizer *ges in self.BGLineScrollView.gestureRecognizers) {
    //        [self.BGLineScrollView removeGestureRecognizer:ges];
    //    }
    //
    //    [self.BGLineScrollView removeFromSuperview];
    //        self.BGLineScrollView = nil;
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    
    if (flag) {
        
        if (_isShowLineChart) {
            
            for (int32_t m=0;m<_drawLineValue.count;m++) {
                //                NSLog(@"%@",_drawLineValue[m]);
                //                CAShapeLayer *roundLayer = [CAShapeLayer layer];
                //                UIBezierPath *roundPath = [UIBezierPath bezierPathWithArcCenter:[_drawLineValue[m] CGPointValue] radius:3.0 startAngle:M_PI_2 endAngle:M_PI_2 + M_PI * 2 clockwise:YES];
                //                roundLayer.path = roundPath.CGPath;
                //                roundLayer.fillColor = [UIColor whiteColor].CGColor;
                //                roundLayer.strokeColor = _lineChartPathColor.CGColor;
                //                roundLayer.lineWidth = 2.0;
                //
                //                [self.layerArr addObject:roundLayer];
                //                [self.BGScrollView.layer addSublayer:roundLayer];
            }
        }
        
    }
    [self bringSubviewToFront:self.BGLineScrollView];//
    
}


-(void)columnItem:(JHColumnItem *)item didClickAtIndexPath:(JHIndexPath *)indexPath{
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(columnChart:columnItem:didClickAtIndexPath:)]) {
            [_delegate columnChart:self columnItem:item didClickAtIndexPath:indexPath];
        }
        
        if ([_delegate respondsToSelector:@selector(columnChart:columnItem:didClickAtIndexRow:)]) {
            [_delegate columnChart:self columnItem:item didClickAtIndexRow:item.index];
        }
    }
}

#pragma mark - Getter And Setter
-(NSMutableArray *)drawLineValue{
    if (!_drawLineValue) {
        _drawLineValue = [NSMutableArray array];
    }
    return _drawLineValue;
}

-(NSMutableArray *)showViewArr{
    
    
    if (!_showViewArr) {
        _showViewArr = [NSMutableArray array];
    }
    
    return _showViewArr;
    
}

-(NSMutableArray *)layerArr{
    if (!_layerArr) {
        _layerArr = [NSMutableArray array];
    }
    
    return _layerArr;
}


-(UIScrollView *)BGScrollView{
    if (!_BGScrollView) {
        _BGScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _BGScrollView.showsHorizontalScrollIndicator = NO;
        _BGScrollView.backgroundColor = _bgVewBackgoundColor;
        _BGScrollView.scrollEnabled = NO;
        [self addSubview:_BGScrollView];
    }
    
    return _BGScrollView;
}

-(JHScrollView *)BGLineScrollView{
    if (!_BGLineScrollView) {
        
        _BGLineScrollView = [[JHScrollView alloc] initWithFrame:CGRectMake(self.originSize.x, 0, self.width -  self.originSize.x, self.height)];
        _BGLineScrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_BGLineScrollView];
        
        UIPanGestureRecognizer *longPress = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(event_panAction:)];
        longPress.delegate  = self;
        [_BGLineScrollView addGestureRecognizer:longPress];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event_tapAction:)];
        [_BGLineScrollView addGestureRecognizer:tap];
    }
    return _BGLineScrollView;
}
-(NSMutableArray *)yLineDataArr{
    
    
    if (!_yLineDataArr) {
        _yLineDataArr = [NSMutableArray array];
    }
    return _yLineDataArr;
    
}

@end
