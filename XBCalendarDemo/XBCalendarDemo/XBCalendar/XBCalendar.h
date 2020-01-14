//
//  XBCalendar.h
//  smarthome
//
//  Created by xxb on 2020/1/8.
//  Copyright © 2020 DreamCatcher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBCalendarConfig.h"
#import "XBCalendarMonthModePresenter.h"
#import "XBCalendarYearModePresenter.h"

@class XBCalendar;

@protocol XBCalendarDelegate <NSObject>

/**
 显示模式发生改变
*/
- (void)calendarModeDidChanged:(XBCalendar *_Nonnull)calendar;

/**
 展示完全所需高度
 */
- (void)calendar:(XBCalendar *_Nonnull)calendar needHeight:(CGFloat)height;

/**
 展示的年份或者月份发生改变
*/
- (void)calendar:(XBCalendar *_Nonnull)calendar year:(int)year month:(int)month didChangedForMode:(XBCalendarMode)mode;

@end

NS_ASSUME_NONNULL_BEGIN

@interface XBCalendar : UIView
/**
 当前所处模式
*/
@property (nonatomic,readonly,assign) XBCalendarMode currentMode;
@property (nonatomic,readonly,strong) NSDate *dateToday;
@property (nonatomic,readonly,assign) XBCalendarWeekFirstDay firstDay;
@property (nonatomic,readonly,strong) XBCalendarMonthModePresenter *monthPresenter;
@property (nonatomic,readonly,strong) XBCalendarYearModePresenter *yearPresenter;
@property (nonatomic,weak) id<XBCalendarDelegate>delegate;

+ (instancetype)currentCalendar;
+ (void)setCurrentCalendar:(XBCalendar *)calendar;
+ (void)clearCurrentCalendar;

- (instancetype)initWithFirstDay:(XBCalendarWeekFirstDay)firstDay delegate:(id<XBCalendarDelegate>)delegate;

/**
 切换显示模式
 */
- (void)changeToMode:(XBCalendarMode)mode;

/**
 选中的日期
 */
- (NSArray <NSDate *> *)selectedDates;

/**
 回到现在的年份或者月份
 */
- (void)showThis;

/**
 根据currentYear和currentMonth获得
 */
- (NSDate *)currentDate;

- (CGFloat)needHeight;

@end

NS_ASSUME_NONNULL_END
