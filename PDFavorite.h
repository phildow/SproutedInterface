//
//  PDFavorite.h
//  SproutedInterface
//
//  Created by Philip Dow on 3/17/06.
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

#define PDFavoriteNoHover		0
#define PDFavoriteHover			1
#define PDFavoriteMouseDown		2

@interface PDFavorite : NSView {
	
	NSString			*_title;
	//NSAttributedString	*_attributedTitle;
	id					_identifier;
	//NSArray				*_subElements;
	
	NSSize				_idealSize;
	int					_state;
	
	int label;
	BOOL drawsLabel;
}

- (id) initWithFrame:(NSRect)frame title:(NSString*)title identifier:(id)identifier;

- (NSString*) title;
- (void) setTitle:(NSString*)title;

//- (NSAttributedString*) attributedTitle;
//- (void) setAttributedTitle:(NSAttributedString*)title;

- (id) identifier;
- (void) setIdentifier:(id)identifier;

- (int) state;
- (void) setState:(int)state;

- (int) label;
- (void) setLabel:(int)aLabel;

- (BOOL) drawsLabel;
- (void) setDrawsLabel:(BOOL)draws;

- (NSAttributedString*) generateAttributedTitle:(NSString*)title;
- (NSAttributedString*) generateHoverAttributedTitle:(NSString*)title;
- (NSSize) idealSize;
- (NSImage*) image;

- (void) _drawLabel:(NSRect)rect;

@end
