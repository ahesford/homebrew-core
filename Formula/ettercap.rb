class Ettercap < Formula
  desc "Multipurpose sniffer/interceptor/logger for switched LAN"
  homepage "https://ettercap.github.io/ettercap/"
  url "https://github.com/Ettercap/ettercap/archive/v0.8.2.tar.gz"
  sha256 "f38514f35bea58bfe6ef1902bfd4761de0379942a9aa3e175fc9348f4eef2c81"
  head "https://github.com/Ettercap/ettercap.git"

  bottle do
    revision 1
    sha256 "05e3c0fe0da148df590f32a71d6265ef92028a031814c1f34d87a028dc7ee598" => :el_capitan
    sha256 "6bdead34623676c9b61f134985bab01f59a58f19848fdc93c51ac512a65685c5" => :yosemite
    sha256 "c01dfad3aa45e307c633dbf87069bd39f6ac99761342e21c364ac412fa4513bf" => :mavericks
  end

  option "without-curses", "Install without curses interface"
  option "without-plugins", "Install without plugins support"
  option "without-ipv6", "Install without IPv6 support"

  depends_on "cmake" => :build
  depends_on "ghostscript" => [:build, :optional]
  depends_on "pcre"
  depends_on "libnet"
  depends_on "openssl"
  depends_on "curl" if MacOS.version <= :mountain_lion # requires >= 7.26.0.
  depends_on "gtk+" => :optional
  depends_on "gtk+3" => :optional
  depends_on "luajit" => :optional

  def install
    args = std_cmake_args + %W[
      -DBUNDLED_LIBS=OFF
      -DINSTALL_SYSCONFDIR=#{etc}
    ]

    if build.with? "curses"
      args << "-DENABLE_CURSES=ON"
    else
      args << "-DENABLE_CURSES=OFF"
    end

    if build.with? "plugins"
      args << "-DENABLE_PLUGINS=ON"
    else
      args << "-DENABLE_PLUGINS=OFF"
    end

    if build.with? "ipv6"
      args << "-DENABLE_IPV6=ON"
    else
      args << "-DENABLE_IPV6=OFF"
    end

    if build.with? "ghostscript"
      args << "-DENABLE_PDF_DOCS=ON"
    else
      args << "-DENABLE_PDF_DOCS=OFF"
    end

    if build.with?("gtk+") || build.with?("gtk+3")
      args << "-DENABLE_GTK=ON" << "-DINSTALL_DESKTOP=ON"
      args << "-DGTK_BUILD_TYPE=GTK3" if build.with? "gtk+3"
    else
      args << "-DENABLE_GTK=OFF" << "-DINSTALL_DESKTOP=OFF"
    end

    if build.with? "luajit"
      args << "-DENABLE_LUA=ON"
    else
      args << "-DENABLE_LUA=OFF"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system bin/"ettercap", "--version"
  end
end
