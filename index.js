
'use strict'

const { NativeModules } = require('react-native');
/**
 * 开启监听
 */
export const startListener= ()=>{
  const ScreenCapture = NativeModules.ScreenCapture;
  return ScreenCapture.startListener();    
}

/**
 * 关闭监听
 */
export const stopListener= ()=>{
  const ScreenCapture = NativeModules.ScreenCapture;
  return ScreenCapture.stopListener();    
}