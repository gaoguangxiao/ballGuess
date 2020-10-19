//
//  Log.h
//
//  Created by David on 12-9-3.
//  Copyright (c) 2012年 David. All rights reserved.
//

#ifndef Log_h
#define Log_h

//------------------------------------------------------------------------------
#ifdef LOG

#define log(format,...) do{NSLog((format), ##__VA_ARGS__);}while(0)

#else

#define log(format,...)

#endif

//------------------------------------------------------------------------------

#ifdef TRACE

#define trace(format,...) do{\
    NSLog([NSString stringWithFormat:@"\r\n\r\n【%@】\r\n【Function:%s】\r\n【Line:%d】\r\n【File:%s】\r\n",format,__func__,__LINE__,__FILE__],##__VA_ARGS__);}while(0)

#else

#define trace(format,...)

#endif

//------------------------------------------------------------------------------

#ifdef EVENT

#define logEvent(format,...) do{\
    NSLog([NSString stringWithFormat:@"\r\n\r\n【Event:%@】\r\n【Function:%s】\r\n【Line:%d】\r\n【File:%s】\r\n",format,__func__,__LINE__,__FILE__],##__VA_ARGS__);}while(0)

#else

#define logEvent(format,...)

#endif

//------------------------------------------------------------------------------
#endif
