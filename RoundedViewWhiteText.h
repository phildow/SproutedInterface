//
//  RoundedViewWhiteText.h
//  SproutedInterface
//
//  Created by Philip Dow on 6/12/06.
//  Copyright 2006 Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>

#import <SproutedInterface/RoundedView.h>

@interface RoundedViewWhiteText : RoundedView {
	
	NSColor *_color;
	NSString *_title;
}

- (NSColor*) color;
- (void) setColor:(NSColor*)aColor;

- (NSString*) title;
- (void) setTitle:(NSString*)text;

@end
