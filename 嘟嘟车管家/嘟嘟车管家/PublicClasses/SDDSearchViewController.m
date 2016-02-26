//
//  SDDSearchViewController.m
//  嘟嘟车管家
//
//  Created by joinus on 15/10/15.
//  Copyright (c) 2015年 soulnear. All rights reserved.
//

#import "SDDSearchViewController.h"
#import "SellerModel.h"
#import "SellerListTableViewCell.h"
#import "SellerDetailViewController.h"
#import "DiscountDetailViewController.h"


@interface SDDSearchViewController ()<SNRefreshDelegate,UITableViewDataSource>{
    
}

@property(nonatomic,strong)UISearchBar * mySearchBar;

@property(nonatomic,strong)SNRefreshTableView * myTableView;

@property(nonatomic,strong)NSMutableArray * data_array;

@end

@implementation SDDSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title_label.text = _search_title;
    
    _data_array = [NSMutableArray array];
    
    _myTableView = [[SNRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) showLoadMore:YES];
    _myTableView.dataSource = self;
    _myTableView.isHaveMoreData = YES;
    _myTableView.refreshDelegate = self;
    [self.view addSubview:_myTableView];
    
    [self startLoading];
    [self loadData];
}

-(void)loadData{
    __weak typeof(self)wself = self;
    NSLog(@"dic ------   %@",@{@"keyword":_search_title,@"page":[NSString stringWithFormat:@"%d",_myTableView.pageNum]});
    [[ZAPI manager] sendPost:SEARCH_URL myParams:@{@"keyword":_search_title,@"page":[NSString stringWithFormat:@"%d",_myTableView.pageNum]} success:^(id data) {
        [self endLoading];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if (wself.myTableView.pageNum == 1) {
                [wself.data_array removeAllObjects];
            }
            NSArray * array = [data objectForKey:@"shoplist"];
            if (array.count == 0) {
                wself.myTableView.isHaveMoreData = NO;
            }
            for (NSDictionary * item in array) {
                SellerModel * model = [[SellerModel alloc] initWithDictionary:item];
                [wself.data_array addObject:model];
            }
        }
        [wself.myTableView finishReloadigData];

    } failure:^(NSError *error) {
        [self endLoading];
        [wself.myTableView finishReloadigData];
    }];
}

#pragma mark -----  UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data_array.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    SellerListTableViewCell * cell = (SellerListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SellerListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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

#pragma mark ------  SNRefreshViewDelegate
- (void)loadNewData{
    [self loadData];
}
- (void)loadMoreData{
    [self loadData];
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_myTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SellerModel * model = _data_array[indexPath.row];
    SellerDetailViewController * seller_vc = [[SellerDetailViewController alloc] init];
    seller_vc.shop_id = model.id;
    [self.navigationController pushViewController:seller_vc animated:YES];
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    return 100;
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
