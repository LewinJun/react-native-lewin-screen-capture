package com.lewin.qrcode;



import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.os.Build;
import android.os.Environment;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.util.Base64;
import android.view.View;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Locale;

import javax.annotation.Nullable;


/**
 * Created by lewin on 2018/3/14.
 */

public class ScreenCapture extends ReactContextBaseJavaModule {

    private ReactApplicationContext reactContext;

    private ScreenCapturetListenManager manager;

    private final static String path = "/screen-capture/";

    public ScreenCapture(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "ScreenCapture";
    }

    @ReactMethod
    public void startListener(Promise promise) {

        promise.resolve("true");

        if (Build.VERSION.SDK_INT > 22) {
            List<String> permissionList = new ArrayList<>();
            // 检查权限
            if (ContextCompat.checkSelfPermission(reactContext, Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                permissionList.add(Manifest.permission.WRITE_EXTERNAL_STORAGE);
            } else {
                this.startListenerCapture(promise);
            }
            if (permissionList != null && (permissionList.size() != 0)) {
                Activity activity = findActivity(reactContext);
                if (activity != null) {
                    ActivityCompat.requestPermissions(activity, permissionList.toArray(new String[permissionList.size()]), 0);
                }

            }

        }else {
            this.startListenerCapture(promise);
        }
    }

    @ReactMethod
    public void stopListener(Promise promise) {
        if (manager != null) {
            manager.stopListen();
            manager = null;
        }
        promise.resolve("true");
    }

    @ReactMethod
    public void screenCapture(Promise promise) {
        promise.resolve(shotActivity(findActivity(reactContext)));
    }

    private void startListenerCapture(Promise promise) {
        // 开始监听
        manager = ScreenCapturetListenManager.newInstance(reactContext);
        manager.setListener(
                new ScreenCapturetListenManager.OnScreenCapturetListen() {
                    public void onShot(String imagePath) {
                        // 获取到系统文件
                        WritableMap map = Arguments.createMap();
                        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("ScreenCapture", map);
                    }
                }
        );
        promise.resolve("success");
    }

    /**
     * 根据指定的Activity截图（带空白的状态栏）
     *
     * @param context 要截图的Activity
     * @return Bitmap
     */
    public static  WritableMap shotActivity(Activity context) {
        WritableMap map = Arguments.createMap();
        View view = context.getWindow().getDecorView();
        view.setDrawingCacheEnabled(true);
        view.buildDrawingCache();

        Bitmap bitmap = Bitmap.createBitmap(view.getDrawingCache(), 0, 0, view.getMeasuredWidth(), view.getMeasuredHeight());
        view.setDrawingCacheEnabled(false);
        view.destroyDrawingCache();
        Calendar now = new GregorianCalendar();
        SimpleDateFormat simpleDate = new SimpleDateFormat("yyyyMMddHHmmss", Locale.getDefault());
        String fileName = Environment.getExternalStorageDirectory() + path + simpleDate.format(now.getTime()) + ".png";
        try {
            File file = new File(fileName);
            if(file.exists()) {
                file.delete();
            }
            file.createNewFile();
            FileOutputStream out = new FileOutputStream(file);
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, out);
            out.flush();
            out.close();
            map.putString("code", "200");
            map.putString("uri", fileName);
            map.putString("base64", bitmapToBase64(bitmap));
        } catch (Exception e) {
            e.printStackTrace();
            map.putString("code", "500");
        }


        return map;
    }


    /**
     * bitmap转为base64
     *
     * @param bitmap
     * @return
     */
    public static String bitmapToBase64(Bitmap bitmap) {

        String result = null;
        ByteArrayOutputStream baos = null;
        try {
            if (bitmap != null) {
                baos = new ByteArrayOutputStream();
                bitmap.compress(Bitmap.CompressFormat.PNG, 100, baos);

                baos.flush();
                baos.close();

                byte[] bitmapBytes = baos.toByteArray();
                result = Base64.encodeToString(bitmapBytes, Base64.DEFAULT);
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (baos != null) {
                    baos.flush();
                    baos.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return result;
    }




    @Nullable
    public static Activity findActivity(Context context) {
        if (context instanceof Activity) {
            return (Activity) context;
        }
        if (context instanceof ContextWrapper) {
            ContextWrapper wrapper = (ContextWrapper) context;
            return findActivity(wrapper.getBaseContext());
        } else {
            return null;
        }
    }

}
