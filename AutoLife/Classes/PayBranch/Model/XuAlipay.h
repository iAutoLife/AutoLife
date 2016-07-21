//
//  XuAlipay.h
//  AutoLife
//
//  Created by xubupt218 on 16/3/16.
//  Copyright © 2016年 徐成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>


@interface XuAlipay : NSObject

+(void) alipayWithLocalKey:(void(^)())finished;
+(void) alipayWithDic:(NSDictionary *)dictionary andFinish:(void(^)(NSDictionary *resultDic))finished;

@end
