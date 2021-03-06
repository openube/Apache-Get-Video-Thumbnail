#
# Copyright (c) 2012 - Maxwell Dayvson <dayvson@gmail.com>
# Copyright (c) 2012 - Tiago de Pádua <tiagopadua@gmail.com>
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of the University nor the names of its contributors
#    may be used to endorse or promote products derived from this software
#    without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.

include defines.mk

# Standard VARS, may be overwritten by external parameters
CFLAGS = -Iinclude
LIBS = -lavcodec -lswscale -lavutil -lavformat -ljpeg
FLAGS = -Wc,-DMAJOR=$(MAJOR) -Wc,-DMINOR=$(MINOR) -Wc,-DPATCH=$(PATCH) -Iinclude

.PHONY : all
all: apxs

.PHONY : install
install: apxs
	cp -f .libs/$(LIBNAME) $(APACHE_MODULES_DIR)
	echo "Don't forget to edit httpd.conf"

.PHONY : clean
clean:
	rm -Rf $(BINNAME) $(NAME) src/*.o src/*~ src/*.la src/*.lo src/*.slo src/*.so src/*.loT src/.libs src/*.jpg

apxs: 
	apxs -c $(FLAGS) src/util.c src/jpegencoder.c src/storyboard.c src/thumbnail.c src/video_thumbnail_module.c src/querystring.c -o $(BINNAME) $(LIBS)

.PHONY : test
test:
	gcc $(CFLAGS) $(LIBS) src/util.c src/jpegencoder.c src/storyboard.c src/thumbnail.c src/querystring.c test/main.c -o $(NAME) && ./videothumb