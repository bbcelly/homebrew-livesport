require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
# Example: /opt/brew/Library/Contributions/example-formula.rb

class Lsgitflow < Formula
  package = "lsgitflow"
  version = "1.5.7-0+ubuntu_all"
  urlPrefix = "http://#{package}.belakos/"

  version version

  url "#{urlPrefix}#{version}/#{package}_#{version}.tar.gz"
  sha1 "7ce3bbc221bd5e37b68591745c0c1dbf24ab174f"
  depends_on "lsdevtools"
  depends_on "bash-completion"

  patch do
    url "#{urlPrefix}#{version}/#{package}_#{version}.diff"
    sha1 "40c7ec0efe628008938ed67762ddfa7ae77035c2"
  end

  def install

    prefix.install Dir["./etc"]
    prefix.install Dir["./usr/local/bin"]

  end
end
