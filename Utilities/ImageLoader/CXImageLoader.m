//
//  CXImageLoader.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/7.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXImageLoader.h"

#import "CXImageCache.h"

#import "AFHTTPRequestOperation.h"
#import "AFURLResponseSerialization.h"
#import "TSWCommonTool.h"


@interface CXImageLoader ()

@property (nonatomic, strong) NSMutableArray *runningRequests;

@property (nonatomic, strong) id <AFURLResponseSerialization> imageResponseSerializer;

@end

@implementation CXImageLoader

+ (CXImageLoader *)sharedImageLoader
{
    static CXImageLoader *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CXImageLoader alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.timeoutInterval = 30.0;
        _runningRequests = [[NSMutableArray alloc] init];
        self.imageResponseSerializer = [AFImageResponseSerializer serializer];
    }
    return self;
}

- (void)dealloc {
    [self cancelAllRequests];
}

- (void)cancelAllRequests {
    for (AFHTTPRequestOperation *imageRequestOperation in self.runningRequests) {
        [imageRequestOperation cancel];
    }
}

- (void)cancelRequestForUrl:(NSURL *)aURL {
    for (AFHTTPRequestOperation *imageRequestOperation in self.runningRequests) {
        if ([imageRequestOperation.request.URL isEqual:aURL]) {
            [imageRequestOperation cancel];
            break;
        }
    }
}

#if TARGET_OS_IPHONE
- (void)loadImageForURL:(NSURL *)anURL image:(void (^)(UIImage *image, NSError *error))imageBlock {
    
    if (!anURL) {
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadURL userInfo:@{NSLocalizedDescriptionKey : @"You must set a url"}];
        imageBlock(nil, error);
        return;
    };
    
    __block NSURL *aURL = anURL;
    
    UIImage *anImage = [[CXImageCache sharedImageCache] imageForURL:aURL];
    
    if (anImage) {
        if (imageBlock) {
            imageBlock(anImage, nil);
        }
    }
    else {
        [self cancelRequestForUrl:aURL];
        
        if([aURL isKindOfClass:[NSString class]])//aUrl may be a string class
            aURL = [NSURL URLWithString:(NSString *)aURL];
        
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:aURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:_timeoutInterval];
        [urlRequest addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        
        __weak __typeof(self)weakSelf = self;
        
        AFHTTPRequestOperation *imageRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        imageRequestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [self.runningRequests addObject:imageRequestOperation];
        
        __weak AFHTTPRequestOperation *imageRequestOperationForBlock = imageRequestOperation;
        
        [imageRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             __strong __typeof(weakSelf)strongSelf = weakSelf;
             
             UIImage *image = responseObject;
             if (imageBlock) {
                 imageBlock(image, nil);
             }
             //!!!: if right not,put into aijia workQueue,more productive.
             
             dispatch_queue_t workQue = [TSWCommonTool getDelegateWorkQueueForconsumptionOperation];
             
             dispatch_async(workQue, ^{
                 [[CXImageCache sharedImageCache] setImage:image forURL:aURL];
             });
             //            [[CXImageCache sharedImageCache] setImage:image forURL:aURL];
             
             [strongSelf.runningRequests removeObject:imageRequestOperationForBlock];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             __strong __typeof(weakSelf)strongSelf = weakSelf;
             
             if (imageBlock) {
                 imageBlock(nil, error);
             }
             [strongSelf.runningRequests removeObject:imageRequestOperationForBlock];
         }];
        
        [imageRequestOperation start];
    }
}
#endif

- (BOOL)hasLoadedImageURL:(NSURL*)url {
    return [[CXImageCache sharedImageCache] hasCacheForPath:[url absoluteString]];
}

@end
