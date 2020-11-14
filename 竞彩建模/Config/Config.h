
//
//  Config.h
//  CPetro
//
//  Created by ggx on 2017/3/8.
//  Copyright © 2017年 高广校. All rights reserved.
//  应用配置

#ifndef Config_h
#define Config_h
//http://


//http://v.juhe.cn
#define HOSTDOMAIN @"v.juhe.cn"
#define WEBSEARVICE  [NSString stringWithFormat:@"http://%@/",HOSTDOMAIN]

//#define HOSTDOMAIN @"blocks.chinahxmedia.com"
//#define WEBSEARVICE  [NSString stringWithFormat:@"http://%@/",HOSTDOMAIN]

//Bmob数据
#define BMOBAPPKEY @"0d77340863fa72fc68d0907ab7a81a54"

//API聚合数据
#define API_OPENID @"JHa6e281a1613686f8f4d6937f8851e7e3"
//流量直冲key
#define API_EXCHANGE @"513737b33b937eaaa455d269b7bc2884"

//融云
#define RongCloudAppKey @"c9kqb3rdcxsfj"//开发环境

//设置Webservice变量结构
#define API_STATUS @"error_code"
#define API_MSG @"reason"
#define API_CONTENT @"result"
#define API_MODEL @"model_list"
#endif /* Config_h */
