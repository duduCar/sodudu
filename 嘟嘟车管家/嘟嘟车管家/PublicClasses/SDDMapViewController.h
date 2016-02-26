//
//  SDDMapViewController.h
//  嘟嘟车管家
//
//  Created by joinus on 15/10/15.
//  Copyright (c) 2015年 soulnear. All rights reserved.
//

#import "MyViewController.h"
#import <MapKit/MapKit.h>

@interface SDDMapViewController : MyViewController
{
    double userLatitude;
    double userlongitude;
}

@property(nonatomic,strong)MKMapView * myMapView;

///标题
@property(nonatomic,strong)NSString * title_string;
///纬度
@property(nonatomic,assign)double address_latitude;
///经度
@property(nonatomic,assign)double address_longitude;
///标题
@property(nonatomic,strong)NSString * address_title;
///简介
@property(nonatomic,strong)NSString * address_content;


@end
