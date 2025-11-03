package com.siprocal.siprocalsdk_helios_example

import android.app.Application
import com.siprocal.sdk.client.SiprocalSDK
import com.siprocal.sdk.client.SiprocalSDKSettings
import java.util.Arrays

class MyApp : Application() {
    override fun onCreate() {

        super.onCreate()
        val siprocalSetting = SiprocalSDKSettings.Builder()
            .setNotificationChannelNames(Arrays.asList("Alerts", "Promos", "Top-ups", "Services", "TV"))
            //.activeSDKManually()
            .enableLogInfoSdk()
            //.enablePopupHandling()
            .build()
        SiprocalSDK.init(this, siprocalSetting)
    }
}