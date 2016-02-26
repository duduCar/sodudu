//
//  SellerListTableViewCell.h
//  嘟嘟车管家
//
//  Created by joinus on 15/10/13.
//  Copyright (c) 2015年 soulnear. All rights reserved.
//
/**
 *  商家列表cell
 */

#import <UIKit/UIKit.h>
#import "SellerModel.h"

typedef void(^SellerListCellActivityTapBlock)(int index);

@interface SellerListTableViewCell : UITableViewCell{
    SellerListCellActivityTapBlock seller_list_cell_block;
}
/**
 *  头图
 */
@property(nonatomic,strong)UIImageView * header_imageView;
///推荐商家图片
@property(nonatomic,strong)UIImageView * commend_imageView;
/**
 *  商家名称
 */
@property(nonatomic,strong)UILabel * seller_name_label;
/**
 *  评论数
 */
@property(nonatomic,strong)UILabel * comments_label;
/**
 *  评分
 */
@property(nonatomic,strong)DJWStarRatingView * star_view;
/**
 *  人均消费
 */
@property(nonatomic,strong)UILabel * price_label;
/**
 *  地址
 */
@property(nonatomic,strong)UILabel * adress_label;
/**
 *  距离
 */
@property(nonatomic,strong)UILabel * distance_label;
/**
 *  优惠活动
 */
@property(nonatomic,strong)UIView * event_view;



-(void)setInfomationWith:(SellerModel*)info WithActivityBlock:(SellerListCellActivityTapBlock)block;

@end
