//
//  SDDCommentsTableViewCell.m
//  嘟嘟车管家
//
//  Created by joinus on 16/1/25.
//  Copyright © 2016年 soulnear. All rights reserved.
//

#import "SDDCommentsTableViewCell.h"

@implementation SDDCommentsTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if (!_sr_view) {
            _sr_view = [[DJWStarRatingView alloc] initWithStarSize:CGSizeMake(13, 13) numberOfStars:5 rating:5 fillColor:RGBCOLOR(253, 180, 90) unfilledColor:[UIColor clearColor] strokeColor:RGBCOLOR(253, 180, 90)];
            _sr_view.padding = 2;
            _sr_view.top = 10;
            _sr_view.left = DEVICE_WIDTH-90;
            [self.contentView addSubview:_sr_view];
        }
        
//        if (!_shop_name_label) {
//            _shop_name_label = [ZTools createLabelWithFrame:CGRectMake(10, 10, DEVICE_WIDTH-_sr_view.width-40, 25) text:@"" textColor:DEFAULT_BLACK_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:14];
//            [self.contentView addSubview:_shop_name_label];
//        }
        
        if (!_content_label) {
            _content_label = [ZTools createLabelWithFrame:CGRectMake(10, _sr_view.bottom+5, DEVICE_WIDTH-20, 20) text:@"" textColor:DEFAULT_GRAY_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:13];
            _content_label.numberOfLines = 0;
            [self.contentView addSubview:_content_label];
        }
        
        if (!_date_label) {
            _date_label = [ZTools createLabelWithFrame:CGRectMake(10, _content_label.bottom+5, DEVICE_WIDTH-80, 15) text:@"" textColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentLeft font:11];
            [self.contentView addSubview:_date_label];
        }
    }
    
    return self;
}

-(void)setInfomationWithCommentsModel:(SDDCommentsModel *)model{
    
//    _shop_name_label.text = model.username;
    
    _sr_view.rating = [model.star intValue]/10.0;
    
    CGSize content_size = [ZTools stringHeightWithFont:_content_label.font WithString:model.content WithWidth:_content_label.width];
    _content_label.height = content_size.height;
    _content_label.text = model.content;
    
    _date_label.top = _content_label.bottom+5;
    
    _date_label.text = model.dateline;
}

@end
