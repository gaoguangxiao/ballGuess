//
//  RRCSegmentView.m
//  MXSFramework
//
//  Created by 人人彩 on 2019/9/27.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "RRCSegmentView.h"
#import "YBColorConfigure.h"
#import "RRCDeviceConfigure.h"
#import "Masonry.h"

#define BaseBtnTag 500
#define BaseLineTag 600
@interface RRCSegmentView ()

@property (nonatomic,strong) UIColor *backSealectColor;//背景颜色
@property (nonatomic,strong) UIColor *normalColor;
@property (nonatomic,strong) UIColor *selectColor;
@end
@implementation RRCSegmentView
{
    UIButton *_lastBtn;
}

-(instancetype)initWithFrame:(CGRect)frame Titles:(NSArray *)titleArr{
    if (self = [super initWithFrame:frame]) {
        _normalColor = RRCHighLightTitleColor;
        _selectColor = RRCUnitViewColor;
        _backNormalColor = RRCUnitViewColor;
        _backSealectColor = RRCHighLightTitleColor;
        [self initSegment:titleArr];
    }
    return self;
}

-(void)initSegment:(NSArray *)titlesArr{
    self.titleArr = titlesArr;
    self.layer.cornerRadius = 3*Device_Ccale;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = RRCBorderViewColor.CGColor;
    self.layer.borderWidth = .5*Device_Ccale;
    
    float btnWidth = self.frame.size.width/titlesArr.count;
    for (int i = 0; i < titlesArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = self.backNormalColor;
        btn.tag = BaseBtnTag + i;
        btn.frame = CGRectMake(btnWidth *i, 0, btnWidth, self.frame.size.height);
        [btn setTitle:titlesArr[i] forState:0];
        btn.titleLabel.font = [UIFont systemFontOfSize:12*Device_Ccale];
        [btn setTitleColor:self.normalColor forState:0];
        [btn setTitleColor:self.selectColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        if (i < titlesArr.count - 1 && titlesArr.count > 2) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(btn.frame.size.width - .5*Device_Ccale, 0, .5, self.frame.size.height)];
            lineView.backgroundColor = RRCThemeViewColor;
            lineView.tag = BaseLineTag + i;
            [btn addSubview:lineView];
        }
    }
    [self btnAction:(UIButton *)[self viewWithTag:BaseBtnTag]];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    for (int i = 0; i< self.titleArr.count; i++) {
        UIButton *btn = [self viewWithTag:BaseBtnTag + i];
        if (_lastBtn == btn) {
            btn.backgroundColor = self.backSealectColor;
        }else{
            btn.backgroundColor = self.backNormalColor;
        }
    }
}

-(void)setBordeColor:(UIColor *)bordeColor{
    _bordeColor = bordeColor;
    self.layer.borderColor = bordeColor.CGColor;
    for (int i = 0; i< self.titleArr.count - 1; i++) {
        UIView *lineView = [self viewWithTag:BaseLineTag + i];
        lineView.backgroundColor = bordeColor;
    }
}

-(void)setTitleFont:(float)titleFont{
    _titleFont = titleFont;
    for (int i = 0; i< self.titleArr.count; i++) {
        UIButton *btn = [self viewWithTag:BaseBtnTag + i];
        btn.titleLabel.font = [UIFont systemFontOfSize:titleFont];
    }
}

-(void)setNormalColor:(UIColor *)normalColor{
    _normalColor = normalColor;
    for (int i = 0; i< self.titleArr.count; i++) {
        UIButton *btn = [self viewWithTag:BaseBtnTag + i];
        [btn setTitleColor:normalColor forState:0];
    }
}

-(void)setSelectColor:(UIColor *)selectColor{
    _selectColor = selectColor;
    for (int i = 0; i< self.titleArr.count; i++) {
        UIButton *btn = [self viewWithTag:BaseBtnTag + i];
        [btn setTitleColor:selectColor forState:UIControlStateSelected];
    }
}

-(void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex = selectIndex;
    UIButton *btn = (UIButton *)[self viewWithTag:selectIndex + BaseBtnTag];
    if (btn.selected) {
        return;
    }
    btn.selected = !btn.selected;
    btn.backgroundColor = self.backSealectColor;
    _lastBtn.backgroundColor = self.backNormalColor;
    _lastBtn.selected = NO;
    _lastBtn = btn;
//    [self btnAction:(UIButton *)[self viewWithTag:selectIndex + BaseBtnTag]];
}

-(void)btnAction:(UIButton *)btn{
    if (btn.selected) {
        return;
    }
    btn.selected = !btn.selected;
    btn.backgroundColor = self.backSealectColor;
    _lastBtn.backgroundColor = self.backNormalColor;
    _lastBtn.selected = NO;
    _lastBtn = btn;
    _selectIndex = btn.tag - BaseBtnTag;
    if ([self.segmentDelegate respondsToSelector:@selector(segmentSelect:)]) {
        [self.segmentDelegate segmentSelect:_selectIndex];
    }
}

-(void)setBackSealectColor:(UIColor *)backSealectColor{
    _backSealectColor = backSealectColor;
    _lastBtn.backgroundColor = backSealectColor;
}

@end
