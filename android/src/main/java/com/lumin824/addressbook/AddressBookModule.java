package com.lumin824.addressbook;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;


public class AddressBookModule extends ReactContextBaseJavaModule {

  public AddressBookModule(ReactApplicationContext reactContext) {
    super(reactContext);
  }

  @Override
  public String getName(){
    return "AddressBookModule";
  }

  @ReactMethod
  public void test(Promise promise){
    promise.resolve("ok");
  }
}
