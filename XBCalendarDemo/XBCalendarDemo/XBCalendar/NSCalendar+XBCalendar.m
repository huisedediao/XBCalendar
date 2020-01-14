//
//  NSCalendar+XBCalendar.m
//  smarthome
//
//  Created by 谢贤彬 on 2020/1/11.
//  Copyright © 2020 DreamCatcher. All rights reserved.
//

#import "NSCalendar+XBCalendar.h"

@implementation NSCalendar (XBCalendar)

/**
 上个月，如果date是2 28 11:23，则返回的是 1 28 11:23
 */
+ (NSDate *)lastMonth:(NSDate *)date
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

/**
 下个月，如果date是1 31 11:23，则返回的是 2 28(29) 11:23
 */
+ (NSDate *)nextMonth:(NSDate *)date
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

/**
 date所在的月的第一天的序号，0 - 6
 */
+ (NSInteger)firstWeekdayIndexOfMonth:(NSDate *)date firstDayIsSun:(BOOL)firstDayIsSun
{
    if (!date)
    {
        return 0;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //设置每周的第一天从周几开始,默认为1,从周日开始
    if (firstDayIsSun)
    {
        [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    }
    else
    {
        [calendar setFirstWeekday:2];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    }
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

/**
 date所在的月总共有多少天
 */
+ (NSInteger)totaldaysInMonth:(NSDate *)date
{
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}

/**
 计算date所在的月，在日历控件中需要几行来展示（7天一行）
 */
+ (NSInteger)dataCollectViewRowcount:(NSDate *)date firstDayIsSun:(BOOL)firstDayIsSun
{
    NSInteger number = [self firstWeekdayIndexOfMonth:date firstDayIsSun:firstDayIsSun] + [self totaldaysInMonth:date];
    if (number > 28)
    {
        if (number >35 )
        {
            return 6;
        }
        else
        {
            return 5;
        }
    }
    else
    {
        return 4;
    }
}

/**
 @[@[上一个月的所有date],@[date所在月的所有date],@[下一个月的所有date]]
 返回三个月的所有date（每天的零点）
 */
+ (NSArray *)threedateArray:(NSDate *)date
{
    if (!date)
    {
        return nil;
    }
    NSDate *lastMonth = [self lastMonth:date];
    NSDate *nexttMonth = [self nextMonth:date];
    NSArray *array = @[[self monthDateArray:lastMonth],[self monthDateArray:date],[self monthDateArray:nexttMonth]];
    return array;
    
}

/**
 返回date所在月的所有date（每天的零点）
 */
+ (NSArray *)monthDateArray:(NSDate *)date
{
    if (!date)
    {
        return nil;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSInteger currentinteger = [self totaldaysInMonth:firstDayOfMonthDate];
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int i = 0; i < currentinteger; i++)
    {
        NSDateComponents *dayComponent = [NSDateComponents new];
        dayComponent.day = 1;
        [mutableArray addObject:firstDayOfMonthDate];
        firstDayOfMonthDate = [calendar dateByAddingComponents:dayComponent toDate:firstDayOfMonthDate options:0];
    }
    return [mutableArray copy];
}

@end
