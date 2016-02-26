//
//  MyViewController.m
//  推盟
//
//  Created by joinus on 15/7/30.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "MyViewController.h"
#import <MapKit/MapKit.h>

@interface MyViewController (){
    float keyboard_height;
}

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = RGBCOLOR(78, 78, 78);
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    _title_label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,200, 44)];
    _title_label.textColor = RGBCOLOR(27, 27, 27);
    _title_label.textAlignment = NSTextAlignmentCenter;
    _title_label.font = [UIFont systemFontOfSize:18];
    self.navigationItem.titleView = _title_label;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

}

-(void)setMyViewControllerLeftButtonType:(MyViewControllerButtonType)lType WihtLeftString:(NSString *)lString{
    leftType = lType;
    
    if (lString.length != 0)
    {
        NSString * title = @"";
        NSString * image_name = @"";
        if (lType == MyViewControllerButtonTypeBack) {
            image_name = @"back.png";
        }else if (lType == MyViewControllerButtonTypelogo){
            image_name = @"logo.png";
        }else if (lType == MyViewControllerButtonTypePhoto){
            image_name = lString;
        }else if (lType == MyViewControllerButtonTypeText){
            title = lString;
        }
        
        _left_button = [UIButton buttonWithType:UIButtonTypeCustom];
        _left_button.frame = CGRectMake(0,0,40,40);
        _left_button.userInteractionEnabled = NO;
        [_left_button setTitle:title forState:UIControlStateNormal];
        [_left_button setTitleColor:RGBCOLOR(168, 168, 168) forState:UIControlStateNormal];
        [_left_button setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
        [_left_button addTarget:self action:@selector(leftButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        if (image_name.length > 0) {
            UIImage * image = [UIImage imageNamed:image_name];
            [_left_button setImage:image forState:UIControlStateNormal];
            _left_button.width = image.size.width;
            _left_button.left = 0;
        }
        
        UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0,0,50,44);
        [leftButton addTarget:self action:@selector(leftButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [leftButton addSubview:_left_button];

        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    }
    
    
}

-(void)setMyViewControllerRightButtonType:(MyViewControllerButtonType)rType WihtRightString:(NSString *)rString{
    rightType = rType;
    if (rString.length != 0)
    {
        NSString * title = @"";
        NSString * image_name = @"";
        if (rType == MyViewControllerButtonTypeBack) {
            image_name = @"back.png";
        }else if (rType == MyViewControllerButtonTypelogo){
            image_name = @"logo.png";
        }else if (rType == MyViewControllerButtonTypePhoto){
            image_name = rString;
        }else if (rType == MyViewControllerButtonTypeText){
            title = rString;
        }
        
        _right_button = [UIButton buttonWithType:UIButtonTypeCustom];
        _right_button.frame = CGRectMake(0,0,50,44);
        _right_button.titleLabel.textAlignment = NSTextAlignmentRight;
        _right_button.userInteractionEnabled = NO;
        _right_button.titleLabel.font = [UIFont systemFontOfSize:16];
        [_right_button setTitle:title forState:UIControlStateNormal];
        [_right_button setTitleColor:RGBCOLOR(168, 168, 168) forState:UIControlStateNormal];
        _right_button.imageView.contentMode = UIViewContentModeScaleToFill;
        
        if (image_name.length > 0) {
            UIImage * image = [UIImage imageNamed:image_name];
            [_right_button setImage:image forState:UIControlStateNormal];
            _right_button.width = image.size.width;
            _right_button.right = 50;
        }else if(title.length > 0){
            CGSize size = [ZTools stringHeightWithFont:[UIFont systemFontOfSize:16] WithString:title WithWidth:MAXFLOAT];
            _right_button.width = size.width;
            _right_button.right = 50;
        }
        
        UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0,0,50,44);
        [rightButton addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton addSubview:_right_button];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    }
}

/**
 *  左侧按钮点击方法
 */
-(void)leftButtonTap:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  左侧按钮点击方法
 */
-(void)rightButtonTap:(UIButton *)sender{
    
    
}

-(void)setRight_string:(NSString *)right_string{
    if (rightType == MyViewControllerButtonTypePhoto) {
        [_right_button setImage:[UIImage imageNamed:right_string] forState:UIControlStateNormal];
    }else if (rightType == MyViewControllerButtonTypeText){
        [_right_button setTitle:right_string forState:UIControlStateNormal];
    }
}
-(void)setLeft_string:(NSString *)left_string{
    if (leftType == MyViewControllerButtonTypePhoto) {
        [_left_button setImage:[UIImage imageNamed:left_string] forState:UIControlStateNormal];
    }else if (leftType == MyViewControllerButtonTypeText){
        [_left_button setTitle:left_string forState:UIControlStateNormal];
    }
}

-(void)restLeftButtonWithImageName:(NSString*)imageName{
    
}


- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboard_height = keyboardRect.size.height;
}

#pragma mark - 全局文本框

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //[self animateTextField: textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    float movement = 0;

    if (DEVICE_HEIGHT - keyboard_height - self.view.top < textField.bottom) {
        movement = DEVICE_HEIGHT  - keyboard_height - textField.bottom - 20;

        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration:0.2];
        self.view.top = movement;//CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    
}

#define kTextFieldDruation 0.25f
#define kTextFieldMovementDistance [UIScreen mainScreen].bounds.size.height * 0.2

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const float movementDuration = kTextFieldDruation; // tweak as needed
    
    float up_distance = 0;
    if ((DEVICE_HEIGHT - 253 - self.view.top < textField.bottom) && up) {
        up_distance = DEVICE_HEIGHT - 220 - self.view.top - textField.bottom;
    }
    
    int movement = (up ? up_distance : 64);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.top = movement;//CGRectOffset(self.view.frame, 0,up?movement:0);
    [UIView commitAnimations];
}

- (void) animateTextView: (UITextView*) textField up: (BOOL) up
{
    const int movementDistance = kTextFieldMovementDistance; // tweak as needed
    const float movementDuration = kTextFieldDruation; // tweak as needed
   
    int movement = (up ? -movementDistance : 0);
    
    if (DEVICE_HEIGHT - textField.bottom < 240 && up) {
        movement = DEVICE_HEIGHT - 44 - 230 - textField.bottom;
    }
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.top = 64;//CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


#pragma mark -=-=-=-=-   返回前一菜单   -=-=-=-=-=-=
-(void)disappearWithPOP:(BOOL)isPop afterDelay:(float)dur{
    [self performSelector:@selector(disappear:) withObject:[NSString stringWithFormat:@"%d",isPop] afterDelay:dur];
}

-(void)disappear:(NSString*)isPop{
    NSLog(@"zhang------%@",isPop);
    if (isPop.intValue == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

-(void)startLoading{
    dispatch_async(dispatch_get_main_queue(), ^{
        loading_hud = [ZTools showMBProgressWithText:@"加载中..." WihtType:MBProgressHUDModeIndeterminate addToView:self.view isAutoHidden:NO];
    });
}
-(void)endLoading{
    [loading_hud hide:YES];
}




#pragma mark ----------   获取用户当前地理位置
-(void)setupLocationManagerWith:(SDDLocationManagerBlock)block{
    
    sdd_location_manager_block = block;
    
    locationManager = [[CLLocationManager alloc] init] ;
    
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog( @"Starting CLLocationManager" );
        locationManager.delegate = self;
        locationManager.distanceFilter = 200;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [locationManager requestWhenInUseAuthorization];
        }
        [locationManager startUpdatingLocation];
        
    } else {
        //提示用户无法进行定位操作
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位不成功 ,请确认开启定位" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

#pragma mark - 定位
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    
    [locationManager stopUpdatingLocation];
    
    
    // 停止位置更新
    [manager stopUpdatingLocation];
    
    CLLocation *currentLocation = [locations lastObject];
    // 获取经纬度
    NSLog(@"纬度:%f",currentLocation.coordinate.latitude);
    NSLog(@"经度:%f",currentLocation.coordinate.longitude);
    double lat = currentLocation.coordinate.latitude;
    double lng = currentLocation.coordinate.longitude;
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0)
        {
            CLPlacemark *placemark = [array objectAtIndex:0];
//            //将获得的所有信息显示到label上
//            NSLog(@"%@",placemark.name);
//            //获取城市
//            for (CityInfo * info in _city_array) {
//                if ([placemark.locality rangeOfString:info.name].length > 0) {
//                    location_city = info.name;
//                }
//            }
//            NSLog(@"city -----   %@",location_city);
            
            if (sdd_location_manager_block) {
                sdd_location_manager_block(lat,lng,placemark);
            }
        }
    }];
}


-(void)callMapWithType:(NSString*)type fromLat:(double)from_lat fromLng:(double)from_lng toLat:(double)to_lat toLng:(double)to_lng WithTitle:(NSString*)title{
    if ([type isEqualToString:@"百度"]) {
        ///name:起始位置
        NSString * string = [NSString stringWithFormat:@"baidumap://map/direction?origin=%f,%f&destination=%f,%f&mode=driving&src=sodudu",from_lat,from_lng,to_lat,to_lng];
        
        UIApplication *app = [UIApplication sharedApplication];
        
        if ([app canOpenURL:[NSURL URLWithString:string]])
        {
            [app openURL:[NSURL URLWithString:string]];
        }else
        {
            [ZTools showMBProgressWithText:@"您还没有安转百度地图" WihtType:MBProgressHUDModeText addToView:[UIApplication sharedApplication].keyWindow isAutoHidden:YES];
        }
    }else{
        
        CLLocationCoordinate2D from = CLLocationCoordinate2DMake(from_lat,from_lng);
        MKPlacemark * fromMark = [[MKPlacemark alloc] initWithCoordinate:from
                                                       addressDictionary:nil];
        MKMapItem * fromLocation = [[MKMapItem alloc] initWithPlacemark:fromMark];
        fromLocation.name = @"我的位置";
        
        
        CLLocationCoordinate2D to = CLLocationCoordinate2DMake(to_lat,to_lng);
        MKPlacemark * toMark = [[MKPlacemark alloc] initWithCoordinate:to
                                                     addressDictionary:nil];
        MKMapItem * toLocation = [[MKMapItem alloc] initWithPlacemark:toMark];
        toLocation.name = title;
        
        NSArray  * values = [NSArray arrayWithObjects:
                             MKLaunchOptionsDirectionsModeDriving,
                             [NSNumber numberWithBool:YES],
                             [NSNumber numberWithInt:2],
                             nil];
        NSArray * keys = [NSArray arrayWithObjects:
                          MKLaunchOptionsDirectionsModeKey,
                          MKLaunchOptionsShowsTrafficKey,
                          MKLaunchOptionsMapTypeKey,nil];
        
        [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:fromLocation, toLocation, nil]
                       launchOptions:[NSDictionary dictionaryWithObjects:values
                                                                 forKeys:keys]];
    }
}

-(void)pushToViewController:(UIViewController*)vc withAnimation:(BOOL)animation{
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:animation];
}
-(void)login{
    if (![ZTools isLogin]) {
        LogInViewController * login = [LogInViewController sharedManager];
        UINavigationController * navc = [[UINavigationController alloc] initWithRootViewController:login];
        [self presentViewController:navc animated:YES completion:NULL];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
