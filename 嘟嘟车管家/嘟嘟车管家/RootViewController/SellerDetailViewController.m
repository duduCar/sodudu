//
//  SellerDetailViewController.m
//  嘟嘟车管家
//
//  Created by joinus on 15/10/14.
//  Copyright (c) 2015年 soulnear. All rights reserved.
//

#import "SellerDetailViewController.h"
#import "SellerModel.h"
#import "CommentModel.h"
#import "CommentTableViewCell.h"
#import "SDDMapViewController.h"
#import "CommentsViewController.h"
#import "SShareView.h"
#import "SellerIntroductionViewController.h"

@interface SellerDetailViewController ()<SNRefreshDelegate,UITableViewDataSource,UIAlertViewDelegate,UIActionSheetDelegate>{
    UIView * header_view;
    ///商家信息
    UIView * section_view1;
    ///点评
    UIView * section_view2;
    ///商家介绍
    UIView * shop_introduction_view;
    ///优惠促销
    UIView * shop_activity_view;
    
    UIImageView * header_imageView;
    UILabel * price_label;
    UILabel * seller_name_label;
    UILabel * shop_type_label;
    UILabel * comment_label;
    UIButton * comment_button;
    ///商户星级评价
    DJWStarRatingView * _evaluation_view;
    ///是否被推荐
    UIImageView * _commend_imageView;
}


@property(nonatomic,strong)SNRefreshTableView * myTableView;
@property(nonatomic,strong)NSMutableArray * data_array;
@property(nonatomic,strong)SellerModel * shop_info;

@end

@implementation SellerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title_label.text = @"商家详情";
    [self setMyViewControllerRightButtonType:MyViewControllerButtonTypePhoto WihtRightString:@"system_share_image"];
    _data_array = [NSMutableArray array];
    
    
    _myTableView = [[SNRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) showLoadMore:YES];
    _myTableView.refreshDelegate = self;
    _myTableView.isHaveMoreData = YES;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    
    
    // 调cell对齐
    if ([self.myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.myTableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    if ([self.myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.myTableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    
    [self startLoading];
    [self loadSellerDetailData];
}

#pragma mark ---------   分享
-(void)rightButtonTap:(UIButton *)sender{
    UIImage *shareImage = header_imageView.image?header_imageView.image:[UIImage imageNamed:@"default_icon_image"];
    UMSocialUrlResource * url_resource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:_shop_info.photo];
    SShareView * shareView = [[SShareView alloc] initWithTitles:@[SHARE_WECHAT_FRIEND,SHARE_WECHAT_CIRCLE,SHARE_SINA_WEIBO] title:_shop_info.name content:[NSString stringWithFormat:@"%@ %@",_shop_info.address,_shop_info.telphone] Url:[NSString stringWithFormat:SHARE_URL,_shop_id] image:shareImage location:nil urlResource:url_resource presentedController:self];
    [shareView showInView:self.navigationController.view];
    
    __weak typeof(shareView)wShareView = shareView;
    
    [shareView setShareSuccess:^(NSString *type) {
        [wShareView ShareViewRemoveFromSuperview];
        [ZTools showMBProgressWithText:@"分享成功" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        
    } failed:^{
        [wShareView ShareViewRemoveFromSuperview];
        [ZTools showMBProgressWithText:@"分享失败" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
    }];

}

#pragma mark ------  网络请求  获取商家详细信息
-(void)loadSellerDetailData{
    __weak typeof(self)wself = self;
    
    NSLog(@"dic-------%@",@{@"shopid":@"14818",@"page":[NSString stringWithFormat:@"%d",_myTableView.pageNum]});
    [[ZAPI manager] sendPost:SELLER_DETAIL_URL myParams:@{@"shopid":_shop_id,@"page":[NSString stringWithFormat:@"%d",_myTableView.pageNum]} success:^(id data) {
        [wself endLoading];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:[data objectForKey:@"shopinfo"]];
            id eventlist = [data objectForKey:@"eventlist"];
            if (eventlist && ![eventlist isKindOfClass:[NSNull class]]) {
                [dic setObject:eventlist forKey:@"event"];
            }
            
            wself.shop_info = [[SellerModel alloc] initWithDictionary:dic];
            NSArray * array = [data objectForKey:@"commentinfo"];
            if ([array isKindOfClass:[NSArray class]] && array.count > 0) {
                if (wself.myTableView.pageNum == 1) {
                    wself.myTableView.isHaveMoreData = YES;
                    [wself.data_array removeAllObjects];
                }
                for (NSDictionary * item in array) {
                    CommentModel * model = [[CommentModel alloc] initWithDictionary:item];
                    [wself.data_array addObject:model];
                }
            }else{
                wself.myTableView.isHaveMoreData = NO;
            }
        }
        
        [wself createSectionHeaderView];
        [wself.myTableView finishReloadigData];
        
    } failure:^(NSError *error) {
        [wself endLoading];
    }];
}

-(void)createSectionHeaderView{
    
    if (!header_view) {
        header_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 210)];
        header_view.backgroundColor = RGBCOLOR(238, 238, 238);
        
        section_view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 160)];
        section_view1.backgroundColor = [UIColor whiteColor];
        [header_view addSubview:section_view1];
        
        //头图
        header_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 45)];
        [section_view1 addSubview:header_imageView];
        
        _commend_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(header_imageView.width-30, 0, 30, 30)];
        _commend_imageView.image = [UIImage imageNamed:@"shop_commend_image"];
        _commend_imageView.hidden = YES;
        [header_imageView addSubview:_commend_imageView];
        
        //商家名称
        seller_name_label = [ZTools createLabelWithFrame:CGRectMake(header_imageView.right+10, 10, DEVICE_WIDTH-100, 20) text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:15];
        seller_name_label.numberOfLines = 2;
        [section_view1 addSubview:seller_name_label];
        
        _evaluation_view = [[DJWStarRatingView alloc] initWithStarSize:CGSizeMake(13, 13) numberOfStars:5 rating:5 fillColor:RGBCOLOR(253, 160, 90) unfilledColor:[UIColor clearColor] strokeColor:RGBCOLOR(253, 180, 90)];
        _evaluation_view.padding = 2;
        _evaluation_view.top = seller_name_label.bottom+3;
        _evaluation_view.left = header_imageView.right+10;
        [section_view1 addSubview:_evaluation_view];
        
        //价格
        price_label = [ZTools createLabelWithFrame:CGRectMake(_evaluation_view.right+5, seller_name_label.bottom, 100, 20) text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:13];
        [section_view1 addSubview:price_label];
        
        //商家类型
        shop_type_label = [ZTools createLabelWithFrame:CGRectMake(header_imageView.right + 10, price_label.bottom, DEVICE_WIDTH-100, 20) text:@"" textColor:[UIColor grayColor] textAlignment:NSTextAlignmentLeft font:13];
        [section_view1 addSubview:shop_type_label];
        
        
        NSArray * image_array = @[[UIImage imageNamed:@"system_address_image"],[UIImage imageNamed:@"system_telphone_image"]];
        for (int i = 0; i < 2; i++) {
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = 1000+i;
            button.frame = CGRectMake(10, shop_type_label.bottom+10 + 40*i, 40, 40);
            button.userInteractionEnabled = NO;
            [button setImage:image_array[i] forState:UIControlStateNormal];
            [section_view1 addSubview:button];
            
            UILabel * label = [ZTools createLabelWithFrame:CGRectMake(45, shop_type_label.bottom+10 + 40*i, DEVICE_WIDTH-70, 40) text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:13];
            label.tag = 10000+i;
            label.userInteractionEnabled = YES;
            [section_view1 addSubview:label];
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressAndPhoneTap:)];
            [label addGestureRecognizer:tap];
            
            
            UIView * line_view = [[UIView alloc] initWithFrame:CGRectMake(15, label.top-0.5, DEVICE_WIDTH-30, 0.5)];
            line_view.backgroundColor = [UIColor lightGrayColor];
            line_view.tag = 100 + i;
            [section_view1 addSubview:line_view];
        }
        
        
        section_view2 = [[UIView alloc] initWithFrame:CGRectMake(0, section_view1.bottom+10, DEVICE_WIDTH, 40)];
        section_view2.backgroundColor = [UIColor whiteColor];
        [header_view addSubview:section_view2];
        
        comment_label = [ZTools createLabelWithFrame:CGRectMake(15, 0, DEVICE_WIDTH-100, 40) text:@"点评(0)" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:13];
        [section_view2 addSubview:comment_label];
        
        comment_button = [ZTools createButtonWithFrame:CGRectMake(DEVICE_WIDTH-80, 8, 65, 24) title:@"我要点评" image:nil];
        comment_button.backgroundColor = RGBCOLOR(251, 148, 11);
        comment_button.titleLabel.font = [UIFont systemFontOfSize:13];
        comment_button.layer.cornerRadius = 5;
        [comment_button addTarget:self action:@selector(commentButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [section_view2 addSubview:comment_button];
        
        UIView * line_view = [[UIView alloc] initWithFrame:CGRectMake(15, section_view2.height-0.5, DEVICE_WIDTH-30, 0.5)];
        line_view.backgroundColor = [UIColor lightGrayColor];
        [section_view2 addSubview:line_view];
        
    }
    
    
    if ([[ZTools replaceNullString:_shop_info.summary WithReplaceString:@""] length] > 0) {
        [self createShopIntroductionView];
    }
    
    if (_shop_info.event_array.count > 0) {
        [self createShopEventView];
    }
    
    [self setSectionInfomation];
    
    _myTableView.tableHeaderView = header_view;
}
///创建商家介绍
-(void)createShopIntroductionView{
    if (!shop_introduction_view) {
        shop_introduction_view = [[UIView alloc] initWithFrame:CGRectMake(0, section_view1.bottom+5, DEVICE_WIDTH, 70)];
        shop_introduction_view.backgroundColor = [UIColor whiteColor];
        [header_view addSubview:shop_introduction_view];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showShopDetailTap:)];
        [shop_introduction_view addGestureRecognizer:tap];
    }else{
        for (UIView * view in shop_introduction_view.subviews) {
            [view removeFromSuperview];
        }
        shop_introduction_view.height = 0;
    }
    
    ///商家介绍
    UILabel * label = [ZTools createLabelWithFrame:CGRectMake(10, 2.5, DEVICE_WIDTH-20, 20) text:@"商家介绍" textColor:DEFAULT_BLACK_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:14];
    label.font = [UIFont boldSystemFontOfSize:14];
    [shop_introduction_view addSubview:label];
    
    UIView * line_view = [[UIView alloc] initWithFrame:CGRectMake(10, label.bottom+5, DEVICE_WIDTH-20, 0.5)];
    line_view.backgroundColor = DEFAULT_LINE_COLOR;
    [shop_introduction_view addSubview:line_view];
    
    ///商家介绍详情
    UILabel * introduction_label = [ZTools createLabelWithFrame:CGRectMake(10, line_view.bottom+5, DEVICE_WIDTH-40, 35) text:_shop_info.summary textColor:DEFAULT_GRAY_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:13];
    introduction_label.numberOfLines = 2;
    [shop_introduction_view addSubview:introduction_label];
    
    UIImageView * arrow_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH-18, introduction_label.center.y-9, 8, 14)];
    arrow_imageView.image = [UIImage imageNamed:@"arrow_right_image"];
    [shop_introduction_view addSubview:arrow_imageView];
}
///创建优惠促销
-(void)createShopEventView{
    if (!shop_activity_view) {
        shop_activity_view = [[UIView alloc] initWithFrame:CGRectMake(0, shop_introduction_view.bottom+5, DEVICE_WIDTH, 0)];
        shop_activity_view.backgroundColor = [UIColor whiteColor];
        [header_view addSubview:shop_activity_view];
    }else{
        for (UIView * view in shop_activity_view.subviews) {
            [view removeFromSuperview];
        }
        shop_activity_view.height = 0;
    }
    
    ///优惠活动介绍
    UILabel * label = [ZTools createLabelWithFrame:CGRectMake(10, 2.5, DEVICE_WIDTH-20, 20) text:@"优惠促销" textColor:DEFAULT_BLACK_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:14];
    label.font = [UIFont boldSystemFontOfSize:14];
    [shop_activity_view addSubview:label];
    
    UIView * line_view = [[UIView alloc] initWithFrame:CGRectMake(10, label.bottom+5, DEVICE_WIDTH-20, 0.5)];
    line_view.backgroundColor = DEFAULT_LINE_COLOR;
    [shop_activity_view addSubview:line_view];

    
    for (int i = 0; i < _shop_info.event_array.count; i++) {
        SellerDiscountModel * item = _shop_info.event_array[i];
        UILabel * type_label = [ZTools createLabelWithFrame:CGRectMake(10, line_view.bottom+5+25*i, 25, 15) text:[item.type intValue]==1?@"团购":[item.type intValue]==2?@"活动":@"" textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:12];
        type_label.backgroundColor = RGBCOLOR(252, 102, 34);
        [shop_activity_view addSubview:type_label];
        
        UILabel * title_label = [ZTools createLabelWithFrame:CGRectMake(type_label.right+5, type_label.top, shop_activity_view.width-type_label.right-15, 15) text:item.title textColor:DEFAULT_GRAY_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:12];
        [shop_activity_view addSubview:title_label];
    }
    
    shop_activity_view.height = 30+25*_shop_info.event_array.count;
}

#pragma mark -----   sectionView 数据填充
-(void)setSectionInfomation{
    [header_imageView sd_setImageWithURL:[NSURL URLWithString:_shop_info.photo] placeholderImage:[UIImage  imageNamed:@"homepage_comment_listitem_imgbg"]];
    
//    CGSize name_size = [ZTools stringHeightWithFont:seller_name_label.font WithString:_shop_info.name WithWidth:seller_name_label.width];
//    seller_name_label.height = name_size.height;
    seller_name_label.text = _shop_info.name;
    if (_shop_info.commend.intValue == 1) {
        _commend_imageView.hidden = NO;
    }else{
        _commend_imageView.hidden = YES;
    }
    _evaluation_view.rating = _shop_info.score.intValue/10.0;
    
    price_label.text = _shop_info.price;
    
    shop_type_label.text = _shop_info.sort;
    
    UIButton * address_button = (UIButton*)[header_view viewWithTag:1000];
    UILabel * address_label = (UILabel*)[header_view viewWithTag:10000];
    UIView * address_line_view = [header_view viewWithTag:100];
    address_label.text = _shop_info.address;
    
    UIButton * phone_button = (UIButton*)[header_view viewWithTag:1001];
    UILabel * phone_label = (UILabel*)[header_view viewWithTag:10001];
    UIView * phone_line_view = [header_view viewWithTag:101];
    
    phone_label.text = _shop_info.telphone;
    
    if ([_shop_info.address isKindOfClass:[NSNull class]] || _shop_info.address.length == 0) {
        if (address_button.height) {
            address_label.height = 0;
            address_button.height = 0;
            address_button.userInteractionEnabled = NO;
            address_line_view.hidden = YES;
            
            section_view1.height -= 40;
            section_view2.top = section_view1.bottom+10;
            header_view.height -= 40;
        }
    }else{
        if (address_button.height == 0) {
            address_label.height = 40;
            address_button.height = 40;
            address_button.userInteractionEnabled = YES;
            address_line_view.hidden = NO;
            
            section_view1.height += 40;
            section_view2.top = section_view1.bottom+10;
            header_view.height += 40;
        }
    }
    
    if ([_shop_info.telphone isKindOfClass:[NSNull class]] || _shop_info.telphone.length == 0) {
        if (phone_button.height) {
            phone_label.height = 0;
            phone_button.userInteractionEnabled = NO;
            phone_button.height = 0;
            phone_line_view.hidden = YES;
            
            section_view1.height-=40;
            section_view2.top = section_view1.bottom+10;
            header_view.height -= 40;
        }
    }else{
        if (phone_button.height == 0) {
            phone_label.height = 40;
            phone_button.userInteractionEnabled = YES;
            phone_button.height = 40;
            phone_line_view.hidden = NO;
            
            section_view1.height+=40;
            section_view2.top = section_view1.bottom+10;
            header_view.height += 40;
        }
    }
    
    comment_label.text = [NSString stringWithFormat:@"点评(%@)",_shop_info.comments];
    
    
    if (shop_introduction_view.height > 0) {
        shop_introduction_view.top = section_view1.bottom+10;
    }
    
    if (shop_activity_view.height > 0) {
        shop_activity_view.top = section_view1.bottom + (shop_introduction_view.height?(shop_introduction_view.height+20):10);
    }
    
    section_view2.top = section_view1.bottom + 10 + (shop_introduction_view.height?(shop_introduction_view.height+10):0) + (shop_activity_view.height?(shop_activity_view.height+10):0);
    
    header_view.height = section_view2.bottom;
}

#pragma mark ______________   跳转到商家介绍详情界面
-(void)showShopDetailTap:(UITapGestureRecognizer*)sender{
    SellerIntroductionViewController * introduction_vc = [[SellerIntroductionViewController alloc] init];
    introduction_vc.shop_info = _shop_info;
    [self pushToViewController:introduction_vc withAnimation:YES];
}

#pragma mark ----  我要点评
-(void)commentButtonTap:(UIButton*)button{
    CommentsViewController * commentsVC = [[CommentsViewController alloc] init];
    commentsVC.shop_id = _shop_id;
    [self.navigationController pushViewController:commentsVC animated:YES];
}
#pragma mark --------  地址或电话
-(void)addressAndPhoneTap:(UITapGestureRecognizer*)sender{
    if (sender.view.tag == 10000) {
        SDDMapViewController * sdd_vc = [[SDDMapViewController alloc] init];
        sdd_vc.address_content = _shop_info.telphone;
        sdd_vc.title_string = _shop_info.name;
        sdd_vc.address_latitude = [_shop_info.lat doubleValue];
        sdd_vc.address_longitude = [_shop_info.lng doubleValue];
        sdd_vc.address_title = _shop_info.name;
        [self.navigationController pushViewController:sdd_vc animated:YES];
    }else if(sender.view.tag == 10001){
        UIAlertView * alert_view = [[UIAlertView alloc] initWithTitle:_shop_info.telphone message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
        [alert_view show];
    }
}

#pragma mark ------   UITableViewDelegate
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
    cell.shop_name_label.text = model.dateline;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
}

#pragma mark --------  SNRefreshTableViewDelegate
-(void)loadNewData{
    [self loadSellerDetailData];
}

- (void)loadMoreData{
    [self loadSellerDetailData];
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_myTableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    CommentModel * model = _data_array[indexPath.row];
    CGSize content_size = [ZTools stringHeightWithFont:[UIFont systemFontOfSize:13] WithString:model.content WithWidth:DEVICE_WIDTH-80];
    
    return content_size.height + 20 + 50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark ------- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_shop_info.telphone]]];
    }
}
#pragma mark -----  UIActionSheetViewDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }else if (buttonIndex == 1){

    }
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







