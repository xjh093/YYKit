YYKit
==============

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/ibireme/YYKit/master/LICENSE)&nbsp;
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)&nbsp;
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)&nbsp;
[![CocoaPods](https://img.shields.io/cocoapods/v/YYKit-andy0570.svg?style=flat)](http://cocoapods.org/pods/YYKit-andy0570)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/YYKit.svg?style=flat)](http://cocoadocs.org/docsets/YYKit)&nbsp;
[![Language](https://img.shields.io/badge/language-Objective--C-informational)](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/Introduction/Introduction.html)&nbsp;
[![Support](https://img.shields.io/badge/support-iOS%209%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;
[![Build Status](https://travis-ci.org/ibireme/YYKit.svg?branch=master)](https://travis-ci.org/ibireme/YYKit)&nbsp;
[![Gitmoji](https://img.shields.io/badge/gitmoji-%20😜%20😍-FFDD67.svg?style=flat-square)](https://gitmoji.dev)

YYKit is a collection of iOS components.

It's so huge that I split it into several independent components:

* [YYModel](https://github.com/ibireme/YYModel) — High performance model framework for iOS.
* [YYCache](https://github.com/ibireme/YYCache) — High performance cache framework for iOS.
* [YYImage](https://github.com/ibireme/YYImage) — Image framework for iOS to display/encode/decode animated WebP, APNG, GIF.
* [YYWebImage](https://github.com/ibireme/YYWebImage) — Asynchronous image loading framework.
* [YYText](https://github.com/ibireme/YYText) — Powerful rich text component for iOS.
* [YYKeyboardManager](https://github.com/ibireme/YYKeyboardManager) — Access keyboard view and track keyboard animation.
* [YYDispatchQueuePool](https://github.com/ibireme/YYDispatchQueuePool) — iOS utility class to manage global dispatch queue.
* [YYAsyncLayer](https://github.com/ibireme/YYAsyncLayer) — iOS utility classes for asynchronous rendering and display.
* [YYCategories](https://github.com/ibireme/YYCategories) — A set of useful categories for Foundation and UIKit.


Demo Project
==============
See `Demo/YYKitDemo.xcodeproj`

<img src="https://raw.github.com/ibireme/YYKit/master/Demo/Snapshots/twitter.png" width="320"><br/>
<img src="https://raw.github.com/ibireme/YYKit/master/Demo/Snapshots/weibo.png" width="320"> <img src="https://raw.github.com/ibireme/YYKit/master/Demo/Snapshots/weibo_compose.png" width="320">


Installation
==============

### CocoaPods

1. Add `pod 'YYKit'` to your Podfile.
2. Run `pod install` or `pod update`.
3. Import \<YYKit/YYKit.h\>.


### Carthage

1. Add `github "ibireme/YYKit"` to your Cartfile.
2. Run `carthage update --platform ios` and add the framework to your project.
3. Import \<YYKit/YYKit.h\>.
4. Notice: carthage framework doesn't include webp component, if you want to support webp, use CocoaPods or install manually.

### Manually

1. Download all the files in the `YYKit` subdirectory.
2. Add the source files to your Xcode project.
3. Add `-fno-objc-arc` compiler flag to `NSObject+YYAddForARC.m` and `NSThread+YYAdd.m`.
4. Link with required frameworks:
    * UIKit
    * CoreFoundation
    * CoreText
    * CoreGraphics
    * CoreImage
    * QuartzCore
    * ImageIO
    * AssetsLibrary
    * Accelerate
    * MobileCoreServices
    * SystemConfiguration
    * sqlite3
    * libz
5. Add `Vendor/WebP.framework`(static library) to your Xcode project if you want to support WebP.
6. Import `YYKit.h`.


Documentation
==============
Full API documentation is available on [CocoaDocs](http://cocoadocs.org/docsets/YYKit/).<br/>
You can also install documentation locally using [appledoc](https://github.com/tomaz/appledoc).


Requirements
==============
This library requires `iOS 6.0+` and `Xcode 8.0+`.

Notice
==============
I want to use the APIs as if it was provided by system, and I don't add prefix in
these categories. I do not recommend using the `YYKit` directly, you should try the separated components first.

License
==============
YYKit is provided under the MIT license. See LICENSE file for details.


<br/><br/>
---
中文介绍
==============
YYKit 是一组功能丰富的 iOS 组件。

为了尽量复用代码，这个项目中的某些组件之间有比较强的依赖关系。为了方便其他开发者使用，我从中拆分出以下独立组件：

* [YYModel](https://github.com/ibireme/YYModel) — 高性能的 iOS JSON 模型框架。
* [YYCache](https://github.com/ibireme/YYCache) — 高性能的 iOS 缓存框架。
* [YYImage](https://github.com/ibireme/YYImage) — 功能强大的 iOS 图像框架。
* [YYWebImage](https://github.com/ibireme/YYWebImage) — 高性能的 iOS 异步图像加载框架。
* [YYText](https://github.com/ibireme/YYText) — 功能强大的 iOS 富文本框架。
* [YYKeyboardManager](https://github.com/ibireme/YYKeyboardManager) — iOS 键盘监听管理工具。
* [YYDispatchQueuePool](https://github.com/ibireme/YYDispatchQueuePool) — iOS 全局并发队列管理工具。
* [YYAsyncLayer](https://github.com/ibireme/YYAsyncLayer) — iOS 异步绘制与显示的工具。
* [YYCategories](https://github.com/ibireme/YYCategories) — 功能丰富的 Category 类型工具库。


演示项目
==============
查看并运行 `Demo/YYKitDemo.xcodeproj`

<img src="https://raw.github.com/ibireme/YYKit/master/Demo/Snapshots/twitter.png" width="320"><br/>
<img src="https://raw.github.com/ibireme/YYKit/master/Demo/Snapshots/weibo.png" width="320"> <img src="https://raw.github.com/ibireme/YYKit/master/Demo/Snapshots/weibo_compose.png" width="320">


安装
==============

### CocoaPods

1. 在 Podfile 中添加  `pod 'YYKit'`。
2. 执行 `pod install` 或 `pod update`。
3. 导入 \<YYKit/YYKit.h\>。


### Carthage

1. 在 Cartfile 中添加 `github "ibireme/YYKit"`。
2. 执行 `carthage update --platform ios` 并将生成的 framework 添加到你的工程。
3. 导入 \<YYKit/YYKit.h\>。
4. 注意: carthage framework 并没有包含 webp 组件。如果你需要支持 webp，可以用 CocoaPods 安装，或者手动安装。

### 手动安装

1. 下载 YYKit 文件夹内的所有内容。
2. 将 YYKit 内的源文件添加(拖放)到你的工程。
3. 为 `NSObject+YYAddForARC.m` 和 `NSThread+YYAdd.m` 添加编译参数 `-fno-objc-arc`。
4. 链接以下 frameworks:
    * UIKit
    * CoreFoundation
    * CoreText
    * CoreGraphics
    * CoreImage
    * QuartzCore
    * ImageIO
    * AssetsLibrary
    * Accelerate
    * MobileCoreServices
    * SystemConfiguration
    * sqlite3
    * libz
5. 如果你需要支持 WebP，可以将 `Vendor/WebP.framework`(静态库) 加入你的工程。
6. 导入 `YYKit.h`。


文档
==============
你可以在 [CocoaDocs](http://cocoadocs.org/docsets/YYKit/) 查看在线 API 文档，也可以用 [appledoc](https://github.com/tomaz/appledoc) 本地生成文档。

系统要求
==============
该项目最低支持 `iOS 9.0` 和 `Xcode 10.0`。


注意
==============
我希望调用 API 时，有着和调用系统自带 API 一样的体验，所以我并没有为 Category 方法添加前缀。我已经用工具扫描过这个项目中的 API，确保没有对系统 API 产生影响，但即使这样没有前缀的 Category 也可能会带来其他麻烦。因此我不太推荐直接使用 `YYKit` 这个库，你应该先尝试一下上面那些拆分出来的独立组件。 


许可证
==============
YYKit 使用 MIT 许可证，详情见 LICENSE 文件。


相关文章
==============
[iOS 保持界面流畅的技巧
](https://blog.ibireme.com/2015/11/12/smooth_user_interfaces_for_ios/) 

