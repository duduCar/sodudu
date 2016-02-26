//
//  MyViewController.h
//  推盟
//
//  Created by joinus on 15/7/30.
//  Copyright (c) 2015年 joinus. All rights reserved.
//
/**
 base viewcontroller
 */

#import <UIKit/UIKit.h>


typedef enum
{
    MyViewControllerButtonTypeBack=0,
    MyViewControllerButtonTypelogo=1,
    MyViewControllerButtonTypePhoto=2,
    MyViewControllerButtonTypeNull=3,
    MyViewControllerButtonTypeText = 4
}MyViewControllerButtonType;


typedef void(^SDDLocationManagerBlock)(double lat,double lng,CLPlacemark *placemark);



@interface MyViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,CLLocationManagerDelegate>{
    MyViewControllerButtonType leftType;
    MyViewControllerButtonType rightType;
    /**
     *  加载中提示
     */
    MBProgressHUD * loading_hud;
    
    CLLocationManager * locationManager;
    
    SDDLocationManagerBlock sdd_location_manager_block;
}

/**
 *  如果为text类型，代表显示文字，如果为photo类型，代表图片名称
 */
@property(nonatomic,strong)NSString * right_string;
/**
 *  导航栏右侧按钮
 */
@property(nonatomic,strong)UIButton * right_button;
/**
 *  如果为text类型，代表显示文字，如果为photo类型，代表图片名称
 */
@property(nonatomic,strong)NSString * left_string;
/**
 *  导航栏左侧按钮
 */
@property(nonatomic,strong)UIButton * left_button;
/**
 *  标题
 */
@property(nonatomic,strong)UILabel * title_label;

/**
 *  左侧按钮点击方法
 */
-(void)leftButtonTap:(UIButton *)sender;


/**
 *  右侧按钮点击方法
 */
-(void)rightButtonTap:(UIButton *)sender;


/**
 *  设置导航栏左侧按钮类型
 *
 *  @param lType   按钮类型 默认为MyViewControllerButtonTypeNull
 *  @param lString 按钮内容
 */
-(void)setMyViewControllerLeftButtonType:(MyViewControllerButtonType)lType WihtLeftString:(NSString *)lString;
/**
 *  设置导航栏右侧按钮类型
 *
 *  @param rType   按钮类型 默认为MyViewControllerButtonTypeNull
 *  @param rString 按钮内容
 */
-(void)setMyViewControllerRightButtonType:(MyViewControllerButtonType)rType WihtRightString:(NSString *)rString;
/**
 *  界面延时消失
 *
 *  @param isPop 消失方式（pop(1)/dismiss(0)）
 *  @param dur   消失时间
 */
-(void)disappearWithPOP:(BOOL)isPop afterDelay:(float)dur;
/**
 *  开始加载动画
 */
-(void)startLoading;
/**
 *  结束加载动画
 */
-(void)endLoading;

///获取用户当前地理位置
-(void)setupLocationManagerWith:(SDDLocationManagerBlock)block;

///跳转到第三方地图
-(void)callMapWithType:(NSString*)type fromLat:(double)from_lat fromLng:(double)from_lng toLat:(double)to_lat toLng:(double)to_lng WithTitle:(NSString*)title;
///跳转
-(void)pushToViewController:(UIViewController*)vc withAnimation:(BOOL)animation;

/**
 *  登录
 */
-(void)login;
@end










