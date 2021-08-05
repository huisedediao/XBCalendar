# XBCalendar
美观易用的日期选择控件

<br/>

### 效果图：
![image](https://github.com/huisedediao/XBCalendar/raw/master/XBCalendar.gif)<br/>

### 示例代码：

<pre>
#import "CalendarSheet.h"
#import "NSDate+Category.h"

CalendarSheet *sheet = [[CalendarSheet alloc] initWithDisplayView:[UIApplication sharedApplication].keyWindow];
sheet.doneBlock = ^(NSArray<NSDate *> * _Nonnull arrSelectedDays) {
    ///arrSelectedDays里的date是0时区的
    /**
     如果选了起始日期、结束日期，则回传起始日期的00：00和结束日期的24:00
     举例：选了5号和6号，则：
            起始：5号00:00
            结束：6号24:00，也就是7号00:00
     */
    /**
     如果只选择了一个日期，则回传为选择的日期的00:00和24:00
     举例：选了5号，则：
            起始：5号00:00
            结束：5号24:00，也就是6号00:00
     */
    
    NSString *format = @"yyyy-MM-dd HH:mm:ss";
    
    ///如果设置时区，则需要设置成你当前希望的时区
    NSString *start = [NSDate stringFromDate:arrSelectedDays[0] format:format timeZone:[NSTimeZone timeZoneWithName:@"GMT+8"]];
    ///如果不设置时区，系统会根据手机当前时区自动转换
    NSString *end = [NSDate stringFromDate:arrSelectedDays[1] format:format];
    
    NSString *printStr = [NSString stringWithFormat:@"start : %@\rend: %@",start,end];
    NSLog(@"%@",printStr);
};
[sheet show];
</pre>
