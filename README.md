# JTRefresh      

## Install(安装)
#### 目前还没弄到pod上去，直接将项目的JTRefresh文件拖到项目中吧~    

## 适用场景
UIScrollView, UITableView, UICollectionView, UIWebView

## Use(使用)
### Normal(正常使用)
#### 直接使用(UIScrollView，UITableView, UICollectionView调用)
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
#### 自己设置属性
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
header.setStatusText("header...0", for: .normal)            // 下拉过程中
header.setStatusText("header...1", for: .readyRefresh)      // 即将刷新(释放即可刷新)
header.setStatusText("header...2", for: .refreshing)        // 刷新中
/// 添加
scrollView.headerView = header
// 或者
tableView.headerView = header
collectionView.headerView = header
webView.scrollView.headerView = header
```
- *添加上拉刷新*
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
footer.setStatusText("footer...0", for: .normal)
footer.setStatusText("footer...1", for: .readyRefresh)
footer.setStatusText("footer...2", for: .refreshing)
/// 添加
scrollView.footerView = footer
// 或者
tableView.footerView = footer
collectionView.footerView = footer
webView.scrollView.footerView = footer
```

### GIF(添加动画)

### DIY(自定义视图)

### Note(使用注意)


## Effect(效果)
