//
//  PersonalModel.h
//  嘟嘟车管家
//
//  Created by joinus on 15/12/28.
//  Copyright © 2015年 soulnear. All rights reserved.
//

#import "BaseModel.h"

@interface PersonalModel : BaseModel
/**
 *
 */
@property(nonatomic,strong)NSString * avatar;
/**
 *  车型信息
 */
@property(nonatomic,strong)NSString * carinfo;
/**
 *  所在城市
 */
@property(nonatomic,strong)NSString * city;
/**
 *  是否为商家
 */
@property(nonatomic,strong)NSString * isshop;
/**
 *
 */
@property(nonatomic,strong)NSString * lasttime;
/**
 *  所在省份
 */
@property(nonatomic,strong)NSString * province;
/**
 *  注册时间
 */
@property(nonatomic,strong)NSString * regtime;
/**
 *  店铺id
 */
@property(nonatomic,strong)NSString * shopid;
/**
 *  用户id
 */
@property(nonatomic,strong)NSString * uid;
/**
 *  用户名
 */
@property(nonatomic,strong)NSString * username;


@end
