//
//  SNRefreshCollectionView.m
//  嘟嘟车管家
//
//  Created by joinus on 15/12/3.
//  Copyright © 2015年 soulnear. All rights reserved.
//

#import "SNRefreshCollectionView.h"
#define TABLEFOOTER_HEIGHT 50.f
#define NORMAL_TEXT @"上拉加载更多"
#define NOMORE_TEXT @"没有更多数据"



@implementation SNRefreshCollectionView

-(id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.pageNum = 1;
        self.delegate = self;
        self.dataSource = self;
        self.isHaveMoreData = YES;
        [self createHeaderView];
    }
    return self;
}

-(void)createHeaderView
{
    if (_refreshHeaderView && _refreshHeaderView.superview) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = [[LRefreshTableHeaderView alloc]initWithFrame:CGRectMake(0.0f,0.0f -self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    _refreshHeaderView.backgroundColor = [UIColor clearColor];
    [self addSubview:_refreshHeaderView];
    [_refreshHeaderView refreshLastUpdatedDate];
}
-(void)removeHeaderView
{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = Nil;
}

- (void)createFooterView
{
    UICollectionReusableView *tableFooterView = [[UICollectionReusableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, DEVICE_WIDTH, TABLEFOOTER_HEIGHT)];
    
    [tableFooterView addSubview:self.loadingIndicator];
    [tableFooterView addSubview:self.loadingLabel];
    [tableFooterView addSubview:self.normalLabel];
    
    tableFooterView.backgroundColor = [UIColor clearColor];
    _footer_view = tableFooterView;
}


#pragma mark force to show the refresh headerView
//代码触发刷新
-(void)showRefreshHeader:(BOOL)animated
{
    if (animated)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.contentInset = UIEdgeInsetsMake(65.0f, 0.0f, 0.0f, 0.0f);
        [self scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        [UIView commitAnimations];
    }
    else
    {
        self.contentInset = UIEdgeInsetsMake(65.0f, 0.0f, 0.0f, 0.0f);
        [self scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
    }
    
    [_refreshHeaderView setState:L_EGOOPullRefreshLoading];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self];
}


-(void)showRefreshNoOffset
{
    _isReloadData = YES;
    
    //    self.userInteractionEnabled = NO;
    
    _reloading = YES;
    
    if (_refreshDelegate && [_refreshDelegate respondsToSelector:@selector(loadNewData)]) {
        
        self.pageNum = 1;
        [_refreshDelegate performSelector:@selector(loadNewData)];
    }
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_refreshHeaderView)
    {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    
    // 下拉到最底部时显示更多数据
    if(_isHaveMoreData && scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height+40) && scrollView.contentOffset.y > 0)
    {
        if (_refreshDelegate && [_refreshDelegate respondsToSelector:@selector(loadMoreData)]) {
            
            [self startLoading];
            
            _isLoadMoreData = YES;
            
            self.pageNum ++;
            [_refreshDelegate performSelector:@selector(loadMoreData)];
        }
    }
}


#pragma mark - EGORefreshTableDelegate
#pragma mark - EGORefreshTableDelegate
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    [self beginToReloadData:aRefreshPos];
}

//根据刷新类型，是看是下拉还是上拉
-(void)beginToReloadData:(EGORefreshPos)aRefreshPos
{
    //  should be calling your tableviews data source model to reload
    _reloading = YES;
    if (aRefreshPos ==  EGORefreshHeader)
    {
        _isReloadData = YES;
        
        if (_refreshDelegate && [_refreshDelegate respondsToSelector:@selector(loadNewData)]) {
            
            self.pageNum = 1;
            [_refreshDelegate performSelector:@selector(loadNewData)];
        }
    }
    
    // overide, the actual loading data operation is done in the subclass
}

//成功加载
- (void)reloadData:(NSArray *)data total:(int)totalPage
{
    if (self.pageNum < totalPage) {
        
        self.isHaveMoreData = YES;
    }else
    {
        self.isHaveMoreData = NO;
    }
    
    [self performSelector:@selector(finishReloadigData) withObject:nil afterDelay:0];
}

//请求数据失败

- (void)loadFail
{
    if (self.isLoadMoreData) {
        self.pageNum --;
    }
    [self performSelector:@selector(finishReloadigData) withObject:nil afterDelay:1.0];
    
}

//完成数据加载

- (void)finishReloadigData
{
    NSLog(@"finishReloadigData完成加载");
    _reloading = NO;
    if (_refreshHeaderView) {
        [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
        self.isReloadData = NO;
    }
    
    @try {
        
        [self reloadData];
        
    }
    @catch (NSException *exception) {
        
        NSLog(@"%@",exception);
    }
    @finally {
        
    }
    
    //如果有更多数据，重新设置footerview  frame
    if (self.isHaveMoreData)
    {
        [self stopLoading:1];
        
    }else {
        
        [self stopLoading:2];
    }
    
    
    self.userInteractionEnabled = YES;
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view
{
    return _reloading;
}
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
    return [NSDate date];
}

#pragma - mark 创建所需label 和 UIActivityIndicatorView

- (UIActivityIndicatorView*)loadingIndicator
{
    if (!_loadingIndicator) {
        _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadingIndicator.hidden = YES;
        _loadingIndicator.backgroundColor = [UIColor clearColor];
        _loadingIndicator.hidesWhenStopped = YES;
        _loadingIndicator.frame = CGRectMake(self.frame.size.width/2 - 70 ,6+2 + (TABLEFOOTER_HEIGHT - 40)/2.0, 24, 24);
    }
    return _loadingIndicator;
}

- (UILabel*)normalLabel
{
    if (!_normalLabel) {
        _normalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 8 + (TABLEFOOTER_HEIGHT - 40)/2.0, self.frame.size.width, 20)];
        _normalLabel.text = NSLocalizedString(NORMAL_TEXT, nil);
        _normalLabel.backgroundColor = [UIColor clearColor];
        [_normalLabel setFont:[UIFont systemFontOfSize:14]];
        _normalLabel.textAlignment = NSTextAlignmentCenter;
        [_normalLabel setTextColor:[UIColor darkGrayColor]];
    }
    
    return _normalLabel;
    
}

- (UILabel*)loadingLabel
{
    if (!_loadingLabel) {
        _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(320.f/2-80,8 + (TABLEFOOTER_HEIGHT - 40)/2.0, self.frame.size.width/2+30, 20)];
        _loadingLabel.text = NSLocalizedString(@"加载中...", nil);
        _loadingLabel.backgroundColor = [UIColor clearColor];
        [_loadingLabel setFont:[UIFont systemFontOfSize:14]];
        _loadingLabel.textAlignment = NSTextAlignmentCenter;
        [_loadingLabel setTextColor:[UIColor darkGrayColor]];
        [_loadingLabel setHidden:YES];
    }
    
    return _loadingLabel;
}


- (void)startLoading
{
    [self.loadingIndicator startAnimating];
    [self.loadingLabel setHidden:NO];
    [self.normalLabel setHidden:YES];
}

- (void)stopLoading:(int)loadingType
{
    _isLoadMoreData = NO;
    
    [self.loadingIndicator stopAnimating];
    switch (loadingType) {
        case 1:
            [self.normalLabel setHidden:NO];
            [self.normalLabel setText:NSLocalizedString(NORMAL_TEXT, nil)];
            [self.loadingLabel setHidden:YES];
            break;
        case 2:
            [self.normalLabel setHidden:NO];
            [self.normalLabel setText:NSLocalizedString(NOMORE_TEXT, nil)];
            [self.loadingLabel setHidden:YES];
            break;
        default:
            break;
    }
}

#pragma mark ***********  UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger number = 0;
    if (_refreshDelegate && [_refreshDelegate respondsToSelector:@selector(sncollectionView:numberOfItemsInSection:)]) {
        number = [_refreshDelegate sncollectionView:collectionView numberOfItemsInSection:section];
    }
    return number;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    NSInteger number = 0;
    if (_refreshDelegate && [_refreshDelegate respondsToSelector:@selector(snnumberOfSectionsInCollectionView:)]) {
        number = [_refreshDelegate snnumberOfSectionsInCollectionView:collectionView];
    }
    return number;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = nil;
    if (_refreshDelegate && [_refreshDelegate respondsToSelector:@selector(sncollectionView:cellForItemAtIndexPath:)]) {
        cell = [_refreshDelegate sncollectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeZero;
    if (_refreshDelegate && [_refreshDelegate respondsToSelector:@selector(sncollectionView:layout:sizeForItemAtIndexPath:)]) {
        size = [_refreshDelegate sncollectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
    return size;
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edge = UIEdgeInsetsZero;
    if (_refreshDelegate && [_refreshDelegate respondsToSelector:@selector(sncollectionView:layout:insetForSectionAtIndex:)]) {
        edge = [_refreshDelegate sncollectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
    }
    return edge;
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    CGFloat number = 0.0;
    if (_refreshDelegate && [_refreshDelegate respondsToSelector:@selector(sncollectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        number = [_refreshDelegate sncollectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:section];
    }
    return number;
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_refreshDelegate && [_refreshDelegate respondsToSelector:@selector(sncollectionView:didSelectItemAtIndexPath:)]) {
        [_refreshDelegate sncollectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL shouldSelect;
    
    if (_refreshDelegate && [_refreshDelegate respondsToSelector:@selector(sncollectionView:shouldSelectItemAtIndexPath:)]) {
        shouldSelect = [_refreshDelegate sncollectionView:collectionView shouldSelectItemAtIndexPath:indexPath];
    }
    return shouldSelect;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (kind == UICollectionElementKindSectionFooter)
    {
        UICollectionReusableView *FooterView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        [FooterView addSubview:self.loadingIndicator];
        [FooterView addSubview:self.loadingLabel];
        [FooterView addSubview:self.normalLabel];
        _footer_view = FooterView;
    }
    
    _footer_view.backgroundColor = [UIColor clearColor];
    return _footer_view;
}


@end
