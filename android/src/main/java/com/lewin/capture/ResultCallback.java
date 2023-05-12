package com.lewin.capture;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;

public interface ResultCallback {
    public void invoke(WritableMap data);
}