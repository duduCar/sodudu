//
//  SNRefreshCollectionView.h
//  嘟嘟车管家
//
//  Created by joinus on 15/12/3.
//  Copyright © 2015年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SNRefreshCollectionViewDelegate <NSObject>

@optional
- (void)loadNewData;
- (void)loadMoreData;
-(NSInteger)sncollectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;

-(NSInteger)snnumberOfSectionsInCollectionView:(UICollectionView *)collectionView;

-(UICollectionViewCell*)sncollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

- (CGSize)sncollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
-(UIEdgeInsets)sncollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
- (CGFloat)sncollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
-(void)sncollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
-(BOOL)sncollectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath;

- (UICollectionReusableView *)sncollectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;

@end


@interface SNRefreshCollectionView : UICollectionView<L_EGORefreshTableDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,weak)id<SNRefreshCollectionViewDelegate>refreshDelegate;
@property (nonatomic,retain)LRefreshTableHeaderView * refreshHeaderView;

@property (nonatomic,assign)BOOL                        isReloadData;      //是否是下拉刷新数据
@property (nonatomic,assign)BOOL                        reloading;         //是否正在loading
@property (nonatomic,assign)BOOL                        isLoadMoreData;    //是否是载入更多
@property (nonatomic,assign)BOOL                        isHaveMoreData;    //是否还有更多数据,决定是否有更多view


@property (nonatomic,assign)int pageNum;//页数


@property(nonatomic,retain)UIActivityIndicatorView *loadingIndicator;
@property(nonatomic,retain)UILabel *normalLabel;
@property(nonatomic,retain)UILabel *loadingLabel;
@property(nonatomic,assign)BOOL hiddenLoadMore;//隐藏加载更多,默认隐藏

@property(nonatomic,strong)UICollectionReusableView * footer_view;

- (void)finishReloadigData;

@end
