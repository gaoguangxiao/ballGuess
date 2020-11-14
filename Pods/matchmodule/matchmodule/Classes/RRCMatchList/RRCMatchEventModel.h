//
//  RRCMatchEventModel.h
//  matchmodule
//
//  Created by gaoguangxiao on 2020/5/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RRCMatchEventModel : NSObject

@property (nonatomic,copy) NSString *homeBallControlRate;   //主队控球率
@property (nonatomic,copy) NSString *visitingTeamBallControlRate;//客队控球率

@property (nonatomic,copy) NSString *homeAttack;            //主队进攻
@property (nonatomic,copy) NSString *visitingTeamAttack;    //客队进攻

@property (nonatomic,copy) NSString *homeDangerousAttack;   //主队危险进攻
@property (nonatomic,copy) NSString *visitingTeamDangerousAttack;//客队危险进攻

@property (nonatomic,copy) NSString *homeShootPositive;     //主队射正
@property (nonatomic,copy) NSString *visitingTeamShootPositive;  //客队射正

@property (nonatomic,copy) NSString *homeShootNumber;      //主队射门
@property (nonatomic,copy) NSString *visitingTeamShootNumber;//客队射门

@property (nonatomic,copy) NSString *homeDeflection;        //主队射偏
@property (nonatomic,copy) NSString *visitingTeamDeflection;     //客队射偏

@end

NS_ASSUME_NONNULL_END
