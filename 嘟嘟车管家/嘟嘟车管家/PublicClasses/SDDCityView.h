//
//  SDDCityView.h
//  嘟嘟车管家
//
//  Created by joinus on 15/10/18.
//  Copyright (c) 2015年 soulnear. All rights reserved.
//
/**
 *  选取城市
 */
#import <UIKit/UIKit.h>

typedef void(^SDDCityViewBlock)(NSString * city,NSString * city_id);

@interface SDDCityView : UIView{
    SDDCityViewBlock myBlock;
}
/**
 *  所有城市
 */
@property(nonatomic,strong)NSMutableArray * city_array;
/**
 *  当前定位到的城市
 */
@property(nonatomic,strong)NSString * location_city;

-(id)initWithFrame:(CGRect)frame WithLocal:(NSString*)location WithOther:(NSMutableArray*)other;
-(void)selectedCity:(SDDCityViewBlock)block;
-(void)setLocal:(NSString*)local Cities:(NSMutableArray*)citys;
@end
