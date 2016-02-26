//
//  SDDOrderModel.h
//  嘟嘟车管家
//
//  Created by joinus on 16/1/19.
//  Copyright © 2016年 soulnear. All rights reserved.
//
/**
 *  订单model
 */

#import "BaseModel.h"

@interface SDDOrderModel : BaseModel

/**
 *  订单id
 */
@property(nonatomic,strong)NSString * id;
/**
 *  tid
 */
@property(nonatomic,strong)NSString * tid;
/**
 *  sid
 */
@property(nonatomic,strong)NSString * sid;
/**
 *  短标题
 */
@property(nonatomic,strong)NSString * stitle;
/**
 *  评分
 */
@property(nonatomic,strong)NSString * sscore;
/**
 *  uid
 */
@property(nonatomic,strong)NSString * uid;
/**
 *  用户昵称
 */
@property(nonatomic,strong)NSString * username;
/**
 *
 */
@property(nonatomic,strong)NSString * carinfo;
/**
 *  真实姓名
 */
@property(nonatomic,strong)NSString * realname;
/**
 *  价格
 */
@property(nonatomic,strong)NSString * price;
/**
 *  省份
 */
@property(nonatomic,strong)NSString * province;
/**
 *  城市
 */
@property(nonatomic,strong)NSString * city;
/**
 *  地址
 */
@property(nonatomic,strong)NSString * address;
/**
 *  手机号码
 */
@property(nonatomic,strong)NSString * telphone;
/**
 *  订单内容
 */
@property(nonatomic,strong)NSString * content;
/**
 *  订单创建时间
 */
@property(nonatomic,strong)NSString * posttime;



@end
