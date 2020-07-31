/*
 * AppDelegate.m
 * GPhoto2.framework Information
 * 
 * Copyright (C) 2010-2012 Andreas Steinel
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 */

#import <gphoto2/gphoto2-version.h>
#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    const char **version_port_library = gp_port_library_version( GP_VERSION_SHORT );
    const char **version_library = gp_library_version( GP_VERSION_SHORT );
    
    [lb_gphoto setStringValue:[NSString stringWithFormat:@"%s", version_library[0]]];
    [lb_gphotoport setStringValue:[NSString stringWithFormat:@"%s", version_port_library[0]]];


}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    return true;
}

- (IBAction)closeApplication:(id)sender
{
    [NSApp terminate: nil];
}



#pragma mark -
#pragma mark Homepage Actions

- (IBAction)visitHomepage:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/lnxbil/GPhoto2.framework"]];
}

- (IBAction)visitGPhotoHomepage:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.gphoto.org/"]];
}

- (IBAction)visitLibtoolHomepage:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.gnu.org/software/libtool/"]];
}

- (IBAction)visitJPEGHomepage:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.ijg.org/"]];
}

- (IBAction)visitLibusbHomepage:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.libusb.org/"]];
}


#pragma mark -
#pragma mark License Actions

- (IBAction)visitLicenseLesser:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.gnu.org/copyleft/lesser.html"]];
}

- (IBAction)visitLicenseLesser21:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html"]];
}

- (IBAction)visitJPEGLicense:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://xstandard.com/1D1B6C13-7BB6-4FA8-A1F9-EC1E32577D26/license-ijg.txt"]];
}



@end
