//
//  RootViewController.m
//  嘟嘟车管家
//
//  Created by joinus on 15/10/13.
//  Copyright (c) 2015年 soulnear. All rights reserved.
//

#import "RootViewController.h"
#import "CommentModel.h"
#import "CommentTableViewCell.h"
#import "SellerListViewController.h"
#import "CityModel.h"
#import "SDDCityView.h"
#import "AppDelegate.h"
#import <MapKit/MapKit.h>
#import "SDDSearchViewController.h"
#import "HotServerView.h"
#import "HotServerModel.h"
#import "MyWebViewController.h"
#import "HotMapListViewController.h"
#import "SellerDetailViewController.h"
#import "RootADModel.h"

@interface RootViewController ()<UITableViewDataSource,SNRefreshDelegate,UISearchBarDelegate,CLLocationManagerDelegate>{
    UIView * section_header_view;
    UIButton * left_button;
    SDDCityView * city_view;
    CLLocationManager * locationManager;
    NSString * location_city;
    double lat;
    double lng;
    
    NSArray * titles_array;
}

@property(nonatomic,strong)SNRefreshTableView * myTableView;
///评论
@property(nonatomic,strong)NSMutableArray * data_array;
///城市
@property(nonatomic,strong)NSMutableArray * city_array;
///热门服务
@property(nonatomic,strong)NSMutableArray * hot_server_array;
///广告
@property(nonatomic,strong)NSMutableArray * ad_array;
@property(nonatomic,strong)AppDelegate * mydelegate;
@end

@implementation RootViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title_label.text = @"嘟嘟车管家";
    [self setMyViewControllerRightButtonType:MyViewControllerButtonTypeText WihtRightString:@"   "];
    self.right_button.enabled = NO;
    
    _data_array = [NSMutableArray array];
    
    titles_array = @[CAR_XICHE,CAR_WEIXIU,CAR_MEIRONG,CAR_PEIJIAN,CAR_BAOXIAN,CAR_SSSS,CAR_ZULIN];
    
    _myTableView = [[SNRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) showLoadMore:NO];
    _myTableView.refreshDelegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    [_myTableView showRefreshHeader:YES];
    
    [self createSectionHeaderView];
    
    [self startLoading];
    [self loadCityListData];

    [self createLeftItem];
    [self setupLocationManager];
    
    
   // [self login];
}
-(void)createLeftItem{
    NSString * city = [ZTools getSelectedCity];
    left_button = [ZTools createButtonWithFrame:CGRectMake(0, 0, 60, 44) title:city.length>0?city:@"北京" image:[UIImage imageNamed:@"seller_bottom_arrow_image"]];
    [left_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    left_button.titleLabel.font = [UIFont systemFontOfSize:15];
    [left_button setImage:[UIImage imageNamed:@"seller_top_arrow_image"] forState:UIControlStateSelected];
    
    CGSize size = [ZTools stringHeightWithFont:[UIFont systemFontOfSize:15] WithString:@"北京" WithWidth:left_button.width];
    [left_button setImageEdgeInsets:UIEdgeInsetsMake(0, (size.width+left_button.width)/2, 0, 0)];
    [left_button setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    [left_button addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left_button];
}
-(void)leftButtonClicked:(UIButton*)button{
    button.selected = !button.selected;
    
    if (button.selected) {
        if (!city_view) {
            city_view = [[SDDCityView alloc] initWithFrame:CGRectZero WithLocal:@"北京" WithOther:_city_array];
        }
        [self.view addSubview:city_view];
        __weak typeof(self)wself = self;
        [city_view setLocal:location_city?location_city:@"定位失败" Cities:_city_array];
        [city_view selectedCity:^(NSString *city, NSString *city_id) {
            button.selected = !button.selected;
            [ZTools setSelectedCity:city];
            [left_button setTitle:city forState:UIControlStateNormal];
            [city_view removeFromSuperview];
            [wself.myTableView showRefreshHeader:YES];
            [wself loadNewestCommentData];
        }];
    }else{
        [city_view removeFromSuperview];
    }
}

-(void)setupLocationManager{
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

#pragma mark -----   数据请求（最新评论+热门服务+广告）
-(void)loadNewestCommentData{
    __weak typeof(self)wself = self;
    NSString * selected_city = [ZTools getSelectedCity];
    NSString * city = selected_city.length?selected_city:location_city.length?location_city:@"北京";
    CityInfo * info = [ZTools findCityInfoWith:city];
    
    NSDictionary * dic = @{@"city":info?info.ename:@""};
    [[ZAPI manager] sendPost:NEWEST_COMMENT_URL myParams:dic success:^(id data) {
        [wself endLoading];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            [wself.data_array removeAllObjects];
            [wself createHotServerArray];
            [wself createADArray];
            wself.myTableView.isHaveMoreData = YES;
            NSArray * comment_array = data[@"comment"];
            if (comment_array && [comment_array isKindOfClass:[NSArray class]]) {
                if (comment_array.count > 0) {
                    for (NSDictionary * dic in comment_array) {
                        CommentModel * model = [[CommentModel alloc] initWithDictionary:dic];
                        [wself.data_array addObject:model];
                    }
                }else{
                    wself.myTableView.isHaveMoreData = NO;
                }
            }
            
            NSArray * service_array = data[@"service"];
            
            if (service_array && [service_array isKindOfClass:[NSArray class]]) {
                for (NSDictionary * item in service_array) {
                    HotServerModel * model = [[HotServerModel alloc] initWithDictionary:item];
                    [wself.hot_server_array addObject:model];
                }
                
            }
            
            NSArray * ad_arr = data[@"ad"];
            if (ad_arr && [ad_arr isKindOfClass:[NSArray class]]) {
                for (NSDictionary * item in ad_arr) {
                    RootADModel * model = [[RootADModel alloc] initWithDictionary:item];
                    [wself.ad_array addObject:model];
                }
            }
            
            [wself createSectionHeaderView];
        }
        [wself.myTableView finishReloadigData];
    } failure:^(NSError *error) {
        [wself endLoading];
    }];
}
-(void)loadCityListData{
    __weak typeof(self)wself = self;
    [[ZAPI manager] sendGet:CITY_LIST_URL success:^(id data) {
        if (data && [data isKindOfClass:[NSArray class]]) {
            [wself cityData:data];
        }else{
            [wself cityData:nil];
        }
        [wself.myTableView finishReloadigData];
    } failure:^(NSError *error) {
        [wself cityData:nil];
    }];
}

-(void)cityData:(NSArray*)array{
    
    if (!_city_array) {
        _city_array = [NSMutableArray array];
    }
    [_city_array removeAllObjects];
   
    if (!array) {
        array = [CityInfo MR_findAll];
        NSLog(@"city --------   %lu",(unsigned long)array.count);
        [_city_array addObjectsFromArray:array];
    }else{
        [CityInfo MR_truncateAll];
        
        for (NSDictionary * dic in array) {
            CityInfo * info = [CityInfo MR_createEntity];
            info.id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
            info.name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
            info.ename = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ename"]];
            info.listname = [NSString stringWithFormat:@"%@",[dic objectForKey:@"listname"]];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            
            [_city_array addObject:info];
        }
    }
    
    [_myTableView finishReloadigData];
}

-(void)createHotServerArray{
    if (!_hot_server_array) {
        _hot_server_array = [NSMutableArray array];
    }else{
        [_hot_server_array removeAllObjects];
    }
}
-(void)createADArray{
    if (!_ad_array) {
        _ad_array = [NSMutableArray array];
    }else{
        [_ad_array removeAllObjects];
    }
}

#pragma mark -----   创建SectionView
-(UIView*)createSectionHeaderView{
    if (!section_header_view) {
        section_header_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 300)];
        section_header_view.backgroundColor = RGBCOLOR(234, 234, 234);
    }else{
        for (UIView * view in section_header_view.subviews) {
            [view removeFromSuperview];
        }
    }
    
    UISearchBar * search_bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 40)];
    search_bar.placeholder = @"请输入地名或商家";
    search_bar.delegate = self;
    [section_header_view addSubview:search_bar];
    
    
    UIView * service_view = [[UIView alloc] initWithFrame:CGRectMake(0, search_bar.height, DEVICE_WIDTH, 240)];
    service_view.backgroundColor = [UIColor whiteColor];
    [section_header_view addSubview:service_view];
    
    
    NSArray * images_array = @[@"root_xiche_image",@"root_weixiu_image",@"root_meirong_image",@"root_peijian_image",@"root_chexian_image",@"root_ssss_image",@"root_zulin_image"];
    float image_width =  [ZTools autoWidthWith:64];
    float image_height = image_width*90/64;
    for (int i = 0; i < titles_array.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(15+((DEVICE_WIDTH-30-image_width*4)/3 + image_width)*(i%4), 20+(image_height+25)*(i/4), image_width, image_height);
        button.tag = 100 + i;
        [button setImage:[UIImage imageNamed:images_array[i]] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0,0,image_height - image_width,0)];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [service_view addSubview:button];
        
        UILabel * name_label = [ZTools createLabelWithFrame:CGRectMake(0, image_height-20, image_width, 20) text:titles_array[i] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter font:15*image_width/64];
        [button addSubview:name_label];
    }
    
    service_view.height = image_height*2 + 65;
    
    if (_hot_server_array.count > 0) {
        //热门服务
        HotServerView * hot_view = [[HotServerView alloc] initWithFrame:CGRectMake(0, service_view.bottom+10, DEVICE_WIDTH, 0)];
        hot_view.backgroundColor = [UIColor whiteColor];
        hot_view.data_array = _hot_server_array;
        [section_header_view addSubview:hot_view];
        
        __weak typeof(self)wself = self;
        [hot_view sddHotServerClicked:^(int index) {
            HotServerModel * model = wself.hot_server_array[index];
            NSLog(@"index ----   %d",index);
            
            if ([model.isweb intValue] == 1) {
                MyWebViewController * webView = [[MyWebViewController alloc] init];
                webView.myURL = model.url;
                webView.title_string = model.name;
                webView.hidesBottomBarWhenPushed = YES;
                [wself.navigationController pushViewController:webView animated:YES];
            }else if ([model.isweb intValue] == 0){
                HotMapListViewController * hot_map_vc = [[HotMapListViewController alloc] init];
                hot_map_vc.server_name = model.name;
                hot_map_vc.hidesBottomBarWhenPushed = YES;
                [wself.navigationController pushViewController:hot_map_vc animated:YES];
            }
        }];
        
        section_header_view.height = hot_view.bottom+10;
    }else{
        section_header_view.height = service_view.bottom + 10;
    }
    
    
    if (_ad_array.count > 0) {
        ///广告
        float ad_total_height = 0;
        for (int i = 0; i < _ad_array.count; i++) {
            RootADModel * model = [_ad_array objectAtIndex:i];
            float ad_imageView_height = model.height*DEVICE_WIDTH/model.width;
            UIImageView * ad_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, section_header_view.height + (ad_imageView_height+10)*i, DEVICE_WIDTH, ad_imageView_height)];
            ad_imageView.userInteractionEnabled = YES;
            ad_imageView.tag = 10000+i;
            [ad_imageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"home_ad_default_img_big"]];
            [section_header_view addSubview:ad_imageView];
            
            UITapGestureRecognizer * ad_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adTap:)];
            [ad_imageView addGestureRecognizer:ad_tap];
            
            ad_total_height += ad_imageView_height + 10;
        }
        
        section_header_view.height += ad_total_height;
    }
    
    ///热门评论
    UIView * hot_comments_view = [[UIView alloc] initWithFrame:CGRectMake(0, section_header_view.height, DEVICE_WIDTH, 30)];
    hot_comments_view.backgroundColor = [UIColor whiteColor];
    [section_header_view addSubview:hot_comments_view];
 
    UILabel * top_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, DEVICE_WIDTH-20, 30)];
    top_label.text = @"热门评论";
    top_label.textAlignment = NSTextAlignmentLeft;
    top_label.font = [UIFont systemFontOfSize:15];
    top_label.textColor = RGBCOLOR(3, 3, 3);
    [hot_comments_view addSubview:top_label];
    

    UIView * comments_line_view = [[UIView alloc] initWithFrame:CGRectMake(0, hot_comments_view.height-0.5, DEVICE_WIDTH, 0.5)];
    comments_line_view.backgroundColor = DEFAULT_LINE_COLOR;
    [hot_comments_view addSubview:comments_line_view];
    
    section_header_view.height = hot_comments_view.bottom;
   
    self.myTableView.tableHeaderView = section_header_view;
    return section_header_view;
}

#pragma mark ---  选取服务栏目
-(void)buttonClicked:(UIButton*)button{
    SellerListViewController * viewController = [[SellerListViewController alloc] init];
    viewController.column_id = [ZTools findColumnId:titles_array[button.tag-100]];
    viewController.lat = lat;
    viewController.lng = lng;
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma mark ------  点击跳转到广告页面
-(void)adTap:(UITapGestureRecognizer*)sender{
    RootADModel * model = [_ad_array objectAtIndex:sender.view.tag-10000];
    MyWebViewController * webView = [[MyWebViewController alloc] init];
    webView.myURL = model.url;
    webView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webView animated:YES];
}
#pragma mark ------  UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data_array.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    CommentTableViewCell * cell = (CommentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    CommentModel * model = _data_array[indexPath.row];
    [cell setInfomationWith:model];
    
    return cell;
}
#pragma mark -----  SNRefreshTableViewDelegate
- (void)loadNewData{
    [self loadNewestCommentData];
}
- (void)loadMoreData{
    
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_myTableView deselectRowAtIndexPath:indexPath animated:YES];
    CommentModel * model = _data_array[indexPath.row];
    SellerDetailViewController * detail = [[SellerDetailViewController alloc] init];
    detail.shop_id = model.shopid;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    CommentModel * model = _data_array[indexPath.row];
    CGSize content_size = [ZTools stringHeightWithFont:[UIFont systemFontOfSize:13] WithString:model.content WithWidth:DEVICE_WIDTH-80];
    
    return content_size.height + 20 + 50;
}

#pragma mark ------   UISearchBarDelegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    return YES;
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = NO;
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    SDDSearchViewController * search_vc = [[SDDSearchViewController alloc] init];
    search_vc.search_title = searchBar.text;
    search_vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search_vc animated:YES];
    searchBar.text = @"";
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
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
    lat = currentLocation.coordinate.latitude;
    lng = currentLocation.coordinate.longitude;
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0)
        {
            CLPlacemark *placemark = [array objectAtIndex:0];
            //将获得的所有信息显示到label上
            NSLog(@"%@",placemark.name);
            //获取城市
            
            for (CityInfo * info in _city_array) {
                if ([placemark.locality rangeOfString:info.name].length > 0) {
                    location_city = info.name;
                }
            }
            NSLog(@"city -----   %@",location_city);
        }
    }];
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
