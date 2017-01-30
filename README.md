# Interactive-Transition-Injector

## A brief introduction

Oftentimes, we want interactive transitions between view controllers. In order to achieve that, we would have to:

1. Instantiate a UIGestureRecognizer subclass, set it up in the source view controller's `viewDidLoad` method, and attach it to the relevant view.
2. Write code to handle the delegete method of the gestureRecognizer.
3. Override the `prepareForSegue` method of the source view controller. Setup the destination view controller's transitionDelegate to an object(often the source view controller itself) in your own implementation. Then implement four delegate methods of transitionDelegate.
4. Insert code in the destination view controller to setup the interactive transition for opposite direction.


This project is an attempt to simplify things and decouple code.

And all settings can be modified in the Interface Builder's attribute inspector. You only need to:

    1. set the segueIdentifier.
    2. set the targetView that triggers the transition.
    2. set the direction for which the interactive transition gestureRecognizer should be triggered.


## 中文说明
一般来说，要在两个视图控制器间插入交互式转场，你需要在源控制器中和目标控制器中插入代码。

    在源控制器的viewDidLoad中生成并配置手势识别器，加入到相关view。
    在源控制器中添加代码处理手势回调。
    在源控制器的prepareForSegue:中设置目标控制器的transitionDelegate，并实现四个回调方法。
    在目标控制器插入代码实现返回功能。如果要实现手势返回则需要更多代码。


本解决方案优雅粗暴，全故事版配置。

    1. 配置segueIdentifier
    2. 配置targetView
    3. 配置手势方向
    
