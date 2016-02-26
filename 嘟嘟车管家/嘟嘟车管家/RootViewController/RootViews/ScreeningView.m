//
//  ScreeningView.m
//  嘟嘟车管家
//
//  Created by joinus on 15/10/14.
//  Copyright (c) 2015年 soulnear. All rights reserved.
//

#import "ScreeningView.h"

@implementation ScreeningView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(UIView*)initWithArray:(NSArray *)array{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, DEVICE_WIDTH, 44);
        self.backgroundColor = [UIColor whiteColor];
        
        for (int i = 0; i < 3; i++) {
            UIButton * button = [ZTools createButtonWithFrame:CGRectMake(10+((DEVICE_WIDTH-40)/3.0f+10)*i, 0, (DEVICE_WIDTH-40)/3.0f, self.height) title:array[i] image:[UIImage imageNamed:@"seller_bottom_arrow_image"]];
            button.tag = 100+i;
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"seller_top_arrow_image"] forState:UIControlStateSelected];
            
            CGSize size = [ZTools stringHeightWithFont:[UIFont systemFontOfSize:15] WithString:array[i] WithWidth:button.width];
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, (size.width+button.width)/2, 0, 0)];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
            if (i != 0) {
                UIView * line_view = [[UIView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH/3.0f*i, 10, 0.5, self.height-20)];
                line_view.backgroundColor = [UIColor grayColor];
                [self addSubview:line_view];
            }
        }
        
        UIView * bottom_line_view = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-0.5, DEVICE_WIDTH, 0.5)];
        bottom_line_view.backgroundColor = [UIColor grayColor];
        [self addSubview:bottom_line_view];
    }
    
    return self;
}

-(void)buttonClicked:(UIButton*)button{
    button.selected = !button.selected;
    UIButton * pre_button;
    if (_current_index !=0 && _current_index != button.tag) {
        pre_button = (UIButton*)[self viewWithTag:_current_index];
        pre_button.selected = !pre_button;
    }
    if (button_block) {
        button_block(button,(int)button.tag-100,_current_index-100);
    }    
    
    _current_index = (int)button.tag;
}

-(void)buttonClickedWith:(ScreeningViewButtonClickedBlock)block{
    button_block = block;
}

-(void)setButtonTitle:(NSString*)title atIndex:(int)index{
    UIButton * button = (UIButton*)[self viewWithTag:index+100];
    [button setTitle:title forState:UIControlStateNormal];
    button.selected = !button.selected;
}

-(void)resetButtonState{
    for (int i = 0; i<3; i++) {
        UIButton * button = (UIButton*)[self viewWithTag:i+100];
        button.selected = NO;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
