//
//  CommentTableViewCell.h
//  嘟嘟车管家
//
//  Created by joinus on 15/10/13.
//  Copyright (c) 2015年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface CommentTableViewCell : UITableViewCell{
    
}

/**
 *  头像
 */
@property(nonatomic,strong)UIImageView * header_imageView;
/**
 *  用户名
 */
@property(nonatomic,strong)UILabel * user_name_label;
/**
 *  评分
 */
@property(nonatomic,strong)DJWStarRatingView * evaluation_view;
/**
 *  评价内容
 */
@property(nonatomic,strong)UILabel * content_label;
/**
 *  商家名称
 */
@property(nonatomic,strong)UILabel * shop_name_label;


-(void)setInfomationWith:(CommentModel*)info;

@end
