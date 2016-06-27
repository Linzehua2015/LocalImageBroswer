//
//  ALAssetsLibraryExt.m
//  Transmitter
//
//  Created by 林泽华 on 10/14/15.
//  Copyright (c) 2015 zjw. All rights reserved.
//

#import "ALAssetsLibraryExt.h"

@implementation ALAssetsLibrary(Ext)

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred,
                  ^{
                      library = [[ALAssetsLibrary alloc] init];
                  });
    return library;
}

@end
