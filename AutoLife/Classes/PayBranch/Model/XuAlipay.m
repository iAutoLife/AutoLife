//
//  XuAlipay.m
//  AutoLife
//
//  Created by xubupt218 on 16/3/16.
//  Copyright © 2016年 徐成. All rights reserved.
//

#import "XuAlipay.h"
#import "AutoLife-Swift.h"

@implementation XuAlipay
//void(^)()
+(void) alipayWithLocalKey:(void(^)())finished {
    NSString *partner = @"2088221302895420";
    NSString *seller = @"2088221302895420";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBANr7+LUZDKd9iw+w2ezKT2eU62BIZu2nkIXXGCQ1eyRLti5iL7sndYiTnuY8kdgLGu1tpPSvmcMq15dBfYuRrFfKzpeY8rDVEzZl5+HUrDtVtJ2IbH31G+YPIcTeF0cGXQroqhppa9a8Dmlyzag3zIBkJkqx54bmxGGLJXzxUXWrAgMBAAECgYA9kll0ug1XzrHaAJTVwnCfJD0mPlVKfzHgoAD2tV7hbrRTyGG5Urf2ZeNowyESyNSSa6DU98bZHGOv8McXBieZpnQf2pQYTrGp/Rw+eM+l19+OysFGpUfvf3/j4YlbyfP+E54fUwMfUl8fhAfrrFWnt94rWUDLorWsWx/AqEvzmQJBAPc2lj8EnWBruSCXJ9zZ5TA+Zd9uIffWc7sbXrx7vr6YNyUKhDErZ38wHi8DL0xZhci7towYrNEzXvatBv/j8zcCQQDixIbn0QAQgKLP1fZ70/d9CRhiJ2ujfSU0O7MlcEes10pGINS8HVZHmebqfyoTSelYW6esxe8xrk8MR4GK8nMtAkBLVjNLWRisvadZKzdWsoCJxzo8cM+hO5VhO+IPBpcGdlS30RCf+147AGryYMIVPmLq3WmwIATqbAFQo0Iy0UDZAkEAgPhW5ZcHW1tdvaip08k9E37NwF09KbFuLGPbwmo2SYX0NyhK9WYWAQj1vN5v9qJttRQDrA6yuGWzjX9JnNXBTQJAIcdmncfOCnoNhproYLa9JiiRnFwwJBV6mP8TWp1lpszPHVhiptIPogzu/hq37+bIC0EQcaU14VujFCt9HgxBlg==";
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"缺少partner或者seller或者私钥。" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        return;
    }
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.productName = @"停车消费"; //商品标题
    order.productDescription = @"停车行为支付"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",0.01]; //商品价格
    order.notifyURL =  @"http://101.200.229.224/CarManageSystem/alipay_notify.jsp"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"iAutoLifeAlipay";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:orderSpec,@"orderSpec", nil];
    
    NSLog(@"orderSpec = %@ >>>>>%@",orderSpec,dic);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//    [XuAlamofire postParameters:@"http://10.104.5.172:8080/CarManageSystem/alipay/sign" parameters:dic successWithString:^(NSString * _Nullable success) {
//        NSLog(@"success:%@",success);
//        NSString *orderString = nil;
//        if (success != nil) {
//            orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                           orderSpec, success, @"RSA"];
//            
//            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//                NSLog(@"reslut = %@",resultDic);
//                finished();
//            }];
//        }
//    } failed:^(NSError * _Nonnull fail, BOOL isOK) {
//        
//    }];
    
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    NSLog(@"signedString:%@",signedString);
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            finished();
        }];
    }

}



+ (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    NSLog(@"generateTradeNO:%@",resultStr);
    return resultStr;
}

@end
