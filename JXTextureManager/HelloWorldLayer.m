//
//  HelloWorldLayer.m
//  JXTextureManager
//
//  Created by Joe on 13-4-15.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "JXTextureManager.h"
// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        CCSprite *sp = [CCSprite node];
        sp.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
        [self addChild:sp];
        [JXTextureManager addImageAsync:@"Icon-72.png" callback:^(CCTexture2D *texture) {
            NSLog(@"加载成功");
            [sp setTexture:texture];
            [sp setTextureRect:CGRectMake(0, 0,
                                          texture.contentSize.width,
                                          texture.contentSize.height)];
        }];
        NSLog(@"开始加载");
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
