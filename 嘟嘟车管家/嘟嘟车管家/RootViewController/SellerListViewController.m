//
//  SellerListViewController.m
//  嘟嘟车管家
//
//  Created by joinus on 15/10/13.
//  Copyright (c) 2015年 soulnear. All rights reserved.
//

#import "SellerListViewController.h"
#import "SellerModel.h"
#import "SellerListTableViewCell.h"
#import "ScreeningView.h"
#import "SellerDetailViewController.h"
#import "SDDSearchViewController.h"
#import "SDDSelectView.h"
#import <MapKit/MapKit.h>
#import "DiscountDetailViewController.h"

@interface SellerListViewController ()<SNRefreshDelegate,UITableViewDataSource,UISearchBarDelegate,CLLocationManagerDelegate>{
    UIView * search_background_view;
    SDDSelectView * selection_view;
    //顶部视图
    ScreeningView * screen_view;
    //城市英文名
    NSString * city_ename;
    //服务项目id
    NSString * sort_id;
    //综合 类型id
    NSString * orderby;
    
    CLLocationManager * locationManager;
}

@property(nonatomic,strong)SNRefreshTableView * myTableView;

@property(nonatomic,strong)UISearchBar * mySearchBar;

@property(nonatomic,strong)NSMutableArray * data_array;

@end

@implementation SellerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title_label.text = [ZTools findColumnName:_column_id];
    [self setMyViewControllerRightButtonType:MyViewControllerButtonTypePhoto WihtRightString:@"system_search_image"];
    
    _data_array = [NSMutableArray array];
    
    //获取选择的城市名
    NSString * selected_city_name = [ZTools getSelectedCity];
    if (selected_city_name.length) {
        NSArray * array = [CityInfo MR_findByAttribute:@"name" withValue:selected_city_name];
        if (array.count) {
            CityInfo * info = [array objectAtIndex:0];
            city_ename = info.ename;
        }else{
            city_ename = @"beijing";
        }
    }else{
        city_ename = @"beijing";
    }
    
    orderby = @"default";
    sort_id = _column_id;
        
    _myTableView = [[SNRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) showLoadMore:YES];
    _myTableView.isHaveMoreData = YES;
    _myTableView.refreshDelegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    [_myTableView showRefreshHeader:YES];
    
    
}

-(void)rightButtonTap:(UIButton *)sender{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (!_mySearchBar) {
        
        search_background_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        search_background_view.backgroundColor = RGBCOLOR(221, 221, 221);
        
        UIView * search_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 64)];
        search_view.backgroundColor = RGBCOLOR(168, 168, 168);
        [search_background_view addSubview:search_view];
        
        _mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, DEVICE_WIDTH-60, 44)];
        _mySearchBar.placeholder = @"请输入地名或商家";
        _mySearchBar.delegate = self;
        _mySearchBar.backgroundColor = [UIColor clearColor];
        
        [search_view addSubview:_mySearchBar];
        
        for (UIView * view in _mySearchBar.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
                [[view.subviews objectAtIndex:0] removeFromSuperview];
                break;
            }
        }
        
        UIButton * cancel_button = [UIButton buttonWithType:UIButtonTypeCustom];
        cancel_button.frame = CGRectMake(DEVICE_WIDTH, 27, 40, 30);
        [cancel_button setTitle:@"取消" forState:UIControlStateNormal];
        [cancel_button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        cancel_button.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancel_button addTarget:self action:@selector(cancelSearchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [search_view addSubview:cancel_button];
        
        [UIView animateWithDuration:0.4 animations:^{
            cancel_button.left = DEVICE_WIDTH-50;
        }];
    }
    
    [_mySearchBar becomeFirstResponder];
    [self.view addSubview:search_background_view];
    
}

#pragma mark ----  数据请求
-(void)loadSellerListData{
    
    __weak typeof(self)wself = self;
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{@"sortid":sort_id,@"city":city_ename,@"orderby":orderby,@"page":[NSString stringWithFormat:@"%d",_myTableView.pageNum]}];
    if (_lat) {
        [dic setObject:[NSString stringWithFormat:@"%f",_lat] forKey:@"lat"];
    }
    if (_lng) {
        [dic setObject:[NSString stringWithFormat:@"%f",_lng] forKey:@"lng"];
    }
    
    NSLog(@"dic -------- %@",dic);

    [[ZAPI manager] sendPost:SELLER_LIST_URL myParams:dic success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if (wself.myTableView.pageNum == 1) {
                [wself.data_array removeAllObjects];
            }
            NSArray * array = [data objectForKey:@"shoplist"];
            for (NSDictionary * item in array) {
                SellerModel * model = [[SellerModel alloc] initWithDictionary:item];
                [wself.data_array addObject:model];
            }
        }
        [wself.myTableView finishReloadigData];
    } failure:^(NSError *error) {
        [wself.myTableView finishReloadigData];
    }];
}

#pragma mark --------  取消搜索
-(void)cancelSearchButtonClicked:(UIButton*)sender{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [search_background_view removeFromSuperview];
}

#pragma mark ------- UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data_array.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    SellerListTableViewCell * cell = (SellerListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SellerListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    SellerModel * model = _data_array[indexPath.row];
    [cell setInfomationWith:model WithActivityBlock:^(int index) {
        SellerDiscountModel * item = model.event_array[index];
        DiscountDetailViewController * discount_detail_vc = [[DiscountDetailViewController alloc] init];
        discount_detail_vc.aid = item.id;
        [self pushToViewController:discount_detail_vc withAnimation:YES];
    }];
    
    return cell;
}


- (void)loadNewData{
    [self loadSellerListData];
}
- (void)loadMoreData{
    [self loadSellerListData];
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_myTableView deselectRowAtIndexPath:indexPath animated:YES];
    SellerModel * model = _data_array[indexPath.row];
    SellerDetailViewController * seller_vc = [[SellerDetailViewController alloc] init];
    seller_vc.shop_id = model.id;
    [self.navigationController pushViewController:seller_vc animated:YES];
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    
    SellerModel * model = _data_array[indexPath.row];
    CGSize name_size = [ZTools stringHeightWithFont:[UIFont systemFontOfSize:15] WithString:model.name WithWidth:DEVICE_WIDTH-140];
    
    return 90+name_size.height-20;// + 25*model.event_array.count;
}
- (UIView *)viewForHeaderInSection:(NSInteger)section{
    
    if (!screen_view) {
        NSString * selected_city = [ZTools getSelectedCity];
        
        screen_view = [[ScreeningView alloc] initWithArray:@[selected_city.length==0?@"北京":selected_city,self.title_label.text,@"综合"]];
        [screen_view buttonClickedWith:^(UIButton*button, int index, int pre_index) {
            
            [UIView animateWithDuration:0.3 animations:^{
                if (button.selected && button.tag-100 == pre_index) {
                    [self createCityView:index];
                }else{
                    selection_view.height = 0;
                }
            } completion:^(BOOL finished) {
                if (index != pre_index) {
                    [self createCityView:index];
                }
            }];
        }];
    }
   
    return screen_view;
}
- (CGFloat)heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(void)scrollViewDidScrollWith:(UIScrollView *)scrollView{
    if (selection_view.height > 0) {
        selection_view.height = 0;
        [screen_view resetButtonState];
    }
}


-(void)createCityView:(int)type{
    if (!selection_view) {
        selection_view = [[SDDSelectView alloc] initWithFrame:CGRectMake(0, 44, DEVICE_WIDTH, 0)];
        [self.view addSubview:selection_view];
    }
    
    [selection_view selectedColumn:^(NSString *column_name) {
        if ([column_name isEqualToString:@"附近"] && (_lat == 0 || _lng == 0)) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"定位失败，请查看是否开启定位服务" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alertView show];
            return ;
        }
        
        selection_view.height = 0;
        if (type == 0)//地区
        {
            NSArray * array = [CityInfo MR_findByAttribute:@"listname" withValue:column_name];
            NSLog(@"array -----  %@",array);
            if (array.count) {
                CityInfo * info = [array objectAtIndex:0];
                city_ename = info.ename;
                [screen_view setButtonTitle:info.name atIndex:type];
            }
        }else if (type == 1)//服务栏目
        {
            sort_id = [ZTools findColumnId:column_name];
            [screen_view setButtonTitle:column_name atIndex:type];
        }else if (type == 2)//综合
        {
            [screen_view setButtonTitle:column_name atIndex:type];
            
            NSString * order = [ZTools findComprehensiveWithName:column_name];
            if ([order isEqualToString:@"nearby"]) {
                [self setupLocationManager];
                return ;
            }
            
            orderby = [ZTools findComprehensiveWithName:column_name];
        }
        
        [_myTableView showRefreshHeader:YES];
        [self loadSellerListData];
    }];
    
    selection_view.type = type;
}

#pragma mark -------   UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    SDDSearchViewController * search_vc = [[SDDSearchViewController alloc] init];
    search_vc.search_title = searchBar.text;
    [self.navigationController pushViewController:search_vc animated:YES];
    searchBar.text = @"";
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [search_background_view removeFromSuperview];
}


#pragma mark ****************  获取地理位置
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
    _lat = currentLocation.coordinate.latitude;
    _lng = currentLocation.coordinate.longitude;
    
    orderby = @"nearby";
    [self loadSellerListData];
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
