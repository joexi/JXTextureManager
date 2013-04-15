//
//  PATextureManager.h
//  EOW
//
//  Created by Joe on 13-3-22.
//  Copyright (c) 2013年 Joe Xi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@interface JXTextureManager : NSObject
{
    NSLock              *_contextLock;
    EAGLContext         *_auxGLcontext;
    dispatch_queue_t    _textureQueue;
}
+ (JXTextureManager *)sharedManager;

/** 异步加载纹理
 @param path 文件路径
 @param callback 加载完成后回调
 */
+ (void)addImageAsync:(NSString *)path
             callback:(void (^) (CCTexture2D *texture))callback;

/** 异步加载纹理
 @param path 文件路径
 @param callback 加载完成后回调
 @param onMainThread 是否回调主线程
 */
+ (void)addImageAsync:(NSString *)path
             callback:(void (^) (CCTexture2D *texture))callback
         onMainThread:(BOOL)onMainThread;

/** 异步加载纹理
 @param imageRef 图像数据
 @param 缓存的key值
 @param callback 加载完成后回调
 @param onMainThread 是否回调主线程
 */
+ (void)addCGImageAsync:(CGImageRef)imageRef
                 forKey:(NSString *)key
               callback:(void (^) (CCTexture2D *texture))callback;

/** 异步加载纹理
 @param imageRef 图像数据
 @param 缓存的key值
 @param callback 加载完成后回调
 @param onMainThread 是否回调主线程
 */
+ (void)addCGImageAsync:(CGImageRef)imageRef
                 forKey:(NSString *)key
               callback:(void (^) (CCTexture2D *texture))callback
           onMainThread:(BOOL)onMainThread;
@end
