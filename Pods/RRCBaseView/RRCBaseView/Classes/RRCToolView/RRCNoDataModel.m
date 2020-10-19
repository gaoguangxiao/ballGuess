//
//  RRCNoDatabgView.m
//  MXSFramework
//
//  Created by renrencai on 2019/4/2.
//  Copyright © 2019年 MXS. All rights reserved.
//

#import "RRCNoDataModel.h"
#import "YBColorConfigure.h"
#import "RRCDeviceConfigure.h"

@implementation RRCNoDataModel

-(instancetype)init{
    if (self = [super init]) {
        
        _topMargin = -60;
        _emptyContentHeight = 300;
        _emptyContentWidth  = kScreenWidth;
        _backViewColor      = RRCUnitViewColor;
        
        _buttonWidth = 141 * Device_Ccale;
        _buttonHeight = 40 * Device_Ccale;
    }
    return self;
}
@end
