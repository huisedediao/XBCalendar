//
//  XBCalendarYearModeCell.m
//  smarthome
//
//  Created by xxb on 2020/1/8.
//  Copyright © 2020 DreamCatcher. All rights reserved.
//

#import "XBCalendarYearModeCell.h"
#import "XBCalendarMonthBtn.h"
#import "Masonry.h"

@interface XBCalendarYearModeCell ()
@property (nonatomic,strong) NSMutableArray *arrmBtns;
@end

@implementation XBCalendarYearModeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _arrmBtns = [NSMutableArray new];
        [self createSubviews];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"4444 XBCalendarYearModeCell 销毁");
}

- (void)createSubviews
{
    int hCount = 3;
    int vCount = 4;
    
    CGFloat btnVSpacce = kMonthBtnVSpace;
    XBCalendarMonthBtn *lastLineBtn = nil;
    for (int i = 0; i < vCount; i++)
    {
        XBCalendarMonthBtn *lastBtn = nil;
        for (int j = 0; j < hCount; j++)
        {
            int month = i * hCount + j + 1;
            XBCalendarMonthBtn *btn = [[XBCalendarMonthBtn alloc] initWithMonth:month];
            [self addSubview:btn];
            [self.arrmBtns addObject:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0)
                {
                    make.top.equalTo(self);
                }
                else
                {
                    make.top.equalTo(lastLineBtn.mas_bottom).offset(btnVSpacce);
                }
                if (j == 0)
                {
                    make.leading.equalTo(self).offset(kMonthBtnTitleLeft);
                }
                else
                {
                    make.leading.equalTo(lastBtn.mas_trailing).offset(kMonthBtnTitleLeft);
                    make.width.equalTo(lastBtn);
                }
                if (j == hCount - 1)
                {
                    make.trailing.equalTo(self).offset(- kMonthBtnTitleLeft);
                }
                make.height.equalTo(btn.mas_width).multipliedBy(kMonthThumbnailHWScale);
            }];
//            btn.backgroundColor = [UIColor colorWithRed:(arc4random() % 256) / 255.0 green:(arc4random() % 256) / 255.0 blue:(arc4random() % 256) / 255.0 alpha:1];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            if (j == hCount - 1)
            {
                lastLineBtn = btn;
            }
            
            lastBtn = btn;
        }
    }
}

#pragma mark - 点击事件
- (void)btnClick:(XBCalendarMonthBtn *)btn
{
    if (self.didSelectedBlock)
    {
        self.didSelectedBlock(btn.month);
    }
}

- (void)refreshWithYear:(int)year
{
    for (XBCalendarMonthBtn *btn in self.arrmBtns)
    {
        [btn refreshWithYear:year];
    }
}


@end
