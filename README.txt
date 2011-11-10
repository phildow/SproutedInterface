
INTRODUCTION

SproutedUtilities is a hodgepodge of code I have come to use in Journler and other projects. 
Originally I wanted to create a collection of reusable code for a number of applications 
I was developing at the time. I now realize that there is no need for this code to be in a 
framework, although a repository of general code is a fine idea. Future work on this 
framework will involve decomposing it so that the project does not produce any usable binary 
but instead simply maintains the repository.

THIS IS OLD CODE. Much of it is deprecated or obsolete. In fact I'm not sure the framework 
even compiles on Mac OS 10.7. I am nevertheless publishing the code as part of the Journler open 
source project because it is used extensively throughout Journler. As Journler 2.6 development 
proceeds changes to this framework will take place as well. I will push updates to github as they 
accumulate.


SPROUTED DEPENDENCIES

    - SproutedUtilities framework
    

THE LICENSE

The SproutedInterface framework is Copyright (c) Philip Dow, Sprouted. All rights reserved. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted 
provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions 
and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions 
and the following disclaimer in the documentation and/or other materials provided with the distribution.

Neither the name of the organization nor the names of its contributors may be used to endorse or 
promote products derived from this software without specific prior written permission.

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


3rd PARTY LICENSING AND ACKNOWLEDGEMENTS

The SproutedInterface license does not supersede the licensing terms specified by third party software 
which the framework includes. Licenses specified by 3rd party developers must be respected. Software 
which uses 3rd party code in its use of this framework must also acknowledge that use independently of 
any acknowledgement to Philip Dow or Sprouted.

It is possible that software being used in this framework has not been correctly attributed or is being 
used in ways consistent with the licensing terms. If you come across source code which you believe should
not be included in this framework or which requires more robust attribution, please contact me.  I've 
collected code from a number of sources and I don't always note where it's from. For example, a lot of 
code is based on public source at cocoadev.com, a great repository for Cocoa and Obj-C developers. 
Check it out.

The SproutedInterface framework makes use of the following open source software:

	- MUPhotoView, Blake Seely
	- RBSplitView, Rainer Brockerhoff
	- Polished Window, HUDWindow, and TransparentWindow and other UI classes, Matt Gemmell
	- EtchedText, EtchedPopUpButton and other iLife controls, Sean Patrick O'Brien
	- MNLineNumberTextView and related classes, Masatoshi Nishikata


INCLUDED IMAGES

The images included in this framework are not my own. They come from the resource files of old Apple 
applications, eg Safari for 10.4 or 10.5. In the past Apple has not commented on developers using icons 
from its own applications, one imagines in the name of interface consistency, although Apple retains
legal ownership of them. Ideally as this framework is decomposed the images will be removed from it so
that developers will have to include them in the application itself, or they will be replaced by resolution 
independent custom drawing code. 