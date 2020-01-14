//
//  XBCalendarMonthBtn.h
//  smarthome
//
//  Created by xxb on 2020/1/10.
//  Copyright © 2020 DreamCatcher. All rights reserved.
//

/**
 year模式下，月份按钮
*/

#import <UIKit/UIKit.h>
#import "XBCalendarConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface XBCalendarMonthBtn : UIControl
@property (nonatomic,readonly,assign) int month;
- (instancetype)initWithMonth:(int)month;
- (void)refreshWithYear:(int)year;
@end

NS_ASSUME_NONNULL_END
