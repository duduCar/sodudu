//
//  SCityPickerView.h
//  嘟嘟车管家
//
//  Created by joinus on 16/1/26.
//  Copyright © 2016年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SCityPickerViewBlock)(NSString * province,NSString * city);

@interface SCityPickerView : UIView{
    SCityPickerViewBlock cityPickerViewBlock;
}


-(void)returnAreaWithBlock:(SCityPickerViewBlock)block;

/**
 *  是否显示
 */
-(void)pickerShow:(BOOL)show;

@end
