require 'formula'
require 'tab'
require 'keg'

def quartz?
    ARGV.include? '--quartz'
end

def cairo_quartz?
    c = Formula.factory('cairo')
    if c.installed?
        k = Keg.for(c.prefix)
        Tab.for_keg(k).installed_with? '--quartz'
    else
        false
    end
end

class Pango < Formula
    homepage 'http://www.pango.org/'
    url 'http://ftp.gnome.org/pub/gnome/sources/pango/1.28/pango-1.28.4.tar.bz2'
    sha256 '7eb035bcc10dd01569a214d5e2bc3437de95d9ac1cfa9f50035a687c45f05a9f'

    depends_on 'pkg-config' => :build
    depends_on 'glib'

    depends_on 'fontconfig' if MacOS.leopard? # Leopard's fontconfig is too old.

    # - Leopard doesn't come with Cairo
    # - The Cairo library shipped with Lion contains a flaw that causes Graphviz
    #       to segfault. See the following ticket for information:
    #       https://trac.macports.org/ticket/30370
    depends_on 'cairo' unless (MacOS.snow_leopard? and not quartz?)

    fails_with_llvm "Undefined symbols when linking", :build => "2326"

    def options
        [ ['--quartz', "Build for use with Quartz enabled libcairo (experimental)"] ]
    end

    def install
        if quartz? and not cairo_quartz?
            onoe "To build pango with quartz support, build cairo with --quartz as well"
        exit 1
        end

        if quartz?
            args = ['--without-x']
        elsif
            ENV.x11
            args = ["--with-x"]
        end

        args += ["--disable-dependency-tracking", "--disable-debug",
                 "--prefix=#{prefix}",
                 "--enable-man",
                 "--with-html-dir=#{share}/doc"]

        system "./configure", *args
        system "make"
        system "make install"
    end

    def test
        mktemp do
            ohai "Test fails with assertion error, this may be a bug in pango-view and not in pango itself."
            system "#{bin}/pango-view -t 'test-image' --waterfall --rotate=10 --annotate=1 --header -q -o output.png"
            system "/usr/bin/qlmanage -p output.png"
        end
    end
end
