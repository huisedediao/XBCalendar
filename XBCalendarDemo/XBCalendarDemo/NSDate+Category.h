//
//  NSDate+Category.h
//  Calendar
//
//  Created by Mako on 16/12/17.
//  Copyright © 2016年 SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Category)
- (int)year;
- (int)month;
- (int)day;
- (int)hour;
- (NSString *)weekString;
- (NSDate *)offsetDay:(int)numDays;
- (BOOL)isToday;

+ (NSDate *)dateForDay:(unsigned int)day month:(unsigned int)month year:(unsigned int)year;
+ (NSDate *)dateStartOfDay:(NSDate *)date;
+ (int)dayBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;
+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format timeZone:(NSTimeZone *)timeZone;
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;
+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSDate *)dateFromStringBySpecifyTime:(NSString *)dateString hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
+ (NSDateComponents *)nowDateComponents;
+ (NSDateComponents *)dateComponentsFromNow:(NSInteger)days;
@end
