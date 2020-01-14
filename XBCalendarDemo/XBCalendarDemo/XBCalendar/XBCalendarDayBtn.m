//
//  XBCalendarDayBtn.m
//  smarthome
//
//  Created by xxb on 2020/1/9.
//  Copyright © 2020 DreamCatcher. All rights reserved.
//

#import "XBCalendarDayBtn.h"
#import "XBCalendarConfig.h"
#import "Masonry.h"
#import "NSDate+Category.h"
#import "XBCalendar.h"

@interface XBCalendarDayBtn ()
@property (nonatomic,strong) UILabel *labelTitle;
@property (nonatomic,strong) CALayer *selectedPointCircleLayer;
@property (nonatomic,strong) CALayer *selectedPointLayerLeft;
@property (nonatomic,strong) CALayer *selectedPointLayerRight;
@end

@implementation XBCalendarDayBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addNotice];
        [self createSubviews];
    }
    return self;
}

- (void)dealloc
{
//    NSLog(@"7777 XBCalendarDayBtn 销毁");
    [self removeNotice];
}

- (void)createSubviews
{
    self.labelTitle = ({
        UILabel *label = [UILabel new];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        label.font = kFontDayTextDefault;
        label.textColor = kColorDayTextDefault;
        label;
    });
}

#pragma mark - 方法重写
- (void)setDate:(NSDate *)date
{
    _date = date;
    
    NSString *dateStr = [NSDate stringFromDate:date format:@"dd"];
    self.labelTitle.text = dateStr;
    
    [self changeState];
}

#pragma mark - 通知相关
- (void)addNotice
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calendarSelectedDateChanged:) name:kNotice_calendarSelectedDateChanged object:nil];
}

- (void)removeNotice
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)calendarSelectedDateChanged:(NSNotification *)noti
{
    [self changeState];
}

#pragma mark - 私有方法
- (void)changeState
{
    if (self.selectedPointLayerLeft)
    {
        [self.selectedPointLayerLeft removeFromSuperlayer];
        self.selectedPointLayerLeft = nil;
    }
    if (self.selectedPointLayerRight)
    {
        [self.selectedPointLayerRight removeFromSuperlayer];
        self.selectedPointLayerRight = nil;
    }
    if (self.selectedPointCircleLayer)
    {
        [self.selectedPointCircleLayer removeFromSuperlayer];
        self.selectedPointCircleLayer = nil;
    }
    NSDate *startDate = [XBCalendar currentCalendar].monthPresenter.selectedStartDate;
    NSDate *endDate = [XBCalendar currentCalendar].monthPresenter.selectedEndDate;
    NSTimeInterval startTime = [startDate timeIntervalSince1970];
    NSTimeInterval endTime = [endDate timeIntervalSince1970];
    NSTimeInterval selfTime = [self.date timeIntervalSince1970];
    if (selfTime == startTime)
    {
        [self selectedPointStateStart];
    }
    else if (selfTime == endTime)
    {
        [self selectedPointStateEnd];
    }
    else if (selfTime > startTime && selfTime < endTime)
    {
        [self selectedState];
    }
    else
    {
        [self unSelectedState];
    }
}

///选中状态
- (void)selectedState
{
    self.labelTitle.textColor = kColorDayTextSelected;
    self.backgroundColor = kColorDayBtnSelectedState;
}

///未选中状态
- (void)unSelectedState
{
    NSDate *showedDate = [XBCalendar currentCalendar].dateToday;
    if (showedDate.year == self.date.year &&
        showedDate.month == self.date.month &&
        showedDate.day == self.date.day)
    {
        self.labelTitle.textColor = kColorDayTextToday;
    }
    else
    {
        self.labelTitle.textColor = kColorDayTextDefault;
    }
    self.backgroundColor = kColorDayBtnUnSelectedState;
}

///选中并且是区间的头
- (void)selectedPointStateStart
{
    self.labelTitle.textColor = kColorDayTextSelected;
    self.backgroundColor = kColorDayBtnUnSelectedState;
    
    if ([XBCalendar currentCalendar].monthPresenter.selectedStartDate && [XBCalendar currentCalendar].monthPresenter.selectedEndDate)
    {
        self.selectedPointLayerRight = ({
            CALayer *layer = [[CALayer alloc] init];
            [self.layer insertSublayer:layer below:self.labelTitle.layer];
            layer.frame = CGRectMake(self.bounds.size.width / 2, 0, self.bounds.size.width / 2, self.bounds.size.height);
            layer.backgroundColor = kColorDayBtnSelectedState.CGColor;
            layer;
        });
    }
    
    [self createSelectedPointCircleLayer];
}
///选中并且是区间的尾
- (void)selectedPointStateEnd
{
    self.labelTitle.textColor = kColorDayTextSelected;
    self.backgroundColor = kColorDayBtnUnSelectedState;
    
    if ([XBCalendar currentCalendar].monthPresenter.selectedStartDate && [XBCalendar currentCalendar].monthPresenter.selectedEndDate)
    {
        self.selectedPointLayerLeft = ({
            CALayer *layer = [[CALayer alloc] init];
            [self.layer insertSublayer:layer below:self.labelTitle.layer];
            layer.frame = CGRectMake(0, 0, self.bounds.size.width / 2, self.bounds.size.height);
            layer.backgroundColor = kColorDayBtnSelectedState.CGColor;
            layer;
        });
    }
    [self createSelectedPointCircleLayer];
}

- (void)createSelectedPointCircleLayer
{
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat left = (selfWidth - kDayBtnHeight) / 2 - 0.15;
    
    self.selectedPointCircleLayer = ({
        CALayer *layer = [CALayer new];
        [self.layer insertSublayer:layer below:self.labelTitle.layer];
        layer.frame = CGRectMake(left, 0, kDayBtnHeight, kDayBtnHeight);
        layer.backgroundColor = kColorDayBtnSelectedPointState.CGColor;
        layer.cornerRadius = kDayBtnHeight * 0.5;
        layer;
    });
}
@end
