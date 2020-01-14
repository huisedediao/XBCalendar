//
//  XBCalendarMonthThumbnailView.m
//  smarthome
//
//  Created by xxb on 2020/1/10.
//  Copyright © 2020 DreamCatcher. All rights reserved.
//

#import "XBCalendarMonthThumbnailView.h"
#import "NSCalendar+XBCalendar.h"
#import "NSDate+Category.h"
#import "XBCalendar.h"

@interface XBCalendarMonthThumbnailView ()
@property (nonatomic,strong) NSArray <NSDate *> *arrDates;
@end

@implementation XBCalendarMonthThumbnailView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"十一十一十一十一 XBCalendarMonthThumbnailView 销毁");
}

- (void)drawRect:(CGRect)rect
{
    NSInteger hCount = 7;
    CGFloat width = rect.size.width / 7;
    CGFloat vSpace = 5;
    CGFloat height = kFontSizeMonthThumbnailTitle;
    NSInteger firstDayIndex = [NSCalendar firstWeekdayIndexOfMonth:self.arrDates[0] firstDayIsSun:[XBCalendar currentCalendar].firstDay == XBCalendarWeekFirstDay_sun];
    
    for (NSDate *date in self.arrDates)
    {
        NSInteger index = [self.arrDates indexOfObject:date];
        
        NSInteger factIndex = index + firstDayIndex;
        NSInteger rowIndex = factIndex / hCount;
        NSInteger inRowIndex = factIndex % hCount;
        CGPoint topLeftPoint = CGPointMake(inRowIndex * width, rowIndex * (height + vSpace));
        
        NSString *dayStr = [NSString stringWithFormat:@"%02d",date.day];
        
        UIColor *textColor = nil;
        UIFont *font = nil;
        
        if ([XBCalendar currentCalendar].dateToday.year == date.year &&
            [XBCalendar currentCalendar].dateToday.month == date.month &&
            [XBCalendar currentCalendar].dateToday.day == date.day)
        {
            textColor = kColorDayTextToday;
            font = kFontMonthThumbnailTextToday;
        }
        else
        {
            textColor = kColorMonthThumbnailTitle;
            font = kFontMonthThumbnailText;
        }
        
        NSDictionary *params = @{NSForegroundColorAttributeName:textColor,NSFontAttributeName:font};
        [dayStr drawAtPoint:topLeftPoint withAttributes:params];
    }
    
}

- (void)refreshWithDates:(NSArray <NSDate *> *)arrDates
{
    _arrDates = arrDates;
    [self setNeedsDisplay];
}

@end
