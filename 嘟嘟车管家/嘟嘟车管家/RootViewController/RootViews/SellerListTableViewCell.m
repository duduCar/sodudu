//
//  SellerListTableViewCell.m
//  嘟嘟车管家
//
//  Created by joinus on 15/10/13.
//  Copyright (c) 2015年 soulnear. All rights reserved.
//

#import "SellerListTableViewCell.h"
#import "SellerDiscountModel.h"

@implementation SellerListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (!_header_imageView) {
            _header_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 45)];
            [self.contentView addSubview:_header_imageView];
            
            _commend_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_header_imageView.width-30, 0, 30, 30)];
            _commend_imageView.image = [UIImage imageNamed:@"shop_commend_image"];
            [_header_imageView addSubview:_commend_imageView];
        }
        if (!_seller_name_label) {
            _seller_name_label = [[UILabel alloc] initWithFrame:CGRectMake(_header_imageView.right+10, 10, DEVICE_WIDTH-140, 20)];
            _seller_name_label.textAlignment = NSTextAlignmentLeft;
            _seller_name_label.numberOfLines = 0;
            _seller_name_label.textColor = [UIColor blackColor];
            _seller_name_label.font = [UIFont systemFontOfSize:15];
            [self.contentView addSubview:_seller_name_label];
        }
        
        if (!_comments_label) {
            _comments_label = [[UILabel alloc] initWithFrame:CGRectMake(DEVICE_WIDTH-70, 10, 60, 20)];
            _comments_label.textAlignment = NSTextAlignmentRight;
            _comments_label.textColor = [UIColor orangeColor];
            _comments_label.font = [UIFont systemFontOfSize:14];
            [self.contentView addSubview:_comments_label];
        }
        
        if (!_star_view) {            
            _star_view = [[DJWStarRatingView alloc] initWithStarSize:CGSizeMake(13, 13) numberOfStars:5 rating:5 fillColor:RGBCOLOR(253, 180, 90) unfilledColor:[UIColor clearColor] strokeColor:RGBCOLOR(253, 180, 90)];
            _star_view.padding = 2;
            _star_view.top = _seller_name_label.bottom+18;
            _star_view.left = _header_imageView.right+10;
            [self.contentView addSubview:_star_view];

        }
        
        if (!_price_label) {
            _price_label = [ZTools createLabelWithFrame:CGRectMake(_star_view.right+10, _seller_name_label.bottom+15, 100, 20) text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:13];
            [self.contentView addSubview:_price_label];
        }
        
        if (!_adress_label) {
            _adress_label = [ZTools createLabelWithFrame:CGRectMake(_header_imageView.right+10, _price_label.bottom+5, DEVICE_WIDTH-140, 20) text:@"" textColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentLeft font:13];
            _adress_label.backgroundColor = [UIColor whiteColor];
            [self.contentView addSubview:_adress_label];
        }
        
        if (!_distance_label) {
            _distance_label = [ZTools createLabelWithFrame:CGRectMake(DEVICE_WIDTH-65, _price_label.bottom+5, 60, 20) text:@"" textColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentRight font:13];
            [self.contentView addSubview:_distance_label];
        }
        
        /*
        if (!_event_view) {
            _event_view = [[UIView alloc] initWithFrame:CGRectMake(_seller_name_label.left, _adress_label.bottom, DEVICE_WIDTH-_header_imageView.right-15, 0)];
            _event_view.backgroundColor = [UIColor whiteColor];
            [self.contentView addSubview:_event_view];
        }
         */
        
    }
    return self;
}

-(void)setInfomationWith:(SellerModel *)info WithActivityBlock:(SellerListCellActivityTapBlock)block{
    
    seller_list_cell_block = block;
    
    for (UIView * view in _event_view.subviews) {
        [view removeFromSuperview];
    }
    
    [_header_imageView sd_setImageWithURL:[NSURL URLWithString:info.photo] placeholderImage:[UIImage  imageNamed:@"homepage_comment_listitem_imgbg"]];
    _seller_name_label.text = info.name;
    _comments_label.text = [NSString stringWithFormat:@"%@评",info.comments];
    _star_view.rating = [info.score intValue]/10.0;
    _price_label.text = info.price;
    _adress_label.text = [NSString stringWithFormat:@"%@  %@",info.area,info.address];
    _distance_label.text = info.distance;
    
    ///是否显示推荐图片
    if (info.commend.intValue == 1) {
        _commend_imageView.hidden = NO;
    }else{
        _commend_imageView.hidden = YES;
    }
    
    
    CGSize size = [ZTools stringHeightWithFont:_seller_name_label.font WithString:info.name WithWidth:_seller_name_label.width];
    _seller_name_label.height = size.height;
    _star_view.top = _seller_name_label.bottom+10;
    _price_label.top = _star_view.top-3;
    _adress_label.top = _star_view.bottom+8;
    _distance_label.top = _adress_label.top;
    
    
    /*
    _event_view.top = _distance_label.bottom+2;
    _event_view.height = info.event_array.count*25;
    if (info.event_array.count > 0) {
        UIView * line_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _event_view.width, 0.5)];
        line_view.backgroundColor = DEFAULT_LINE_COLOR;
        [_event_view addSubview:line_view];
    }
    for (int i = 0; i < info.event_array.count; i++) {
        SellerDiscountModel * item = info.event_array[i];
        UILabel * type_label = [ZTools createLabelWithFrame:CGRectMake(0, 7+25*i, 20, 15) text:[item.type intValue]==1?@"团购":[item.type intValue]==2?@"活动":@"" textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:12];
        [type_label sizeToFit];
        type_label.backgroundColor = RGBCOLOR(252, 102, 34);
        [_event_view addSubview:type_label];
        
        UILabel * title_label = [ZTools createLabelWithFrame:CGRectMake(type_label.right+5, type_label.top, _event_view.width-type_label.right-15, 15) text:item.title textColor:DEFAULT_GRAY_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:12];
        title_label.userInteractionEnabled = YES;
        title_label.tag = 100 + i;
        [_event_view addSubview:title_label];
        
        UITapGestureRecognizer * activity_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(activityTitleClicked:)];
        [title_label addGestureRecognizer:activity_tap];
    }
     */
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)activityTitleClicked:(UITapGestureRecognizer*)sender{
    seller_list_cell_block((int)sender.view.tag-100);
}




@end







