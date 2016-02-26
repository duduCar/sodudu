//
//  SDDMapViewController.m
//  嘟嘟车管家
//
//  Created by joinus on 15/10/15.
//  Copyright (c) 2015年 soulnear. All rights reserved.
//

#import "SDDMapViewController.h"

@interface SDDMapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate,UIActionSheetDelegate>{
    CLLocationManager * locationManager;
}

@end

@implementation SDDMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title_label.text = _title_string;
    [self setMyViewControllerRightButtonType:MyViewControllerButtonTypeText WihtRightString:@"导航"];
    
    _myMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT-64)];
    _myMapView.mapType=MKMapTypeStandard;
    _myMapView.delegate=self;
    _myMapView.showsUserLocation=NO;
    [self.view addSubview:_myMapView];
    
    
    MKCoordinateSpan span;
    MKCoordinateRegion region;
    
    span.latitudeDelta=0.05;
    span.longitudeDelta=0.05;
    region.span=span;
    region.center=CLLocationCoordinate2DMake(_address_latitude,_address_longitude);//[userLocation coordinate];
    
    [_myMapView setRegion:region animated:YES];
    
    MKPointAnnotation *ann = [[MKPointAnnotation alloc] init];
    ann.coordinate = region.center;
    [ann setTitle:_address_title];
    [ann setSubtitle:_address_content];
    //触发viewForAnnotation
    [_myMapView addAnnotation:ann];
    
    
    
    UIButton * center_button = [UIButton buttonWithType:UIButtonTypeCustom];
    center_button.frame = CGRectMake(DEVICE_WIDTH-40-12,DEVICE_HEIGHT-56-12-64,40,40);
    center_button.backgroundColor = [UIColor whiteColor];
    //    center_button.layer.masksToBounds = YES;
    center_button.layer.cornerRadius = 3;
    center_button.layer.shadowColor = [UIColor blackColor].CGColor;
    center_button.layer.shadowOffset = CGSizeMake(-0.1,-0.1);
    center_button.layer.shadowOpacity = 0.3;
    center_button.layer.shadowRadius = 1;
    [center_button setImage:[UIImage imageNamed:@"map_icon_mine"] forState:UIControlStateNormal];
    [center_button addTarget:self action:@selector(centerButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:center_button];
    
    
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];

}

-(void)rightButtonTap:(UIButton *)sender{
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"请选择地图" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"使用手机自带地图",@"使用百度地图", nil];
    [sheet showInView:self.view];
}

#pragma mark - 回到获取到的位置
-(void)centerButtonTap:(UIButton *)button
{
    [_myMapView setCenterCoordinate:CLLocationCoordinate2DMake(_address_latitude,_address_longitude) animated:YES];
}


#pragma mark-MapViewDelegate

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    userLatitude=userLocation.coordinate.latitude;
    userlongitude=userLocation.coordinate.longitude;
    
    MKCoordinateSpan span;
    MKCoordinateRegion region;
    
    span.latitudeDelta=0.010;
    span.longitudeDelta=0.010;
    region.span=span;
    region.center=[userLocation coordinate];
    
    [_myMapView setRegion:[_myMapView regionThatFits:region] animated:YES];
}

#pragma mark - 定位
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [manager stopUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error)
     {
         userLatitude = newLocation.coordinate.latitude;
         userlongitude =  newLocation.coordinate.longitude;
     }];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 2:
        {//取消
            
        }
            break;
        case 1:
        {//百度
            [self callMapWithType:@"百度" fromLat:userLatitude fromLng:userlongitude toLat:_address_latitude toLng:_address_longitude WithTitle:_address_title];
        }
            break;
        case 0:
        {//手机
            [self callMapWithType:@"手机" fromLat:userLatitude fromLng:userlongitude toLat:_address_latitude toLng:_address_longitude WithTitle:_address_title];
        }
            break;
            
        default:
            break;
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
