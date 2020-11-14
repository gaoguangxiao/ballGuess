//
//  HBLocalizationManager.m
//  FBSnapshotTestCase
//
//  Created by 彩人人 on 2020/8/18.
//

#define HBLANGUAGEKEY @"HBLANGUAGEKEY"

#import "HBLocalizationManager.h"

@interface HBLocalizationManager()

@property (nonatomic, assign) HBLanguageType type;

@property (nonatomic, strong) NSString* path;

@property (nonatomic, strong) NSBundle* bundle;

@property (nonatomic, strong) NSMutableArray<NSString*>* paths;

@property (nonatomic, strong) NSMutableArray<NSString*>* fileNames;

@property (nonatomic, strong) NSString* table;

@end

@implementation HBLocalizationManager
static HBLocalizationManager* _instance;

+ (void)load{
    HBLocalizationManager* manager = [self shareManager];
    manager.path = [[NSBundle bundleForClass:[self class]] pathForResource:@"RRCBaseUI" ofType:@"bundle"];
    manager.bundle = [NSBundle bundleWithPath:manager.path];
    [manager.paths addObjectsFromArray:[manager.bundle pathsForResourcesOfType:@"strings" inDirectory:nil]];
    for (NSString* str in manager.paths) {
        [manager.fileNames addObject:[str.lastPathComponent componentsSeparatedByString:@"."].firstObject];
    }
    manager.type = [self getLanguageToUDF];

}

+ (void)setNativeLanguage:(HBLanguageType)type handler:(void (^ _Nullable)(void))handler{
    [self setLanguageToUDF:type];
    if (handler) {
        handler();
    }
}

+ (HBLanguageType)getNativeLanaguage{
    return [self getLanguageToUDF];
}

+ (NSArray<NSString *> *)getSupportedLanguage{
    HBLocalizationManager* manager = [self shareManager];
    NSMutableArray<NSString*>* language = [[NSMutableArray alloc] init];
    for (NSString* str in manager.fileNames) {
        [language addObject:[manager.bundle localizedStringForKey:@"语言" value:@"" table:str]];
    }
    return language;
}

+ (NSString *)loadLanguageWithKey:(NSString *)key{
    
    return [self loadLanguageWithKey:key commont:nil];
}

+ (NSString *)loadLanguageWithKey:(NSString *)key commont:(NSString * _Nullable)commont{
    HBLocalizationManager* manager = [self shareManager];
    return [manager.bundle localizedStringForKey:key value:commont table:manager.table];
}

#pragma mark - 私有类方法

///  保存设置的默认语言
/// @param type 类型
+(void)setLanguageToUDF:(HBLanguageType)type{
    HBLocalizationManager* manager = [self shareManager];
    manager.type = type;
    [[NSUserDefaults standardUserDefaults] setObject:@(type) forKey:HBLANGUAGEKEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// 获取设置的默认语言
+(HBLanguageType)getLanguageToUDF{
    NSNumber* number = [[NSUserDefaults standardUserDefaults] objectForKey:HBLANGUAGEKEY];
    if (number) {
        return [number integerValue];
    }
    return HBLanguageDef;
}

/// 获取当前系统语言
+ (NSString*)getCurrentLanguage{
    NSArray*languages = [NSLocale preferredLanguages];
    return [languages objectAtIndex:0];
}

#pragma mark - set方法

- (void)setType:(HBLanguageType)type{
    _type = type;
    self.table = nil;
    if (type == HBLanguageZH){
        self.table = @"zh";
    }else if (type == HBLanguageVI){
        self.table = @"vi-VN";
    }else if (type == HBLanguageEN){
        self.table = @"en";
    }else{
        NSString* str = [HBLocalizationManager getCurrentLanguage];
        for (NSString* name in self.fileNames) {
            if ([str hasPrefix:name]) {
                self.table = name;
                break;
            }
        }
        if (!self.table) {
            self.table = @"en";
        }
    }
}

#pragma mark -  单利
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}

+(instancetype)shareManager
{
    return [[self alloc]init];
}

-(id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}

#pragma mark - 懒加载

- (NSMutableArray<NSString *> *)paths{
    if (!_paths) {
        _paths = [[NSMutableArray alloc] init];
    }
    return _paths;
}

- (NSMutableArray<NSString *> *)fileNames{
    if (!_fileNames) {
        _fileNames = [[NSMutableArray alloc] init];
    }
    return _fileNames;
}

@end
