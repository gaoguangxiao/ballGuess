//
//  AndyDropDownList.h
//  AndyDropDownList
//
//  Created by 933 on 16/1/29.
//  Copyright © 2016年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AndyDropDownList;
@protocol AndyDropDownDelegate <NSObject>

/**
 *  代理
 */
-(void)dropDownListParame:(NSString *)aStr andViewAndy:(AndyDropDownList *)andyDropDownList;

@end

@interface AndyDropDownList : UIView

/**
 *  下拉列表
 *  @param array       数据源
 *  @param rowHeight   行高
 *  @param v           控制器>>>可根据需求修改
 */
-(id)initWithListDataSource:(NSArray *)array
                  rowHeight:(CGFloat)rowHeight
                     indexy:(CGFloat)y
                       view:(UIView *)v;

/**
 *  设置代理
 */
@property(nonatomic,assign)id<AndyDropDownDelegate>delegate;

-(void)setShowData:(NSArray *)strString;
/**
 *   显示下拉列表
 */
-(void)showList:(CGFloat)startY;
/**
 *   隐藏
 */
-(void)hiddenList;
@end
