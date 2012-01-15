require 'formula'

def gtk_quartz?
    c = Formula.factory('gtk')
    if c.installed?
        k = Keg.for(c.prefix)
        Tab.for_keg(k).installed_with? '--quartz'
    else
        false
    end
end

class Glade < Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/glade3/3.8/glade3-3.8.0.tar.bz2'
  homepage 'http://glade.gnome.org/'
  md5 '42f8b2dd01b9bfb8860bb3a5d978e1a2'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'intltool'
  depends_on 'libglade'
  depends_on 'hicolor-icon-theme'

  depends_on 'cairo'

  def patches
    # patch glade to use GtkOSXApplication
    # fix menu accelerators
    ['https://bugzilla.gnome.org/attachment.cgi?id=201040',
     'https://bugzilla.gnome.org/attachment.cgi?id=201039']
  end

  def install
    system "find . | grep Makefile.in | xargs -t -J % sed -i '.sed' 's/IGE_MAC/GTK_MAC/g' %"
    system "sed -i '.sed' 's/IGE_MAC/GTK_MAC/g' configure"
    system "sed -i '.sed' 's/ige-mac/gtk-mac/g' configure"

  #  if gtk_quartz?
  #      cairo = Formula.factory('cairo').lib+"pkgconfig"
  #      ENV['PKG_CONFIG_PATH'] += cairo
  #  end
    
    system "./configure", "--enable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
