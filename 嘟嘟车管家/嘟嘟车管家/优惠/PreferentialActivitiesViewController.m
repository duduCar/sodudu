//
//  PreferentialActivitiesViewController.m
//  嘟嘟车管家
//
//  Created by joinus on 15/12/1.
//  Copyright © 2015年 soulnear. All rights reserved.
//

#import "PreferentialActivitiesViewController.h"
#import "PACollectionViewCell.h"
#import "PAModel.h"
#import "SNRefreshCollectionView.h"
#import "DiscountDetailViewController.h"
#import "ActivityDetailViewController.h"

@interface PreferentialActivitiesViewController ()<SNRefreshCollectionViewDelegate>{
    int current_index;
}

@property(nonatomic,strong)SNRefreshCollectionView * PACollectionView;

@property(nonatomic,strong)NSMutableArray * data_array;

@end

@implementation PreferentialActivitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title_label.text = @"优惠";
    self.view.backgroundColor = DEFAULT_GRAY_BACKGROUND_COLOR;
    _data_array = [NSMutableArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array], nil];
    
    
    UISegmentedControl * segC = [[UISegmentedControl alloc] initWithItems:@[@"团购",@"活动"]];
    segC.frame = CGRectMake(0, 7, 200, 30);
    segC.selectedSegmentIndex = 0;
    [segC addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    segC.tintColor = RGBCOLOR(252, 102, 34);
    self.navigationItem.titleView = segC;

    
    UICollectionViewFlowLayout * paFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    paFlowLayout.footerReferenceSize = CGSizeMake(DEVICE_WIDTH, 50.0f);
    [paFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    
    _PACollectionView = [[SNRefreshCollectionView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) collectionViewLayout:paFlowLayout];
    _PACollectionView.backgroundColor = DEFAULT_GRAY_BACKGROUND_COLOR;
    _PACollectionView.refreshDelegate = self;
    _PACollectionView.alwaysBounceVertical = YES;
    [self.view addSubview:_PACollectionView];
    
    [self.PACollectionView registerClass:[PACollectionViewCell class] forCellWithReuseIdentifier:@"identifier"];
    [self.PACollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    [self.PACollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    
    current_index = 1;
    [self loadDiscountListData];
    
    [self startLoading];
}

#pragma mark --------   网络请求
-(void)loadDiscountListData{
   
    CityInfo * info = [ZTools findCityInfoWith:[ZTools getSelectedCity]];
    NSDictionary * dic = @{@"token":[ZTools getUID],@"city":info?info.ename:@"beijing",@"type":[NSString stringWithFormat:@"%d",current_index],@"page":[NSString stringWithFormat:@"%d",_PACollectionView.pageNum]};
    __weak typeof(self)wself = self;
    [[ZAPI manager] sendPost:DISCOUNT_LIST_URL myParams:dic success:^(id data) {
        [self endLoading];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if (wself.PACollectionView.pageNum == 1) {
                [wself.data_array[current_index-1] removeAllObjects];
                wself.PACollectionView.isHaveMoreData = YES;
            }
            if ([data[ERROR_CODE] intValue] == 0) {
                NSArray * array = data[@"data"][@"eventlist"];
                if (array && [array isKindOfClass:[NSArray class]]) {
                    if (array.count == 0) {
                        wself.PACollectionView.isHaveMoreData = NO;
                    }
                    for (NSDictionary * item in array) {
                        PAModel * model = [[PAModel alloc] initWithDictionary:item];
                        [wself.data_array[current_index-1] addObject:model];
                    }
                }
            }
        }
        [wself.PACollectionView finishReloadigData];
    } failure:^(NSError *error) {
        [self endLoading];
        [wself.PACollectionView finishReloadigData];
    }];
}
#pragma mark *************  UICollectionViewDelegate
-(NSInteger)sncollectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_data_array[current_index-1] count];
}

-(NSInteger)snnumberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UICollectionViewCell*)sncollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    PACollectionViewCell * cell = (PACollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell sizeToFit];
    if (cell == nil) {
        
    }
    
    [cell setInfomationWithPAModel:_data_array[current_index-1][indexPath.row]];
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)sncollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(DEVICE_WIDTH-20)/2-5-5 所以总高(DEVICE_WIDTH-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake((DEVICE_WIDTH-20)/2, (DEVICE_WIDTH-20)/2+50);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)sncollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 5, 5);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)sncollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)sncollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择%ld",indexPath.row);
    PAModel * model = _data_array[current_index-1][indexPath.row];
    DiscountDetailViewController * discount_vc = [[DiscountDetailViewController alloc] init];
    discount_vc.aid = model.id;
    [self pushToViewController:discount_vc withAnimation:YES];
    

    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)sncollectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)loadNewData{
    [self loadDiscountListData];
}
-(void)loadMoreData{
    [self loadDiscountListData];
}

#pragma mark -----------   SegmentViewMethod
-(void)segmentValueChanged:(UISegmentedControl*)sender{
    [_data_array[current_index-1] removeAllObjects];
    [_PACollectionView reloadData];
    current_index = (int)sender.selectedSegmentIndex+1;
    [self startLoading];
    [self loadDiscountListData];
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
