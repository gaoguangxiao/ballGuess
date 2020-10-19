//
//  Singleton.h
//
//  Created by David on 13-3-5.
//  Copyright (c) 2013年 David. All rights reserved.
//

#define DeclareSingleton(classname)\
+(classname*)shared##classname\

#define ImplementSingleton(classname)\
\
static classname* shared##classname=nil; \
\
+(classname*)shared##classname \
{ \
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        shared##classname=[[classname alloc] init];\
    });\
    return shared##classname;\
} \
\
//for arc,disable following codes.
//+(id)allocWithZone:(NSZone*)zone \
{ \
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        if(shared##classname==nil) \
        { \
            shared##classname = [super allocWithZone:zone]; \
            return shared##classname; \
        } \
    });\
    return nil; \
} \
\
-(id)copyWithZone:(NSZone*)zone \
{ \
    return self; \
} \
\
//-(id)retain \
{ \
    return self; \
} \
\
-(NSUInteger)retainCount \
{ \
    return NSUIntegerMax; \
} \
\
//-(oneway void)release \
{ \
} \
\
//-(id)autorelease \
{ \
    return self; \
} \