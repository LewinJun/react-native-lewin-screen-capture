/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, {Component} from 'react';
import {Platform, StyleSheet, Text, View, TouchableOpacity, Image} from 'react-native';

import ScreenCaptureUtil from 'react-native-lewin-screen-capture'

const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\n' + 'Cmd+D or shake for dev menu',
  android:
    'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});

type Props = {};
export default class App extends Component<Props> {

  state = {
    uri: 'http://c.hiphotos.baidu.com/image/h%3D300/sign=06f18776399b033b3388fada25cf3620/77c6a7efce1b9d162f210013fedeb48f8d5464da.jpg'
  }

  componentDidMount () {
    
  }

  render() {
    const  {uri} = this.state
    return (
      <View style={styles.container}>
       <Image source = {{uri: uri}} style = {{width: 200, height: 350, backgroundColor: 'red'}}/>
        <TouchableOpacity onPress = {()=>{
          ScreenCaptureUtil.startListener(res=>{
            console.log(res)
            // this.setState({uri:'data:image/png;base64,' + res.base64})
            this.setState({uri: res.uri})
          },'abc,test')
        }} activeOpacity = {0.6} style = {styles.btn}>
          <Text> 开始监听截屏事件 </Text>
        </TouchableOpacity>
        <TouchableOpacity onPress = {()=>{
          ScreenCaptureUtil.stopListener()
        }} activeOpacity = {0.6} style = {styles.btn}>
          <Text> 关闭监听截屏事件 </Text>
        </TouchableOpacity>

        <TouchableOpacity onPress = {()=>{
          ScreenCaptureUtil.screenCapture((res)=>{
            console.log(res)
            this.setState({uri: res.uri})
          })
        }} activeOpacity = {0.6} style = {styles.btn}>
          <Text> 截取当前屏幕 </Text>
        </TouchableOpacity>

        <TouchableOpacity onPress = {()=>{
          ScreenCaptureUtil.clearCache()
        }} activeOpacity = {0.6} style = {styles.btn}>
          <Text> 删除缓存 </Text>
        </TouchableOpacity>

        
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  btn: {
    marginTop: 20
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
