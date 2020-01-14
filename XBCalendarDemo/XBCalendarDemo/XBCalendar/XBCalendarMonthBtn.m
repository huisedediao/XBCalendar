//
//  XBCalendarMonthBtn.m
//  smarthome
//
//  Created by xxb on 2020/1/10.
//  Copyright © 2020 DreamCatcher. All rights reserved.
//

#import "XBCalendarMonthBtn.h"
#import "Masonry.h"
#import "XBCalendarMonthThumbnailView.h"
#import "NSCalendar+XBCalendar.h"
#import "NSDate+Category.h"

@interface XBCalendarMonthBtn ()
@property (nonatomic,strong) UILabel *labelTitle;
@property (nonatomic,strong) XBCalendarMonthThumbnailView *monthThumView;
@end

@implementation XBCalendarMonthBtn

- (instancetype)initWithMonth:(int)month
{
    if (self = [super init])
    {
        _month = month;
        [self createSubviews];
    }
    return self;
}

//- (void)dealloc
//{
//    NSLog(@"十十十十 XBCalendarMonthBtn 销毁");
//}

- (void)createSubviews
{
    self.labelTitle = ({
        UILabel *label = [UILabel new];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self);
            make.top.equalTo(self);
        }];
        label.textColor = kColorMonthBtnTitle;
        label.font = kFontMonthBtnTitle;
        label.text = [NSString stringWithFormat:@"%d月",self.month];
        label;
    });
    
    self.monthThumView = ({
        XBCalendarMonthThumbnailView *view = [XBCalendarMonthThumbnailView new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.labelTitle.mas_bottom).offset(5);
            make.bottom.trailing.equalTo(self);
            make.leading.equalTo(self);
        }];
        view;
    });
}
- (void)refreshWithYear:(int)year
{
    NSDate *date = [NSDate dateForDay:1 month:self.month year:year];
    NSArray *dates = [NSCalendar monthDateArray:date];
    [self.monthThumView refreshWithDates:dates];
}

@end
