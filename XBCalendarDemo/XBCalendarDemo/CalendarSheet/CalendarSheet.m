//
//  CalendarSheet.m
//  smarthome
//
//  Created by xxb on 2020/1/8.
//  Copyright © 2020 DreamCatcher. All rights reserved.
//

#import "CalendarSheet.h"
#import "XBCalendar.h"
#import "Masonry.h"

#define kActionBarHeight (50)
#define kCanlendarSpaceToActionBar (15)
#define kAnimationTime (0.3)

#define kFullHeight [UIScreen mainScreen].bounds.size.height
#define iPhoneXHeight 812

#define kSafeArea_Top       ((kFullHeight >= iPhoneXHeight) ? 24 : 0)
#define kSafeArea_Bottom    ((kFullHeight >= iPhoneXHeight) ? 34 : 0)

#define selfHeight (kActionBarHeight + self.calendarHeight + kSafeArea_Bottom + kCanlendarSpaceToActionBar)

@interface CalendarSheet () <XBCalendarDelegate>

@property (nonatomic,assign) CGFloat calendarHeight;

@property (nonatomic,strong) UIView *actionBar;
@property (nonatomic,strong) UIButton *btnYearMonth;
@property (nonatomic,strong) UIButton *btnShowThis;
@property (nonatomic,strong) UIButton *btnDone;

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) XBCalendar *calendar;

@end

@implementation CalendarSheet

- (void)dealloc
{
    NSLog(@"1111 CalendarSheet 销毁");
}

- (void)hidden
{
    [super hidden];
    [XBCalendar clearCurrentCalendar];
}

- (void)actionBeforeShow
{
    self.backgroundViewColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    [self createActionBar];
    [self createCalendar];
    
    CGFloat height = selfHeight;
    self.showLayoutBlock = ^(XBAlertViewBase *alertView) {
        [alertView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(alertView.superview);
            make.height.mas_equalTo(height);
            make.bottom.equalTo(alertView.superview);
        }];
    };
    
    self.hiddenLayoutBlock = ^(XBAlertViewBase *alertView) {
        [alertView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(alertView.superview);
            make.height.mas_equalTo(height);
            make.top.equalTo(alertView.superview.mas_bottom);
        }];
    };
}

- (void)createActionBar
{
    self.actionBar = [UIView new];
    [self addSubview:self.actionBar];
    self.actionBar.backgroundColor = [UIColor clearColor];
    [self.actionBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self);
        make.height.mas_equalTo(kActionBarHeight);
    }];

    self.btnYearMonth = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.actionBar addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.bottom.equalTo(self.actionBar);
            make.width.mas_equalTo(80);
        }];
        [btn addTarget:self action:@selector(changeMode:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn;
    });

    self.btnDone = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.actionBar addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.top.bottom.equalTo(self.actionBar);
            make.width.mas_equalTo(60);
        }];
        [btn addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"Done" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn;
    });

    self.btnShowThis = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.actionBar addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.actionBar);
            make.trailing.equalTo(self.btnDone.mas_leading).offset(-20);
            make.width.mas_equalTo(50);
        }];
        [btn addTarget:self action:@selector(showThis:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"今天" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn;
    });
}

- (void)createCalendar
{
    self.contentView = ({
        UIView *view = [UIView new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(kActionBarHeight + kCanlendarSpaceToActionBar);
            make.leading.trailing.equalTo(self);
            make.bottom.equalTo(self).offset(- kSafeArea_Bottom);
        }];
        view.clipsToBounds = YES;
        view;
    });
    self.calendar = ({
        CGFloat height = kMonthBtnHeight * 4;
        XBCalendar *calendar = [[XBCalendar alloc] initWithFirstDay:XBCalendarWeekFirstDay_sun delegate:self];
        [self.contentView addSubview:calendar];
        [calendar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.leading.trailing.equalTo(self.contentView);
            make.height.mas_equalTo(height);
        }];
        calendar;
    });
    self.calendarHeight = [self.calendar needHeight];
}

- (void)updateFrame
{
    [UIView animateWithDuration:kAnimationTime animations:^{
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.superview);
            make.height.mas_equalTo(selfHeight);
            make.bottom.equalTo(self.superview);
        }];
        [self.superview layoutIfNeeded];
    }];
}

#pragma mark - 点击事件
- (void)changeMode:(UIButton *)btn
{
    if (self.calendar.currentMode == XBCalendarMode_year)
    {
        [self.calendar changeToMode:XBCalendarMode_month];
    }
    else
    {
        [self.calendar changeToMode:XBCalendarMode_year];
    }
}
- (void)done:(UIButton *)btn
{
    if (self.calendar.selectedDates.count)
    {
        [self hidden];
        if (self.doneBlock)
        {
            self.doneBlock(self.calendar.selectedDates);
        }
    }
    else
    {
        NSLog(@"尚未选择日期");
    }
}
- (void)showThis:(UIButton *)btn
{
    [self.calendar showThis];
}

#pragma mark - calendar代理
- (void)calendarModeDidChanged:(XBCalendar *)calendar
{
    if (calendar.currentMode == XBCalendarMode_year)
    {
        [self.btnShowThis setTitle:@"今年" forState:UIControlStateNormal];
    }
    else
    {
        [self.btnShowThis setTitle:@"今天" forState:UIControlStateNormal];
    }
}
- (void)calendar:(XBCalendar *)calendar needHeight:(CGFloat)height
{
    NSLog(@"need height : %f",height);
    if (self.calendarHeight == height)
    {
        return;
    }
    self.calendarHeight = height;
    [self updateFrame];
}
- (void)calendar:(XBCalendar *)calendar year:(int)year month:(int)month didChangedForMode:(XBCalendarMode)mode
{
    if (mode == XBCalendarMode_month)
    {
        NSString *yearStr = [NSString stringWithFormat:@"%d",year];
        NSString *string = [NSString stringWithFormat:@"%02d %@",month,yearStr];
        [self.btnYearMonth setTitle:string forState:UIControlStateNormal];
    }
    else if (mode == XBCalendarMode_year)
    {
        NSString *string = [NSString stringWithFormat:@"%d",year];
        [self.btnYearMonth setTitle:string forState:UIControlStateNormal];
    }
}

@end
