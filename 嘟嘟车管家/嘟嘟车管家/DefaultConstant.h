//
//  DefaultConstant.h
//  推盟
//
//  Created by soulnear on 14-8-9.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#ifndef ___DefaultConstant_h
#define ___DefaultConstant_h


#define CAR_XICHE @"洗车"
#define CAR_WEIXIU @"维修保养"
#define CAR_PEIJIAN @"车饰配件"
#define CAR_MEIRONG @"汽车美容"
#define CAR_BAOXIAN @"汽车保险"
#define CAR_SSSS @"4S店"
#define CAR_ZULIN @"汽车租赁"

#define CAR_XICHE_ID @"2828"
#define CAR_WEIXIU_ID @"176"
#define CAR_PEIJIAN_ID @"177"
#define CAR_MEIRONG_ID @"20026"
#define CAR_BAOXIAN_ID @"259"
#define CAR_SSSS_ID @"175"
#define CAR_ZULIN_ID @"178"

//
#define USER_NAME @"user_name"


#define CURRENT_BUILD [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define CURRENT_VERSION [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]

#pragma mark 所有接口
#pragma mark -----------域名--------------
#define WEBSITE @"http://www.sodudu.cn"
#define BASE_URL @"http://www.sodudu.cn/api.php?c=%@&a=%@"
//#define BASE_URL @"http://demo.sodudu.cn/api.php?c=%@&a=%@"
#pragma mark -----------------   分享链接地址
#define SHARE_URL @"http://www.sodudu.cn/mshopinfo/%@.html"

#pragma mark******************  最新评论接口+热门服务+广告接口
#define NEWEST_COMMENT_URL [NSString stringWithFormat:BASE_URL,@"dianping",@"startup"]
#pragma mark******************   商家列表
#define SELLER_LIST_URL [NSString stringWithFormat:BASE_URL,@"dianping",@"shoplist"]
#pragma mark******************   商家详情
#define SELLER_DETAIL_URL [NSString stringWithFormat:BASE_URL,@"dianping",@"shopinfo"]
#pragma mark******************   包含商家介绍详情接口
/*
 **shopid
 **token
 */
#define SELLER_DETAIL_CONTENT_URL [NSString stringWithFormat:BASE_URL,@"dianping",@"shopcontent"]
#pragma mark******************   获取城市列表接口
#define CITY_LIST_URL [NSString stringWithFormat:BASE_URL,@"dianping",@"getcity"]
#pragma mark******************   搜索接口
#define SEARCH_URL [NSString stringWithFormat:BASE_URL,@"dianping",@"search"]
#pragma mark******************   发表评论接口
#define COMMENTS_URL [NSString stringWithFormat:BASE_URL,@"dianping",@"addcomment"]

#pragma mark ——————————————————————————  用户系统   ————————————————————————————
///登录(username:用户名 password：密码)
#define LOGIN_URL [NSString stringWithFormat:BASE_URL,@"member",@"login"]
///注册(username:用户名 password：密码)
#define REGISTER_URL [NSString stringWithFormat:BASE_URL,@"member",@"register"]
/**
 *  修改密码(oldpassword:旧密码  password：新密码  token：用户加密id)
 */
#define MODIFY_PASSWORD_URL [NSString stringWithFormat:BASE_URL,@"member",@"updatepassword"]
/**
 *  获取个人信息
 *  token 用户id
 */
#define  GET_USER_INFOMATION_URL [NSString stringWithFormat:BASE_URL,@"member",@"myprofile"]

/**
 *  获取用户所有订单(token:用户id)
 */
#define  GET_USER_ORDER_URL [NSString stringWithFormat:BASE_URL,@"member",@"myorder"]
/**
 *  获取订单详情接口（id：订单id  token：用户id）
 */
#define GET_ORDER_DETAIL_URL [NSString stringWithFormat:BASE_URL,@"member",@"myorderinfo"]
/**
 *  获取订单详情(id：订单id token:用户id)
 */
#define  GET_USER_ORDER_INFO_URL [NSString stringWithFormat:BASE_URL,@"member",@"myorderinfo"]
/**
 *  我的评论接口  token:用户id
 */
#define GET_USER_COMMENTS_URL [NSString stringWithFormat:BASE_URL,@"member",@"mycomment"]

#pragma mark ——————————————————————————  优惠   ————————————————————————————
/*优惠列表
 *city 所在城市
 *type 优惠类型 
 *1 团购;2 活动 
 *token ⽤用户token
 */
#define DISCOUNT_LIST_URL [NSString stringWithFormat:BASE_URL,@"event",@"eventlist"]
/*
 **id id
 **token 用户id
 */
#define DISCOUNT_DETAIL_URL [NSString stringWithFormat:BASE_URL,@"event",@"eventinfo"]

#pragma mark ——————————————————————————  车信息   ————————————————————————————
/**
 * 获取所有车品牌
 */
#define GET_CAR_BRAND_URL [NSString stringWithFormat:BASE_URL,@"member",@"getcar"]




#endif






















