# GPhoto2.framework

This is an [Apple Umbrella Framework](http://support.apple.com/kb/TA25631?viewlocale=en_US) (Library) embedding all necessary open source libraries:

* [libtool](http://www.gnu.org/software/libtool/) - Necessary part `ltdl` is licensed under [LGPL 2.1](http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html)
* [libusb](http://www.libusb.org/) - licensed under [LGPL 2.1](http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html)
* [libusb-compat](http://www.libusb.org/) - licensed under [LGPL 2.1](http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html)
* [jpeg](http://www.ijg.org/) - licensed under [Own free license](http://xstandard.com/1D1B6C13-7BB6-4FA8-A1F9-EC1E32577D26/license-ijg.txt)
* [libgphoto2](http://www.gphoto.org/) - licensed under [LGPL 3.0](http://www.gnu.org/copyleft/lesser.html)

This framework itself is released under the Lesser [GPL 3.0](http://www.gnu.org/copyleft/).


## Downloading
Binary version of the framework are occasionally built and uploaded to

* [Google Code](http://code.google.com/p/gphoto2-framework/downloads/list)


## Building
After cloning the repository, installing XCode, installing `wget`, you can directly start the build process by running `build.sh`. You need to have write access to `/Library/Frameworks/GPhoto2.framework` in order to be able to build the framework.
<pre>
$ ./build.sh
Build Process of the GPhoto2.framework
https://github.com/lnxbil/GPhoto2.framework

+ Checking permissions on /Library/Frameworks/GPhoto2.framework
+ Download and extracting files
+ Start building at Fri Jan 27 21:05:07 CET 2012 with 16 threads
  - Building libtool-2.4.2
  - Building pkg-config-0.25
  - Building libusb-1.0.8
  - Building libusb-compat-0.1.3
  - Building jpeg-6b1
  - Building libgphoto2-2.4.12
+ Finished building at Fri Jan 27 21:06:19 CET 2012
+ Cleaning up framework directory
+ Linking headers
+ Building Apple Framework infrastructure
</pre>

It is also possible to build the SVN version of `libgphoto2`, please set
<pre>
GPHOTO="SVN"
</pre>
which automatically fetches or updates the local svn working copy.

## Example Usage
A working example is provided in the `example` directory. You need to have the `GPhoto2.framework` to be installed in order to build the example with XCode:

![image](https://github.com/lnxbil/GPhoto2.framework/raw/master/example/doc/app.png)

If you want to build your own application, you need to the the `-flat_namespace` linker option in XCode:

![image](https://github.com/lnxbil/GPhoto2.framework/raw/master/example/doc/flat_namespace.png)
