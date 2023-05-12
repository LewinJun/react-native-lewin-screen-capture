package com.lewin.capture;

import android.graphics.Bitmap;
import androidx.annotation.Nullable;

public interface CaptureCallback {
    public void invoke(@Nullable Bitmap data);
}