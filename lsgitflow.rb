require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
# Example: /opt/brew/Library/Contributions/example-formula.rb

# vim command: read !openssl dgst -sha1 *.tar.gz *.diff

class Lsgitflow < Formula
  package = "lsgitflow"
  version = "1.5.6-7+ubuntu_all"
  urlPrefix = "http://#{package}.belakos/"

  version version

  url "#{urlPrefix}#{version}/#{package}_#{version}.tar.gz"
  sha1 "b13270b7e6844c1248278a65a59b1e4459fd447a"
  depends_on "lsdevtools"
  depends_on "bash-completion"

  patch do
    url "#{urlPrefix}#{version}/#{package}_#{version}.diff"
    sha1 "d3588d0c4fefd89d622d3bbd10a37fad65929b09"
  end

  def install

    prefix.install Dir["./etc"]
    prefix.install Dir["./usr/local/bin"]

  end
end
