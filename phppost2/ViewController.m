//
//  ViewController.m
//  phppost2
//
//  Created by ビザンコムマック０７ on 2014/10/22.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    self.activity.hidden = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)upload:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];

}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.label.text = @"アップロードしています";
    self.activity.hidden = NO;
    [self.activity startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *before = UIImageJPEGRepresentation(img, 1.0f);
        NSLog(@"元の長さ%ldバイト",before.length);
        
    NSData *imgdata = UIImageJPEGRepresentation(img, 0.3f);
        
        //0.6の場合はlengthは159117
        //0.5の場合はlengthは109115
    NSLog(@"圧縮後(圧縮率0.3)の長さ%ldバイト",imgdata.length);
    NSURL *url = [NSURL URLWithString:@"http://smartshinobu.miraiserver.com/tokushima/file.php"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = @"--1680ert52491z";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setHTTPMethod:@"POST"];
        //iphoneidのパラメータの設定
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"iphoneid\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *dvid = [UIDevice currentDevice].identifierForVendor.UUIDString;
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", dvid] dataUsingEncoding:NSUTF8StringEncoding]];
        //latのパラメータの設定
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"lat\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *lat = @"34.5555";
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", lat] dataUsingEncoding:NSUTF8StringEncoding]];
        //lngのパラメータの設定
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"lng\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *lng = @"134.5555";
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", lng] dataUsingEncoding:NSUTF8StringEncoding]];
        //imageのパラメータの設定
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"2.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imgdata];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:body];
    NSURLResponse *response;
    NSError *err = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *datastring = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",datastring);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activity stopAnimating];
            self.activity.hidden = YES;
            self.label.text = @"アップロード完了";
        });
    });
}
@end
