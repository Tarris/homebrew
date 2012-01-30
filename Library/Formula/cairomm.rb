require 'formula'
require 'keg'
require 'tab'

def cairo_quartz?
    c = Formula.factory('cairo')
    if c.installed?
        k = Keg.for(c.prefix)
        Tab.for_keg(k).installed_with? '--quartz'
    else
        false
    end
end

class Cairomm < Formula
  url 'http://cairographics.org/releases/cairomm-1.10.0.tar.gz'
  homepage 'http://cairographics.org/cairomm/'
  md5 '9c63fb1c04c8ecd3c5e6473075b8c39f'

  depends_on 'pkg-config' => :build
  depends_on 'libsigc++'

  if not (MacOS.snow_leopard? and not cairo_quartz?)
    depends_on 'cairo'
  end 
  
  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end