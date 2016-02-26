//
//  DiscountDetailModel.h
//  嘟嘟车管家
//
//  Created by joinus on 15/12/9.
//  Copyright © 2015年 soulnear. All rights reserved.
//

#import "BaseModel.h"

@interface RestrictionsModel : BaseModel

///
@property(nonatomic,strong)NSString * is_refundable;
///
@property(nonatomic,strong)NSString * is_reservation_required;
///
@property(nonatomic,strong)NSString * special_tips;

@end

@interface BusinessModel : BaseModel

///商家名称
@property(nonatomic,strong)NSString * name;
///商家id
@property(nonatomic,strong)NSString * id;
///商家所在城市
@property(nonatomic,strong)NSString * city;
///商家经度
@property(nonatomic,assign)double latitude;
///商家纬度
@property(nonatomic,assign)double longitude;
///商家地址
@property(nonatomic,strong)NSString * address;
///
@property(nonatomic,strong)NSString * url;
///
@property(nonatomic,strong)NSString * h5_url;

@end


@interface DiscountDetailModel : BaseModel{
    
}

///id
@property(nonatomic,strong)NSString * id;
///商家id
@property(nonatomic,strong)NSString * shopid;
///
@property(nonatomic,strong)NSString * otherid;
///
@property(nonatomic,strong)NSString * deal_id;
///
@property(nonatomic,strong)NSString * title;
///
@property(nonatomic,strong)NSString * description;
///
@property(nonatomic,strong)NSString * city;
///
@property(nonatomic,strong)NSString * list_price;
///
@property(nonatomic,strong)NSString * current_price;
///
@property(nonatomic,strong)NSString * purchase_count;
///
@property(nonatomic,strong)NSString * purchase_deadline;
///
@property(nonatomic,strong)NSString * publish_date;
///
@property(nonatomic,strong)NSString * details;
///
@property(nonatomic,strong)NSString * image_url;
///
@property(nonatomic,strong)NSString * s_image_url;
///
@property(nonatomic,strong)NSString * more_image_urls;
///
@property(nonatomic,strong)NSString * more_s_image_urls;
///
@property(nonatomic,strong)NSString * is_popular;
///
@property(nonatomic,strong)NSString * deal_url;
///
@property(nonatomic,strong)NSString * deal_h5_url;
///
@property(nonatomic,strong)NSString * type;
///
@property(nonatomic,strong)NSString * isweb;
///
@property(nonatomic,strong)NSString * dateline;
///
@property(nonatomic,strong)RestrictionsModel * restrictions_model;
///
@property(nonatomic,strong)NSArray * categories_array;
///
@property(nonatomic,strong)NSArray * regions_array;
///
@property(nonatomic,strong)NSMutableArray * businesses_array;


@end
