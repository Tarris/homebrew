require 'formula'
require 'keg'
require 'tab'

def quartz?
  ARGV.include? '--quartz'
end

def pango_quartz?
  c = Formula.factory('pango')
  if c.installed?
    k = Keg.for(c.prefix)
    Tab.for_keg(k).installed_with? '--quartz'
  else
    false
  end
end

class Gtkx < Formula
  homepage 'http://www.gtk.org/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.8.tar.bz2'
  sha256 'ac2325a65312922a6722a7c02a389f3f4072d79e13131485cc7b7226e2537043'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'gdk-pixbuf'
  depends_on 'pango'
  depends_on 'jasper' => :optional
  depends_on 'atk' => :optional

  fails_with_llvm "Undefined symbols when linking", :build => "2326" unless MacOS.lion?

  def options
    [ ['--quartz', "Use Quartz (native) backend."] ]
  end

  def patches
    DATA
  end

  def install
    if quartz? and not pango_quartz?
        onoe "To install a GTK+ with the quartz backend you need to compile pango with the --quartz option."
        exit 1
    end

    if not quartz? and pango_quartz?
        onoe "To install GTK+ with X11 backend, you need a pango compiled without the --quartz option."
        exit 1
    end

    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--disable-glibtest", '--disable-introspection']

    args << "--with-gdktarget=quartz" if quartz?

    system "./configure", *args
    system "make install"
  end

  def test
    system "#{bin}/gtk-demo"
  end
end

__END__
diff --git a/tests/Makefile.in b/tests/Makefile.in
index 7a8520a..73e1c84 100644
--- a/tests/Makefile.in
+++ b/tests/Makefile.in
@@ -89,7 +89,7 @@ am__autotestkeywords_SOURCES_DIST = autotestkeywords.cc
 @HAVE_CXX_TRUE@am_autotestkeywords_OBJECTS =  \
 @HAVE_CXX_TRUE@	autotestkeywords-autotestkeywords.$(OBJEXT)
 autotestkeywords_OBJECTS = $(am_autotestkeywords_OBJECTS)
-autotestkeywords_LDADD = $(LDADD)
+autotestkeywords_LDADD = $(LDADDS)
 AM_V_lt = $(am__v_lt_$(V))
 am__v_lt_ = $(am__v_lt_$(AM_DEFAULT_VERBOSITY))
 am__v_lt_0 = --silent
