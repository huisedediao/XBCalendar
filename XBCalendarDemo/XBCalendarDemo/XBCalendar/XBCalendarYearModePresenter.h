//
//  XBCalendarYearModePresenter.h
//  smarthome
//
//  Created by xxb on 2020/1/10.
//  Copyright © 2020 DreamCatcher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBCalendarConfig.h"

NS_ASSUME_NONNULL_BEGIN

@class XBCalendarYearModePresenter;

@protocol XBCalendarYearModePresenterDelegate <NSObject>

- (void)yearModePresenter:(XBCalendarYearModePresenter *)presenter didSelectedYear:(int)year month:(int)month;
- (void)yearModePresenter:(XBCalendarYearModePresenter *)presenter yearDidChanged:(int)year;

@end

@interface XBCalendarYearModePresenter : UIView
@property (nonatomic,readonly,strong) UICollectionView *collectionView;
@property (nonatomic,readonly,assign) int year;
@property (nonatomic,weak) id<XBCalendarYearModePresenterDelegate>delegate;
- (CGFloat)needHeight;
- (void)showYear:(int)year;
@end

NS_ASSUME_NONNULL_END
