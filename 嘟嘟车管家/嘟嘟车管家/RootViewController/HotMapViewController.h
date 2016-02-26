//
//  HotMapViewController.h
//  嘟嘟车管家
//
//  Created by joinus on 15/11/17.
//  Copyright © 2015年 soulnear. All rights reserved.
//
/*
 热门服务地图
 */

#import "MyViewController.h"

@interface HotMapViewController : MyViewController
///热门服务名称
@property(nonatomic,strong)NSString * server_name;
///商家数据
@property(nonatomic,strong)NSMutableArray * shops_array;
///选择的第几个
@property(nonatomic,assign)int index;

@end
