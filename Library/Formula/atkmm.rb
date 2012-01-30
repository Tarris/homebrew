require 'formula'

class Atkmm < Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/atkmm/2.22/atkmm-2.22.6.tar.bz2'
  homepage 'http://library.gnome.org/devel/atk/'
  md5 '7c35324dd3c081a385deb7523ed6f287'

  depends_on 'atk'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

end
