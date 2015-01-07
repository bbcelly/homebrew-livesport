require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
# Example: /opt/brew/Library/Contributions/example-formula.rb

# vim command: read !openssl dgst -sha1 *.tar.gz *.diff

class Lsgitflow < Formula
  package = "lsgitflow"
  version = "1.5.6-2+ubuntu_all"
  urlPrefix = "http://#{package}.belakos/"

  version version

  url "#{urlPrefix}#{version}/#{package}_#{version}.tar.gz"
  sha1 "b8b8726c728d089e68e11cd0c3eebcc3f8a956a5"
  depends_on "lsdevtools"

  patch :p2 do
    url "#{urlPrefix}#{version}/#{package}_#{version}.diff"
    sha1 "4372060727d582992db9f53e38c340d521ac9ec0"
  end

  def install

    prefix.install Dir["./local/bin"]

  end
end
