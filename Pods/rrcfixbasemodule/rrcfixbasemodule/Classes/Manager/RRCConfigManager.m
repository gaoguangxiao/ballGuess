//
//  RRCConfigManager.m
//  
//
//  Created by gaoguangxiao on 2019/10/24.
//

#import "RRCConfigManager.h"

#import "MJExtension.h"
#import "NSBundle+Resources.h"
@implementation RRCConfigManager

NSString * const RRCCompanyYazhiKeys = @"CompanyYazhiKeys";
NSString * const RRCCompanyOuzhiKeys = @"CompanyOuzhiKeys";
NSString * const RRCCompanyDaxiaoKeys = @"CompanyDaxiaoKeys";
NSString * const RRCExponentCompanySelectKeys = @"RRCExponentCompanySelectKeys";
NSString * const RRCPushSetKeys = @"matchPushSet";//赛事推送设置
NSString * const RRCConfigSetKeys = @"RRCConfigSet";//App设置

ImplementSingleton(RRCConfigManager);

#pragma mark - 存储数据
-(id)loadLocalCapacityData:(NSString *)capacityKey{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:capacityKey]) {
       return [userDefault objectForKey:capacityKey];
    }
    return nil;
}

-(void)updateLocalCapacityData:(id)object andCapacityKey:(NSString *)capacityKey{
    if (object != nil) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:object forKey:capacityKey];
        [userDefault synchronize];
    }
}

#pragma mark - APP配置
-(RRCConfigModel *)loadConfigLocal{
    
    //1、读取本地偏好配置，是否具备推送，如果没有就读文件，并将文件存入偏好设置
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (![userDefault objectForKey:RRCConfigSetKeys]) {
        NSDictionary *jsonDic = [self loadJsonFileName:RRCConfigSetKeys];
        [userDefault setObject:jsonDic forKey:RRCConfigSetKeys];
        [userDefault synchronize];
    }
    
    NSDictionary *jsonDic = [userDefault objectForKey:RRCConfigSetKeys];
    RRCConfigModel *m = [RRCConfigModel mj_objectWithKeyValues:jsonDic];
    //默认值读取
    //3.5增加
    if (!m.lotteryId) {
        m.lotteryId = @"3";
    }
    return m;
}

-(void)updateLocalConfigBySetModel:(RRCConfigModel *)configModel{
    NSString *json = [configModel mj_JSONString];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:json forKey:RRCConfigSetKeys];
    [userDefault synchronize];
}

//本地配置
-(RRCMatchSetModel *)loadPushLocalSet{
    //1、读取本地偏好配置，是否具备推送，如果没有就读文件，并将文件存入偏好设置
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (![userDefault objectForKey:RRCPushSetKeys]) {
        NSDictionary *jsonDic = [self loadJsonFileName:RRCPushSetKeys];
        [userDefault setObject:jsonDic forKey:RRCPushSetKeys];
        [userDefault synchronize];
    }
    
    NSDictionary *jsonDic = [userDefault objectForKey:RRCPushSetKeys];
    RRCMatchSetModel *m = [RRCMatchSetModel mj_objectWithKeyValues:jsonDic];
    
    return m;
}

-(void)updatePushLocalSetBySetModel:(RRCMatchSetModel *)setmodel{
    NSString *json = [setmodel mj_JSONString];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:json forKey:RRCPushSetKeys];
    [userDefault synchronize];
}
#pragma mark - 加载JSON
-(NSDictionary *)loadJsonFileName:(NSString *)fileName{
    NSBundle *bundleName = [NSBundle bundleName:@"rrcfixbasemodule" andResourcesBundleName:@""];
    NSString *path = [bundleName pathForResource:fileName ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    if (!data) {
        return @{};
    }
//    对数据进行JSON格式化并返回字典形式
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    if (jsonDic) {
        return jsonDic;
    }else{
        return @{};
    }
}

@end
