package com.mapmapmap;

import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.util.Log;
import android.widget.LinearLayout;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ThemedReactContext;

import net.daum.mf.map.api.MapView;

public class DVMapView extends LinearLayout {
    private static final String TAG = "MapView";

    private ThemedReactContext mContext;
    public MapView mMapView;

    public DVMapView(ThemedReactContext themedReactContext, ReactApplicationContext appContext) {
        super(themedReactContext.getCurrentActivity(), null);
        mContext = themedReactContext;

        init();
        Log.i(TAG, "DVMapView");
    }

    private void init() {
        mMapView = new MapView(mContext.getCurrentActivity());
        addView(mMapView);
        Log.i(TAG, "init");
    }
}