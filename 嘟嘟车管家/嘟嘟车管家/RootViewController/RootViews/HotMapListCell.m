//
//  HotMapListCell.m
//  嘟嘟车管家
//
//  Created by joinus on 15/11/16.
//  Copyright © 2015年 soulnear. All rights reserved.
//

#import "HotMapListCell.h"

@implementation HotMapListCell

- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if (!_background_view) {
            _background_view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, DEVICE_WIDTH, 95)];
            _background_view.backgroundColor = [UIColor whiteColor];
            [self.contentView addSubview:_background_view];
        }
        
        if (!_title_label) {
            _title_label = [ZTools createLabelWithFrame:CGRectMake(12, 5, DEVICE_WIDTH-24, 25) text:@"" textColor:RGBCOLOR(3, 3, 3) textAlignment:NSTextAlignmentLeft font:15];
            [_background_view addSubview:_title_label];
        }
        
        if (!_address_label) {
            _address_label = [ZTools createLabelWithFrame:CGRectMake(12, _title_label.bottom+5, DEVICE_WIDTH-12-90-10, 20) text:@"" textColor:DEFAULT_LINE_COLOR textAlignment:NSTextAlignmentLeft font:13];
            [_background_view addSubview:_address_label];
        }
        
        if (!_distance_label) {
            _distance_label = [ZTools createLabelWithFrame:CGRectMake(DEVICE_WIDTH-90, _address_label.top, 78, 20) text:@"1.5km" textColor:DEFAULT_LINE_COLOR textAlignment:NSTextAlignmentRight font:12];
            [_background_view addSubview:_distance_label];
        }
        
        if (!_h_line_view) {
            _h_line_view = [[UIView alloc] initWithFrame:CGRectMake(12, _address_label.bottom+5, DEVICE_WIDTH-24, 0.5)];
            _h_line_view.backgroundColor = DEFAULT_LINE_COLOR;
            [_background_view addSubview:_h_line_view];
        }
        
        if (!_v_line_view) {
            _v_line_view = [[UIView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH/2.0-0.25, _h_line_view.bottom+5, 0.5, 24)];
            _v_line_view.backgroundColor = DEFAULT_LINE_COLOR;
            [_background_view addSubview:_v_line_view];
        }

        if (!_phone_button) {
            _phone_button = [ZTools createButtonWithFrame:CGRectMake(0, _h_line_view.bottom, 80, 30) title:@"电话" image:nil];
            _phone_button.center = CGPointMake(DEVICE_WIDTH/4.0f, _phone_button.center.y);
            _phone_button.titleLabel.font = [UIFont systemFontOfSize:14];
            [_phone_button setTitleColor:RGBCOLOR(46, 46, 46) forState:UIControlStateNormal];
            [_phone_button setImage:[UIImage imageNamed:@"system_telphone_image"] forState:UIControlStateNormal];
            [_phone_button addTarget:self action:@selector(callPhoneNum:) forControlEvents:UIControlEventTouchUpInside];
            [_background_view addSubview:_phone_button];
        }
        
        if (!_map_button) {
            _map_button = [ZTools createButtonWithFrame:CGRectMake(0, _h_line_view.bottom, 80, 30) title:@"地图" image:[UIImage imageNamed:@"system_address_image"]];
            _map_button.frame = CGRectMake(0, _h_line_view.bottom, 80, 30);
            [_map_button setTitleColor:RGBCOLOR(46, 46, 46) forState:UIControlStateNormal];
            _map_button.titleLabel.font = [UIFont systemFontOfSize:13];
            _map_button.center = CGPointMake(DEVICE_WIDTH/4.0f*3, _map_button.center.y);
            [_map_button addTarget:self action:@selector(openMap:) forControlEvents:UIControlEventTouchUpInside];

            [_background_view addSubview:_map_button];
        }
    }
    
    return self;
}
-(void)setInfomation:(AMapPOI *)info WihtIndex:(int)index WithCall:(HotMapListCellCallPhone)phoneBlock WithOpen:(HotMapListCellOpenMap)mapBlock{
    hot_map_list_cell_phone_block = phoneBlock;
    hot_map_list_cell_map_block = mapBlock;
    _title_label.text = [NSString stringWithFormat:@"%d.%@",index+1,info.name];
    _address_label.text = info.address;
    _distance_label.text = [NSString stringWithFormat:@"%ldm",(long)info.distance];
    if (info.distance >= 1000) {
        _distance_label.text = [NSString stringWithFormat:@"%.1fkm",(long)info.distance/1000.0];
    }
}

#pragma mark ----   打电话
-(void)callPhoneNum:(UIButton*)button{
    hot_map_list_cell_phone_block();
}

#pragma mark ----  地图
-(void)openMap:(UIButton*)button{
    hot_map_list_cell_map_block();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
