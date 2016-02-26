//
//  RootADModel.h
//  嘟嘟车管家
//
//  Created by joinus on 15/11/22.
//  Copyright © 2015年 soulnear. All rights reserved.
//
///首页广告数据模型
#import "BaseModel.h"

@interface RootADModel : BaseModel

@property(nonatomic,strong)NSString * photo;

@property(nonatomic,strong)NSString * url;

@property(nonatomic,assign)float width;

@property(nonatomic,assign)float height;

@end
