
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

// I believe I override a number of methods in MUPhotoView
// so as to use a cell with the class, MUPhotoCell.

//
//
//  MUPhotoView
//
// Copyright (c) 2006 Blake Seely
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
// and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//    LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
//    OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//  * You include a link to http://www.blakeseely.com in your final product.
//
// Version History:
//
// Version 1.0 - April 17, 2006 - Initial Release
// Version 1.1 - April 29, 2006 - Photo removal support, Added support for reduced-size drawing during live resize
// Version 1.2 - September 24, 2006 - Updated selection behavior, Changed to MIT license, Fixed issue where no images would show, fixed autoscroll

#import <Cocoa/Cocoa.h>
#import <SproutedInterface/MUPhotoView.h>

//#import <iMediaBrowser/MUPhotoView.h>
//#import "MUPhotoView.h"

//! MUPhotoView displays a grid of photos similar to iPhoto's main photo view. The class gives developers several options for providing images - via bindings or delegation.

//! MUPhotoView displays a resizeable grid of photos, similar to iPhoto's photo view functionality. MUPhotoView provides developers with two different options for passing photo information to the view
//!  Most importantly, MUPhotoView currently only deals with an array of photos. It does not yet know how to display titles or any other metadata. It also does not know how to find NSImage objects
//!  that are inside another object - it expects NSImage objects. The first method for providing those objects it by binding an array of NSImage objects to the "photosArray" key of the view.
//!  If this key has been bound, MUPhotoView will fetch all the images it displays from that binding. The second method is to have a delegate object provide the photos. MUPhotoView will only
//!  call the delegate's photo methods if the photosArray key has not been bound. Please see the MUPhotoViewDelegate category documentation for descriptions of the methods. 
@interface PDPhotoView : MUPhotoView {
    // Please do not access ivars directly - use the accessor methods documented below
	
	BOOL drawsBackground;
	unsigned indexForMenuEvent;
	
	NSCell *cell;
	NSCursor *hoverCursor;
	
	BOOL amPrinting;
}

- (NSCell*) cell;
- (void) setCell:(NSCell*)aCell;

- (NSCursor*) hoverCursor;
- (void) setHoverCursor:(NSCursor*)aCursor;

- (unsigned) indexForMenuEvent;
- (void) setIndexForMenuEvent:(unsigned)anIndex;

- (BOOL) drawsBackground;
- (void) setDrawsBackground:(BOOL)draws;

- (void) ownerWillClose:(NSNotification*)aNotification;

//- (float)calculatePrintHeight;

@end

@interface NSObject (MUPhotoViewMoreDelegateMethods)

- (NSString*) photoView:(MUPhotoView*)photoView titleForObjectAtIndex:(unsigned int)index;
- (NSString*) photoView:(MUPhotoView*)photoView tooltipForObjectAtIndex:(unsigned int)index;

@end
