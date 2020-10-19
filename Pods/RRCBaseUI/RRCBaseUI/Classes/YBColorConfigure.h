//
//  YBColorConfigure.h
//  YouBang
//
//  Created by UI on 16/10/13.
//
//

#ifndef YBColorConfigure_h
#define YBColorConfigure_h

#import "UIColor+RRCColor.h"

#pragma mark -
#pragma mark - Default And System


// r g b 透明度默认为1.0
#define RGB(r, g, b)    [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]

//十六进制颜色值 透明度默认为1.0
#define COLORRGB(c)    [UIColor colorWithRed:((c>>16)&0xFF)/255.0    \
green:((c>>8)&0xFF)/255.0    \
blue:(c&0xFF)/255.0         \
alpha:1.0]

//十六进制颜色值 透明度
#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 blue:((float)(rgbValue & 0x0000FF))/255.0 alpha:alphaValue]

#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

//所有字体赋值颜色 均需走入此方法，统一用十六进制 0x
//根据模块化传入默认主题颜色，返回应该显示的颜色
//定义颜色
#define RRCTEXTCOLOR(string)  [UIColor textColorDefault:string]

#define RRCViewCOLOR(string)  [UIColor viewColorDefault:string]

#define RRCViewSTRING(string) [NSString viewColorString:string]//颜色字符串 模式转换

//3.4新版定义颜色------- 默认颜色key
#define RRCThemeTextS @"0x2E3133" //（黑色字体）
#define RRCViceTextS @"0x5C6166" // #5C6166（稍微黑一点）
#define RRCGrayTextS @"0x909599" //（灰色）
#define RRCF21646Str @"#F21646"
#define RRC313133Str @"#313133"
#define RRCFFDEE5Str @"#FFDEE5"
#define RRC8E7070Str @"#8E7070"
#define RRCDCE1E6Str @"#DCE1E6"
#pragma mark - 字体颜色
#define RRCThemeTextColor  RRCTEXTCOLOR(@"#2E3133")//主题字体颜色
#define RRCViceTextColor   RRCTEXTCOLOR(@"#5C6166")//副主题字体颜色
#define RRCGrayTextColor   RRCTEXTCOLOR(@"#909599")//一般辅助字体颜色
#define RRCWhiteTextColor  COLORRGB(0xffffff)//模块四：默认字体白色，不论哪种模式都是白色（慎用！，用于背景红色）

#define RRCHighLightTitleColor    RRCTEXTCOLOR(@"#F21646")//字体高亮颜色 红色
#define RRCProgressViewColor      RRCTEXTCOLOR(@"#F21646")//进度条高亮颜色 红色

#define RRCWhiteDarkColor RRCTEXTCOLOR(@"#FFFFFF") //默认字体白色，转换模式之后 是黑色字体

#pragma mark - 视图背景颜色
#define RRCThemeViewColor  RRCViewCOLOR(@"#F21646")//主题背景颜色
#define RRCBorderViewColor RRCViewCOLOR(@"#F21646")//border高亮颜色
#define RRCBorderNomalViewColor RRCViewCOLOR(@"DCE1E6")//border灰色颜色
#define RRCBorderLineViewColor RRCViewCOLOR(@"#909599")//边框深颜色
#define RRCBorderWhiteViewColor RRCViewCOLOR(@"#FFFFFF")//边框白

#define RRCUnitViewColor   RRCViewCOLOR(@"#FFFFFF")//内容背景

#define RRCSplitViewColor  RRCViewCOLOR(@"#F1F3F5")//分割块颜色
#define RRCInputViewColor  RRCViewCOLOR(@"#F7F7F7")//输入框背景颜色
#define RRCLineViewColor   RRCViewCOLOR(@"#DCE1E6")//view下划线颜色
#define RRC07FFFFFFLineColor   RRCViewCOLOR(@"#07FFFFFF")//view下划线透明颜色
#define RRCLineWhiteViewColor COLORRGB(0xffffff)//view下划线颜色
#define RRCGrayViewColor   RRCTEXTCOLOR(@"#909599")//灰色背景颜色

//特殊背景颜色
#define RRCBackViewColor  RRCViewCOLOR(@"#F1F3F5")//view背景 浅灰色 用于tableView颜色设置
#define RRCLineContentViewColor   RRCViewCOLOR(@"#DCE1E6")//深色背景颜色，其显示内容 主要和 F1f3f5为背景时分开
#define RRCInputContentViewColor  RRCViewCOLOR(@"#F7F7F7")//输入框背景添加内容颜色，比较浅 和 F1f3f5区分
#define RRCSplitContentViewColor  RRCViewCOLOR(@"#F1F3F5")//深色背景颜色，其可显示内容

#define RRCActivityColor  RRCViewCOLOR(@"#909599")//足球财富loading颜色

#pragma mark - 颜色定义
#define RRC313133Color   RRCViewCOLOR(@"#313133")//黑色 - 粉红
#define RRC4B75FFColor   RRCViewCOLOR(@"#4B75FF")//背景浅蓝
#define RRCFFEBEEColor   RRCViewCOLOR(@"#FFEBEE")//背景浅红
#define RRCFF650AColor   RRCViewCOLOR(@"#FF650A")//橘黄色
#define RRCFFF0DAColor   RRCViewCOLOR(@"#FFF0DA")//浅黄
#define RRC04BD2CColor   RRCViewCOLOR(@"#04BD2C")//走水
#define RRC0F9958Color   RRCViewCOLOR(@"#0F9958")//降绿色
#define RRCE8FFF4Color   RRCViewCOLOR(@"#E8FFF4")//降背景绿色
#define RRC258940Color   RRCViewCOLOR(@"#258940")//深绿色进度条
#define RRC4A74FFColor   RRCViewCOLOR(@"#4A74FF")//蓝色
#define RRCFFC60AColor   RRCViewCOLOR(@"#FFC60A")//黄牌
#define RRCF88AA2Color   RRCViewCOLOR(@"#F88AA2")//浅红
#define RRCD1D1D1Color   RRCViewCOLOR(@"#D1D1D1")//灰色饼图

#define RRCFFFFFF60FFFFFFColor RRCViewCOLOR(@"#FFFFFF60FFFFFF")//白色 - 透明度60
#define RRCFFFFFF313133Color   RRCViewCOLOR(@"#FFFFFF313133")  //白色 - 黑色
#define RRCF21646313133Color   RRCViewCOLOR(@"#F21646313133")  //

#define RRCFAD277Color    COLORRGB(0xFAD277)//淡黄色
#define RRCB8C2CCColor    COLORRGB(0xB8C2CC)//下拉刷新字体颜色
#define RRC5343e5Color    COLORRGB(0x5343e5)//投稿须知 导航栏背景颜色

#endif /* YBColorConfigure_h */

