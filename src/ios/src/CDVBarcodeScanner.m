//
//  CDVBarcodeScanner.m
//  HelloCordova
//
//  Created by jingren on 16/9/11.
//
//

#import "CDVBarcodeScanner.h"
#import <AVFoundation/AVFoundation.h>
#import "BarcodeScannerViewController.h"


@implementation CDVBarcodeScanner

- (void)startScan:(CDVInvokedUrlCommand *)command{
    self.currentCallbackId = command.callbackId;
//    NSLog(@"args: %@", [command argumentAtIndex:0]);
    NSString *subtitle = command.arguments.count == 0 ? [NSNull null] : [command argumentAtIndex:0];
    
    //存储数据
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:subtitle forKey:@"subtitle"];
    //设置同步
    [defaults synchronize];
    
    BarcodeScannerViewController *barcodeCtrl = [[BarcodeScannerViewController alloc] initWithNibName:@"BarcodeScannerViewController" bundle:nil];
    barcodeCtrl.delegate = self;
    barcodeCtrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.viewController presentViewController:barcodeCtrl animated:YES completion:nil];
}

- (void)reader:(NSString *)result{
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result] callbackId:self.currentCallbackId];
}

- (void)readerDidCancel{
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR] callbackId:self.currentCallbackId];
}

-(void)hasPermission:(CDVInvokedUrlCommand *)command {
    
    Boolean result = false;
        //判断是否已授权
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus == AVAuthorizationStatusDenied||authStatus == AVAuthorizationStatusRestricted) {
                
                result = false;
            }
        }
        // 判断是否可以打开相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            result = true;
        } else {
            result = false;
        }
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
//        case AVAuthorizationStatusNotDetermined:{
            // 许可对话没有出现，发起授权许可
//            
//            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
//                
//                if (granted) {
//                    //第一次用户接受
//                    return true;
//                }else{
//                    //用户拒绝
//                    return false;
//                }
//            }];
//            
//            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
//                if (!granted) { //用户拒绝
//                    
//                }
//            }];
//            break;
//        }
//        case AVAuthorizationStatusAuthorized:{
//            // 已经开启授权，可继续
//             result = true;
//            break;
//        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
        // 用户明确地拒绝授权，或者相机设备无法访问
        result = false;
        break;
        default:
        break;
    }
    
    CDVPluginResult *pluginResult;
    
    if(!result){
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"false"];
    }else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"true"];
    }
    
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

@end
