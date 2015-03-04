require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
# Example: /opt/brew/Library/Contributions/example-formula.rb

# vim command: read !openssl dgst -sha1 *.tar.gz *.diff

class Lsgitflow < Formula
  package = "lsgitflow"
  version = "1.5.6-6+ubuntu_all"
  urlPrefix = "http://#{package}.belakos/"

  version version

  url "#{urlPrefix}#{version}/#{package}_#{version}.tar.gz"
  sha1 "e6a5052f52a581912d30a9dfc9bde6a8079899c3"
  depends_on "lsdevtools"
  depends_on "bash-completion"

  patch do
    url "#{urlPrefix}#{version}/#{package}_#{version}.diff"
    sha1 "01740724e6a96faa0fc75a7fae03c338bc9a4b50"
  end

  def install

    prefix.install Dir["./local/bin"]

  end
end
