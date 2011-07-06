//
//  LabelPicker.h
//  SproutedInterface
//
//  Created by Philip Dow on 11/12/05.
//  Copyright 2005 Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>

@interface LabelPicker : NSView {
	
	NSInteger _tag;
	
	id _target;
	SEL _selector;
	
	NSImage *_labelImage;
	NSImage *_labelSelectedImage;
	NSImage *_labelHoverImage;
	
	NSInteger _labelSelection;
	
	NSRect	_clearRect;
	NSRect	_redRect;
	NSRect	_orangeRect;
	NSRect	_yellowRect;
	NSRect	_greenRect;
	NSRect	_blueRect;
	NSRect	_purpleRect;
	NSRect	_greyRect;
}

- (int) tag;
- (void) setTag:(int)aTag;

- (id) target;
- (void) setTarget:(id)targetObject;

- (SEL) action;
- (void) setAction:(SEL)targetSelector;

- (NSInteger) labelSelection;
- (void) setLabelSelection:(NSInteger)value;

+ (NSInteger) finderEquivalentForPickerLabel:(NSInteger)value;
+ (NSInteger) pickerEquivalentForFinderLabel:(NSInteger)value;

@end
