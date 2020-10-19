//
//  RRCTableViewCell.h
//  MXSFramework
//
//  Created by 人人彩 on 2019/5/27.
//  Copyright © 2019 MXS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBColorConfigure.h"
#import "RRCDeviceConfigure.h"
#import "Masonry.h"
NS_ASSUME_NONNULL_BEGIN

@interface RRCTableViewCell : UITableViewCell

/**传入indexpath */
@property (nonatomic, strong) NSIndexPath *indexPath;

/**当前所有的 */

@property (nonatomic, assign) NSInteger indexPathAll;
/**万能的数据 */
@property (nonatomic, strong) id data;

/**是否隐藏最后一条线， indexPath必须有值*/
@property (nonatomic, assign) BOOL isHiddenLastLineView;

@property (nonatomic,strong) UIView *lineView;
-(void)initBaseCell;
-(void)creatCell;
-(void)setViewColor;
@end

NS_ASSUME_NONNULL_END
