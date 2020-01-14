//
//  XBAlertViewBase+Queue.m
//  XBAlertView
//
//  Created by xxb on 2017/8/22.
//  Copyright © 2017年 xxb. All rights reserved.
//

#import "XBAlertViewBase+Queue.h"
#import <objc/message.h>

static NSMutableArray *arrmAlertViews_;

@implementation XBAlertViewBase (Queue)

+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method show = class_getInstanceMethod(self, @selector(show));
        Method logShow = class_getInstanceMethod(self, @selector(logShow));
        method_exchangeImplementations(show, logShow);
        
        Method hidden = class_getInstanceMethod(self, @selector(hidden));
        Method logHidden = class_getInstanceMethod(self, @selector(logHidden));
        method_exchangeImplementations(hidden, logHidden);
    });
}

+ (NSMutableArray *)arrmAlertViews
{
    if (!arrmAlertViews_) {
        arrmAlertViews_ = [NSMutableArray new];
    }
    return arrmAlertViews_;
}

- (void)logShow
{
    if (self.needInQueue == false)
    {
        [self logShow];
        return;
    }
    
    XBAlertViewBase *alertView = [[self class] arrmAlertViews].lastObject;
    
    [[[self class] arrmAlertViews] addObject:self];
    [self logShow];
    
    [alertView logHidden];
}
- (void)logHidden
{
    if (self.needInQueue == false)
    {
        [self logHidden];
        return;
    }
    [self logHidden];
    
    if (self == [[self class] arrmAlertViews].lastObject)
    {
        [[[self class] arrmAlertViews] removeObject:self];
    }
    
    if ([[self class] arrmAlertViews].count > 0)
    {
        [[[[self class] arrmAlertViews] lastObject] logShow];
    }
}
@end


