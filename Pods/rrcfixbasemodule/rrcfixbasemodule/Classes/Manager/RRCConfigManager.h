//
//  RRCConfigManager.h
//  
//
//  Created by gaoguangxiao on 2019/10/24.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "RRCMatchSetModel.h"
#import "RRCConfigModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RRCConfigManager : NSObject

UIKIT_EXTERN NSString * const RRCCompanyYazhiKeys;
UIKIT_EXTERN NSString * const RRCCompanyOuzhiKeys;
UIKIT_EXTERN NSString * const RRCCompanyDaxiaoKeys;
UIKIT_EXTERN NSString * const RRCExponentCompanySelectKeys;//欧指筛选公司的ID
UIKIT_EXTERN NSString * const RRCPushSetKeys; //推送设置
UIKIT_EXTERN NSString * const RRCConfigSetKeys; //APP设置

DeclareSingleton(RRCConfigManager);

/// 获取存储的数据
/// @param capacityKey 存储数据的key
-(id)loadLocalCapacityData:(NSString *)capacityKey;


/// 存储数组数据
/// @param object 数据
/// @param capacityKey 存储数据的Key
-(void)updateLocalCapacityData:(id)object andCapacityKey:(NSString *)capacityKey;

-(NSDictionary *)loadJsonFileName:(NSString *)fileName;

/// 加载本地存储文件
-(RRCMatchSetModel *)loadPushLocalSet;

/// 更新本地存储文件
/// @param setmodel <#setmodel description#>
-(void)updatePushLocalSetBySetModel:(RRCMatchSetModel *)setmodel;

//本地存储配置文件
-(RRCConfigModel *)loadConfigLocal;

-(void)updateLocalConfigBySetModel:(RRCConfigModel *)configModel;
@end

NS_ASSUME_NONNULL_END
