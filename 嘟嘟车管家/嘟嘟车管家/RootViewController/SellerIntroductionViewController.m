//
//  SellerIntroductionViewController.m
//  嘟嘟车管家
//
//  Created by joinus on 15/12/10.
//  Copyright © 2015年 soulnear. All rights reserved.
//

#import "SellerIntroductionViewController.h"

@interface SellerIntroductionViewController ()<UIWebViewDelegate>{
    ///商家简介
    SDDTitleLineView * shop_introduction_view;
}

@property(nonatomic,strong)UIScrollView * myScrollView;
@property(nonatomic,strong)UIWebView * introduction_webView;

@end

@implementation SellerIntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title_label.text = @"商家详情";
    [self setMyViewControllerRightButtonType:MyViewControllerButtonTypePhoto WihtRightString:@"system_share_image"];

    _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64)];
    _myScrollView.backgroundColor = RGBCOLOR(238, 238, 238);
    [self.view addSubview:_myScrollView];
    
    [self startLoading];
    [self loadSellerDetailData];
    [self createSectionHeaderView];
}


#pragma mark ------  网络请求  获取商家详细信息
-(void)loadSellerDetailData{
    __weak typeof(self)wself = self;
    
    [[ZAPI manager] sendPost:SELLER_DETAIL_CONTENT_URL myParams:@{@"shopid":_shop_info.id} success:^(id data) {
        
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            wself.shop_info.content = data[@"content"];
        }
        
        [wself createShopIntroductionView];
        
    } failure:^(NSError *error) {
        [wself endLoading];
    }];
}


-(void)createSectionHeaderView{
    
    UIView * section_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 160)];
    section_view.backgroundColor = [UIColor whiteColor];
    [_myScrollView addSubview:section_view];
    
    //头图
    UIImageView * header_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 45)];
    [header_imageView sd_setImageWithURL:[NSURL URLWithString:_shop_info.photo] placeholderImage:DEFAULT_LOADING_IMAGE_4_3];
    [section_view addSubview:header_imageView];
    
    if (_shop_info.commend.intValue == 1) {
        UIImageView * _commend_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(header_imageView.width-30, 0, 30, 30)];
        _commend_imageView.image = [UIImage imageNamed:@"shop_commend_image"];
        [header_imageView addSubview:_commend_imageView];
    }
    
    //商家名称
    UILabel * seller_name_label = [ZTools createLabelWithFrame:CGRectMake(header_imageView.right+10, 10, DEVICE_WIDTH-100, 20) text:_shop_info.name textColor:DEFAULT_BLACK_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:15];
    seller_name_label.numberOfLines = 2;
    [section_view addSubview:seller_name_label];
    CGSize name_size = [ZTools stringHeightWithFont:seller_name_label.font WithString:_shop_info.name WithWidth:seller_name_label.width];
    seller_name_label.height = name_size.height;
    
    DJWStarRatingView * _evaluation_view = [[DJWStarRatingView alloc] initWithStarSize:CGSizeMake(13, 13) numberOfStars:5 rating:5 fillColor:RGBCOLOR(253, 160, 90) unfilledColor:[UIColor clearColor] strokeColor:RGBCOLOR(253, 180, 90)];
    _evaluation_view.padding = 2;
    _evaluation_view.rating = _shop_info.score.intValue/10.0;
    _evaluation_view.top = seller_name_label.bottom+3;
    _evaluation_view.left = header_imageView.right+10;
    [section_view addSubview:_evaluation_view];
    
    //价格
    UILabel * price_label = [ZTools createLabelWithFrame:CGRectMake(_evaluation_view.right+5, seller_name_label.bottom, 100, 20) text:_shop_info.price textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:13];
    [section_view addSubview:price_label];
    
    //商家类型
    UILabel * shop_type_label = [ZTools createLabelWithFrame:CGRectMake(header_imageView.right + 10, price_label.bottom, DEVICE_WIDTH-100, 20) text:_shop_info.sort textColor:[UIColor grayColor] textAlignment:NSTextAlignmentLeft font:13];
    [section_view addSubview:shop_type_label];
    section_view.height = shop_type_label.bottom+10;
    
    ///商家简介
    shop_introduction_view = [[SDDTitleLineView alloc] initWithFrame:CGRectMake(0, section_view.bottom+10, DEVICE_WIDTH, DEVICE_HEIGHT-section_view.bottom-10) WithTitle:@"商家介绍"];
    [_myScrollView addSubview:shop_introduction_view];
    
    _introduction_webView = [[UIWebView alloc] initWithFrame:shop_introduction_view.contentView.frame];
    _introduction_webView.delegate = self;
    _introduction_webView.scalesPageToFit = YES;
    _introduction_webView.scrollView.scrollEnabled = NO;
     _introduction_webView.height = shop_introduction_view.height-shop_introduction_view.contentView.bottom-10;
    shop_introduction_view.height = _introduction_webView.bottom+10;
    shop_introduction_view.contentView = _introduction_webView;
}

-(void)createShopIntroductionView{
    [_introduction_webView loadHTMLString:_shop_info.content baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

#pragma mark ————————————————  UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self endLoading];
//    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
//    int height = [height_str intValue];
    
    _introduction_webView.height = _introduction_webView.scrollView.contentSize.height;
    shop_introduction_view.height = _introduction_webView.bottom+10;
    
    _myScrollView.contentSize = CGSizeMake(0, shop_introduction_view.bottom);
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self endLoading];
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
