//
//  CalendarSheet.h
//  smarthome
//
//  Created by xxb on 2020/1/8.
//  Copyright © 2020 DreamCatcher. All rights reserved.
//

#import "XBAlertViewBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface CalendarSheet : XBAlertViewBase
@property (nonatomic,copy) void(^doneBlock)(NSArray <NSDate *> *arrSelectedDays);
@end

NS_ASSUME_NONNULL_END
