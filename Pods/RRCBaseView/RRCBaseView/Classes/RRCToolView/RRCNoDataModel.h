//
//  RRCNoDatabgView.h
//  MXSFramework
//
//  Created by renrencai on 2019/4/2.
//  Copyright © 2019年 MXS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RRCNoDataType) {
    RRCEmptyTypeImage = 0,         //图片
    RRCEmptyTypeImageAndText,      // 图片+文字
    RRCEmptyTypeTextAndResponse,   //文字+按钮（响应）
    RRCEmptyTypeAll,               //所有
};


@interface RRCNoDataModel : NSObject

/**
 显示类型
 */
@property (nonatomic, assign) RRCNoDataType noDataType;


@property (nonatomic,strong) NSString *imageName;
@property (nonatomic, assign) CGSize imageSize;

@property (nonatomic,strong) NSString *text;
@property (nonatomic,strong) NSString *responseText;
@property (nonatomic,assign) NSInteger responseType;//响应类型 0：登录，1：加载网络 2其他事件

@property (nonatomic, assign) CGFloat topMargin;
@property (nonatomic, assign) CGFloat emptyContentWidth;
@property (nonatomic, assign) CGFloat emptyContentHeight;
@property (nonatomic, strong) UIColor *backViewColor;


/*按钮的宽度 */
@property (nonatomic, assign) CGFloat buttonWidth;
/**按钮的高度 */
@property (nonatomic, assign) CGFloat buttonHeight;
@end
NS_ASSUME_NONNULL_END
