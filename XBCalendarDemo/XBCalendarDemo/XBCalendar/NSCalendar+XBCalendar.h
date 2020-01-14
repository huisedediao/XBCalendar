//
//  NSCalendar+XBCalendar.h
//  smarthome
//
//  Created by 谢贤彬 on 2020/1/11.
//  Copyright © 2020 DreamCatcher. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSCalendar (XBCalendar)

/**
 上个月，如果date是2 28 11:23，则返回的是 1 28 11:23
 */
+ (NSDate *)lastMonth:(NSDate *)date;

/**
 下个月，如果date是1 31 11:23，则返回的是 2 28(29) 11:23
 */
+ (NSDate *)nextMonth:(NSDate *)date;

/**
 date所在的月的第一天的序号，0 - 6
 */
+ (NSInteger)firstWeekdayIndexOfMonth:(NSDate *)date firstDayIsSun:(BOOL)firstDayIsSun;

/**
 date所在的月总共有多少天
 */
+ (NSInteger)totaldaysInMonth:(NSDate *)date;

/**
 计算date所在的月，在日历控件中需要几行来展示（7天一行）
 */
+ (NSInteger)dataCollectViewRowcount:(NSDate *)date firstDayIsSun:(BOOL)firstDayIsSun;

/**
 @[@[上一个月的所有date],@[date所在月的所有date],@[下一个月的所有date]]
 返回三个月的所有date（每天的零点）
 */
+ (NSArray *)threedateArray:(NSDate *)date;

/**
 返回date所在月的所有date（每天的零点）
 */
+ (NSArray *)monthDateArray:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
