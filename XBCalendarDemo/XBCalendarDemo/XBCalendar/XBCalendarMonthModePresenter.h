//
//  XBCalendarMonthModePresenter.h
//  smarthome
//
//  Created by xxb on 2020/1/10.
//  Copyright © 2020 DreamCatcher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBCalendarConfig.h"

@class XBCalendarMonthModePresenter;

@protocol XBCalendarMonthModePresenterDelegate <NSObject>

- (void)monthPresenterMonthDidChanged:(XBCalendarMonthModePresenter *_Nonnull)presenter;

- (void)monthPresenterNeedHeightDidChanged:(XBCalendarMonthModePresenter *_Nonnull)presenter;

@end

NS_ASSUME_NONNULL_BEGIN

@interface XBCalendarMonthModePresenter : UIView
@property (nonatomic,readonly,strong) UICollectionView *collectionView;
@property (nonatomic,readonly,assign) CGFloat needHeight;
/**
 选中的起始时间
*/
@property (nonatomic,readonly,strong) NSDate *selectedStartDate;
/**
 选中的结束时间
*/
@property (nonatomic,readonly,strong) NSDate *selectedEndDate;
@property (nonatomic,weak) id<XBCalendarMonthModePresenterDelegate>delegate;
- (int)year;
- (int)month;
- (NSArray <NSDate *> *)selectedDates;
- (void)showYear:(int)year month:(int)month;
/**
 选中某个日期
*/
- (void)addSelectedDate:(NSDate *)date;
@end

NS_ASSUME_NONNULL_END
