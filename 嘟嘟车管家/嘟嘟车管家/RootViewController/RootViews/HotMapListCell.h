//
//  HotMapListCell.h
//  嘟嘟车管家
//
//  Created by joinus on 15/11/16.
//  Copyright © 2015年 soulnear. All rights reserved.
//
///周边服务cell
#import <UIKit/UIKit.h>


typedef void(^HotMapListCellCallPhone)(void);
typedef void(^HotMapListCellOpenMap)(void);


@interface HotMapListCell : UITableViewCell{
    HotMapListCellCallPhone hot_map_list_cell_phone_block;
    HotMapListCellOpenMap hot_map_list_cell_map_block;
}

///背景图
@property(nonatomic,strong)UIView * background_view;

///商家名称
@property(nonatomic,strong)UILabel * title_label;
///商家地址
@property(nonatomic,strong)UILabel * address_label;
///距离
@property(nonatomic,strong)UILabel * distance_label;
///分割线横线
@property(nonatomic,strong)UIView * h_line_view;
///分割线竖线
@property(nonatomic,strong)UIView * v_line_view;
///电话
@property(nonatomic,strong)UIButton * phone_button;
///地图
@property(nonatomic,strong)UIButton * map_button;


-(void)setInfomation:(AMapPOI*)info WihtIndex:(int)index WithCall:(HotMapListCellCallPhone)phoneBlock WithOpen:(HotMapListCellOpenMap)mapBlock;

@end
