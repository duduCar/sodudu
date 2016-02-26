//
//  HotServerModel.h
//  嘟嘟车管家
//
//  Created by joinus on 15/11/13.
//  Copyright © 2015年 soulnear. All rights reserved.
//

#import "BaseModel.h"

@interface HotServerModel : BaseModel


///英文名
@property(nonatomic,strong)NSString * ename;
///是否是H5页面（当isweb为1的时候，url有值。加油站和停车场的isweb为0，url为空）
@property(nonatomic,strong)NSString * isweb;
///名称
@property(nonatomic,strong)NSString * name;
///图片
@property(nonatomic,strong)NSString * photo;
///链接地址
@property(nonatomic,strong)NSString * url;

@end
