//
//  XBCalendarYearModePresenter.m
//  smarthome
//
//  Created by xxb on 2020/1/10.
//  Copyright © 2020 DreamCatcher. All rights reserved.
//

#import "XBCalendarYearModePresenter.h"
#import "Masonry.h"
#import "XBCalendarYearModeCell.h"

@interface XBCalendarYearModePresenter ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,assign) BOOL isScrolling;
@end

@implementation XBCalendarYearModePresenter

- (instancetype)init
{
    if (self = [super init])
    {
        [self createSubviews];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"9999 XBCalendarYearModePresenter 销毁");
}

- (void)createSubviews
{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.minimumInteritemSpacing = 0;
    flow.minimumLineSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 10, 100, 100) collectionViewLayout:flow];
    [self addSubview:_collectionView];
    
    _collectionView.pagingEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.bounces = NO;
    
    [_collectionView registerClass:[XBCalendarYearModeCell class] forCellWithReuseIdentifier:CellReuseID_XBCalendarYearModeCell];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:kStartIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    });
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refresh];
    });
}

#pragma mark - collectionView代理和数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    
    typeof(self) __weak weakSelf = self;
    XBCalendarYearModeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseID_XBCalendarYearModeCell forIndexPath:indexPath];
    cell.didSelectedBlock = ^(NSInteger month) {
        NSLog(@"selecte month : %ld",month);
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(yearModePresenter:didSelectedYear:month:)])
        {
            [weakSelf.delegate yearModePresenter:weakSelf didSelectedYear:weakSelf.year month:(int)month];
        }
    };
    [cell refreshWithYear:(int)(self.year + index - 1)];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.bounds.size.width, [self needHeight]);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark - scrollView代理
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.isScrolling)
    {
        return;
    }
    self.isScrolling = YES;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint pInView = [self convertPoint:self.collectionView.center toView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pInView];
    NSInteger currentIndex = indexPath.item;
    if (currentIndex > kStartIndex)
    {
        [self showYear:_year + 1];
    }
    else if (currentIndex < kStartIndex)
    {
        [self showYear:_year - 1];
    }
    else
    {
        
    }
    
    self.isScrolling = NO;
}

- (void)excuteDelegateYearDidChanged
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(yearModePresenter:yearDidChanged:)])
    {
        [self.delegate yearModePresenter:self yearDidChanged:self.year];
    }
}

- (CGFloat)needHeight
{
//    CGFloat width = (self.bounds.size.width - kMonthBtnTitleLeft * 4) / 3;
//    CGFloat height = (width + kMonthBtnVSpace) * kMonthThumbnailHWScale * 4;
//    return height;
    return kMonthBtnHeight * 4;
}

- (void)showYear:(int)year
{
    _year = year;
    [self refresh];
    [self excuteDelegateYearDidChanged];
}

- (void)refresh
{
    [_collectionView reloadData];
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:kStartIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

@end
