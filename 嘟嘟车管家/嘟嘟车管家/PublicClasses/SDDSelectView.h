//
//  SDDSelectView.h
//  嘟嘟车管家
//
//  Created by joinus on 15/10/20.
//  Copyright (c) 2015年 soulnear. All rights reserved.
//
/**
 *  选择界面  地区 维修保养 综合
 */
#import <UIKit/UIKit.h>

typedef void(^SDDSelectViewBlock)(NSString * column_name);

@interface SDDSelectView : UIView{
    SDDSelectViewBlock sdd_column_block;
}
/**
 *  选择类型（0：地区；1：维修保养 2：综合）
 */
@property(nonatomic,assign)int type;

-(void)selectedColumn:(SDDSelectViewBlock)block;

@end
