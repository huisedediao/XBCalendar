//注意:为了正常显示
//1.懒加载使用
//2.调用类方法show

#import <UIKit/UIKit.h>

@class XBAlertViewBase;

typedef void (^SetConstraintOrFrameForShowBlock)(XBAlertViewBase *alertView);
typedef void (^SetConstraintOrFrameForHiddenBlock)(XBAlertViewBase *alertView);
typedef void (^TouchBeginBlock)(XBAlertViewBase *alertView);

@interface XBAlertViewBase : UIView

/**
 设置显示时的位置的block
 */
@property (nonatomic,copy) SetConstraintOrFrameForShowBlock showLayoutBlock;
/**
 设置隐藏前的位置的block
 */
@property (nonatomic,copy) SetConstraintOrFrameForHiddenBlock hiddenLayoutBlock;

/**
 * 点击时的Block
 */
@property (copy,nonatomic) TouchBeginBlock touchBlock;

/**
 * 灰色背景view
 */
@property (nonatomic,strong) UIView *backgroundView;

/**
 *  是否展示状态
 */
@property (assign,nonatomic,readonly) BOOL isShowState;

/**
 *  是否淡入淡出
 */
@property (assign,nonatomic,getter=isFadeInFadeOut) BOOL fadeInFadeOut;

/**
 *  (黑色半透明背景)是否淡入淡出,默认是
 */
@property (assign,nonatomic,getter=isBackgroundViewFadeInFadeOut) BOOL backgroundViewFadeInFadeOut;

/**
 * 过度动画的时间,默认0.3s
 */
@property (assign,nonatomic) CGFloat duration;

/**
 显示时的位置
 */
@property (assign,nonatomic) CGRect showFrame;

/**
 隐藏时的位置
 */
@property (assign,nonatomic) CGRect hiddenFrame;

/**
 显示在哪个view上
 */
@property (weak,readonly,nonatomic)UIView *displayView;

/**
 点击其他区域是否隐藏，默认yes
 */
@property (nonatomic,assign,getter=isHideWhileTouchOtherArea) BOOL hideWhileTouchOtherArea;

/**
 背景的颜色
 */
@property (nonatomic,strong) UIColor *backgroundViewColor;

/**
 * 是否展示动画,默认展示
 */
@property (assign,nonatomic) BOOL animating;

/**
 * 是否需要适应键盘(默认不适应)
 */
@property (assign,nonatomic) BOOL needAdaptKeyboard;

/**
 * 是否处于展示键盘的状态
 */
@property (assign,nonatomic,readonly) BOOL isShowKeyboard;

/**
 * 是否需要被显示队列管理
 */
@property (assign,nonatomic) BOOL needInQueue;

/**
 初始化方法
 displayView:显示在哪个view上
 */
-(id)initWithDisplayView:(id)displayView;

/**
 显示
 */
-(void)show;

/**
 隐藏
 */
-(void)hidden;

/**
 设置几秒后消失
 */
-(void)hiddenAfterSecond:(CGFloat)second;

/**
 键盘将要显示时调用
 */
-(void)keyboardWillShow:(NSNotification *)noti;
/**
 键盘将要消失时调用
 */
-(void)keyboardWillHide:(NSNotification *)noti;

/**
 在show之前调用，供子类继承
 */
- (void)actionBeforeShow;

@end

