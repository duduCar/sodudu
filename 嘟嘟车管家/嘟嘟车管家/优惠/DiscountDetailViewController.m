//
//  DiscountDetailViewController.m
//  嘟嘟车管家
//
//  Created by joinus on 15/12/8.
//  Copyright © 2015年 soulnear. All rights reserved.
//

#import "DiscountDetailViewController.h"
#import "DiscountDetailModel.h"
#import "SellerListTableViewCell.h"

@interface DiscountDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    ///基本信息背景视图
    UIView * base_info_background_view;
    ///详细信息背景视图
    SDDTitleLineView * detail_info_background_view;
    ///适用商户列表背景视图
    SDDTitleLineView * shop_list_background_view;
    ///其他团购背景视图
    SDDTitleLineView * other_discount_background_view;
    ///购买须知背景视图
    SDDTitleLineView * remind_background_view;
}

@property(nonatomic,strong)UIScrollView * myScrollView;

@property(nonatomic,strong)DiscountDetailModel * detail_info;

@end

@implementation DiscountDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title_label.text = @"团购详情";
    [self setMyViewControllerRightButtonType:MyViewControllerButtonTypePhoto WihtRightString:@"system_share_image"];

    
    
    _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64-35)];
    _myScrollView.backgroundColor = DEFAULT_GRAY_BACKGROUND_COLOR;
    [self.view addSubview:_myScrollView];
    
    UIButton * apply_button = [UIButton buttonWithType:UIButtonTypeCustom];
    apply_button.frame = CGRectMake(0, _myScrollView.bottom, DEVICE_WIDTH, 35);
    apply_button.backgroundColor = RGBCOLOR(252, 102, 34);
    [apply_button setTitle:@"立即购买" forState:UIControlStateNormal];
    apply_button.titleLabel.font = [UIFont systemFontOfSize:15];
    [apply_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [apply_button addTarget:self action:@selector(applyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:apply_button];
    
    [self startLoading];
    [self loadDetailInfo];
}

#pragma mark ---------   分享
-(void)rightButtonTap:(UIButton *)sender{
    /*
    UIImage *shareImage = [UIImage imageNamed:@"default_icon_image"];
    UMSocialUrlResource * url_resource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:_detail_info.image_url];
    SShareView * shareView = [[SShareView alloc] initWithTitles:@[SHARE_WECHAT_FRIEND,SHARE_WECHAT_CIRCLE,SHARE_SINA_WEIBO] title:_detail_info.title content:[NSString stringWithFormat:@"%@ %@",_detail_info.address,_detail_info.telphone] Url:[NSString stringWithFormat:SHARE_URL,_shop_id] image:shareImage location:nil urlResource:url_resource presentedController:self];
    [shareView showInView:self.navigationController.view];
    
    __weak typeof(shareView)wShareView = shareView;
    
    [shareView setShareSuccess:^(NSString *type) {
        [wShareView ShareViewRemoveFromSuperview];
        [ZTools showMBProgressWithText:@"分享成功" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        
    } failed:^{
        [wShareView ShareViewRemoveFromSuperview];
        [ZTools showMBProgressWithText:@"分享失败" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
    }];
    */
}

#pragma mark -------   网络请求
-(void)loadDetailInfo{
    NSDictionary * dic = @{@"id":@"1",@"token":@"7660nc7m506P4GWo0r5V5oPzytQfCKDotIgzZJUgxkbNTxQhAMQcnSrMLA3Z7xT5nJV2z58"};
    __weak typeof(self)wself = self;
    [[ZAPI manager] sendPost:DISCOUNT_DETAIL_URL myParams:dic success:^(id data) {
        [wself endLoading];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([data[ERROR_CODE] intValue] == 0) {
                wself.detail_info = [[DiscountDetailModel alloc] initWithDictionary:[[data objectForKey:@"data"] objectForKey:@"eventinfo"]];
                [wself createContentView];
            }else{
                [ZTools showMBProgressWithText:data[ERROR_INFO] WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
            }
        }else{
            [ZTools showMBProgressWithText:ERROR_FOR_NETWORK WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
        }
    } failure:^(NSError *error) {
        [wself endLoading];
        [ZTools showMBProgressWithText:ERROR_FOR_NETWORK WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
    }];
}

-(void)createContentView{
    
    CGFloat header_height = 0;
    
    ///——————————创建基本信息视图
    base_info_background_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 0)];
    base_info_background_view.backgroundColor = [UIColor whiteColor];
    [_myScrollView addSubview:base_info_background_view];
    ///头图比例为8:5
    UIImageView * header_image_view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_WIDTH*5.0/8.0)];
    [header_image_view sd_setImageWithURL:[NSURL URLWithString:_detail_info.s_image_url] placeholderImage:DEFAULT_LOADING_IMAGE_4_3];
    [base_info_background_view addSubview:header_image_view];
    ///标题
    UILabel * title_label = [ZTools createLabelWithFrame:CGRectMake(10, header_image_view.bottom+5, DEVICE_WIDTH-20, 0) text:_detail_info.title textColor:[UIColor redColor] textAlignment:NSTextAlignmentLeft font:15];
    title_label.numberOfLines = 0;
    [title_label sizeToFit];
    [base_info_background_view addSubview:title_label];
    
    ///优惠价格
    CGSize discount_price_size = [ZTools stringHeightWithFont:[UIFont systemFontOfSize:17] WithString:[NSString stringWithFormat:@"￥%@",_detail_info.purchase_count] WithWidth:MAXFLOAT];
    UILabel * discount_price_label = [ZTools createLabelWithFrame:CGRectMake(10, title_label.bottom+5, discount_price_size.width+10, 30) text:[NSString stringWithFormat:@"￥%@",_detail_info.purchase_count] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:17];
    discount_price_label.backgroundColor = RGBCOLOR(252, 102, 34);
    [base_info_background_view addSubview:discount_price_label];
    
    ///原价
    UILabel * original_price_label = [ZTools createLabelWithFrame:CGRectMake(discount_price_label.right+5, discount_price_label.bottom-20, 10, 20) text:[NSString stringWithFormat:@"原价:￥%@",_detail_info.current_price] textColor:DEFAULT_GRAY_TEXT_COLOR textAlignment:NSTextAlignmentCenter font:15];
    [original_price_label sizeToFit];
    [base_info_background_view addSubview:original_price_label];
    
    ///有效期
    CGSize effective_size = [ZTools stringHeightWithFont:[UIFont systemFontOfSize:12] WithString:[NSString stringWithFormat:@"有效期至：%@",_detail_info.purchase_deadline] WithWidth:MAXFLOAT];
    UILabel * effective_label = [ZTools createLabelWithFrame:CGRectMake(DEVICE_WIDTH-effective_size.width-10, discount_price_label.bottom-20, effective_size.width, 20) text:[NSString stringWithFormat:@"有效期至：%@",_detail_info.purchase_deadline] textColor:DEFAULT_BLACK_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:12];
    [base_info_background_view addSubview:effective_label];
    
    ///**********更新基本信息背景视图高度
    base_info_background_view.height = effective_label.bottom+5;
    header_height += base_info_background_view.height+10;
    
    ///—————————— 创建活动详情介绍视图
    detail_info_background_view = [[SDDTitleLineView alloc] initWithFrame:CGRectMake(0, base_info_background_view.bottom+10, DEVICE_WIDTH, 0) WithTitle:@"团购详情"];
    [_myScrollView addSubview:detail_info_background_view];
    ///团购详情介绍
    UILabel * detail_introduction_label = [ZTools createLabelWithFrame:detail_info_background_view.contentView.frame text:_detail_info.details textColor:DEFAULT_GRAY_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:13];
    detail_introduction_label.numberOfLines = 0;
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_detail_info.details];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:2];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _detail_info.details.length)];
    detail_introduction_label.attributedText = attributedString;
    
    [detail_introduction_label sizeToFit];
    
    detail_info_background_view.contentView = detail_introduction_label;
    
     ///**********更新活动详情介绍视图高度
    detail_info_background_view.height = detail_introduction_label.bottom+10;
    header_height += detail_info_background_view.height + 10;
    
    if (_detail_info.businesses_array.count) {
        ///——————————创建适用商户信息视图
        shop_list_background_view = [[SDDTitleLineView alloc] initWithFrame:CGRectMake(0, detail_info_background_view.bottom+10, DEVICE_WIDTH, 0) WithTitle:@"适用商户"];
        [_myScrollView addSubview:shop_list_background_view];
        

        UIView * shop_view = [[UIView alloc] initWithFrame:shop_list_background_view.contentView.frame];
        shop_list_background_view.contentView  = shop_view;
        
        CGFloat business_height = 0;
        for (int i = 0; i < _detail_info.businesses_array.count; i++) {
            
            if (i != 0) {
                UIView * line_view = [[UIView alloc] initWithFrame:CGRectMake(0, business_height, shop_view.width, 0.5)];
                line_view.backgroundColor = DEFAULT_LINE_COLOR;
                [shop_view addSubview:line_view];
            }
            
            BusinessModel * model = _detail_info.businesses_array[i];
            CGSize shop_name_size = [ZTools stringHeightWithFont:[UIFont systemFontOfSize:14] WithString:model.name WithWidth:shop_view.width];
            UILabel * shop_name_label = [ZTools createLabelWithFrame:CGRectMake(0, 5+business_height, shop_view.width, shop_name_size.height) text:model.name textColor:DEFAULT_BLACK_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:14];
            shop_name_label.numberOfLines = 0;
            [shop_view addSubview:shop_name_label];
            
            CGSize shop_address_size = [ZTools stringHeightWithFont:[UIFont systemFontOfSize:13] WithString:[NSString stringWithFormat:@"%@  %@",model.city,model.address] WithWidth:shop_view.width];
            UILabel * shop_address_label = [ZTools createLabelWithFrame:CGRectMake(0, shop_name_label.bottom+5, shop_view.width, shop_address_size.height) text:[NSString stringWithFormat:@"%@  %@",model.city,model.address] textColor:DEFAULT_GRAY_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:13];
            shop_address_label.numberOfLines = 0;
            [shop_view addSubview:shop_address_label];
            
            business_height += shop_name_size.height + shop_address_size.height + 20;
        }
        
        ///****更新使用商家视图高度
        shop_view.height = business_height;
        
        shop_list_background_view.height = shop_view.bottom+10;
        header_height += shop_list_background_view.height+10;
        
        /*
        UITableView * shop_tableView = [[UITableView alloc] initWithFrame:shop_list_background_view.contentView.frame style:UITableViewStylePlain];
        shop_tableView.delegate = self;
        shop_tableView.dataSource = self;
        shop_tableView.scrollEnabled = NO;
        shop_tableView.height = _detail_info.businesses_array.count*90;
        shop_list_background_view.contentView = shop_tableView;
        
        ///————————更新使用商家视图高度
        shop_list_background_view.height = shop_tableView.bottom;
        header_height += shop_list_background_view.height+10;
         */
         
    }
   
    ///购买须知
    if (_detail_info.restrictions_model) {
        if (_detail_info.restrictions_model.special_tips) {
            remind_background_view = [[SDDTitleLineView alloc] initWithFrame:CGRectMake(0, header_height+10, DEVICE_WIDTH, 0) WithTitle:@"购买须知"];
            [_myScrollView addSubview:remind_background_view];
            
            UILabel * remind_label = [ZTools createLabelWithFrame:remind_background_view.contentView.frame text:_detail_info.restrictions_model.special_tips textColor:DEFAULT_GRAY_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:13];
            remind_label.numberOfLines = 0;
            [remind_label sizeToFit];
            remind_background_view.contentView = remind_label;
            
            ///更新购买须知视图高度
            remind_background_view.height = remind_label.bottom+10;
            header_height+=remind_background_view.height+10;
        }
    }
    
    NSLog(@"regions-----  %@",_detail_info.regions_array);
    
    _myScrollView.contentSize = CGSizeMake(0, header_height);
}



#pragma mark -----   UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _detail_info.businesses_array.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    SellerListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SellerListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    BusinessModel * model = _detail_info.businesses_array[indexPath.row];
    
    [cell.header_imageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:DEFAULT_LOADING_IMAGE_4_3];
    
    cell.seller_name_label.text = model.name;
    cell.adress_label.text = [NSString stringWithFormat:@"%@  %@",model.city,model.address];
    
    cell.star_view.top = cell.seller_name_label.bottom+10;
    cell.adress_label.top = cell.star_view.bottom+5;

    return cell;
}

#pragma mark ——————————————  立即购买按钮  ————————————
-(void)applyButtonClicked:(UIButton*)button{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    base_info_background_view = nil;
    detail_info_background_view = nil;
    shop_list_background_view = nil;
    other_discount_background_view = nil;
    remind_background_view = nil;
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
