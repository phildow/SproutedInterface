//
//  PDURLTextFieldCell.h
//  SproutedInterface
//
//  Created by Philip Dow on 5/28/06.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>

typedef enum {
	kPDAppearanceStyleBlue = 1,
	kPDAppearanceStyleGraphite = 2
} PDAppearanceStyle;

@interface PDURLTextFieldCell : NSTextFieldCell {
	
	double _estimated_progress;
	PDAppearanceStyle _appearanceStyle;
	
	NSImage *_image;
	NSColor *_progress_gradient_start, *_progress_gradient_end;

}

- (void) _initializeColors;

- (NSRect) textRectForFrame:(NSRect)frame;
- (NSRect) imageRectForFrame:(NSRect)frame;
- (NSRect) progressRectForFrame:(NSRect)frame;

- (NSImage*) image;
- (void) setImage:(NSImage*)anImage;

- (double) estimatedProgress;
- (void) setEstimatedProgress:(double)estimate;

- (void) drawFocusRingWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;
- (void) drawProgressIndicatorWithFrame:(NSRect)cellFrame inView:(NSView*)controlView;
- (void) drawImageWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;

@end
