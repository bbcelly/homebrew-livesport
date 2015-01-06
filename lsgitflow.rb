require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
# Example: /opt/brew/Library/Contributions/example-formula.rb

# vim command: read !openssl dgst -sha1 *.tar.gz *.diff

class Lsgitflow < Formula
  package = "lsgitflow"
  version = "1.5.6-1+ubuntu_all"
  urlPrefix = "http://#{package}.belakos/"

  version version

  url "#{urlPrefix}#{version}/#{package}_#{version}.tar.gz"
  sha1 "49f0d23225d480ebecdd5e342109ba68f52d314c"
  depends_on "lsdevtools"

  patch :p2 do
    url "#{urlPrefix}#{version}/#{package}_#{version}.diff"
    sha1 "14a69378fc93d10a7c6f8e6db9f9c753012b4d88"
  end

  def install

    prefix.install Dir["./local/bin"]

  end
end
