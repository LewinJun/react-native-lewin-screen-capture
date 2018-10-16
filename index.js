
'use strict'

const { NativeModules, NativeEventEmitter, DeviceEventEmitter, Platform } = require('react-native');

let screenCaptureEmitter = undefined

type CALL_BBACK_PROPS = {
  code: string, // 200 为正常 其他为异常
  uri: string, // 文件路径
  base64: string, // 图片base64 png
}
/**
 * 开启监听
 */
export const startListener = (callBack : ((data:CALL_BBACK_PROPS) => void))=>{
  const ScreenCapture = NativeModules.ScreenCapture;
  // 创建自定义事件接口
  screenCaptureEmitter && screenCaptureEmitter.removeAllListeners()

  screenCaptureEmitter = Platform.OS === 'ios' ? new NativeEventEmitter(ScreenCapture) : DeviceEventEmitter;
  
  screenCaptureEmitter.addListener('ScreenCapture', (data : CALL_BBACK_PROPS) => {
    if (callBack) {
      callBack(data)
    }
  })
  ScreenCapture.startListener();    
  return screenCaptureEmitter
}

/**
 * 关闭监听
 */
export const stopListener = ()=>{
  screenCaptureEmitter && screenCaptureEmitter.removeAllListeners()
  const ScreenCapture = NativeModules.ScreenCapture;
  return ScreenCapture.stopListener();    
}

/**
 * 截取当前屏幕
 */
export const screenCapture = (callBack:((data:CALL_BBACK_PROPS) => void))=>{
  const ScreenCapture = NativeModules.ScreenCapture;
  ScreenCapture.screenCapture().then(res=>{
    callBack && callBack(res)
  }).catch(err=>{
    callBack && callBack(err)
  })
}

/**
 * 删除缓存中的文件
 */
export const clearCache = (callBack:((data:CALL_BBACK_PROPS) => void))=>{
  const ScreenCapture = NativeModules.ScreenCapture;
  ScreenCapture.clearCache().then(res=>{
    callBack && callBack(res)
  }).catch(err=>{
    callBack && callBack(err)
  })
}