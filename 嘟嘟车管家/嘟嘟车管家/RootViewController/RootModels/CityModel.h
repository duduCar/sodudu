//
//  CityModel.h
//  嘟嘟车管家
//
//  Created by joinus on 15/10/15.
//  Copyright (c) 2015年 soulnear. All rights reserved.
//
/**
 *  城市model
 */

#import "BaseModel.h"

@interface CityModel : BaseModel

/**
 *  城市id
 */
@property(nonatomic,strong)NSString * id;
/**
 *  城市名
 */
@property(nonatomic,strong)NSString * name;
/**
 *  城市英文名称
 */
@property(nonatomic,strong)NSString * ename;
///
@property(nonatomic,strong)NSString * listname;

@end
