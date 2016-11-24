# Interactive-Transition-Injector

一般来说，要在两个视图控制器间插入交互式转场，你需要在源控制器中和目标控制器中插入代码。

    在源控制器的viewDidLoad中生成并配置手势识别器，加入到相关view。
    在源控制器中添加代码处理手势回调。
    在源控制器的prepareForSegue:中设置目标控制器的transitionDelegate，并实现四个回调方法。
    在目标控制器插入代码实现返回功能。如果要实现手势返回则需要更多代码。


本解决方案优雅粗暴，全故事版配置。

    1. 配置segueIdentifier
    2. 配置targetView
    3. 配置手势方向
    
