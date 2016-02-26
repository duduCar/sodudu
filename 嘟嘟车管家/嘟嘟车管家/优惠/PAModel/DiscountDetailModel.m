//
//  DiscountDetailModel.m
//  嘟嘟车管家
//
//  Created by joinus on 15/12/9.
//  Copyright © 2015年 soulnear. All rights reserved.
//

#import "DiscountDetailModel.h"

@implementation RestrictionsModel


@end

@implementation BusinessModel


@end


@implementation DiscountDetailModel

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super initWithDictionary:dic];
    if (self) {
        _businesses_array = [NSMutableArray array];
        NSArray * array = [dic objectForKey:@"businesses"];
        if (array && [array isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary * item in array) {
                BusinessModel * model = [[BusinessModel alloc] initWithDictionary:item];
                [_businesses_array addObject:model];
            }
        }
        
        NSDictionary * restrictions_dic = [dic objectForKey:@"restrictions"];
        if (restrictions_dic && [restrictions_dic isKindOfClass:[NSDictionary class]]) {
            _restrictions_model = [[RestrictionsModel alloc] initWithDictionary:restrictions_dic];
        }
    }
    
    return self;
}

@end
