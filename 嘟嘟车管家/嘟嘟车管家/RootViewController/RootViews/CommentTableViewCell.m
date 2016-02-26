//
//  CommentTableViewCell.m
//  嘟嘟车管家
//
//  Created by joinus on 15/10/13.
//  Copyright (c) 2015年 soulnear. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (!_header_imageView) {
            _header_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 10, 75/2.0f, 58/2.0f)];
            [self.contentView addSubview:_header_imageView];
        }
        
        if (!_user_name_label) {
            _user_name_label = [[UILabel alloc] initWithFrame:CGRectMake(_header_imageView.right+10, 10, DEVICE_WIDTH-150, 20)];
            _user_name_label.textAlignment = NSTextAlignmentLeft;
            _user_name_label.textColor = [UIColor blackColor];
            _user_name_label.font = [UIFont systemFontOfSize:15];
            [self.contentView addSubview:_user_name_label];
        }
        
        if (!_evaluation_view) {
            _evaluation_view = [[DJWStarRatingView alloc] initWithStarSize:CGSizeMake(13, 13) numberOfStars:5 rating:5 fillColor:RGBCOLOR(253, 180, 90) unfilledColor:[UIColor clearColor] strokeColor:RGBCOLOR(253, 180, 90)];
            _evaluation_view.padding = 2;
            _evaluation_view.top = 10;
            _evaluation_view.left = DEVICE_WIDTH-90;
            [self.contentView addSubview:_evaluation_view];
        }
        
        if (!_content_label) {
            _content_label = [[UILabel alloc] initWithFrame:CGRectMake(_header_imageView.right+10, _user_name_label.bottom+5, DEVICE_WIDTH-80, 0)];
            _content_label.textAlignment = NSTextAlignmentLeft;
            _content_label.numberOfLines = 0;
            _content_label.textColor = [UIColor blackColor];
            _content_label.font = [UIFont systemFontOfSize:13];
            [self.contentView addSubview:_content_label];
        }
        
        if (!_shop_name_label) {
            _shop_name_label = [ZTools createLabelWithFrame:CGRectMake(_header_imageView.right+10, _content_label.bottom+10, DEVICE_WIDTH-130, 20) text:@"" textColor:[UIColor grayColor] textAlignment:NSTextAlignmentLeft font:12];
            [self.contentView addSubview:_shop_name_label];
        }
    }
    return self;
}

-(void)setInfomationWith:(CommentModel *)info{
    [_header_imageView sd_setImageWithURL:[NSURL URLWithString:info.useravatar] placeholderImage:[UIImage  imageNamed:@"homepage_comment_listitem_imgbg"]];
    _user_name_label.text = info.username;
    _evaluation_view.rating = [info.star intValue]/10.0;
    CGSize content_size = [ZTools stringHeightWithFont:_content_label.font WithString:info.content WithWidth:_content_label.width];
    _content_label.height = content_size.height;
    _content_label.text = info.content;
    
    _shop_name_label.text = info.shopname;
    _shop_name_label.top = _content_label.bottom+10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
