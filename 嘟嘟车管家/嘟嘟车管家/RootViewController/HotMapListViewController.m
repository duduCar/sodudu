//
//  HotMapListViewController.m
//  嘟嘟车管家
//
//  Created by joinus on 15/11/13.
//  Copyright © 2015年 soulnear. All rights reserved.
//

#import "HotMapListViewController.h"
#import "HotMapListCell.h"
#import "HotMapViewController.h"

@interface HotMapListViewController ()<SNRefreshDelegate,UITableViewDataSource,AMapSearchDelegate>
{
    double location_lat;
    double location_lng;
}

@property(nonatomic,strong)SNRefreshTableView * myTableView;

@property(nonatomic,strong)NSMutableArray * data_array;
///高德地图
@property(nonatomic,strong)AMapSearchAPI *amap_search;
@property(nonatomic,strong)MAMapView * a_mapView;

@end

@implementation HotMapListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title_label.text = _server_name;
    
    [self setMyViewControllerRightButtonType:MyViewControllerButtonTypePhoto WihtRightString:@"map_image"];
    
    _data_array = [NSMutableArray array];
    
    _myTableView = [[SNRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) showLoadMore:YES];
    _myTableView.refreshDelegate = self;
    _myTableView.dataSource = self;
    _myTableView.isHaveMoreData = YES;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
    [_myTableView removeHeaderView];
    
    __weak typeof(self)wself = self;
    [self setupLocationManagerWith:^(double lat, double lng, CLPlacemark *placemark) {
        location_lat = lat;
        location_lng = lng;
        [wself searchPoi];
    }];
    
    
    [self startLoading];
}
//不使用时将delegate设置为 nil
-(void)viewWillDisappear:(BOOL)animated
{

}

-(void)rightButtonTap:(UIButton *)sender{
    HotMapViewController * mapVC = [[HotMapViewController alloc] init];
    mapVC.server_name = self.server_name;
    mapVC.shops_array = self.data_array;
    [self.navigationController pushViewController:mapVC animated:YES];
}

-(void)searchPoi{
    ///高德地图
    //初始化检索对象
    [AMapSearchServices sharedServices].apiKey = @"8495b9c6c03000bdd8da2d91c52ebee9";
    _amap_search = [[AMapSearchAPI alloc] init];
    _amap_search.delegate = self;
    
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:location_lat longitude:location_lng];
    request.keywords = _server_name;
    // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
    // POI的类型共分为20种大类别，分别为：
    // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
    // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
    // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
    request.types = @"餐饮服务|生活服务";
    request.sortrule = 0;
    request.requireExtension = YES;
    request.radius = 5000;
    request.page = _myTableView.pageNum;
    
    //发起周边搜索
    [_amap_search AMapPOIAroundSearch: request];
    
    
}
#pragma mark -------   UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data_array.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    HotMapListCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[HotMapListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = RGBCOLOR(236, 236, 236);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    AMapPOI * info = [_data_array objectAtIndex:indexPath.row];
    
    __weak typeof(self)wself = self;
    [cell setInfomation:info WihtIndex:(int)indexPath.row WithCall:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",info.tel]]];
    } WithOpen:^{
        HotMapViewController * mapVC = [[HotMapViewController alloc] init];
        mapVC.server_name = wself.server_name;
        mapVC.shops_array = wself.data_array;
        mapVC.index = (int)indexPath.row;
        [wself.navigationController pushViewController:mapVC animated:YES];
    }];
    
    return cell;
}

-(void)loadNewData{
    [self searchPoi];
}
-(void)loadMoreData{
    [self searchPoi];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    return 105;
}

#pragma mark ****************  高德地图
//实现POI搜索对应的回调函数
-(void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    [self endLoading];
    if(response.pois.count == 0)
    {
        _myTableView.isHaveMoreData = NO;
        [_myTableView finishReloadigData];
        return;
    }else{
        if (_myTableView.pageNum == 1) {
            [_data_array removeAllObjects];
        }
        _myTableView.isHaveMoreData = YES;
    }
    
    //通过 AMapPOISearchResponse 对象处理搜索结果
////    NSString *strCount = [NSString stringWithFormat:@"count: %ld",(long)response.count];
////    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
////    NSString *strPoi = @"";
//    for (AMapPOI *p in response.pois) {
//        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description];
//        
//        NSLog(@"name ---=-=-=-=-    %@",p.name);
//    }
    
    [_data_array addObjectsFromArray:response.pois];
    
    [_myTableView finishReloadigData];
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    
    NSLog(@"error -----  %@",error);
}

///定位
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}


-(void)dealloc{
    _amap_search.delegate = nil;
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
