//
//  JXTextureManager.m
//  EOW
//
//  Created by Joe on 13-3-22.
//  Copyright (c) 2013年 Joe Xi. All rights reserved.
//

#import "JXTextureManager.h"
@implementation JXTextureManager
static JXTextureManager *_sharedManager;
+ (JXTextureManager *)sharedManager
{
    @synchronized([self class])
    {
        if (!_sharedManager) {
            _sharedManager = [[self alloc]init];
        }
    }
    return _sharedManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        _contextLock = [[NSLock alloc] init];
        _textureQueue = dispatch_queue_create("com.metalnation.Texure", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)dealloc
{
    [_contextLock release];
    [_auxGLcontext release];
    [super dealloc];
}
#pragma mark - class method
+ (void)addImageAsync:(NSString *)path
             callback:(void (^) (CCTexture2D *texture))callback
{
    JXTextureManager *manager = [self sharedManager];
    [manager addImageAsync:path callback:callback onMainThread:YES];
}

+ (void)addImageAsync:(NSString *)path
             callback:(void (^) (CCTexture2D *texture))callback
         onMainThread:(BOOL)onMainThread
{
    JXTextureManager *manager = [self sharedManager];
    [manager addImageAsync:path callback:callback onMainThread:onMainThread];
}

+ (void)addCGImageAsync:(CGImageRef)imageRef
                 forKey:(NSString *)key
               callback:(void (^) (CCTexture2D *texture))callback
{
    JXTextureManager *manager = [self sharedManager];
    [manager addCGImageAsync:imageRef
                      forKey:key
                    callback:callback
                onMainThread:YES];
}

+ (void)addCGImageAsync:(CGImageRef)imageRef
                 forKey:(NSString *)key
               callback:(void (^) (CCTexture2D *texture))callback
           onMainThread:(BOOL)onMainThread
{
    JXTextureManager *manager = [self sharedManager];
    [manager addCGImageAsync:imageRef
                      forKey:key
                    callback:callback
                onMainThread:onMainThread];
}
#pragma mark - texture process
- (void)processTexture:(CCTexture2D *)tex withBlock:(void (^) (CCTexture2D *texture))block onMainThread:(BOOL)onMainThread
{
    if (onMainThread) {
        dispatch_async(dispatch_get_main_queue(), ^{
            block(tex);
        });
    }
    else {
        block(tex);
    }
}

- (void)addImageAsync:(NSString *)path callback:(void (^) (CCTexture2D *texture))callback onMainThread:(BOOL)onMainThread
{
	CCTexture2D *tex = [[CCTextureCache sharedTextureCache] textureForKey:path];
	if (tex) {
        [self processTexture:tex withBlock:callback onMainThread:onMainThread];
		return;
	}
    dispatch_async(_textureQueue, ^{
        @autoreleasepool {
            if ([self begin]) {
                CCTexture2D *tex = [[CCTextureCache sharedTextureCache] addImage:path];
                [self processTexture:tex withBlock:callback onMainThread:onMainThread];
            }
            [self end]; 
        }
    });
}

- (void)addCGImageAsync:(CGImageRef)imageRef
                 forKey:(NSString *)key
               callback:(void (^)(CCTexture2D *))callback
           onMainThread:(BOOL)onMainThread
{
    CCTexture2D *tex = [[CCTextureCache sharedTextureCache] textureForKey:key];
	if (tex) {
        [self processTexture:tex withBlock:callback onMainThread:onMainThread];
		return;
	}
    dispatch_async(_textureQueue, ^{
        @autoreleasepool {
            if ([self begin]) {
                CCTexture2D *tex = [[CCTextureCache sharedTextureCache] addCGImage:imageRef forKey:key];
                [self processTexture:tex withBlock:callback onMainThread:onMainThread];
            }
            [self end];
        }
    });
}

#pragma mark - private
- (BOOL)begin
{
    [_contextLock lock];
    /* 创建 context */
    if (!_auxGLcontext) {
        EAGLSharegroup *shareGroup = [[[[CCDirector sharedDirector] openGLView] context] sharegroup];
        int API = kEAGLRenderingAPIOpenGLES1;
        _auxGLcontext = [[EAGLContext alloc] initWithAPI:API
                                              sharegroup:shareGroup];
    }
    return [EAGLContext setCurrentContext:_auxGLcontext];
}

- (void)end
{
    [EAGLContext setCurrentContext:nil];
    [_contextLock unlock];
}
@end
