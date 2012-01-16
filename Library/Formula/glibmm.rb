require 'formula'

class Glibmm < Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/glibmm/2.30/glibmm-2.30.1.tar.bz2'
  homepage 'http://www.gtkmm.org/'
  md5 '9b333de989287c563334faa88a11fc21'

  depends_on 'pkg-config' => :build
  depends_on 'libsigc++'
  depends_on 'glib'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
