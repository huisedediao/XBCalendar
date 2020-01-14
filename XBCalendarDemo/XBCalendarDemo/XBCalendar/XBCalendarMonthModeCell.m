//
//  XBCalendarMonthModeCell.m
//  smarthome
//
//  Created by xxb on 2020/1/8.
//  Copyright © 2020 DreamCatcher. All rights reserved.
//

#import "XBCalendarMonthModeCell.h"
#import "NSDate+Category.h"
#import "Masonry.h"
#import "NSCalendar+XBCalendar.h"
#import "XBCalendarDayBtn.h"
#import "XBCalendar.h"

#define kTagBase (1277)

@interface XBCalendarMonthModeCell ()
@property (nonatomic,strong) NSMutableArray *arrmBtns;
@property (nonatomic,assign) NSInteger firstDayIndex;
@end

@implementation XBCalendarMonthModeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.arrmBtns = [NSMutableArray new];
        [self createSubviews];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"5555 XBCalendarMonthModeCell 销毁");
}

- (void)createSubviews
{
    int vCount = 6;
    int hCount = 7;
    
    CGFloat height = kDayBtnHeight;
    for (int i = 0; i < vCount; i++)
    {
        CGFloat top = (height + kDayBtnVSpace) * i;
        XBCalendarDayBtn *lastBtn;
        for (int j = 0; j < hCount; j++)
        {
            XBCalendarDayBtn *btn = [XBCalendarDayBtn new];
            [self addSubview:btn];
            [self.arrmBtns addObject:btn];
//            btn.backgroundColor = [UIColor colorWithRed:(arc4random() % 256) / 255.0 green:(arc4random() % 256) / 255.0 blue:(arc4random() % 256) / 255.0 alpha:1];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(top);
                make.height.mas_equalTo(height);
                if (j == 0)
                {
                    make.leading.equalTo(self);
                }
                else
                {
                    make.leading.equalTo(lastBtn.mas_trailing);
                }
                if (j == hCount - 1)
                {
                    make.trailing.equalTo(self);
                }
                if (lastBtn)
                {
                    make.width.equalTo(lastBtn);
                }
            }];
            btn.tag = kTagBase + i * hCount + j;
            [btn addTarget:self action:@selector(dayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            lastBtn = btn;
        }
    }
}

- (void)refreshWithDataSource:(NSArray<NSDate *> *)dataSource
{
    self.firstDayIndex = [NSCalendar firstWeekdayIndexOfMonth:[dataSource firstObject] firstDayIsSun:[XBCalendar currentCalendar].firstDay == XBCalendarWeekFirstDay_sun];
    for (XBCalendarDayBtn *btn in self.arrmBtns)
    {
        NSInteger tag = btn.tag - kTagBase;
        btn.hidden = !(tag >= self.firstDayIndex && tag < self.firstDayIndex + dataSource.count);
        NSInteger dataIndex = tag - self.firstDayIndex;
        if (btn.hidden == NO)
        {
            btn.date = dataSource[dataIndex];
        }
    }
}

#pragma mark - 点击事件
- (void)dayBtnClick:(XBCalendarDayBtn *)btn
{
    [[XBCalendar currentCalendar].monthPresenter addSelectedDate:btn.date];
}

@end
