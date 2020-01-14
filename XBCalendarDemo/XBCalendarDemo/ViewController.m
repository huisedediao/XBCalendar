//
//  ViewController.m
//  XBCalendarDemo
//
//  Created by xxb on 2020/1/14.
//  Copyright © 2020 xxb. All rights reserved.
//

#import "ViewController.h"
#import "CalendarSheet.h"
#import "Masonry.h"

@interface ViewController ()
@property (nonatomic,strong) UILabel *labelDate;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.labelDate = [UILabel new];
    [self.view addSubview:self.labelDate];
    [self.labelDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    self.labelDate.numberOfLines = 0;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.labelDate.text = @"";
    CalendarSheet *sheet = [[CalendarSheet alloc] initWithDisplayView:[UIApplication sharedApplication].keyWindow];
    sheet.doneBlock = ^(NSArray<NSDate *> * _Nonnull arrSelectedDays) {
        self.labelDate.text = [NSString stringWithFormat:@"start : %@\rend: %@",arrSelectedDays[0],arrSelectedDays[1]];
    };
    [sheet show];
}

@end
