//
//  HBLocalizationManager.h
//  FBSnapshotTestCase
//
//  Created by 彩人人 on 2020/8/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HBLanguageType){
    HBLanguageDef,  //默认，则根据系统语言返回，系统语言没有默认返回越南语
    HBLanguageZH,   //中文
    HBLanguageEN,   //英文
    HBLanguageVI    //越南文
};


@interface HBLocalizationManager : NSObject

/// 设置默认语言
/// @param type type
/// @param handler 设置之后的回调
+(void)setNativeLanguage:(HBLanguageType)type handler:(void(^ _Nullable)(void))handler;

/// 获取当前设置的语言
+(HBLanguageType)getNativeLanaguage;

/// 获取所有支持的语言
+(NSArray<NSString*>*)getSupportedLanguage;

/// 获取国际化
/// @param key key
+(NSString*)loadLanguageWithKey:(NSString*)key;

/// 获取国际化
/// @param key key
/// @param commont 获取不到的默认值
+(NSString*)loadLanguageWithKey:(NSString *)key commont:(NSString* _Nullable)commont;

@end


NS_ASSUME_NONNULL_END
