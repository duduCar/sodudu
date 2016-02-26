//
//  ZAPI.h
//  推盟
//
//  Created by joinus on 15/7/29.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZAPI : NSObject
{
    
}
@property (nonatomic,strong)    NSDictionary *responseResult;
@property (readwrite, nonatomic, strong) NSURL *baseURL;


+(instancetype)manager;

-(instancetype)initWithBaseURL:(NSURL *)url;
/**
 *  post 异步请求
 *
 *  @param rawURL  链接地址
 *  @param params  数据内容
 *  @param success 成功回调
 *  @param failure 失败回调
 */
-(void)sendPost:(NSString *)rawURL myParams:(NSDictionary *)params
        success:(void (^)(id data))success
        failure:(void (^)(NSError *error))failure;
/**
 *  get 异步请求
 *
 *  @param rawURL  请求链接地址
 *  @param success 成功回调
 *  @param failure 失败回调
 */
-(void)sendGet:(NSString *)rawURL success:(void (^)(id data))success failure:(void (^)(NSError*error))failure;




@end
