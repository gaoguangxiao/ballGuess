//
//  RRCView.m
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/11/27.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "RRCView.h"

@interface RRCView ()


@end

@implementation RRCView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setViewColor];
        [self setUpView];
    }
    return self;
}

#pragma mark - View
-(void)layoutSubviews{
    [super layoutSubviews];
//    [self setViewColor];
}


-(void)setUpView{
    
}

-(void)setViewColor{
   
    if (self.backViewColors) {
        self.backgroundColor = RRCViewCOLOR(self.backViewColors);
    }else{
        self.backgroundColor = RRCUnitViewColor;
    }
}

#pragma mark - Other
-(void)loadDefaultZeroViewText:(NSString *)text andImageName:(NSString *)imageName{
    self.defaultPageView = [[RRCNetFailView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height)];
    RRCNoDataModel *userExitModel = [RRCNoDataModel new];
    userExitModel.noDataType = RRCEmptyTypeImageAndText;
    userExitModel.text = text;
    userExitModel.imageName = imageName;
    userExitModel.emptyContentHeight = self.frame.size.height;
    userExitModel.topMargin = 6*Device_Ccale;
    [self.defaultPageView alertViewModel:userExitModel withY:0 reloadBtn:^(UIButton * _Nonnull btnBlock) {

    }];
    [self addSubview:self.defaultPageView];
}

-(void)cancleLoadDefaultZero{
    
    [self.defaultPageView hiddenNetFailView];
        
}

#pragma mark - Getter
-(RRCNetFailView *)defaultPageView{
    if (!_defaultPageView) {
        _defaultPageView = [[RRCNetFailView alloc]initWithFrame:self.frame];
    }
    return _defaultPageView;
}
@end
