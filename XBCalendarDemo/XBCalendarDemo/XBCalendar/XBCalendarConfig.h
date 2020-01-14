//
//  XBCalendarConfig.h
//  smarthome
//
//  Created by xxb on 2020/1/8.
//  Copyright © 2020 DreamCatcher. All rights reserved.
//

#ifndef XBCalendarConfig_h
#define XBCalendarConfig_h

typedef enum : NSUInteger {
    XBCalendarMode_year,
    XBCalendarMode_month,
} XBCalendarMode;

typedef enum : NSUInteger {
    XBCalendarWeekFirstDay_sun,
    XBCalendarWeekFirstDay_mon,
} XBCalendarWeekFirstDay;


#define kStartIndex (1)

#define kCalendarAnimationTime (0.3)

#define kDayBtnHeight (44)
#define kDayBtnVSpace (5)
#define kMonthBtnVSpace (5)
#define kMonthBtnTitleLeft (20)
#define kMonthBtnHeight ((((kCalendarWidth - kMonthBtnTitleLeft * 4) / 3) + kMonthBtnVSpace) * kMonthThumbnailHWScale)

#define kFontSizeMonthThumbnailTitle (8)

#define kMonthThumbnailHWScale (1.1)

#define kCalendarWidth ([UIScreen mainScreen].bounds.size.width)


#define kFontDayTextDefault [UIFont systemFontOfSize:14]
#define kFontDayTextSelected [UIFont systemFontOfSize:14]
#define kFontMonthBtnTitle [UIFont boldSystemFontOfSize:18]
#define kFontMonthThumbnailText [UIFont boldSystemFontOfSize:kFontSizeMonthThumbnailTitle]
#define kFontMonthThumbnailTextToday [UIFont boldSystemFontOfSize:kFontSizeMonthThumbnailTitle]

#define kColorDayTextDefault [UIColor blackColor]
#define kColorDayTextSelected [UIColor whiteColor]
#define kColorDayTextToday [UIColor orangeColor]
#define kColorDayBtnSelectedPointState [UIColor orangeColor]
#define kColorDayBtnSelectedState [[UIColor orangeColor] colorWithAlphaComponent:0.3]

#define kColorDayBtnUnSelectedState [UIColor clearColor]
#define kColorMonthBtnTitle [UIColor orangeColor]
#define kColorMonthThumbnailTitle [UIColor blackColor]


#define kNotice_calendarSelectedDateChanged @"kNotice_calendarSelectedDateChanged"

#endif /* XBCalendarConfig_h */
