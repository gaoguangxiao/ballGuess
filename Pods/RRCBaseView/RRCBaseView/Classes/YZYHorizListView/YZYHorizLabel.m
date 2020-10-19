//
//  YZYHorizView.m
//  AutoScrollDemo
//
//  Created by gaoguangxiao on 2019/6/20.
//  Copyright © 2019 YZY. All rights reserved.
//

#import "YZYHorizLabel.h"
#import "YZYHorizListView.h"
#import <Masonry/Masonry.h>
static NSString *const kCellIdentifier = @"HorizCellIdentifier";
@interface YZYHorizLabel ()<YZYHorizListViewDelegate>
{
    CGFloat _textWidth;
}
//@property (nonatomic, strong) 
@property (nonatomic, strong) YZYHorizListView *horizListView;
@property (nonatomic, strong) NSMutableArray *broadcastArray;
@end

@implementation YZYHorizLabel

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    
    self.separationMargin = 10;//默认间距10
    
    self.horizListView = [[YZYHorizListView alloc] initWithFrame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview: _horizListView];
    
    [self.horizListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self);
    }];
    self.horizListView.listViewDelegate = self;
    [self.horizListView.collectionView registerClass: [UICollectionViewCell class] forCellWithReuseIdentifier: kCellIdentifier];
    
}

-(void)setSeparationMargin:(CGFloat)separationMargin{
    _separationMargin = separationMargin;
}

-(void)destructionRunlbel{
    [self.horizListView stopScroll];
}

-(void)startRunlbel{
    [self.horizListView startScroll];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}
-(void)setText:(NSString *)text andLastOffx:(CGFloat)offx{
    
    
    
    //计算text的宽度，如果宽度不够就不滚动
    CGSize t_size = [text boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:self.font.pointSize]} context:nil].size;

    _textWidth = t_size.width;
    [self.broadcastArray removeAllObjects];
    //如果 文本宽度 大于 控件宽度，跑马灯效果，cell的宽度为_textWidth
    if (_textWidth > self.frame.size.width) {
        [self.broadcastArray addObject:text];
        [self.broadcastArray addObject:text];

        self.horizListView.autoScroll = YES;
        [self.horizListView.collectionView reloadData];
        //滚动距离延续上次的
        self.horizListView.collectionView.contentOffset = CGPointMake(offx, self.horizListView.collectionView.contentOffset.y);
    }else{
        //小于控件宽度，适应宽度
        _textWidth = self.frame.size.width;
        
        [self.broadcastArray addObject:text];
        [self.horizListView.collectionView reloadData];
        self.horizListView.collectionView.contentOffset = CGPointMake(0, self.horizListView.collectionView.contentOffset.y);
    }
}

#pragma mark --- YZYHorizListViewDelegate
- (NSInteger)numberOfItemsInHorizListView:(YZYHorizListView *)listView {
    return _broadcastArray.count;
}

- (CGSize)horizListView:(YZYHorizListView *)listView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(_textWidth, self.horizListView.frame.size.height);
}

-(CGFloat)horizListView:(YZYHorizListView *)listView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return self.separationMargin;
}

- (UICollectionViewCell *)horizListView:(YZYHorizListView *)listView collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: kCellIdentifier forIndexPath: indexPath];
    
    NSInteger tag = 1008611;
    [[cell viewWithTag: tag] removeFromSuperview];
    
    UILabel *label = [[UILabel alloc] initWithFrame: cell.bounds];
    [cell addSubview: label];
    label.textColor = self.textColor;
    label.textAlignment = self.textAlignment;
    label.font = self.font;
    label.tag = tag;
    [label setText: _broadcastArray[indexPath.item]];
    
    return cell;
}

-(void)horizListViewRunScollerview:(CGPoint)contentOffset{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textRunviewDistance:)]) {
        [self.delegate textRunviewDistance:contentOffset.x];
    }
}

-(NSMutableArray *)broadcastArray{
    if (!_broadcastArray) {
        _broadcastArray = [NSMutableArray new];
    }
    return _broadcastArray;
}

@end
