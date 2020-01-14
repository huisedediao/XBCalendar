//
//  XBCalendarMonthThumbnailView.h
//  smarthome
//
//  Created by xxb on 2020/1/10.
//  Copyright © 2020 DreamCatcher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBCalendarConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface XBCalendarMonthThumbnailView : UIView
- (void)refreshWithDates:(NSArray <NSDate *> *)arrDates;
@end

NS_ASSUME_NONNULL_END
