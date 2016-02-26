//
//  PACollectionViewCell.h
//  嘟嘟车管家
//
//  Created by joinus on 15/12/3.
//  Copyright © 2015年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAModel.h"

@interface PACollectionViewCell : UICollectionViewCell{
    
}
///头图
@property(nonatomic,strong)UIImageView * header_imageView;
///标题
@property(nonatomic,strong)UILabel * title_label;
///副标题
@property(nonatomic,strong)UILabel * sub_title_label;
///价格
@property(nonatomic,strong)UILabel * price_label;
///标签
@property(nonatomic,strong)UILabel * tag_label;


-(void)setInfomationWithPAModel:(PAModel*)model;

@end
