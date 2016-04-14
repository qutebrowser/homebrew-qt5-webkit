class Qt5WebKit < Formula
  desc "Version 5 of the Qt framework - QtWebKit module"
  homepage "https://www.qt.io/"
  url "http://download.qt.io/community_releases/5.6/5.6.0/qtwebkit-opensource-src-5.6.0.tar.xz"
  mirror "https://www.mirrorservice.org/sites/download.qt-project.org/community_releases/5.6/5.6.0/qtwebkit-opensource-src-5.6.0.tar.xz"
  sha256 "9ca72373841f3a868a7bcc696956cdb0ad7f5e678c693659f6f0b919fdd16dfe"

  head "https://code.qt.io/qt/qtwebkit.git", :branch => "5.6", :shallow => false

  # OS X 10.7 Lion is still supported in Qt 5.5, but is no longer a reference
  # configuration and thus untested in practice. Builds on OS X 10.7 have been
  # reported to fail: <https://github.com/Homebrew/homebrew/issues/45284>.
  depends_on :macos => :mountain_lion

  depends_on "qt5"
  depends_on :xcode => :build

  def install
    args = %W[
      -verbose
      -prefix #{prefix}
      -release
      -opensource -confirm-license
      -system-zlib
      -qt-libpng
      -qt-libjpeg
      -nomake tests
      -no-rpath
    ]

    system "qmake"
    system "make"
    system "make", "INSTALL_ROOT=#{prefix}" "install"
  end

  test do
    (testpath/"hello.pro").write <<-EOS.undent
      QT       += core webkit
      QT       -= gui
      TARGET = hello
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<-EOS.undent
      #include <QCoreApplication>
      #include <QDebug>
      #include <QWebView>

      int main(int argc, char *argv[])
      {
      }
    EOS

    system bin/"qmake", testpath/"hello.pro"
    system "make"
    assert File.exist?("hello")
    assert File.exist?("main.o")
  end
end
