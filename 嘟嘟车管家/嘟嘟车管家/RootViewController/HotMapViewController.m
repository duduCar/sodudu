//
//  HotMapViewController.m
//  嘟嘟车管家
//
//  Created by joinus on 15/11/17.
//  Copyright © 2015年 soulnear. All rights reserved.
//

#import "HotMapViewController.h"

@interface SDDPointAnnotation : MAPointAnnotation{
    
}

@property(nonatomic,assign)int add_tag;

@end


@interface SDDPointAnnotation ()

@end

@implementation SDDPointAnnotation

@end



@interface HotMapViewController ()<MAMapViewDelegate,UIActionSheetDelegate>{
    UILabel * shop_name_label;
    UILabel * address_label;
    
    
    ///地图跳转参数
    double from_lat;
    double from_lng;
}

@property(nonatomic,strong)MAMapView * mapView;

@property(nonatomic,strong)NSMutableArray * annotation_array;

@end

@implementation HotMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title_label.text = _server_name;
    
    if (_shops_array.count > 0) {
        [self setBottomView];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //配置用户Key
    [MAMapServices sharedServices].apiKey = @"8495b9c6c03000bdd8da2d91c52ebee9";
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64-(_shops_array.count?50:0))];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [_mapView setZoomLevel:13 animated:YES];
    if ([_server_name isEqualToString:@"停车场"]) {
        [_mapView setZoomLevel:15 animated:YES];
    }
    
    if (!_annotation_array) {
        _annotation_array = [NSMutableArray array];
    }else{
        [_annotation_array removeAllObjects];
    }
    
    for (int i = 0; i < _shops_array.count; i++) {
        AMapPOI * info = _shops_array[i];
        SDDPointAnnotation *pointAnnotation = [[SDDPointAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(info.location.latitude, info.location.longitude);
        pointAnnotation.title = info.name;
        pointAnnotation.subtitle = info.address;
        pointAnnotation.add_tag = i;
        [_annotation_array addObject:pointAnnotation];
    }
    
    [_mapView addAnnotations:_annotation_array];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _mapView.delegate = nil;
    _mapView = nil;
}

-(void)setBottomView{
    UIView * backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, DEVICE_HEIGHT-64-50, DEVICE_WIDTH, 50)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgroundView];
    
    AMapPOI * info = [_shops_array objectAtIndex:_index];
    
    shop_name_label = [ZTools createLabelWithFrame:CGRectMake(10, 5, DEVICE_WIDTH-70, 20) text:[NSString stringWithFormat:@"%d.%@",_index+1,info.name] textColor:RGBCOLOR(46, 46, 46) textAlignment:NSTextAlignmentLeft font:15];
    [backgroundView addSubview:shop_name_label];
    
    address_label = [ZTools createLabelWithFrame:CGRectMake(10, shop_name_label.bottom, DEVICE_WIDTH-70, 20) text:info.address textColor:DEFAULT_LINE_COLOR textAlignment:NSTextAlignmentLeft font:12];
    [backgroundView addSubview:address_label];
    
    UIButton * navigation_button = [ZTools createButtonWithFrame:CGRectMake(DEVICE_WIDTH-60, 10, 50, 30) title:@"导航" image:[UIImage imageNamed:@"map_navigation_image"]];
    navigation_button.titleLabel.font = [UIFont systemFontOfSize:13];
    [navigation_button setTitleColor:RGBCOLOR(46, 46, 46) forState:UIControlStateNormal];
    [navigation_button addTarget:self action:@selector(navigationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:navigation_button];
}


#pragma mark --------   高德地图
- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[SDDPointAnnotation class]])
    {
        SDDPointAnnotation * sdd_annotation = (SDDPointAnnotation*)annotation;
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        
        annotationView.tag = 1000 + sdd_annotation.add_tag;
        
        annotationView.image = [UIImage imageNamed:@"baidu_map_unselected_image"];
        if (sdd_annotation.add_tag == _index) {
            annotationView.image = [UIImage imageNamed:@"baidu_map_selected_image"];
            annotationView.canShowCallout = YES;
        }
        
        UILabel * label = [ZTools createLabelWithFrame:CGRectMake(0, 5, annotationView.width, 10) text:[NSString stringWithFormat:@"%d",sdd_annotation.add_tag+1] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:10];
        [annotationView addSubview:label];
        
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    int selected_index = (int)view.tag-1000;
    
    if (selected_index > _shops_array.count) {
        return;
    }
    
    if (selected_index == _index) {
        return;
    }
    
    MAPinAnnotationView *pre_AnnotationView = [_mapView viewWithTag:1000+_index];
    pre_AnnotationView.image = [UIImage imageNamed:@"baidu_map_unselected_image"];
    view.image = [UIImage imageNamed:@"baidu_map_selected_image"];
    
    AMapPOI * info = [_shops_array objectAtIndex:view.tag-1000];
    shop_name_label.text = [NSString stringWithFormat:@"%d.%@",(int)view.tag-1000+1,info.name];
    address_label.text = info.address;
    
    _index = selected_index;
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.latitude);
//        [mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude) animated:YES];
        
        from_lat = userLocation.coordinate.latitude;
        from_lng = userLocation.coordinate.longitude;
    }
}



#pragma mark ------  导航按钮
-(void)navigationButtonClicked:(UIButton*)button{
    
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"请选择地图" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"使用手机自带地图",@"使用百度地图", nil];
    [sheet showInView:self.view];
}

#pragma mark -------- UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    AMapPOI * info = [_shops_array objectAtIndex:_index];
    
    switch (buttonIndex) {
        case 2:
        {//取消
            
        }
            break;
        case 1:
        {//百度
            [self callMapWithType:@"百度" fromLat:from_lat fromLng:from_lng toLat:info.location.latitude toLng:info.location.longitude WithTitle:info.name];
        }
            break;
        case 0:
        {//手机
            [self callMapWithType:@"手机" fromLat:from_lat fromLng:from_lng toLat:info.location.latitude toLng:info.location.longitude WithTitle:info.name];
        }
            break;
            
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
