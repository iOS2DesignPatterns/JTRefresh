# JTRefresh(Swift)

## Install(安装)
目前还没弄到pod上去，直接将项目的JTRefresh文件拖到项目中吧~    

## 适用视图
UIScrollView, UITableView, UICollectionView, UIWebView

## Use(使用)
1. 设置控件高度，设置控件的refresh_height属性（上拉以及下拉都是这个属性）
2. 结束刷新，调用适用视图(UIScrollView等)的headerStopRefresh或者footerStopRefresh方法   

### Use-Normal(正常使用)
##### 直接使用(UIScrollView，UITableView, UICollectionView调用)
- *只添加下拉刷新*
```swift
// 默认隐藏最后刷新时间
addRefreshWithTarget(_ target: AnyObject, headerAction: Selector?, footerAction: nil)
// 显示最后刷新时间
addRefreshWithTarget(_ target: AnyObject, headerAction: Selector?, footerAction: nil, hiddenRefreshDate: false)
```
- *只添加上拉刷新*
```swift
addRefreshWithTarget(_ target: AnyObject, headerAction: nil, footerAction: Selector?)
```
- *添加下拉刷新和下拉刷新*
```swift
addRefreshWithTarget(_ target: AnyObject, headerAction: Selector?, footerAction: Selector?, hiddenRefreshDate: Bool = true)
```
##### 设置属性使用
- *添加下拉刷新*
```swift
/// 初始化
// 默认隐藏刷新时间
let header = JTRefreshHeaderView(target: AnyObject, action: Selector, hiddenRefreshDate: Bool = true)
// or
let header = JTRefreshHeaderView(hiddenRefreshDate: false, { [weak self] in
     // 1. 在这个闭包中调用的JTRefreshHeaderView，要弱引用，否则内存泄漏
     // 2. 调用scrollView.headerStopRefresh()停止下拉刷新方法，也要弱引用
})
/// 设置属性
header.refreshStatusLabel?.textColor = UIColor.red
header.refreshStatusLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
// func setStatusText(_ text: String, for state: JTRefresh.headerStatus)
header.setStatusText("header...0", for: .normal)            // 下拉过程中
header.setStatusText("header...1", for: .readyRefresh)      // 即将刷新(释放即可刷新)
header.setStatusText("header...2", for: .refreshing)        // 刷新中
/// 添加
scrollView.headerView = header
// or
tableView.headerView = header
collectionView.headerView = header
webView.scrollView.headerView = header
```
- *添加上拉加载*
```swift
/// 初始化
let footer = JTRefreshFooterView(target: AnyObject, action: Selector)
// or
let footer = JTRefreshFooterView({ [weak self] in
     // 1. 在这个闭包中调用的JTRefreshFooterView， 要弱引用，否则内存泄漏
     // 2. 调用scrollView.footerStopRefresh()停止上拉刷新方法，也要弱引用
})
/// 设置属性
footer.refreshStatusLabel?.textColor = UIColor.red
footer.refreshStatusLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
// func setStatusText(_ text: String, for state: JTRefresh.footerStatus)   
footer.setStatusText("footer...0", for: .normal)         // 上拉中
footer.setStatusText("footer...1", for: .readyLoad)      // 即将加载（释放加载）
footer.setStatusText("footer...2", for: .loading)        // 加载中
/// 添加
scrollView.footerView = footer
// or
tableView.footerView = footer
collectionView.footerView = footer
webView.scrollView.footerView = footer
```    

### Use-GIF(动画使用)
- *添加下拉刷新*
```swift
/// 初始化 
let gifHeader = JTRefreshGIFHeaderView(target: AnyObject, action: Selector, hiddenDate: Bool=true, hiddenStatus: Bool=false)
// or
let gifHeader = JTRefreshGIFHeaderView(hiddenDate: Bool=true, hiddenStatus: Bool=false, { [weak self] in
       // 1. 在这个闭包中调用的JTRefreshGIFHeaderView， 要弱引用，否则内存泄漏
       // 2. 调用scrollView.headerStopRefresh()停止上拉刷新方法，也要弱引用         
})
/// 设置属性
// func setImages(_ images: Array<UIImage>?, for state: JTRefresh.headerStatus)    
gifHeader.setImages([], for: .normal)                             // 下拉过程的动画图片
gifHeader.setImages([], for: .readyRefresh)                       // 即将刷新的动画图片
gifHeader.setImages([], for: .refreshing)                         // 刷新中动画图片
// func setStatusText(_ text: String, for state: JTRefresh.headerStatus)
gifHeader.setStatusText("gifHeader...0", for: .normal)
gifHeader.setStatusText("gifHeader...1", for: .readyRefresh)
gifHeader.setStatusText("gifHeader...2", for: .refreshing)
gifHeader.refreshStatusLabel?.textColor = UIColor.cyan
...
/// 添加使用
scrollView.headerView = gifHeader
// or
tableView.headerView = gifHeader
collectionView.headerView = gifHeader
webView.scrollView.headerView = gifHeader
```
- *添加上拉加载*
```swift
/// 初始化
let gifFooter = JTRefreshGIFFooterView(target: AnyObject, action: Selector, hiddenStatus: Bool = true)
// or
let gifFooter = JTRefreshGIFFooterView(hiddenStatus: Bool = true, { [weak self] in
      // 1. 在这个闭包中调用的JTRefreshGIFFooterView， 要弱引用，否则内存泄漏
      // 2. 调用scrollView.footerStopRefresh()停止上拉刷新方法，也要弱引用
})
/// 设置属性
// setImages(_ images: Array<UIImage>?, for state: JTRefresh.footerStatus)
gifFooter.setImages(gifImages, for: .normal)
gifFooter.setImages([], for: .readyLoad)
gifFooter.setImages(gifImages, for: .loading)
// func setStatusText(_ text: String, for state: JTRefresh.footerStatus)
gifFooter.setStatusText("gifFooter...0", for: .normal)
gifFooter.setStatusText("gifFooter...1", for: .readyLoad)
gifFooter.setStatusText("gifFooter...2", for: .loading)
gifFooter.refreshStatusLabel?.textColor = UIColor.cyan
...
/// 添加使用
scrollView.footerView = gifFooter
// or
tableView.footerView = gifFooter
collectionView.footerView = gifFooter
webView.scrollView.footerView = gifFooter
```   

### Use-DIY(自定义使用)
- **header**
1. 继承于JTRefreshHeader
2. 采用layout自动布局或者autoresizingMask布局 (控制器自定义使用时不需要传入视图frame)
3. 改变视图高度，只要设置属性refresh_height就ok了。
4. 在以下方法中设置你的DIY视图动画，执行方法等。。。
```swift
/// *正常状态(下拉中)，progress为下拉进度
override func headerDroping(_ progrss: CGFloat)
/// *即将刷新
override func headerReadyRefresh()
/// *开始刷新，刷新中 （刷新中，不会从复调用该方法）
override func headerRefreshing()
/// *结束刷新
override func headerStopRefresh()
```   

- **footer**
1. 继承于JTRefreshFooter
2. 采用layout自动布局或者autoresizingMask布局 (控制器自定义使用时不需要传入视图frame)
3. 改变视图高度，只要设置属性refresh_height就ok了
4. 在以下方法中设置你的DIY视图动画，执行方法等。。。
```swift
/// *正常状态(上拉中), progrss为上拉进度
override func footerPulling(_ progrss: CGFloat)
/// *准备加载状态(释放开启加载)
override func footerReadyLoad()
/// *开始，加载中 (不会从复调用该方法)
override func footerLoading()
/// *结束加载
override func footerStopLoad()
```

### Note(使用注意)
1. 在使用提供的JTRefreshHeaderView，JTRefreshFooterView，JTRefreshGIFHeaderView, JTRefreshGIFFooterView初始化过程中，使用Closures(闭包，blocks)初始化时，如果在闭包中使用自己，或者调用该视图父类的JTRefreshProtocol方法时，请使用弱引用(具体看例子)
2. 在UICollectionView添加header或者footer时，请设置collectionView.alwaysBounceVertical = true，或collectionView.alwaysBounceHorizontal=true, 因为这个默认是关闭的，当视图内容小于高度时，滑不动喔

###### 因为我也是刚封装没多久，里面可能有许多不足，如果大家使用中发现bug的话，希望能留言，在此谢谢各路'牛鬼蛇神'了😜

