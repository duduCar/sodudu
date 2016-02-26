//
//  SDDOrderTableViewCell.h
//  嘟嘟车管家
//
//  Created by joinus on 16/1/25.
//  Copyright © 2016年 soulnear. All rights reserved.
//
/**
 *  我的订单
 */

#import <UIKit/UIKit.h>
#import "SDDOrderModel.h"

@interface SDDOrderTableViewCell : UITableViewCell

/**
 *  订单图片
 */
@property(nonatomic,strong)UIImageView * order_imageView;
/**
 *  价格
 */
@property(nonatomic,strong)UILabel * price_label;
/**
 *  标题
 */
@property(nonatomic,strong)UILabel * title_label;
/**
 *  商家名称
 */
@property(nonatomic,strong)UILabel * shop_name_label;
/**
 *  评论时间
 */
@property(nonatomic,strong)UILabel * date_label;
/**
 *  分割线
 */
@property(nonatomic,strong)UIView * line_view;


-(void)setInfomationWithOrderModel:(SDDOrderModel*)model;


@end
