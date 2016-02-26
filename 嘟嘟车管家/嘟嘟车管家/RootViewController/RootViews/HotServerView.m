//
//  HotServerView.m
//  嘟嘟车管家
//
//  Created by joinus on 15/11/12.
//  Copyright © 2015年 soulnear. All rights reserved.
//

#import "HotServerView.h"

#define PADDING (DEVICE_WIDTH-30*4)/5.0
#define IMAGE_HEIGHT 30

#define LINE_COLOR RGBCOLOR(220, 220, 220)

@implementation HotServerView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}

-(void)setData_array:(NSMutableArray *)data_array{
    _data_array = data_array;
    [self setup];
}

-(void)setup{
    
    for (UIView * view in self.subviews) {
        [view removeFromSuperview];
    }
    
    UILabel * top_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, DEVICE_WIDTH-20, 30)];
    top_label.text = @"热门服务";
    top_label.textAlignment = NSTextAlignmentLeft;
    top_label.font = [UIFont systemFontOfSize:15];
    top_label.textColor = RGBCOLOR(3, 3, 3);
    [self addSubview:top_label];
    
    int row = (int)_data_array.count/4+(_data_array.count%4?1:0);
    
    for (int i = 0; i < row; i++) {
        
        UIView * top_line_view = [[UIView alloc] initWithFrame:CGRectMake(0, top_label.bottom + (((DEVICE_WIDTH-1.5)/4.0)+0.5)*i, DEVICE_WIDTH, 0.5)];
        top_line_view.backgroundColor = LINE_COLOR;
        [self addSubview:top_line_view];
        
        for (int j = 0; j < 4; j++) {
            
            if (i*4+j < _data_array.count) {
                
                HotServerModel * model = _data_array[i*4+j];
                
                UIView * backGroundView = [[UIView alloc] initWithFrame:CGRectMake(((DEVICE_WIDTH-1.5)/4.0+1.5)*j, top_line_view.bottom, (DEVICE_WIDTH-1.5)/4.0,(DEVICE_WIDTH-1.5)/4.0)];
                backGroundView.tag = 100 + i*4+j;
                [self addSubview:backGroundView];
                
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
                [backGroundView addGestureRecognizer:tap];
                
                
                UIView * right_line_view = [[UIView alloc] initWithFrame:CGRectMake(backGroundView.right, backGroundView.top, 0.5, backGroundView.height)];
                right_line_view.backgroundColor = LINE_COLOR;
                [self addSubview:right_line_view];
                
                UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,30,30)];
                imageView.center = CGPointMake(backGroundView.width/2.0f, backGroundView.height/2.0-15);
                [imageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage  imageNamed:@"home_hot_service_default_img"]];
                [backGroundView addSubview:imageView];
                
                UILabel * title_label = [[UILabel alloc] initWithFrame:CGRectMake(5, backGroundView.height/2.0f+5, backGroundView.width-10, 20)];
                title_label.text = model.name;
                title_label.textAlignment = NSTextAlignmentCenter;
                title_label.textColor = RGBCOLOR(42, 42, 42);
                title_label.font = [UIFont systemFontOfSize:15];
                [backGroundView addSubview:title_label];
            }
        }
    }
    
    
    self.height = row*((DEVICE_WIDTH-1.5)/4.0) + top_label.height;
    
}

-(void)doTap:(UITapGestureRecognizer*)sender{
    if (hot_server_block) {
        hot_server_block((int)sender.view.tag - 100);
    }
    
}
-(void)sddHotServerClicked:(HotServerViewBlock)block{
    hot_server_block = block;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
