//
//  PDFontPreview.h
//  SproutedInterface
//
//  Created by Philip Dow on xx.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>

@class PDButtonColorWell;
@class PDFontDisplay;

@interface PDFontPreview : NSView
{
	PDFontDisplay	*fontDisplay;
	NSButton		*changeFont;
	/*NSColorWell		*fontColor;*/
	PDButtonColorWell	*fontColor;
	
	NSFont		*font;
	NSColor		*color;
	
	NSString	*_defaultsKey;
	NSString	*colorDefaultsKey;
	
	id				target;
	SEL				selector;
}

// -------------------------------------------------
//
// Key-Value methods for setting the three user defaults keys.
// It is important to set these values.
//
// -------------------------------------------------

//
// used for encoding the font object as archived data
- (void) setDefaultsKey:(NSString*)aKey;
- (NSString*) defaultsKey;

- (void) setColorDefaultsKey:(NSString*)newObject;
- (NSString*) colorDefaultsKey;


// -------------------------------------------------
//
// Key-Value methods for setting the initial font and color methods.
// It is not necessary to use these methods.  Setting the user defaults 
// keys using the above methods will initialize the color and font values.
//
// -------------------------------------------------

- (void) setFont:(NSFont*)newObject;
- (NSFont*) font;
- (void) setColor:(NSColor*)newObject;
- (NSColor*) color;

// -------------------------------------------------
//
// If you do not want the user to be able to change the font color, 
// call setColorHidden and pass YES.
//
// -------------------------------------------------

- (void) setColorHidden:(BOOL)hideColor;
- (BOOL) colorHidden;

// -------------------------------------------------
//
// Target-Action behavior.  PDFontPreview can behave like a control if
// you set a target and action.  Whenever the font or color is changed, 
// the action will be triggered.  PDFontPreview passes itself as the only 
// object to the selector.  You can retrieve the new font and color settings 
// by calling the above font and color accessors.
//
// -------------------------------------------------

- (void) setTarget:(id) newTarget;
- (void) setAction:(SEL) newSelector;

// -------------------------------------------------
//
// Internal methods, actions called by the Set Font button
// and the color well.  You should not call these methods.
//
// -------------------------------------------------

- (void) selectFont:(id) sender;
- (void) selectColor:(id) sender;

- (void) changeColor:(id) sender;

@end
