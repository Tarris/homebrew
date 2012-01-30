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

class GtkMacIntegration < Formula
  url 'http://ftp.gnome.org/pub/gnome/sources/gtk-mac-integration/1.0/gtk-mac-integration-1.0.1.tar.bz2'
  homepage 'http://live.gnome.org/GTK+/OSX'
  sha256 '417773d32be5304839f6f917a6ce4637d9a642829105ce8f9527f663830b8089'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'gtk+'

# depends_on 'pygtk' => :optional
# depends_on 'pyobject-codegen' => :optional

  def install
    unless gtk_quartz?
        onoe "gtk-mac-integration needs gtk with quartz backend."
        exit 1
    end

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-glibtest"

    system "make install"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test gtk-mac-integration`. Remove this comment before submitting
    # your pull request!
    system "false"
  end
end
