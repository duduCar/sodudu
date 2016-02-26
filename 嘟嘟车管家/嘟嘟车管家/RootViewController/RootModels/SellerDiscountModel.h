//
//  SellerDiscountModel.h
//  嘟嘟车管家
//
//  Created by joinus on 15/12/8.
//  Copyright © 2015年 soulnear. All rights reserved.
//
/*
 **商家优惠活动数据模型
 */

#import "BaseModel.h"

@interface SellerDiscountModel : BaseModel

///h5地址
@property(nonatomic,strong)NSString * deal_h5_url;
///
@property(nonatomic,strong)NSString * deal_id;
///
@property(nonatomic,strong)NSString * id;
///是否为web
@property(nonatomic,strong)NSString * isweb;
///标题
@property(nonatomic,strong)NSString * title;
///类型
@property(nonatomic,strong)NSString * type;

@end
