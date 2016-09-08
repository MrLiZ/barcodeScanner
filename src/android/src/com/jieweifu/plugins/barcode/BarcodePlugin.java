package com.jieweifu.plugins.barcode;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PermissionHelper;
import org.json.JSONArray;
import org.json.JSONException;

import android.Manifest;
import android.content.Intent;
import android.hardware.Camera;

/**
 * Created by Administrator on 2016/3/16.
 */
public class BarcodePlugin extends CordovaPlugin {

    public static CallbackContext cbContext = null;

    private String [] permissions = { Manifest.permission.CAMERA };

    @Override
    public boolean execute(String action, final JSONArray args,
                           CallbackContext callbackContext) throws JSONException {
        cbContext = callbackContext;

        if (action.equals("startScan")) {
            if(!hasPermisssion()) {
                requestPermissions(0);
              } else {
                  this.cordova.getActivity().startActivity(new Intent(this.cordova.getActivity().getApplicationContext(), CaptureActivity.class));
              }
        }else if(action.equals("hasPermisssion")){
          if(!hasPermisssion()) {
                requestPermissions(0);
              }
            cbContext.success(hasPermisssion() + "");
            return true;
        }

        return true;
    }
    
    /**
     * check application's permissions
     */
   public boolean hasPermisssion() {
       for(String p : permissions)
       {
           if(!PermissionHelper.hasPermission(this, p))
           {
               return false;
           }else{
             boolean isCanUse = true;  
               Camera mCamera = null;  
               try {  
                   mCamera = Camera.open();  
                   Camera.Parameters mParameters = mCamera.getParameters(); //针对魅族手机  
                   mCamera.setParameters(mParameters);  
               } catch (Exception e) {  
                   isCanUse = false;  
               }  
         
               if (mCamera != null) {  
                   try {  
                       mCamera.release();  
                   } catch (Exception e) {  
                       e.printStackTrace();  
                       return isCanUse;  
                   }  
               }  
               return isCanUse;  
           }
       }
       return true;
   }
   
   /**
    * We override this so that we can access the permissions variable, which no longer exists in
    * the parent class, since we can't initialize it reliably in the constructor!
    *
    * @param requestCode The code to get request action
    */
  public void requestPermissions(int requestCode)
  {
      PermissionHelper.requestPermissions(this, requestCode, permissions);
  }
  
}
