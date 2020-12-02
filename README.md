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

## 用法
```swift

// --- 创建模型类

class Dog: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var age = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class Person: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    let dogs = List<Dog>()

    override static func primaryKey() -> String? {
        return "id"
    }    
}

// --- 数据库操作

// 开启数据库
CTStorage.shared.openRealm()

let dog = Dog.init()
dog.id = 4
dog.name = "rich222"
dog.age = 21

let person = Person.init()
person.id = 3
person.name = "walker22221"
person.dogs.append(dog)
self.person = person

// 添加数据
CTStorage.shared.addObject(obj: person)

// 删除数据
CTStorage.shared.deleteObject(self.person)

// 删除名为2345的数据库文件
CTStorage.shared.deleteDataBaseFile(fileName: "2345")

// 删除当前目录下所有文件
CTStorage.shared.deleteAllFile()

```

## Author

walker, heshanzhang@outlook.com

## 备注：
* 1.本库依赖 `Realm`、`RealmSwift`
* 2.发现库版本号与github上最新版本不一致时请`pod update`。
* 3.发现问题请提交issue或pull request。

## License

CTStorage is available under the MIT license. See the LICENSE file for more info.
