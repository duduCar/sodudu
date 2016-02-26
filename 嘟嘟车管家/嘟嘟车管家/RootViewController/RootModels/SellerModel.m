//
//  SellerModel.m
//  嘟嘟车管家
//
//  Created by joinus on 15/10/13.
//  Copyright (c) 2015年 soulnear. All rights reserved.
//

#import "SellerModel.h"

@implementation SellerModel

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super initWithDictionary:dic];
    if (self) {
        _event_array = [NSMutableArray array];
        NSArray * array = [dic objectForKey:@"event"];
        if (array && [array isKindOfClass:[NSArray class]]) {
            for (NSDictionary * item in array) {
                SellerDiscountModel * model = [[SellerDiscountModel alloc] initWithDictionary:item];
                [_event_array addObject:model];
            }
        }
    }
    
    return self;
}

@end
