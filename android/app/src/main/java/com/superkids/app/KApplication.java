package com.superkids.app;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import vn.hunghd.flutterdownloader.FlutterDownloaderPlugin;

public class KApplication extends FlutterApplication implements PluginRegistry.PluginRegistrantCallback{

    private static final String FLUTTER_DOWNLOADER_REGISTRAR_NAME = "vn.hunghd.flutterdownloader.FlutterDownloaderPlugin";


    @Override
    public void registerWith(PluginRegistry registry) {
        if (registry.hasPlugin(FLUTTER_DOWNLOADER_REGISTRAR_NAME))
            FlutterDownloaderPlugin.registerWith(registry.registrarFor(FLUTTER_DOWNLOADER_REGISTRAR_NAME));
    }
}
