# XBCalendar
美观易用的日期选择控件

<br/>

### 效果图：
![image](https://github.com/huisedediao/XBCalendar/raw/master/XBCalendar.gif)<br/>

### 示例代码：

<pre>
CalendarSheet *sheet = [[CalendarSheet alloc] initWithDisplayView:[UIApplication sharedApplication].keyWindow];
sheet.doneBlock = ^(NSArray<NSDate *> * _Nonnull arrSelectedDays) {

};
[sheet show];
</pre>
