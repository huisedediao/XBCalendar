//
//  XBCalendarYearModeCell.h
//  smarthome
//
//  Created by xxb on 2020/1/8.
//  Copyright © 2020 DreamCatcher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBCalendarConfig.h"

NS_ASSUME_NONNULL_BEGIN

#define  CellReuseID_XBCalendarYearModeCell @"XBCalendarYearModeCell"

@interface XBCalendarYearModeCell : UICollectionViewCell
@property (nonatomic,copy) void(^didSelectedBlock)(NSInteger month);
- (void)refreshWithYear:(int)year;
@end

NS_ASSUME_NONNULL_END
