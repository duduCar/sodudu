//
//  PAModel.h
//  嘟嘟车管家
//
//  Created by joinus on 15/12/3.
//  Copyright © 2015年 soulnear. All rights reserved.
//

#import "BaseModel.h"

@interface PAModel : BaseModel
///
@property(nonatomic,strong)NSString * id;
///
@property(nonatomic,strong)NSString * shopid;
///
@property(nonatomic,strong)NSString * title;
///
@property(nonatomic,strong)NSString * city;
///
@property(nonatomic,strong)NSString * list_price;
///
@property(nonatomic,strong)NSString * current_price;
///
@property(nonatomic,strong)NSString * s_image_url;
///
@property(nonatomic,strong)NSString * is_popular;
///
@property(nonatomic,strong)NSString * deal_url;
///
@property(nonatomic,strong)NSString * deal_h5_url;
///
@property(nonatomic,strong)NSString * businesses;
///
@property(nonatomic,strong)NSString * type;
///
@property(nonatomic,strong)NSString * isweb;
///
@property(nonatomic,strong)NSString * dateline;

@end
