//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "ServiceDebugger_Dock.h"
#import "ServiceDebugger.h"

#if (__ON__ == __BEE_DEVELOPMENT__)

#pragma mark -

@interface ServiceDebugger_Dock()
{
	BeeUIButton *	_debug;
	BeeUIButton *	_close;
}
@end

#pragma mark -

@implementation ServiceDebugger_Dock

DEF_SINGLETON( ServiceDebugger_Dock )

DEF_NOTIFICATION( OPEN )
DEF_NOTIFICATION( CLOSE )

- (void)load
{
	CGRect screenBound = [UIScreen mainScreen].bounds;
	CGRect shortcutFrame;
	shortcutFrame.size.width = 40.0f;
	shortcutFrame.size.height = 40.0f;
	shortcutFrame.origin.x = CGRectGetMaxX(screenBound) - shortcutFrame.size.width;
	shortcutFrame.origin.y = CGRectGetMaxY(screenBound) - shortcutFrame.size.height - 44.0f;

	self.frame = shortcutFrame;
	self.backgroundColor = [UIColor clearColor];
	self.hidden = YES;
	self.windowLevel = UIWindowLevelStatusBar + 2.0f;

	CGRect buttonFrame;
	buttonFrame.origin = CGPointZero;
	buttonFrame.size.width = 40.0f;
	buttonFrame.size.height = 40.0f;
	
	_debug = [[BeeUIButton alloc] initWithFrame:buttonFrame];
	_debug.hidden = NO;
	_debug.backgroundColor = [UIColor clearColor];
	_debug.adjustsImageWhenHighlighted = YES;
	_debug.image = [[ServiceDebugger sharedInstance].bundle image:@"debug.png"];
	_debug.signal = @"debug";
	[self addSubview:_debug];

	_close = [[BeeUIButton alloc] initWithFrame:buttonFrame];
	_close.hidden = YES;
	_close.backgroundColor = [UIColor clearColor];
	_close.adjustsImageWhenHighlighted = YES;
	_close.image = [[ServiceDebugger sharedInstance].bundle image:@"close.png"];
	_close.signal = @"close";
	[self addSubview:_close];
}

- (void)unload
{
	[_debug removeFromSuperview];
	[_debug release];

	[_close removeFromSuperview];
	[_close release];
}

#pragma mark -

ON_SIGNAL2( debug, signal )
{
	[self postNotification:self.OPEN];
	
	_close.hidden = NO;
	_debug.hidden = YES;
}

ON_SIGNAL2( close, signal )
{
	[self postNotification:self.CLOSE];

	_close.hidden = YES;
	_debug.hidden = NO;
}

@end

#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
