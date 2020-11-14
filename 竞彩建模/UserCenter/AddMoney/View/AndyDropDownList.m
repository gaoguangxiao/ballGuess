//
//  AndyDropDownList.m
//  AndyDropDownList
//
//  Created by 933 on 16/1/29.
//  Copyright © 2016年 Andy. All rights reserved.
//

#import "AndyDropDownList.h"

/**
 *  主屏的宽
 */
#define DEF_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

/**
 *  主屏的高
 */
#define DEF_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface AndyDropDownList ()
<UITableViewDataSource,
UITableViewDelegate>

@property(nonatomic,strong)NSArray *arr;
@property(nonatomic,assign)CGFloat rowHeight;   // 行高
@property(nonatomic,strong)UITextField *button;    //从Controller传过来的控制器
@property(nonatomic,strong)UITableView *tableView;
//@property(nonatomic,strong)UIView *bgView;
//@property(nonatomic,strong)UIImageView *arrow;
@property(nonatomic,assign)NSInteger index;    //记录选中行

@end


@implementation AndyDropDownList

-(id)initWithListDataSource:(NSArray *)array
                  rowHeight:(CGFloat)rowHeight
                     indexy:(CGFloat)y
                       view:(UIView *)v
{
    self = [super initWithFrame:CGRectMake(0, y, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT-y)];
    if (self)
    {
        self.arr = array;
        self.rowHeight = rowHeight;
        self.button = (UITextField *)v;
        self.hidden = YES;
    }
    return self;
}
-(UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
-(NSArray *)arr{
    if (!_arr)
    {
        _arr = [[NSArray alloc]init];
    }
    return _arr;
}
-(void)setShowData:(NSArray *)strString{
     self.arr = [NSArray new];
     self.arr = strString;
    
    [_tableView reloadData];
}
/**
 *   显示下拉列表
 */
-(void)showList:(CGFloat)startY
{
    self.hidden = NO;
//    [self addSubview:self.bgView];
    [self addSubview:self.tableView];
    [self.tableView reloadData];
    [UIView animateWithDuration:0.25f animations:^{
        self.tableView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT - startY - 64);
    }];
}
/**
 *  隐藏
 */
-(void)hiddenList
{
    [UIView animateWithDuration:0.25f animations:^{
//        self.bgView.alpha = 0;
        self.tableView.frame = CGRectMake(15, 64, DEF_SCREEN_WIDTH - 30, 0);
    } completion:^(BOOL finished) {
        self.hidden = YES;
//        [_bgView removeFromSuperview];
    }];
}
#pragma mark - UITableViewDelegateAndUITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.arr[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor= K_SubmitTitleColor;

    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
#pragma mark ----------------UITableView  表的选中方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self hiddenList];
    self.index = indexPath.row;
    if ([self.delegate respondsToSelector:@selector(dropDownListParame:andViewAndy:)])
    {
        [self.delegate dropDownListParame:self.arr[indexPath.row]andViewAndy:self];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.rowHeight;
}


@end
