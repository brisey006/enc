package com.digitalhundred.michaels_library;

import androidx.annotation.NonNull;

import java.io.FileInputStream;
import java.io.IOException;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "com.digitalhundred/encrypt";
  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
      .setMethodCallHandler(
        (call, result) -> {
          if (call.method.equals("encryptFile")) {
            String path = call.argument("path");
            result.success(encryptFile(path));
          } else {
            result.notImplemented();
          }
        }
      );
  }

  private String encryptFile (String path) {
    try {
      FileInputStream fileInputStream = new FileInputStream(path);
      int i=0;
      while((i=fileInputStream.read())!=-1){
        System.out.print(i);
      }
      fileInputStream.close();
    } catch (IOException e) {
      System.out.println(e);
    }
    return "Hello from java";
  }
}
