# CTStorage

[![CI Status](https://img.shields.io/travis/ghostlordstar/CTStorage.svg?style=flat)](https://travis-ci.org/ghostlordstar/CTStorage)
[![Version](https://img.shields.io/cocoapods/v/CTStorage.svg?style=flat)](https://cocoapods.org/pods/CTStorage)
[![License](https://img.shields.io/cocoapods/l/CTStorage.svg?style=flat)](https://cocoapods.org/pods/CTStorage)
[![Platform](https://img.shields.io/cocoapods/p/CTStorage.svg?style=flat)](https://cocoapods.org/pods/CTStorage)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
- swift:5.0
- iOS：10.0

## Installation

> 1. 首先添加私有库`repo`到`pod`
```
pod repo add CTSpecs https://github.com/ours-curiosity/CTSpecs.git
```
> 2. 在`Podfile` 中添加私有库的源`source`
```
source 'https://github.com/ours-curiosity/CTSpecs'
```
> 3. 添加以下语句到`Podfile`文件
```
pod 'CTStorage' 
```

## Author

walker, heshanzhang@outlook.com

## 备注：
* 1.本库依赖 `Realm`、`RealmSwift`、`CTBaseFoundation/Core`
* 2.发现库版本号与github上最新版本不一致时请`pod update`。
* 3.发现问题请提交issue或pull request。

## License

CTStorage is available under the MIT license. See the LICENSE file for more info.
