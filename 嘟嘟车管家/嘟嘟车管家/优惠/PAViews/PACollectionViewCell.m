//
//  PACollectionViewCell.m
//  嘟嘟车管家
//
//  Created by joinus on 15/12/3.
//  Copyright © 2015年 soulnear. All rights reserved.
//

#import "PACollectionViewCell.h"

@implementation PACollectionViewCell

- (void)awakeFromNib {
    
}
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        if (!_header_imageView) {
            _header_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width*3/4)];
            _header_imageView.backgroundColor = [UIColor redColor];
            _header_imageView.layer.masksToBounds = YES;
            _header_imageView.layer.borderColor = DEFAULT_LINE_COLOR.CGColor;
            _header_imageView.layer.borderWidth = 0.5;
            [self addSubview:_header_imageView];
        }
        
        if (!_title_label) {
            _title_label = [ZTools createLabelWithFrame:CGRectMake(5, _header_imageView.bottom+5, self.width-10, 25) text:@"洗车王国" textColor:DEFAULT_BLACK_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:15];
            _title_label.numberOfLines = 2;
            _title_label.adjustsFontSizeToFitWidth = YES;
            [self addSubview:_title_label];
        }
        
        if (!_sub_title_label) {
            _sub_title_label = [ZTools createLabelWithFrame:CGRectMake(5, _title_label.bottom+5, self.width-10, 20) text:@"精致32步晶膜美容洗车" textColor:DEFAULT_GRAY_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:13];
            _sub_title_label.numberOfLines = 2;
            _sub_title_label.adjustsFontSizeToFitWidth = YES;
            [self addSubview:_sub_title_label];
        }
        
        if (!_price_label) {
            _price_label = [ZTools createLabelWithFrame:CGRectMake(5, _sub_title_label.bottom+5, self.width-50, 20) text:@"￥26644444" textColor:RGBCOLOR(252, 102, 34) textAlignment:NSTextAlignmentLeft font:16];
            _price_label.adjustsFontSizeToFitWidth = YES;
            [self addSubview:_price_label];
        }
        
        if (!_tag_label) {
            _tag_label = [ZTools createLabelWithFrame:CGRectMake(self.width-50, _sub_title_label.bottom+5, 45, 20) text:@"活动团购" textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font:13];
            _tag_label.backgroundColor = RGBCOLOR(252, 102, 34);
            [self addSubview:_tag_label];
        }
    }
    
    return self;
}

-(void)setInfomationWithPAModel:(PAModel *)model{
    [_header_imageView sd_setImageWithURL:[NSURL URLWithString:model.s_image_url] placeholderImage:DEFAULT_LOADING_IMAGE_4_3];
    _title_label.text = model.title;
    _sub_title_label.text = model.list_price;
    _price_label.text = [NSString stringWithFormat:@"￥%@",model.current_price];
    _tag_label.text = [model.type intValue]==1?@"团购":@"活动";
    [_tag_label sizeToFit];
    _tag_label.right = self.width - 5;
    _price_label.width = self.width-10-_tag_label.width-5;
}

@end
