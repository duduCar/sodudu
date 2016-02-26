//
//  CarBrandModel.h
//  嘟嘟车管家
//
//  Created by joinus on 16/1/19.
//  Copyright © 2016年 soulnear. All rights reserved.
//

#import "BaseModel.h"

@interface CarBrandModel : BaseModel

/**
 *  车品牌id
 */
@property(nonatomic,strong)NSString * id;
/**
 *  上一级ID
 */
@property(nonatomic,strong)NSString * pid;
/**
 *  首字母
 */
@property(nonatomic,strong)NSString * letter;
/**
 *  名称
 */
@property(nonatomic,strong)NSString * name;
/**
 *  type 类型(1 品牌;2  系;3  型)
 */
@property(nonatomic,strong)NSString * type;

@end
