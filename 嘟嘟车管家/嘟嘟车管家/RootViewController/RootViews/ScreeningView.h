//
//  ScreeningView.h
//  嘟嘟车管家
//
//  Created by joinus on 15/10/14.
//  Copyright (c) 2015年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ScreeningViewButtonClickedBlock)(UIButton* button, int index,int pre_index);

@interface ScreeningView : UIView{
    ScreeningViewButtonClickedBlock button_block;
}

@property(nonatomic,assign)int current_index;

-(void)buttonClickedWith:(ScreeningViewButtonClickedBlock)block;

-(UIView*)initWithArray:(NSArray*)array;

-(void)setButtonTitle:(NSString*)title atIndex:(int)index;
-(void)resetButtonState;

@end
