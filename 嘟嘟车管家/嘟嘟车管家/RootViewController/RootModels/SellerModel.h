//
//  SellerModel.h
//  嘟嘟车管家
//
//  Created by joinus on 15/10/13.
//  Copyright (c) 2015年 soulnear. All rights reserved.
//
/**
 *  商家model
 */

#import "BaseModel.h"
#import "SellerDiscountModel.h"

@interface SellerModel : BaseModel
/**
 *  商家id
 */
@property(nonatomic,strong)NSString * id;
/**
 *  商家类别
 */
@property(nonatomic,strong)NSString * sort;
/**
 *  商家类别id
 */
@property(nonatomic,strong)NSString * sortid;
/**
 *  商家名称
 */
@property(nonatomic,strong)NSString * name;
/**
 *  人均价格
 */
@property(nonatomic,strong)NSString * price;
/**
 *  商家电话
 */
@property(nonatomic,strong)NSString * telphone;
/**
 *  商家所属城市id
 */
@property(nonatomic,strong)NSString * cityid;
/**
 *  商家地址
 */
@property(nonatomic,strong)NSString * address;
/**
 *  商家地区
 */
@property(nonatomic,strong)NSString * area;
/**
 *  商家评论数
 */
@property(nonatomic,strong)NSString * comments;
/**
 *  是否为推荐商家（1：推荐，0：未推荐）
 */
@property(nonatomic,strong)NSString * commend;
/**
 *  商家综合评分
 */
@property(nonatomic,strong)NSString * score;
/**
 *  商家图片
 */
@property(nonatomic,strong)NSString * photo;
/**
 *  商家经度
 */
@property(nonatomic,strong)NSString * lng;
/**
 *  商家纬度
 */
@property(nonatomic,strong)NSString * lat;
/**
 *  与商家距离
 */
@property(nonatomic,strong)NSString * distance;
/*
 **商家介绍
 */
@property(nonatomic,strong)NSString * summary;
/*
 **商家介绍(含图文)
 */
@property(nonatomic,strong)NSString * content;
/**
 *  活动信息
 */
@property(nonatomic,strong)NSMutableArray * event_array;




@end
