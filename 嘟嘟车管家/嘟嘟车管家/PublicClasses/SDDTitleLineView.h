//
//  SDDTitleLineView.h
//  嘟嘟车管家
//
//  Created by joinus on 15/12/9.
//  Copyright © 2015年 soulnear. All rights reserved.
//
/*
 **公共类  默认加载左侧对齐的标题跟，标题下方加一条线
 */

#import <UIKit/UIKit.h>

@interface SDDTitleLineView : UIView
///标题
@property(nonatomic,strong)NSString * title;
///内容视图
@property(nonatomic,strong)UIView * contentView;

-(id)initWithFrame:(CGRect)frame WithTitle:(NSString *)aTitle;

@end
