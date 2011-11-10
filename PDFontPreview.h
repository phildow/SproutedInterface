//
//  PDFontPreview.h
//  SproutedInterface
//
//  Created by Philip Dow on xx.
//  Copyright Philip Dow / Sprouted. All rights reserved.
//

/*
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

Neither the name of the organization nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

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
