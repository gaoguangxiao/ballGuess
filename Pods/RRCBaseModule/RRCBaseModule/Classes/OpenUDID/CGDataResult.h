//
//  RRCDataResult.h
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/7/4.
//  Copyright © 2019 MXS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,RRCWebServiceCode){
    RRCWebServiceCodeError   = -1,         //一般性错误
    RRCWebServiceCodeSuccess = 1,          //请求成功
    RRCWebServiceCodeUserExit = -102,      //用户不存在
};

NS_ASSUME_NONNULL_BEGIN
@interface CGDataPageResult : NSObject

@property (nonatomic,strong) NSArray *list;

@property (nonatomic,assign) NSInteger page_num;
@property (nonatomic,assign) NSInteger page_size;
@property (nonatomic,assign) NSInteger total_page;
@property (nonatomic,assign) NSInteger total_row;
@property (nonatomic,assign) BOOL is_last_page;

+(CGDataPageResult *)getResultFromDic:(NSDictionary *)dic;
@end

@interface CGDataResult : NSObject

@property (nonatomic, strong) NSNumber *status;//如果一个值，我们从一个属性我们从一开始就使用assign，那么久没有一个对象会保持对这个对象的应用。那么它很快就会释放了。之后我们再访问的话，就会出现野指针问题。

@property (nonatomic, strong) NSString *errorMsg;

/// 服务器返回码
@property (nonatomic , assign) RRCWebServiceCode serviceCode;

//1001 未登录状态 -601赛事不存在  -310文章评论不存在 -220用户屏蔽 -210帖子不存在
@property (nonatomic, assign) NSInteger code;

/**服务器原始数据 */
@property (nonatomic, strong)id originalData;

@property (nonatomic, strong)id data;

/**额外的信息 */
@property (nonatomic, strong) CGDataPageResult *extraInfo;

+(CGDataResult *)getResultFromDic:(NSDictionary *)dic;
@end



NS_ASSUME_NONNULL_END
