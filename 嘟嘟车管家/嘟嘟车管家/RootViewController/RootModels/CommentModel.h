//
//  CommentModel.h
//  嘟嘟车管家
//
//  Created by joinus on 15/10/13.
//  Copyright (c) 2015年 soulnear. All rights reserved.
//
/**
 *  评论数据类
 */

#import "BaseModel.h"

@interface CommentModel : BaseModel
/**
 *  评论id
 */
@property(nonatomic,strong)NSString * id;
/**
 *  店铺id
 */
@property(nonatomic,strong)NSString * shopid;
/**
 *  评论等级
 */
@property(nonatomic,strong)NSString * star;
/**
 *  店铺名称
 */
@property(nonatomic,strong)NSString * shopname;
/**
 *  评论人名称
 */
@property(nonatomic,strong)NSString * username;
/**
 *  头像
 */
@property(nonatomic,strong)NSString * useravatar;
/**
 *  内容
 */
@property(nonatomic,strong)NSString * content;
/**
 *  价格
 */
@property(nonatomic,strong)NSString * price;
/**
 *  时间
 */
@property(nonatomic,strong)NSString * dateline;

@end
