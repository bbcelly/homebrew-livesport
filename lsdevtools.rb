require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
# Example: /opt/brew/Library/Contributions/example-formula.rb

class Lsdevtools < Formula
  package = "lsdevtools"
  version = "1.16-0+trusty_all"
  urlPrefix = "http://#{package}.belakos/"
  url "#{urlPrefix}#{version}/#{package}_#{version}.tar.xz"
  sha1 "b64c45c0b769bbdca9434a3d33d620d29a36004e"

  depends_on "bash"
  depends_on "coreutils"
  depends_on "git"

  version version

  patch do
    url "#{urlPrefix}#{version}/#{package}_#{version}.diff"
    sha1 "ce0f533510845d0ef9f1be704faf9435df450fd5"
  end

  def install

    prefix.install Dir["./etc"]
    prefix.install Dir["./usr/local/bin"]
    prefix.install Dir["./usr/share"]

    mkdir_p templateHooksPath = File.join(share, 'git-core/templates/hooks')

    gitCoreHooks = File.join(share, "git-core/.hooks")
    Dir.foreach(gitCoreHooks) do |item|
      if item != '.' and item != '..'
        hookPath = File.join(gitCoreHooks, item)
        Pathname.new(templateHooksPath).install_symlink hookPath
        inreplace hookPath, /#!\/usr\/bin\/env bash/, "#!#{HOMEBREW_PREFIX}/bin/bash"
      end
    end

  end
end
