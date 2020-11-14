//
//  JHTableChart.h
//  JHChartDemo
//
//  Created by 简豪 on 16/8/24.
//  Copyright © 2016年 JH. All rights reserved.
//
/************************************************************
 *                                                           *
 *                                                           *
 表格
 *                                                           *
 *                                                           *
 ************************************************************/


#import "JHChart.h"
@class JHTableChart;
@protocol JHTableChartDelegate<NSObject>
@optional
///具体的表格数据填充内容 （不包含表头和属性解释行）
- (UIView *)tableChart:(JHTableChart *)chart viewForContentAtRow:(NSInteger)row column:(NSInteger)column subRow:(NSInteger)subRow contentSize:(CGSize)contentSize;
- (UIView *)tableChart:(JHTableChart *)chart viewForPropertyAtColumn:(NSInteger)column contentSize:(CGSize)contentSize;
- (UIView *)tableChart:(JHTableChart *)chart viewForTableHeaderWithContentSize:(CGSize)contentSize;

/**
 每个单元高度
 
 @param chart <#chart description#>
 @param row <#row description#>
 @param column <#column description#>
 @param matchIndex <#matchIndex description#>
 @param titleTag <#titleTag description#>
 @return <#return value description#>
 */
-(CGFloat)tableChart:(JHTableChart *)chart heightForTableRowAtRow:(NSInteger)row column:(NSInteger)column andMatchIndex:(NSInteger)matchIndex andTagTitle:(NSString *)titleTag;

/**
 单行的高度，类似：- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

 @param chart <#chart description#>
 @param row <#row description#>
 @return <#return value description#>
 */
- (CGFloat)tableChart:(JHTableChart *)chart heightAtRow:(NSInteger)row;

//返回title的颜色 row为0 1 2 column，默认chart.coltitlt
- (UIFont *)fontTableChart:(JHTableChart *)chart colorAtRow:(NSInteger)row andAtcolumn:(NSInteger)column;//每场比赛的颜色

- (CGFloat)tableChart:(JHTableChart *)chart topMarginAtRow:(NSInteger)row;

- (CGFloat)tableChart:(JHTableChart *)chart widthForTableRowAtcolumn:(NSInteger)column;

- (void)tableSelectChart:(JHTableChart *)chart viewForContentAtRow:(NSInteger)row column:(NSInteger)column;

- (void)tableChartDelete:(JHTableChart *)chart;

- (void)tablewChart:(JHTableChart *)chart ViewForTapRow:(NSInteger)row;

- (void)tablewChart:(JHTableChart *)chart ViewForButtonRow:(NSInteger)row;
@end
@interface JHTableChart : JHChart
/**
 *  Table name, if it is empty, does not display a table name
 */
@property (nonatomic, copy) NSString * tableTitleString;

/**
 *  Table header row height, default 50
 */
@property (nonatomic, assign) CGFloat tableChartTitleItemsHeight;


/**
 *  Table header text font size (default 15), color (default depth)
 */
@property (nonatomic, strong) UIFont * tableTitleFont;
@property (nonatomic, strong) UIColor * tableTitleColor;


@property (nonatomic, assign)BOOL isAllowUserInteraction;

/**
 是否允许删除表，为YES，表头会出现删除按钮
 */
@property (nonatomic, assign)BOOL isAllowDeleteChart;

/**
 是否允许对此表进行统计
 */
@property (nonatomic, assign)BOOL isAllowStatisticalChart;

/**
 *  Table line color
 */
@property (nonatomic, strong) UIColor  * lineColor;


/**
 *  Data Source Arrays
 */
@property (nonatomic, strong) NSArray * dataArr;

/**
 *  Width of each column
 */
@property (nonatomic, strong) NSArray * colWidthArr;

/**
 * height of each row
 */
@property (nonatomic, strong) NSArray * rowHeightArr;

/**
 *  The smallest line is high, the default is 50
 */
@property (nonatomic, assign) CGFloat minHeightItems;

/**
 *  Table data font , default : [UIFont systemFontOfSize:15]
 */
@property (nonatomic, strong) UIFont * bodyTextFont;

/**
 *  Table data display color
 */
@property (nonatomic, strong) UIColor * bodyTextColor;

/**
 *  Color of each column data, use 'bodyTextColor' instead if you want to display only one color
 */
@property (nonatomic, strong) NSArray * bodyTextColorArr;

/**
 *  The column header font, equals to 'bodyTextFont' if it's set to nil
 */
@property (nonatomic, strong) UIFont * colTitleFont;
/**
 *  The column header name, the first column horizontal statement, need to use | segmentation
 */
@property (nonatomic, strong) NSArray * colTitleArr;

/**
 *  The column header color, use 'bodyTextColor' instead if header and body are the same
 */
@property (nonatomic, strong) UIColor * colTitleColor;

/**选中背景 */
@property (nonatomic, strong) UIImage * colTitleSelectBackImage;
/**
 *  Color of each column header, use 'colTitleColor' instead if you want to display only one color
 */
@property (nonatomic, strong) NSArray * colTitleColorArr;

/**
 *  The column header height, use 'minHeightItems' instead if it's set to 0
 */
@property (nonatomic, assign) CGFloat colTitleHeight;

/**
 *  Offset value of start point
 */
@property (nonatomic, assign) CGFloat beginSpace;

/**
 * offset value of y start point
 */
@property (nonatomic, assign) CGFloat beginTopMagrin;

@property (nonatomic , weak)id <JHTableChartDelegate> delegate;

/**
 *  According to the current data source to determine the desired table view
 */
- (CGFloat)heightFromThisDataSource;

@end
