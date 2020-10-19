//
//  RRCViewModel.h
//  MXSFramework
//
//  Created by gaoguangxiao on 2020/4/16.
//  Copyright © 2020 MXS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^LoadDataArrayBlock)(NSArray *loadArr);
typedef void(^loadDataBOOLBlock)(BOOL isEnd);
typedef void(^LoadDataArrayIntegerBlock)(NSArray *loadArr,NSInteger count);
typedef void(^LoadDataBOOLIntegerBlock)(BOOL result,NSInteger count);

//result服务器返回结果 yes：正常处理 no：处理异常
//isLoadsuc网络状态请求 yes：请求成功 no：请求失败【操作取消、断网、请求超时】
typedef void(^LoadDataBOOLBOOLBlock)(BOOL result,BOOL isLoadsuc);

@interface RRCViewModel : NSObject

-(void)requestDataWithParameters:(NSDictionary *)parameters andComplete:(void(^)(NSArray *loadArr,BOOL isLoadsuc))blockList;

/// 列表数组
@property (nonatomic , strong) NSMutableArray *listArray;


/// 选中列表数组
@property (nonatomic, strong) NSMutableArray *itemChoseArrayID;
@end

NS_ASSUME_NONNULL_END
