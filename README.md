# react-native-lewin-screen-capture
react-native 获取系统截屏通知并获取图片/截取当前屏幕

## Table of contents
- [Install](#install)
- [Usage](#usage)

## Install
### 1: yarn add 或者npm install,现在最新版本是1.0.0
`yarn add react-native-lewin-screen-capture  `
### 2: yarn install 或 npm install
### 3: react-native link react-native-lewin-screen-capture

## Usage
### NOTE: 可以参考Example的App.js中的方法

```javascript
import ScreenCaptureUtil from 'react-native-lewin-screen-capture'

// 开始监听
ScreenCaptureUtil.startListener(res=>{
            console.log(res)
            // this.setState({uri:'data:image/png;base64,' + res.base64})
            this.setState({uri: res.uri})
          }, '截屏,screen')
// 停止监听
ScreenCaptureUtil.stopListener()
// 截取当前屏幕
ScreenCaptureUtil.screenCapture((res)=>{
            console.log(res)
            this.setState({uri: res.uri})
          })
// 清理缓存
ScreenCaptureUtil.clearCache()
```

