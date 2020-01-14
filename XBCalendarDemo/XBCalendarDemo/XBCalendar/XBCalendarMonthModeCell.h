//
//  XBCalendarMonthModeCell.h
//  smarthome
//
//  Created by xxb on 2020/1/8.
//  Copyright © 2020 DreamCatcher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBCalendarConfig.h"

NS_ASSUME_NONNULL_BEGIN

#define  CellReuseID_XBCalendarMonthModeCell @"XBCalendarMonthModeCell"

@interface XBCalendarMonthModeCell : UICollectionViewCell
- (void)refreshWithDataSource:(NSArray <NSDate *> *)dataSource;
@end

NS_ASSUME_NONNULL_END
