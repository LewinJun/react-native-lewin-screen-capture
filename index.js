
'use strict'

const { NativeModules, NativeEventEmitter, DeviceEventEmitter, Platform } = require('react-native');

let screenCaptureEmitter = undefined

type CALL_BBACK_PROPS = {
  code: string, // 200 为正常 其他为异常
  uri: string, // 文件路径
  base64: string, // 图片base64 png
}

/**
 * 获取系统截屏事件/截屏工具类
 * android 默认不包含状态时间
 * ios 截屏不包含时间
 */
export default class ScreenCaptureUtil  {

  /**
   * 开始监听截屏事件， keyWords android 监听数据变化，截屏文件名的关键字
   * @param {*} callBack 
   */
  static startListener (callBack : ((data:CALL_BBACK_PROPS) => void), keyWords) {
    const ScreenCapture = NativeModules.ScreenCapture;
    // 创建自定义事件接口
    screenCaptureEmitter && screenCaptureEmitter.removeAllListeners('ScreenCapture')

    screenCaptureEmitter = Platform.OS === 'ios' ? new NativeEventEmitter(ScreenCapture) : DeviceEventEmitter;
    
    screenCaptureEmitter.addListener('ScreenCapture', (data : CALL_BBACK_PROPS) => {
      if (callBack) {
        callBack(data)
      }
    })
    if (Platform.OS === 'android') {
      ScreenCapture.startListener(keyWords);    
    } else {
      ScreenCapture.startListener();    
    }
    
    return screenCaptureEmitter
  }

  /**
   * 停止监听
   */
  static stopListener () {
    screenCaptureEmitter && screenCaptureEmitter.removeAllListeners('ScreenCapture')
    const ScreenCapture = NativeModules.ScreenCapture;
    return ScreenCapture.stopListener();    
  }

  /**
   * 清除截屏缓存文件
   * @param {*} callBack 
   */
  static clearCache (callBack:((data:CALL_BBACK_PROPS) => void)) {
    const ScreenCapture = NativeModules.ScreenCapture;
    ScreenCapture.clearCache().then(res=>{
      callBack && callBack(res)
    }).catch(err=>{
      callBack && callBack(err)
    })
  }

  /**
   * 截取当前屏幕方法
   */
  static screenCapture = (callBack:((data:CALL_BBACK_PROPS) => void), isHiddenStatus) => {
    const ScreenCapture = NativeModules.ScreenCapture;
    if (isHiddenStatus === undefined || isHiddenStatus === null) {
      isHiddenStatus = Platform.OS === 'android'
    }
    ScreenCapture.screenCapture(isHiddenStatus).then(res=>{
      callBack && callBack(res)
    }).catch(err=>{
      callBack && callBack(err)
    })
  }
}