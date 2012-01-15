require 'formula'

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

  def install
    if quartz? and not pango_quartz?
        onoe "To install a GTK+ with the quartz backend you need to compile pango with the --quartz option"
        exit 1
    end
    
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--disable-glibtest", '--disable-introspection']
   
    args << "--with-gdktarget=quartz" << if quartz?
        
    # cairo_pkgconfig = Formula.factory("cairo").prefix+'lib'+'pkgconfig'
    # pango_pkgconfig = Formula.factory("pango").prefix+'lib'+'pkgconfig'
    # ENV['PKG_CONFIG_PATH'] = [ cairo_pkgconfig, pango_pkgconfig ].join(":")
  
    system "./configure", *args
    system "make install"
  end

  def test
    system "#{bin}/gtk-demo"
  end
end
