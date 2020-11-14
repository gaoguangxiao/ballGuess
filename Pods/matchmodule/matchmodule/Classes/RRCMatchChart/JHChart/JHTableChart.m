//
//  JHTableChart.m
//  JHChartDemo
//
//  Created by 简豪 on 16/8/24.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHTableChart.h"
#import "JHTableDataRowModel.h"
#import "JHTableRowModel.h"
#import "YBColorConfigure.h"
#import "RRCDeviceConfigure.h"
#import "YBImageConfigure.h"
@interface JHTableChart ()
/** 标题高度被更新之后的高度*/
@property (nonatomic,assign) CGFloat titleUpdateHeight;
@property (nonatomic,assign) CGFloat tableWidth;
@property (nonatomic,assign) CGFloat tableHeight;
@property (nonatomic,assign) CGFloat lastY;
@property (nonatomic,assign) CGFloat bodyHeight;
@property (nonatomic,strong)NSMutableArray * dataModelArr;
@end

@implementation JHTableChart

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        _minHeightItems             = 40;
        _beginSpace                 = 15.0;
        _beginTopMagrin             = 8.0 * Device_Ccale;
        _tableChartTitleItemsHeight = 50.0;
        _lineColor                  = [UIColor darkGrayColor];
        _tableTitleFont             = [UIFont systemFontOfSize:15];
        _bodyTextFont               = [UIFont systemFontOfSize:15];
        _tableTitleColor            = [UIColor darkGrayColor];
        _tableWidth                 = 100;
        _lastY                      = _beginSpace;
        _bodyHeight                 = 0;
        _colTitleColor              = RRCThemeTextColor;
        _bodyTextColor              = RRCThemeTextColor;
        _colTitleSelectBackImage    = RRCF21646Image;
        
    }
    return self;
}

-(void)setBeginSpace:(CGFloat)beginSpace{
    
    _beginSpace = beginSpace;
    _lastY = beginSpace;
    
}
-(void)setBeginTopMagrin:(CGFloat)beginTopMagrin{
    _beginTopMagrin = beginTopMagrin;
}
-(void)setDataArr:(NSArray *)dataArr{
    
    
    _dataArr = dataArr;
    
    _dataModelArr = [NSMutableArray array];
    
    for (NSInteger i = 0; i<_dataArr.count; i++) {
        
        JHTableDataRowModel *model = [JHTableDataRowModel new];
        model.maxCount = 1;
        
        for (id obj in _dataArr[i]) {
            
            if ([obj isKindOfClass:[NSArray class]]) {
                if (model.maxCount<=[obj count]) {
                    model.maxCount = [obj count];
                }
            }
        }
        model.dataArr = dataArr[i];
        
        [_dataModelArr addObject:model];
    }
    
}

/// CoreGraphic 绘图
/// @param rect rect
-(void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    /*        表头         */
    if (_tableTitleString.length>0) {
        [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, _beginSpace +_tableChartTitleItemsHeight) andEndPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace , _beginSpace+_tableChartTitleItemsHeight) andIsDottedLine:NO andColor:_lineColor];
        
        BOOL drawText = true;
        if ([_delegate respondsToSelector:@selector(tableChart:viewForTableHeaderWithContentSize:)]) {
            UIView *header = [_delegate tableChart:self viewForTableHeaderWithContentSize:CGSizeMake(_tableWidth, _tableChartTitleItemsHeight)];
            if (header) {
                header.frame = CGRectMake(_beginSpace+1, _beginSpace+1, _tableWidth-2, _tableChartTitleItemsHeight-2);
                drawText = false;
                [self addSubview:header];
            }
        }
        CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(_tableWidth, _tableChartTitleItemsHeight) textFont:_tableTitleFont.pointSize aimString:_tableTitleString];
        if (drawText) {
            [self drawText:_tableTitleString context:context atPoint:CGRectMake(CGRectGetWidth(self.frame)/2.0 - size.width / 2, _beginSpace + _tableChartTitleItemsHeight/2 - size.height / 2.0, _tableWidth, _tableChartTitleItemsHeight) WithColor:_tableTitleColor font:_tableTitleFont];
        }
        
        _lastY = _beginSpace + _tableChartTitleItemsHeight;
    }
    
    
    /*        绘制列的分割线         */
    self.titleUpdateHeight  = self.colTitleHeight;
    [self drawTitleRect:rect andContext:context];
    
    BOOL hasSetColWidth = 0;
    /*        如果指定了列的宽度         */
    if (_colTitleArr.count == _colWidthArr.count && _colTitleArr.count>0) {
        
        hasSetColWidth = YES;
        
    }else{
        hasSetColWidth = NO;
    }
    
    /*        绘制具体的行数据   i表示第几行 j表示第几列      */
    for (NSInteger i = 0; i<_dataModelArr.count; i++) {
        JHTableDataRowModel *model = _dataModelArr[i];
        CGFloat lastX = _beginSpace;
        CGFloat perItemsHeightByMaxCount = 0;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(tableChart:heightAtRow:)]) {
            CGFloat heightRow = [self.delegate tableChart:self heightAtRow:i];
            if (heightRow > 0) {
                _minHeightItems = heightRow;
            }
        }
        
        //每一个行绘制底部view，用于触发点击
        [self drawViewWithTag:i andContext:context atPoint:CGRectMake(lastX, _lastY, _tableWidth, _minHeightItems)];
        
        
        if (model.dataArr.count == 5) {
            NSString *rowEndItems = [model.dataArr[4] lastObject];
//           5推迟、6"待定章"、7："腰斩章"、8："中断章"
            if ([rowEndItems isEqualToString:@"取消"] || [rowEndItems isEqualToString:@"推迟"]|| [rowEndItems isEqualToString:@"待定"]|| [rowEndItems isEqualToString:@"腰斩"]|| [rowEndItems isEqualToString:@"中断"]) {
                _bodyTextColor = RRCGrayTextColor;
            }else{
                _bodyTextColor = RRCThemeTextColor;
            }
        }
        
        for (NSInteger j = 0; j< model.dataArr.count; j++) {
            id rowItems = model.dataArr[j];
            CGFloat wid = (hasSetColWidth?[_colWidthArr[j] floatValue]:_tableWidth / _colTitleArr.count);
            
            if (j != 0) {
                [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY) andEndPoint:P_M(lastX, _lastY + _minHeightItems) andIsDottedLine:NO andColor:_lineColor];
            }
            
            
            //绘制列数组元素
            if ([rowItems isKindOfClass:[NSArray class]]) {//列元素为数组时
                
                perItemsHeightByMaxCount =  _minHeightItems / [rowItems count];//平均下来
                CGFloat last_y = 0;
                /*       具体某一列有多个元素时       */
                for (NSInteger n = 0; n<[rowItems count]; n++) {
                    //1、获取数组元素每一行的行高
                    if (self.delegate && [self.delegate respondsToSelector:@selector(tableChart:heightForTableRowAtRow:column:andMatchIndex:andTagTitle:)] && [rowItems count] >= 2) {
                        CGFloat heightRow = [self.delegate tableChart:self heightForTableRowAtRow:n column:j andMatchIndex:i andTagTitle:rowItems[n]];
                        if (heightRow > 0) {
                            perItemsHeightByMaxCount = heightRow;
                        }
                    }
                    
                    if (n == 0) {
                        [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY + (n + 1) * perItemsHeightByMaxCount) andEndPoint:P_M(lastX + wid, _lastY + (n + 1) * perItemsHeightByMaxCount) andIsDottedLine:NO andColor:_lineColor];
                    }else if (n != [rowItems count] - 1){
                        [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY + last_y +  perItemsHeightByMaxCount) andEndPoint:P_M(lastX + wid, _lastY + last_y +  perItemsHeightByMaxCount) andIsDottedLine:NO andColor:_lineColor];
                    }
                    
                    BOOL drawText = true;
                    if ([_delegate respondsToSelector:@selector(tableChart:viewForContentAtRow:column:subRow:contentSize:)]) {
                        CGSize contentSize = CGSizeMake(wid - 2, _minHeightItems*model.maxCount/[rowItems count] - 2);
                        
                        UIView *cacheView = [_delegate tableChart:self  viewForContentAtRow:i column:j subRow:n contentSize:contentSize];
                        if (cacheView) {
                            cacheView.frame = CGRectMake(lastX+1, _lastY+2 + n * _minHeightItems*model.maxCount/[rowItems count] , contentSize.width, contentSize.height);
                            drawText = false;
                            [self addSubview:cacheView];
                        }
                    }
                    
                    if (drawText) {
                        //改变字体颜色
                        NSArray *rowArr = [rowItems[n] componentsSeparatedByString:@"|"];
                        if (rowArr.count == 1) {
                            if (j == 4) {//赛果
                                if ([rowItems[n] isEqualToString:@"无"]) {
                                    [self drawText:rowItems[n] context:context atPoint:CGRectMake(lastX, _lastY + last_y, wid, perItemsHeightByMaxCount) WithColor:_bodyTextColor font:_bodyTextFont];
                                }else{
                                    CGFloat imageWidth = 38 * Device_Ccale;
                                    [self drawImageText:rowItems[n] atPoint:CGRectMake(lastX + (wid - imageWidth)/2, _lastY + last_y + (perItemsHeightByMaxCount - imageWidth)/2,imageWidth, imageWidth)];
                                }
                                
                            }else{
                                
                                [self drawText:rowItems[n] context:context atPoint:CGRectMake(lastX , _lastY + last_y , wid, perItemsHeightByMaxCount) WithColor:_bodyTextColor font:_bodyTextFont];
                            }
                        }
                        else if(rowArr.count == 2){
                            NSString *titleColor = rowArr[1];
                            
                            //获取颜色改变颜色
                            UIColor *oddsColor;//初始化无颜色，只有走水，显示颜色
                            NSArray *ya_end_arr = model.dataArr.lastObject;
                            NSString *rowEndItems = @"";
                            if (ya_end_arr.count == 1) {
                                rowEndItems = [model.dataArr.lastObject lastObject];
                            }else if (ya_end_arr.count == 2 && [rowItems count] == 3){
                                if (n == 2) {
                                    rowEndItems = model.dataArr.lastObject[1];
                                }else{
                                    rowEndItems = model.dataArr.lastObject[0];
                                }
                            }else if (ya_end_arr.count == [rowItems count]){//如果是一个选项一种结果，
                                rowEndItems = model.dataArr.lastObject[n];
                            }else{
                                rowEndItems = [model.dataArr.lastObject firstObject];
                            }
                            if ([rowEndItems isEqualToString:@"走"] && [(NSString *)rowArr[0] containsString:@"@"]) {//只有亚指才有走水
                                oddsColor = RRC04BD2CColor;
                            }
                            
                            if ([titleColor integerValue]) {
                                if (!oddsColor) {
                                    oddsColor = RRCHighLightTitleColor;
                                }
                                [self drawText:rowArr[0] context:context atPoint:CGRectMake(lastX , _lastY + last_y , wid, perItemsHeightByMaxCount) WithColor:oddsColor font:[UIFont fontWithName:@"PingFangSC-Semibold" size: 12 * Device_Ccale]];
                            }else{
                                if (oddsColor) {
                                    [self drawText:rowArr[0] context:context atPoint:CGRectMake(lastX , _lastY + last_y , wid, perItemsHeightByMaxCount) WithColor:oddsColor font:[UIFont fontWithName:@"PingFangSC-Semibold" size: 12 * Device_Ccale]];
                                }else{
                                    [self drawText:rowArr[0] context:context atPoint:CGRectMake(lastX , _lastY + last_y , wid, perItemsHeightByMaxCount) WithColor:_bodyTextColor font:_bodyTextFont];
                                }
                                
                            }
                            
                        }
                        
                        last_y += perItemsHeightByMaxCount;
                    }
                    
                    
                }
                
            }
            else{//绘制列元素 非数组
                
                CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, model.maxCount * _minHeightItems) textFont:_bodyTextFont.pointSize aimString:rowItems];
                
                BOOL drawText = true;
                if ([_delegate respondsToSelector:@selector(tableChart:viewForContentAtRow:column:subRow:contentSize:)]) {
                    CGSize contentSize = CGSizeMake(wid - 2, _minHeightItems * model.maxCount - 2);
                    UIView *cacheView = [_delegate tableChart:self  viewForContentAtRow:i column:j subRow:0 contentSize:contentSize];
                    if (cacheView) {
                        cacheView.frame = CGRectMake(lastX+1, _lastY+1, contentSize.width, contentSize.height);
                        drawText = false;
                        [self addSubview:cacheView];
                    }
                    
                }
                if (drawText) {
                    //如果是 分割开的
                    NSArray *rowArr = [rowItems componentsSeparatedByString:@"|"];
                    
                    if (rowArr.count == 2) {
                        UIFont *textFont = j == 0 ? _colTitleFont : _bodyTextFont;
                        size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, self.colTitleHeight) textFont:14 aimString:rowArr[0]];
                        
                        // + wid / 2.0 - size.width / 2
                        [self drawText:rowArr[0] context:context atPoint:CGRectMake(lastX, _lastY + 5, wid, self.colTitleHeight / 2.0) WithColor:_bodyTextColor font:textFont];
                        
                        size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, self.colTitleHeight) textFont:14 aimString:rowArr[1]];
                        //+ wid / 4.0 - size.width / 2.0
                        [self drawText:rowArr[1] context:context atPoint:CGRectMake(lastX , _lastY + self.colTitleHeight / 2.0 + self.colTitleHeight / 4.0, wid, self.colTitleHeight / 2.0) WithColor:_bodyTextColor font:textFont];
                    }
                    else if (rowArr.count >= 3){
                        CGSize firstSize = [self sizeOfStringWithMaxSize:CGSizeMake(wid, 16 * Device_Ccale) textFont:14 * Device_Ccale aimString:rowArr[0]];
                        CGFloat topMagrin = self.beginTopMagrin;//居中显示即可
                        if (self.delegate && [self.delegate respondsToSelector:@selector(tableChart:topMarginAtRow:)]) {
                            topMagrin = [self.delegate tableChart:self topMarginAtRow:i];
                        }
   
                        [self drawText:rowArr[0] context:context atPoint:CGRectMake(lastX, _lastY + topMagrin, wid, firstSize.height) WithColor:_bodyTextColor font:_bodyTextFont];
                        
                        CGSize secondSize = [self sizeOfStringWithMaxSize:CGSizeMake(wid, 16 * Device_Ccale) textFont:14 * Device_Ccale aimString:rowArr[1]];
                        
                        if (rowArr.count == 4 && [(NSString *)rowArr[1] containsString:@":"]) {
                            [self drawText:rowArr[1] context:context atPoint:CGRectMake(lastX , _lastY  + topMagrin + firstSize.height, wid, secondSize.height) WithColor:RRCHighLightTitleColor font:_bodyTextFont];
                        }else{
                            [self drawText:rowArr[1] context:context atPoint:CGRectMake(lastX , _lastY  + topMagrin + firstSize.height , wid, secondSize.height) WithColor:_bodyTextColor font:_bodyTextFont];
                        }
                        
                        
                        size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, self.minHeightItems/3) textFont:14 aimString:rowArr[2]];
                        //+ wid / 4.0 - size.width / 2.0
                        [self drawText:rowArr[2] context:context atPoint:CGRectMake(lastX , _lastY  + topMagrin + firstSize.height + secondSize.height, wid, size.height) WithColor:_bodyTextColor font:_bodyTextFont];
                        
                        //主V客 擅长联赛标签为 1时，出现擅长标签
                        if (j == 1 && rowArr.count == 4) {
                            if ([rowArr.lastObject integerValue]) {
                                [self drawImageView:@"擅长联赛" andContext:context atRect:CGRectMake(lastX , _lastY, 29 * Device_Ccale, 29 * Device_Ccale)];
                            }
                        }
                        
                    }
                    else{
                        //                      //第0行高度定制过
                        if (i == 0 && j == 0  && self.titleUpdateHeight != self.colTitleHeight) {
                            [self drawText:rowItems context:context atPoint:CGRectMake(lastX, self.titleUpdateHeight, wid, _minHeightItems - 16 * Device_Ccale) WithColor:_colTitleColor font:_colTitleFont];
                        }else if (j == 0 && model.dataArr.count != 5){
                            [self drawText:rowItems context:context atPoint:CGRectMake(lastX, _lastY, wid, _minHeightItems) WithColor:_colTitleColor font:_colTitleFont];
                        }else{
                            [self drawText:rowItems context:context atPoint:CGRectMake(lastX, _lastY, wid, _minHeightItems) WithColor:_bodyTextColor font:_bodyTextFont];
                        }
                        
                        
                    }
                }
            }
            lastX += wid;
        }
        //        NSLog(@"绘制的横线位置：%f",_lastY +  onceMatchHeight);
        if (i != _dataModelArr.count - 1) {
            [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, _lastY +  _minHeightItems) andEndPoint:P_M(_beginSpace + _tableWidth, _lastY +  _minHeightItems) andIsDottedLine:NO andColor:_lineColor];
        }
        
        
        _lastY += _minHeightItems;
    }
    
    
}

#pragma mark - 绘制标题
- (void)drawTitleRect:(CGRect)rect andContext:(CGContextRef)context{
    if (_colTitleArr.count>0) {
        
        BOOL hasSetColWidth = 0;
        /*        如果指定了列的宽度         */
        if (_colTitleArr.count == _colWidthArr.count) {
            hasSetColWidth = YES;
        }else{
            hasSetColWidth = NO;
        }
        
        CGFloat lastX = _beginSpace;
        //属性头绘制
        for (NSInteger i = 0; i<_colTitleArr.count; i++) {
            CGFloat wid = (hasSetColWidth?[_colWidthArr[i] floatValue]:_tableWidth / _colTitleArr.count);
            CGFloat lastWid = ((hasSetColWidth && i != 0 )?[_colWidthArr[i - 1] floatValue]:_tableWidth / _colTitleArr.count);
            
            CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, self.colTitleHeight) textFont:self.colTitleFont.pointSize aimString:_colTitleArr[i]];
            
            BOOL drawText = true;
            
            if ([_delegate respondsToSelector:@selector(tableChart:viewForPropertyAtColumn:contentSize:)]) {
                UIView *proView = [_delegate tableChart:self viewForPropertyAtColumn:i contentSize:CGSizeMake(wid-2, self.colTitleHeight-2)];
                if (proView) {
                    proView.frame = CGRectMake(lastX+1, _lastY+1, wid-2, self.colTitleHeight-2);
                    drawText = false;
                    [self addSubview:proView];
                }
            }
            
            if (!drawText) {
                lastX += wid;
                if (i==_colTitleArr.count - 1) {
                    
                }else{
                    //绘制列分割线
                    [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY) andEndPoint:P_M(lastX, _lastY + _bodyHeight) andIsDottedLine:NO andColor:_lineColor];
                }
                continue;
            }
            
            //绘制标题的font
            UIFont *colomnFont = self.colTitleFont;
            if (self.delegate && [self.delegate respondsToSelector:@selector(fontTableChart:colorAtRow:andAtcolumn:)]) {
                UIFont *_font = [self.delegate fontTableChart:self colorAtRow:i andAtcolumn:0];
                if (_font) {
                    colomnFont = _font;
                }
            }
            
            if ([_colTitleArr[i] isKindOfClass:[NSString class]]) {
                NSArray *firArr = [_colTitleArr[i] componentsSeparatedByString:@"|"];
                if (firArr.count == 2) {
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(tableChart:heightForTableRowAtRow:column:andMatchIndex:andTagTitle:)] && [firArr count] >= 2) {
                        CGFloat heightRow = [self.delegate tableChart:self heightForTableRowAtRow:i column:0 andMatchIndex:i andTagTitle:@""];
                        if (heightRow > 0) {
                            self.titleUpdateHeight = heightRow;
                        }
                    }
                    size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, self.colTitleHeight) textFont:14 aimString:firArr[0]];
                    
                    [self drawText:firArr[0] context:context atPoint:CGRectMake(lastX , _lastY + _beginTopMagrin, wid, self.titleUpdateHeight / 2.0) WithColor:[self colorForColTitle:i] font:colomnFont];
                    
                    size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, self.colTitleHeight) textFont:14 aimString:firArr[1]];
                    
                    //拉去
                    UIFont *_lastFont = colomnFont;
                    if (self.delegate && [self.delegate respondsToSelector:@selector(fontTableChart:colorAtRow:andAtcolumn:)]) {
                        _lastFont = [self.delegate fontTableChart:self colorAtRow:i andAtcolumn:1];
                    }
                    [self drawText:firArr[1] context:context atPoint:CGRectMake(lastX, _lastY + self.titleUpdateHeight / 2.0, wid, self.titleUpdateHeight/2) WithColor:[self colorForColTitle:i] font:_lastFont];
                }
                else if (firArr.count == 3){
                    // 主队 VS 客队 、添加统计
                    CGFloat itemWidth =  i == _colTitleArr.count - 1 ? wid:wid - 1;
                    
                    if (self.isAllowDeleteChart && i == _colTitleArr.count - 1) {
                        [self drawDeleteBtn:@"" andRect:CGRectMake(lastX + wid, _lastY, self.colTitleHeight, self.colTitleHeight)];
                    }
                    if (self.isAllowStatisticalChart && _colTitleArr.count - 1) {
                        [self drawBtn:@"统计" andRect:CGRectMake(lastX + wid, _lastY, itemWidth, self.colTitleHeight) andFont:[UIFont systemFontOfSize:11 * Device_Ccale] andbackColor:RRC04BD2CColor];
                    }
                    
                    [self drawText:firArr[0] context:context atPoint:CGRectMake(lastX , _lastY + 4 * Device_Ccale, itemWidth, self.colTitleHeight/3 - 2) WithColor:[self colorForColTitle:i] font:colomnFont];
                    [self drawText:firArr[1] context:context atPoint:CGRectMake(lastX, _lastY + self.colTitleHeight/3 + 3 * Device_Ccale, itemWidth, self.colTitleHeight/3 - 6) WithColor:[self colorForColTitle:i] font:colomnFont];
                    [self drawText:firArr[2] context:context atPoint:CGRectMake(lastX, _lastY + self.colTitleHeight/3 * 2, itemWidth, self.colTitleHeight/3 - 6) WithColor:[self colorForColTitle:i] font:colomnFont];
                }
                else{//胜/平/负 | 1.3 |  选中状态 | 是否能选择 | 是够赔率低 四个元素
                    
                    if (self.isAllowDeleteChart && _colTitleArr.count == 3 && i == 2) {
                        
                        [self drawDeleteBtn:@"" andRect:CGRectMake(lastX + wid, _lastY, self.colTitleHeight, self.colTitleHeight)];
                        
                        [self drawTitleText:_colTitleArr[i] atPoint:CGRectMake(lastX + 12 * Device_Ccale, _lastY, wid - 12 * Device_Ccale, self.colTitleHeight) WithColor:[self colorForColTitle:i] font:self.colTitleFont];
                    }else{
                        [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX, _lastY, wid, self.colTitleHeight) WithColor:[self colorForColTitle:i] font:self.colTitleFont];
                    }
                    
                    if (self.isAllowStatisticalChart && _colTitleArr.count - 1 && i == 2) {
                        [self drawBtn:@"统计" andRect:CGRectMake(lastX + wid, _lastY, wid, self.colTitleHeight) andFont:[UIFont systemFontOfSize:11 * Device_Ccale] andbackColor:RRC04BD2CColor];
                    }
                    
                }
            }
            else if([_colTitleArr[i] isKindOfClass:[JHTableRowModel class]]){
                JHTableRowModel *titleRowModel = _colTitleArr[i];
                if ([titleRowModel.ball_str isEqualToString:@"无"] || [titleRowModel.ball_num isEqualToString:@"无"]) {//【胜平负 | 数字 | 选中状态 | 是否可选择 | 赔率】五个元素
                    if (self.isAllowUserInteraction) {
                        CGFloat itemWidth =  i == _colTitleArr.count - 1 ? wid:wid - 1;
                        [self drawImageView:@"不能选择" andContext:context atRect:CGRectMake(lastX, _lastY, itemWidth, self.colTitleHeight - 2)];
                    }
                    [self drawText:@"无" context:context atPoint:CGRectMake(lastX , _lastY, wid, self.colTitleHeight) WithColor:RRCGrayTextColor font:self.colTitleFont];
                }else{
                    if (self.isAllowUserInteraction) {
                        CGFloat itemWidth =  i == _colTitleArr.count - 1 ? wid:wid - 1;
                        [self drawUserBtntag:i andRect:CGRectMake(lastX, _lastY, itemWidth, self.colTitleHeight - 2) disEnableUser:titleRowModel.unitDisTouch andChoseState:titleRowModel.unitSelect andFlagState:titleRowModel.unitbackImageisHidden];
                    }
                    
                    [self drawText:titleRowModel.ball_str context:context atPoint:CGRectMake(lastX , _lastY + 8, wid, self.colTitleHeight/2 - 8) WithColor:[self colorSelectChose:titleRowModel.unitSelect andOddsFlag:titleRowModel.unitbackImageisHidden] font:self.colTitleFont];
                    [self drawText:titleRowModel.ball_num context:context atPoint:CGRectMake(lastX, _lastY + self.colTitleHeight/2, wid, self.colTitleHeight/2 - 8) WithColor:[self colorSelectChose:titleRowModel.unitSelect andOddsFlag:titleRowModel.unitbackImageisHidden] font:self.colTitleFont];
                    
                }
            }
            lastX += wid;
            if (i==_colTitleArr.count - 1) {
                
            }else{
                [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY) andEndPoint:P_M(lastX, _lastY + self.colTitleHeight) andIsDottedLine:NO andColor:_lineColor];
            }
            
            //行名分割线
            CGFloat widthRow= 0;
            if (self.delegate && [self.delegate respondsToSelector:@selector(tableChart:widthForTableRowAtcolumn:)]){
                widthRow = [self.delegate tableChart:self widthForTableRowAtcolumn:i];
                if (i == 0) {
                    if (widthRow > 0) {
                        [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, self.titleUpdateHeight) andEndPoint:P_M(_beginSpace + widthRow, self.titleUpdateHeight) andIsDottedLine:NO andColor:_lineColor];
                    }else{
                        [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, self.colTitleHeight) andEndPoint:P_M(_beginSpace + _tableWidth, self.colTitleHeight) andIsDottedLine:NO andColor:_lineColor];
                    }
                }else{
                    [self drawLineWithContext:context andStarPoint:P_M(_beginSpace + lastWid, self.colTitleHeight) andEndPoint:P_M(_beginSpace + _tableWidth, self.colTitleHeight) andIsDottedLine:NO andColor:_lineColor];
                }
            }else{
                [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, _lastY) andEndPoint:P_M(_beginSpace + _tableWidth, _lastY ) andIsDottedLine:NO andColor:_lineColor];
            }
        }
        _lastY += self.colTitleHeight;
    }
}

/**
 *  绘图前数据构建
 */
- (void)configBaseData{
    _tableWidth = CGRectGetWidth(self.frame) - _beginSpace * 2;
    
    [self configColWidthArr];
    [self countTableHeight];
    [self clear];
}


/**
 *  重构列数据
 */
- (void)configColWidthArr{
    CGFloat wid = 0;
    if (_colTitleArr.count>0&&_colTitleArr.count == _colWidthArr.count) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 0; i<_colWidthArr.count; i++) {
            
            if (wid>_tableWidth) {
                arr = nil;
            }else{
                if (i==_colWidthArr.count-1) {
                    
                    [arr addObject:[NSNumber numberWithFloat:(_tableWidth - wid)]];
                }else
                    [arr addObject:_colWidthArr[i]];
                
            }
            wid += [_colWidthArr[i] floatValue];
        }
        _colWidthArr = [arr copy];
        
    }else{
        _colWidthArr = nil;
    }
    
}

/**
 *  计算表格总高度和表格体高度
 */
- (void)countTableHeight{
    
    NSInteger rowCount = _dataArr.count;
    _bodyHeight = rowCount * _minHeightItems  + (_colTitleArr.count>0?self.colTitleHeight:0);
    _tableHeight = 0;
    _tableHeight += (_tableTitleString.length>0?_tableChartTitleItemsHeight:0) + _bodyHeight;
}

/**
 *  绘制图形
 */
-(void)showAnimation{
    [self configBaseData];
    [self setNeedsDisplay];
}

/**
 *  返回该图表所需的高度
 *
 *  @return 高度
 */
- (CGFloat)heightFromThisDataSource{
    [self countTableHeight];
    return _tableHeight + _beginSpace * 2;
    
}

#pragma mark - 数据行高及字体颜色处理
- (UIFont *)colTitleFont{
    if (!_colTitleFont) {
        _colTitleFont = self.bodyTextFont;
    }
    return _colTitleFont;
}

- (CGFloat)colTitleHeight{
    return _colTitleHeight > 0 ? _colTitleHeight : self.minHeightItems;
}

- (UIColor *)colorForColTitle:(NSInteger)colTitleIndex{
    UIColor *defaultTitleColor = self.colTitleColor ?: self.bodyTextColor;
    if (self.colTitleColorArr) {
        if (colTitleIndex < self.colTitleColorArr.count) {
            if (![self.colTitleColorArr[colTitleIndex] isKindOfClass:[UIColor class]]) {
                return defaultTitleColor;
            }
            return self.colTitleColorArr[colTitleIndex];
        }
    }
    return defaultTitleColor;
}

- (UIColor *)colorForColBody:(NSInteger)colIndex{
    if (self.bodyTextColorArr) {
        if (colIndex < self.bodyTextColorArr.count) {
            if (![self.bodyTextColorArr[colIndex] isKindOfClass:[UIColor class]]) {
                return self.bodyTextColor;
            }
            return self.bodyTextColorArr[colIndex];
        }
    }
    return self.bodyTextColor;
}

//字体是否选中【选中白色、未选中黑色】字体是否能够点击【能，黑色，不能黑色】
- (UIColor *)colorSelectChose:(NSInteger )choseNum andOddsFlag:(NSInteger)OddsFlag{
    if (OddsFlag) {
        if (choseNum) {
            return RRCWhiteTextColor;
        }else{
            return RRCThemeTextColor;
        }
    }else{
        return RRCThemeTextColor;
    }
}

//按钮背景 图片不能操作，但是可以触摸 imageBtnEnable控制gui的z值，能不能触摸，1不可触摸
-(void)drawUserBtntag:(NSInteger)tag andRect:(CGRect)rect disEnableUser:(NSInteger )imagedisEnable andChoseState:(NSInteger )choseState andFlagState:(NSInteger )flagState{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btn.frame = rect;
    btn.tag   = tag;
    if (flagState) {
        if (imagedisEnable == 1) {
            btn.userInteractionEnabled = NO;
            [btn setImage:[UIImage imageNamed:@"不能选择"] forState:UIControlStateNormal];
        }else{
            if (choseState) {
                [btn setBackgroundImage:self.colTitleSelectBackImage forState:UIControlStateNormal];
            }else{
                [btn setBackgroundImage:RRCFFFFFFImage forState:UIControlStateNormal];
            }
        }
    }else{
        [btn setImage:[UIImage imageNamed:@"不能选择"] forState:UIControlStateNormal];
    }
    
    [btn addTarget:self action:@selector(chartSelectItem:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

//按钮图片 白色 和 主题颜色
-(void)drawBtnRect:(CGRect )rect WithBtnBacKColor:(UIColor *)color enebleUser:(NSString *)imageBtnEnable{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btn.frame = rect;
    btn.userInteractionEnabled = NO;
    [btn setImage:[UIImage imageNamed:@"不能选择"] forState:UIControlStateNormal];
    [self addSubview:btn];
}

-(void)drawDeleteBtn:(NSString *)deleteImageName andRect:(CGRect)rect{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    CGFloat deleteWidth = rect.size.width;
    btn.frame = CGRectMake(rect.origin.x - deleteWidth, rect.origin.y + (rect.size.height - deleteWidth)/2, deleteWidth, deleteWidth);
    [btn setImage:[UIImage imageNamed:@"红删除"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(chartDelete:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}
-(void)chartSelectItem:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableSelectChart:viewForContentAtRow:column:)]) {
        //获取此时点击的行
        [self.delegate tableSelectChart:self viewForContentAtRow:self.tag column:sender.tag];
    }
}
-(void)chartDelete:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableChartDelete:)]) {
        [self.delegate tableChartDelete:self];
    }
}
///清空表格
-(void)clear{
    //移除视图上的所有子视图
    for (UIView *sub in self.subviews) {
        [sub removeFromSuperview];
    }
}
#pragma mark - Event Response
-(void)chartViewTapEvent:(NSInteger)viewTag{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tablewChart:ViewForTapRow:)]) {
        [self.delegate tablewChart:self ViewForTapRow:viewTag];
    }
}
-(void)chartViewButtonEvent:(NSInteger)buttonTag{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tablewChart:ViewForButtonRow:)]) {
        [self.delegate tablewChart:self ViewForButtonRow:buttonTag];
    }
}
@end
