//
//  LiveViewModel.h
//  SwiftDemo
//
//  Created by jiazhuo1 on 2018/5/21.
//  Copyright © 2018年 熊文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveViewModel : NSObject

/**
 *  主播数组
 */
@property (strong, nonatomic) NSMutableArray *anchorArray;

/**
 *  技能数组
 */
@property (strong, nonatomic) NSMutableArray *intelligentArray;
/**
 *  banner
 */
@property (strong, nonatomic) NSMutableArray *bannerArray;

/**
 *  轮播数组
 */
@property (strong, nonatomic) NSMutableArray *informationArray;

- (void)liveRequestHeaderData:(void (^)(void))aCompletion;

@end
