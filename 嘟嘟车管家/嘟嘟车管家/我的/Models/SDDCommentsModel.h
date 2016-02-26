//
//  SDDCommentsModel.h
//  嘟嘟车管家
//
//  Created by joinus on 16/1/25.
//  Copyright © 2016年 soulnear. All rights reserved.
//
/**
 *  我的评论
 */

#import "BaseModel.h"

@interface SDDCommentsModel : BaseModel

/**
 *  评论id
 */
@property(nonatomic,strong)NSString * id;
/**
 *  商家id
 */
@property(nonatomic,strong)NSString * shopid;
/**
 *  评分
 */
@property(nonatomic,strong)NSString * star;
/**
 *  用户名
 */
@property(nonatomic,strong)NSString * username;
/**
 *  评论内容
 */
@property(nonatomic,strong)NSString * content;
/**
 *  价格
 */
@property(nonatomic,strong)NSString * price;
/**
 *  评论时间
 */
@property(nonatomic,strong)NSString * dateline;






@end
