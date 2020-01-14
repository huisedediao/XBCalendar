//
//  XBCalendar.m
//  smarthome
//
//  Created by xxb on 2020/1/8.
//  Copyright © 2020 DreamCatcher. All rights reserved.
//

#import "XBCalendar.h"
#import "Masonry.h"
#import "NSDate+Category.h"

static XBCalendar *currentCalendar_;

@interface XBCalendar () <XBCalendarMonthModePresenterDelegate,XBCalendarYearModePresenterDelegate>

@end

@implementation XBCalendar
@synthesize currentMode = _currentMode;

+ (instancetype)currentCalendar
{
    return currentCalendar_;
}

+ (void)setCurrentCalendar:(XBCalendar *)calendar
{
    currentCalendar_ = calendar;
}

+ (void)clearCurrentCalendar
{
    currentCalendar_ = nil;
}

- (instancetype)initWithFirstDay:(XBCalendarWeekFirstDay)firstDay delegate:(id<XBCalendarDelegate>)delegate
{
    if (self = [super init])
    {
        _delegate = delegate;
        _dateToday = [NSDate date];
        self.clipsToBounds = YES;
        _firstDay = firstDay;
        _currentMode = XBCalendarMode_month;
        [XBCalendar setCurrentCalendar:self];
        [self createSubviews];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"2222 XBCalendar 销毁");
}

- (void)createSubviews
{
    _yearPresenter = ({
        CGFloat height = kMonthBtnHeight * 4;
        XBCalendarYearModePresenter *yearPresenter = [[XBCalendarYearModePresenter alloc] init];
        [self addSubview:yearPresenter];
        [yearPresenter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
            make.height.mas_equalTo(height);
        }];
        yearPresenter.delegate = self;
        yearPresenter.alpha = 0;
        yearPresenter;
    });
    
    _monthPresenter = ({
        XBCalendarMonthModePresenter *presenter = [[XBCalendarMonthModePresenter alloc] init];
        [self addSubview:presenter];
        [presenter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
            make.height.mas_equalTo((kDayBtnHeight + kDayBtnVSpace) * 6);
        }];
        presenter.delegate = self;
        presenter;
    });

    [_monthPresenter.superview layoutIfNeeded];
    [_monthPresenter showYear:self.dateToday.year month:self.dateToday.month];
}

#pragma mark - XBCalendarMonthModePresenter代理
- (void)monthPresenterMonthDidChanged:(XBCalendarMonthModePresenter *)presenter
{
    [self excuteDelegateYearOrMnothDidChangeForMonthMode];
}

- (void)monthPresenterNeedHeightDidChanged:(XBCalendarMonthModePresenter * _Nonnull)presenter {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self excuteDelegateNeedHeight];
    });
}

#pragma mark - XBCalendarYearModePresenter代理
- (void)yearModePresenter:(XBCalendarYearModePresenter *)presenter didSelectedYear:(int)year month:(int)month
{
    [self changeToMode:XBCalendarMode_month];
    [self.monthPresenter showYear:year month:month];
}
- (void)yearModePresenter:(XBCalendarYearModePresenter *)presenter yearDidChanged:(int)year
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendar:year:month:didChangedForMode:)])
    {
        [self.delegate calendar:self year:year month:10000 didChangedForMode:XBCalendarMode_year];
    }
}

#pragma mark - 公有方法
/**
 切换显示模式
 */
- (void)changeToMode:(XBCalendarMode)mode
{
    if (_currentMode == mode)
    {
        return;
    }
    _currentMode = mode;
    if (mode == XBCalendarMode_month)
    {
        [self view:_yearPresenter makeTransitionAnimationWithDelegate:nil k_transitionType:@"fade"  kCATransitionFrom:kCATransitionFromRight duration:kCalendarAnimationTime];
        [UIView animateWithDuration:0.1 animations:^{
            self->_yearPresenter.alpha = 0;
            self.monthPresenter.alpha = 1;
        }];
        [self.monthPresenter showYear:self.monthPresenter.year month:self.monthPresenter.month];
    }
    else if (mode == XBCalendarMode_year)
    {
        [self view:self.monthPresenter makeTransitionAnimationWithDelegate:nil k_transitionType:@"fade"  kCATransitionFrom:kCATransitionFromLeft duration:kCalendarAnimationTime];
        [UIView animateWithDuration:0.1 animations:^{
            self.yearPresenter.alpha = 1;
            self.monthPresenter.alpha = 0;
        }];
        [self.yearPresenter showYear:self.monthPresenter.year];
    }
    [self excuteDelegateNeedHeight];
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarModeDidChanged:)])
    {
        [self.delegate calendarModeDidChanged:self];
    }
}

/**
 当前所处模式
 */
- (XBCalendarMode)currentMode
{
    return _currentMode;
}

/**
 选中的日期
 */
- (NSArray <NSDate *> *)selectedDates
{
    return self.monthPresenter.selectedDates;
}

- (NSDate *)currentDate
{
    return [NSDate dateForDay:1 month:self.monthPresenter.month year:self.monthPresenter.year];
}

- (CGFloat)needHeight
{
    CGFloat height = 0;
    if (_currentMode == XBCalendarMode_year)
    {
        height = [self.yearPresenter needHeight];
    }
    else if (_currentMode == XBCalendarMode_month)
    {
        height = [self.monthPresenter needHeight];
    }
    return height;
}

- (void)showThis
{
    if (self.currentMode == XBCalendarMode_month)
    {
        [self showThisMonthInfo];
    }
    else if (self.currentMode == XBCalendarMode_year)
    {
        [self showThisYearInfo];
    }
}

/**
 回到现在年份
 仅在年的模式下有效
 */
- (void)showThisYearInfo
{
    [self.yearPresenter showYear:self.dateToday.year];
}

/**
 回到现在的月份
 仅在月的模式下有效
 */
- (void)showThisMonthInfo
{
    [self.monthPresenter showYear:self.dateToday.year month:self.dateToday.month];
}

#pragma mark - 私有方法
- (void)view:(UIView *)view makeTransitionAnimationWithDelegate:(id <CAAnimationDelegate>)delegate k_transitionType:(NSString *)k_transitionType kCATransitionFrom:(NSString *)kCATransitionFrom duration:(NSTimeInterval)duration;
{
    CATransition *anim = [CATransition animation];
    anim.type = k_transitionType; // 动画过渡类型
    if (kCATransitionFrom != nil)
    {
        anim.subtype = kCATransitionFrom; // 动画过渡方向
    }
    anim.duration = duration; // 动画持续1s
    // 代理，动画执行完毕后会调用delegate的animationDidStop:finished:
    anim.delegate = delegate;
    [view.layer addAnimation:anim forKey:nil];
}
- (void)excuteDelegateYearOrMnothDidChangeForMonthMode
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendar:year:month:didChangedForMode:)])
    {
        [self.delegate calendar:self year:self.monthPresenter.year month:self.monthPresenter.month didChangedForMode:XBCalendarMode_month];
    }
}
- (void)excuteDelegateNeedHeight
{
    CGFloat height = [self needHeight];
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendar:needHeight:)])
    {
        [self.delegate calendar:self needHeight:height];
    }
}

@end

