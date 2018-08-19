# GPhoto2.framework

This is an [Apple Umbrella Framework](http://support.apple.com/kb/TA25631?viewlocale=en_US) (Library) embedding all necessary open source libraries:

* [libtool](http://www.gnu.org/software/libtool/) - Necessary part `ltdl` is licensed under [LGPL 2.1](http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html)
* [libusb](https://github.com/libusb/libusb) - licensed under [LGPL 2.1](http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html)
* [libusb-compat](https://github.com/libusb/libusb-compat-0.1) - licensed under [LGPL 2.1](http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html)
* [libjpeg-turbo](https://github.com/libjpeg-turbo/libjpeg-turbo) - licensed by [three compatible BSD-style open source licenses](https://github.com/libjpeg-turbo/libjpeg-turbo/blob/master/LICENSE.md)
* [libgphoto2](https://github.com/gphoto/libgphoto2) - licensed under [LGPL 2.1](http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html)

This framework itself is released under the Lesser [GPL 3.0](http://www.gnu.org/copyleft/).


## Downloading
Binary version of the framework are occasionally built and uploaded to

* [Google Code](http://code.google.com/p/gphoto2-framework/downloads/list)


## Building
# Build Requirements
* wget
* Nasm 2.07 or later (install using [homebrew](http://brew.sh)) required for libjpeg-turbo.

After cloning the repository, installing XCode, installing `wget` and `nasm`, you can directly start the build process by running `build.sh`. You need to have write access to `/Library/Frameworks/GPhoto2.framework` in order to be able to build the framework.


<pre>
$ ./build.sh
Build Process of the GPhoto2.framework
https://github.com/lnxbil/GPhoto2.framework

+ Checking permissions on /Library/Frameworks/GPhoto2.framework
+ Download and extracting files
+ Start building at Fri Dec 23 19:05:16 MSK 2016 with 16 threads
  - Building libtool-2.4.6
  - Building pkg-config-0.29.1
  - Building libusb-1.0.21
  - Building libusb-compat-0.1-0.1.6-rc2
  - Building libjpeg-turbo-1.5.1
  - Building libgphoto2-libgphoto2-2_5_11-release
+ Finished building at Fri Dec 23 19:08:58 MSK 2016
+ Cleaning up framework directory
+ Linking headers
+ Building Apple Framework infrastructure
</pre>

It is also possible to build the SVN version of `libgphoto2`, please set
<pre>
GPHOTO="SVN"
</pre>
in the `config` file, which automatically fetches or updates the local svn working copy.

## Example Usage
A working example is provided in the `example` directory. You need to have the `GPhoto2.framework` to be installed in order to build the example with XCode:

![image](https://github.com/lnxbil/GPhoto2.framework/raw/master/example/doc/app.png)

If you want to build your own application, you need to use the `-flat_namespace` linker option in XCode:

![image](https://github.com/lnxbil/GPhoto2.framework/raw/master/example/doc/flat_namespace.png)
