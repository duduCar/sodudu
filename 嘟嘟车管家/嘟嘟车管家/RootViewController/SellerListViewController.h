//
//  SellerListViewController.h
//  嘟嘟车管家
//
//  Created by joinus on 15/10/13.
//  Copyright (c) 2015年 soulnear. All rights reserved.
//
/**
 *  商家列表
 */

#import "MyViewController.h"

@interface SellerListViewController : MyViewController{
    
}
/**
 *  服务栏目id
 */
@property(nonatomic,strong)NSString * column_id;
/**
 *  经纬度
 */
@property(nonatomic,assign)double lat;
@property(nonatomic,assign)double lng;

@end
