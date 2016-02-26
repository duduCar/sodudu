//
//  SDDOrderTableViewCell.m
//  嘟嘟车管家
//
//  Created by joinus on 16/1/25.
//  Copyright © 2016年 soulnear. All rights reserved.
//

#import "SDDOrderTableViewCell.h"

@implementation SDDOrderTableViewCell

- (void)awakeFromNib {
    
}

-(void)setInfomationWithOrderModel:(SDDOrderModel *)model{
    _date_label.text = [ZTools timechangeWithTimestamp:model.posttime WithFormat:@"YYYY-MM-dd HH:mm"];
    [_date_label sizeToFit];
    _line_view.width = _date_label.width;
//    _order_imageView.backgroundColor = [UIColor redColor];
    _title_label.text = model.stitle;
    _price_label.text = [NSString stringWithFormat:@"￥%@",model.price];
    _shop_name_label.text = model.username;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if (!_date_label) {
            _date_label = [ZTools createLabelWithFrame:CGRectMake(15, 10, DEVICE_WIDTH-30, 15) text:@"" textColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentLeft font:13];
            [self.contentView addSubview:_date_label];
        }
        
        if (!_line_view) {
            _line_view = [[UIView alloc] initWithFrame:CGRectMake(15, _date_label.bottom+5, DEVICE_WIDTH-30, 0.5)];
            _line_view.backgroundColor = RGBCOLOR(198, 198, 198);
            [self.contentView addSubview:_line_view];
        }
        
//        if (!_order_imageView) {
//            _order_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, _line_view.bottom+5, 60, 45)];
//            [self.contentView addSubview:_order_imageView];
//        }
        
        if (!_title_label) {
            _title_label = [ZTools createLabelWithFrame:CGRectMake(15, _line_view.bottom+5, DEVICE_WIDTH-30, 25) text:@"" textColor:DEFAULT_BLACK_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:15];
            [self.contentView addSubview:_title_label];
        }
        
        if (!_price_label) {
            _price_label = [ZTools createLabelWithFrame:CGRectMake(15, _title_label.bottom+5, 60, 20) text:@"" textColor:DEFAULT_YELLOW_COLOR textAlignment:NSTextAlignmentLeft font:13];
            [self.contentView addSubview:_price_label];
        }
        
        if (!_shop_name_label) {
            _shop_name_label = [ZTools createLabelWithFrame:CGRectMake(_price_label.right+5, _price_label.top, DEVICE_WIDTH-_price_label.right-10, 20) text:@"" textColor:DEFAULT_GRAY_TEXT_COLOR textAlignment:NSTextAlignmentRight font:13];
            [self.contentView addSubview:_shop_name_label];
        }
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
