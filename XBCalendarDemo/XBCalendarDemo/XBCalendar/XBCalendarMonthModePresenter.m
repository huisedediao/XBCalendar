//
//  XBCalendarMonthModePresenter.m
//  smarthome
//
//  Created by xxb on 2020/1/10.
//  Copyright © 2020 DreamCatcher. All rights reserved.
//

#import "XBCalendarMonthModePresenter.h"
#import "Masonry.h"
#import "XBCalendarMonthModeCell.h"
#import "XBCalendar.h"
#import "NSDate+Category.h"
#import "NSCalendar+XBCalendar.h"

@interface XBCalendarMonthModePresenter ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    int _year;
    int _month;
}
@property (nonatomic,strong) NSArray *arrDataSource;
@property (nonatomic,assign) BOOL isScrolling;
@end

@implementation XBCalendarMonthModePresenter

- (instancetype)init
{
    if (self = [super init])
    {
        _arrDataSource = [NSCalendar threedateArray:[XBCalendar currentCalendar].dateToday];
        _needHeight = [self newNeedHeight];
        [self createSubviews];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"8888 XBCalendarMonthModePresenter 销毁");
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
    
    [_collectionView registerClass:[XBCalendarMonthModeCell class] forCellWithReuseIdentifier:CellReuseID_XBCalendarMonthModeCell];
    
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
    return self.arrDataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.item;
    XBCalendarMonthModeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseID_XBCalendarMonthModeCell forIndexPath:indexPath];
    [cell refreshWithDataSource:self.arrDataSource[index]];
//    cell.contentView.backgroundColor = [UIColor colorWithRed:(arc4random() % 256) / 255.0 green:(arc4random() % 256) / 255.0 blue:(arc4random() % 256) / 255.0 alpha:1];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.bounds.size.width, (kDayBtnHeight + kDayBtnVSpace) * 6);
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
        [self forwardOneMonth];
        [self excuteDelegateMonthDidChange];
        [self refresh];
        [self excuteDelegateNeedHeightDidChangedIfNeed];
    }
    else if (currentIndex < kStartIndex)
    {
        [self backwardOneMonth];
        [self excuteDelegateMonthDidChange];
        [self refresh];
        [self excuteDelegateNeedHeightDidChangedIfNeed];
    }
    else
    {
        
    }
    
    self.isScrolling = NO;
}

- (void)excuteDelegateMonthDidChange
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(monthPresenterMonthDidChanged:)])
    {
        [self.delegate monthPresenterMonthDidChanged:self];
    }
}

- (void)excuteDelegateNeedHeightDidChangedIfNeed
{
    CGFloat needHeight = [self newNeedHeight];
    if (_needHeight != needHeight)
    {
        _needHeight = needHeight;
        if (self.delegate && [self.delegate respondsToSelector:@selector(monthPresenterNeedHeightDidChanged:)])
        {
            [self.delegate monthPresenterNeedHeightDidChanged:self];
        }
    }
}

- (void)refresh
{
    _arrDataSource = [NSCalendar threedateArray:[NSDate dateForDay:1 month:_month year:_year]];
    [_collectionView reloadData];
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:kStartIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (CGFloat)newNeedHeight
{
    NSInteger count = [NSCalendar dataCollectViewRowcount:[XBCalendar currentCalendar].currentDate firstDayIsSun:[XBCalendar currentCalendar].firstDay == XBCalendarWeekFirstDay_sun];
    return (kDayBtnHeight + kDayBtnVSpace) * count + 10;
}

- (void)forwardOneMonth
{
    NSDate *currentDate = [NSDate dateForDay:1 month:_month year:_year];
    NSDate *nextMonth = [NSCalendar nextMonth:currentDate];
    _year = nextMonth.year;
    _month = nextMonth.month;
}

- (void)backwardOneMonth
{
    NSDate *currentDate = [NSDate dateForDay:1 month:_month year:_year];
    NSDate *lastMonth = [NSCalendar lastMonth:currentDate];
    _year = lastMonth.year;
    _month = lastMonth.month;
}

#pragma mark - 公有方法
- (int)year
{
    return _year;
}

- (int)month
{
    return _month;
}

- (NSArray<NSDate *> *)selectedDates
{
    if (self.selectedStartDate == nil)
    {
        return @[];
    }
    NSDate *startDate = self.selectedStartDate;
    NSDate *endDate = nil;
    if (self.selectedEndDate)
    {
        NSTimeInterval endTime = [self.selectedEndDate timeIntervalSince1970] + 24 * 60 * 60;
        endDate = [NSDate dateWithTimeIntervalSince1970:endTime];
    }
    else
    {
        NSTimeInterval endTime = [startDate timeIntervalSince1970] + 24 * 60 * 60;
        endDate = [NSDate dateWithTimeIntervalSince1970:endTime];
    }
    return @[startDate,endDate];
}

- (void)showYear:(int)year month:(int)month
{
    _year = year;
    _month = month;
    [self excuteDelegateMonthDidChange];
    [self refresh];
    [self excuteDelegateNeedHeightDidChangedIfNeed];
}
/**
 选中某个日期
*/
- (void)addSelectedDate:(NSDate *)date
{
    NSTimeInterval newTime = [date timeIntervalSince1970];
    NSTimeInterval startTime = [_selectedStartDate timeIntervalSince1970];
    if (_selectedStartDate == nil)
    {
        _selectedStartDate = date;
    }
    else if (newTime == startTime)
    {
        if (_selectedEndDate)
        {
            _selectedEndDate = nil;
        }
    }
    else if (_selectedEndDate == nil)
    {
        if (newTime < startTime)
        {
            NSDate *tempDate = _selectedStartDate;
            _selectedStartDate = date;
            _selectedEndDate = tempDate;
        }
        else
        {
            _selectedEndDate = date;
        }
    }
    else
    {
        _selectedStartDate = date;
        _selectedEndDate = nil;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotice_calendarSelectedDateChanged object:nil];
}

@end
