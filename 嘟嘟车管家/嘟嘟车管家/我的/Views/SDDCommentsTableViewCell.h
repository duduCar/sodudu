//
//  SDDCommentsTableViewCell.h
//  嘟嘟车管家
//
//  Created by joinus on 16/1/25.
//  Copyright © 2016年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDDCommentsModel.h"

@interface SDDCommentsTableViewCell : UITableViewCell

/**
 *  商家名称
 */
@property(nonatomic,strong)UILabel * shop_name_label;
/**
 *  评论内容
 */
@property(nonatomic,strong)UILabel * content_label;
/**
 *  评论时间
 */
@property(nonatomic,strong)UILabel * date_label;
/**
 *  评分
 */
@property(nonatomic,strong)DJWStarRatingView * sr_view;



-(void)setInfomationWithCommentsModel:(SDDCommentsModel*)model;

@end
