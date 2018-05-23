//
//  LiveViewModel.m
//  SwiftDemo
//
//  Created by jiazhuo1 on 2018/5/21.
//  Copyright © 2018年 熊文. All rights reserved.
//

#import "LiveViewModel.h"
#import "ContentModel.h"
#import "NewsModel.h"
#import "NetWorkEngine.h"
#import "SVProgressHUD.h"
#import "MJExtension.h"

@implementation LiveViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.anchorArray = NSMutableArray.array;
        self.intelligentArray = NSMutableArray.array;
        self.bannerArray = NSMutableArray.array;
        self.informationArray = NSMutableArray.array;
    }
    return self;
}

- (void)liveRequestHeaderData:(void (^)(void))aCompletion {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD show];
    [[NetWorkEngine shareNetWorkEngine] postInfoFromServerWithUrlStr:[NSString stringWithFormat:@"%@currency/get_info",@"http://mobile.ishangbo.com/index.php/api/"] Paremeters:nil successOperation:^(id object) {
        [SVProgressHUD dismiss];
        [SVProgressHUD setDefaultMaskType:1];
        if ([object isKindOfClass:NSDictionary.class]){
            NSInteger code = [object[@"errcode"] integerValue];
            if (code == 1) {
                NSDictionary *responseDictionary = object[@"data"];
                //banner展示
                NSMutableArray* ary = responseDictionary[@"ad"];
                for (NSDictionary* i in ary){
                    [self.bannerArray addObject:i[@"adimg"]];
                }
                //tableview展示
                self.intelligentArray = [ContentModel mj_objectArrayWithKeyValuesArray:responseDictionary[@"group"]];
                self.anchorArray = [IntelligentModel mj_objectArrayWithKeyValuesArray:responseDictionary[@"anchor"]];
                self.informationArray = [NewsModel mj_objectArrayWithKeyValuesArray:responseDictionary[@"information"]];
                if (aCompletion) {
                    aCompletion();
                }
            }
            else {
                [SVProgressHUD showErrorWithStatus:object[@"message"]];
            }
        }
    } failoperation:^(NSError *error) {
        [SVProgressHUD dismiss];
//        [[SYPromptBoxView sharedInstance] setPromptViewMessage:@"网络信号差，请稍后再试" andDuration:2.0 PromptLocation:PromptBoxLocationCenter];
    }];
}

@end
