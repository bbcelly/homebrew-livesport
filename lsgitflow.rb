require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
# Example: /opt/brew/Library/Contributions/example-formula.rb

# vim command: read !openssl dgst -sha1 *.tar.gz *.diff

class Lsgitflow < Formula
  package = "lsgitflow"
  version = "1.5.6-4+ubuntu_all"
  urlPrefix = "http://#{package}.belakos/"

  version version

  url "#{urlPrefix}#{version}/#{package}_#{version}.tar.gz"
  sha1 "f57783632f9813df93a897ba9c4255d5fa1841de"
  depends_on "lsdevtools"

  patch :p2 do
    url "#{urlPrefix}#{version}/#{package}_#{version}.diff"
    sha1 "f458603db8b032dd21697a9651318cf517b9b2dc"
  end

  def install

    prefix.install Dir["./local/bin"]

  end
end
