//
//  RRCCollectionViewCell.h
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/12/19.
//  Copyright © 2019 MXS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBColorConfigure.h"
#import "RRCDeviceConfigure.h"
#import "Masonry.h"
NS_ASSUME_NONNULL_BEGIN

@interface RRCCollectionViewCell : UICollectionViewCell

/**万能的数据 */
@property (nonatomic, strong) id data;

-(void)creatCell;

-(void)setViewColor;
@end

NS_ASSUME_NONNULL_END
