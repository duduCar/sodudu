//
//  SDDTitleLineView.m
//  嘟嘟车管家
//
//  Created by joinus on 15/12/9.
//  Copyright © 2015年 soulnear. All rights reserved.
//

#import "SDDTitleLineView.h"

#define INDENTATION_DISTANCE 10

@interface SDDTitleLineView (){
    UILabel * title_label;
}

@end

@implementation SDDTitleLineView

-(id)initWithFrame:(CGRect)frame WithTitle:(NSString *)aTitle{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _title = aTitle;
        title_label = [ZTools createLabelWithFrame:CGRectMake(INDENTATION_DISTANCE, 5, DEVICE_WIDTH-INDENTATION_DISTANCE*2, 20) text:aTitle textColor:DEFAULT_BLACK_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:13];
        [self addSubview:title_label];
        
        UIView * line_view = [[UIView alloc] initWithFrame:CGRectMake(INDENTATION_DISTANCE, title_label.bottom+5, DEVICE_WIDTH-INDENTATION_DISTANCE*2, 0.5)];
        line_view.backgroundColor = DEFAULT_LINE_COLOR;
        [self addSubview:line_view];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(INDENTATION_DISTANCE, line_view.bottom+5, DEVICE_WIDTH-INDENTATION_DISTANCE*2, 0)];
        [self addSubview:_contentView];
    }
    return self;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    title_label.text = title;
}

-(void)setContentView:(UIView *)contentView{
    [_contentView removeFromSuperview];
    [self addSubview:contentView];
}

@end
