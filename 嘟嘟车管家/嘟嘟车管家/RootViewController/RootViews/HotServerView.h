//
//  HotServerView.h
//  嘟嘟车管家
//
//  Created by joinus on 15/11/12.
//  Copyright © 2015年 soulnear. All rights reserved.
//
/*
 热门服务
 */
#import <UIKit/UIKit.h>
#import "HotServerModel.h"

typedef void(^HotServerViewBlock)(int index);

@interface HotServerView : UIView{
    HotServerViewBlock hot_server_block;
}


@property(nonatomic,strong)NSMutableArray * data_array;

-(void)sddHotServerClicked:(HotServerViewBlock)block;

@end
