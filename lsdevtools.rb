require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
# Example: /opt/brew/Library/Contributions/example-formula.rb

# vim command: read !openssl dgst -sha1 *.tar.gz *.diff

class Lsdevtools < Formula
  package = "lsdevtools"
  version = "1.15.6-0+ubuntu_all"
  urlPrefix = "http://#{package}.belakos/"

  version version

  url "#{urlPrefix}#{version}/#{package}_#{version}.tar.gz"
  sha1 "b2fa530491ed03073b2819fde9b4194f062efddb"
  depends_on "bash"
  depends_on "coreutils"

  patch do
    url "#{urlPrefix}#{version}/#{package}_#{version}.diff"
    sha1 "dfcb85217590ba704039e29456c6da000dcff01c"
  end

  resource "prepareTimemachine.sh" do
    url "#{urlPrefix}prepareTimemachine.sh"
    sha1 "9b4f7017adbae88eb96dbb19f3a31eb70c560450"
  end

  def install

    # hooks to bash v4

    gitCoreHooks = "./usr/share/git-core/.hooks"
    Dir.foreach(gitCoreHooks) do |item|
      if item == '.' or item == '..'
        next
      end
      inreplace File.join(gitCoreHooks, item), /#!\/usr\/bin\/env bash/, "#!#{HOMEBREW_PREFIX}/bin/bash"
    end

    # install

    prefix.install Dir["./etc"]
    prefix.install Dir["./usr/local/bin"]
    prefix.install Dir["./usr/share"]

    # prepareTimemachine.sh

    resource("prepareTimemachine.sh").stage {
      bin.install "prepareTimemachine.sh"
    }

    # Xcode gitconfig

    xCodeDeveloper = %x(xcode-select --print-path).strip
    xCodeEtc = File.join(xCodeDeveloper, "usr/etc")
    xCodeGitConfig = File.join(xCodeEtc, "gitconfig")

    if not File.directory?(xCodeEtc)
      %x(sudo mkdir -p "#{xCodeEtc}")
    end

    if File.file?(xCodeGitConfig) or File.symlink?(xCodeGitConfig)
      %x(sudo rm -f "#{xCodeGitConfig}")
    end

    target = File.join(etc, "gitconfig")
    %x(sudo ln -sfn "#{target}" "#{xCodeEtc}")

    # git hooks

    xCodeGitTemplates = File.join(xCodeDeveloper, "usr/share/git-core/templates/hooks")

    Dir.foreach(File.join(share, "git-core/.hooks")) do |item|
      if item == '.' or item == '..'
        next
      end
      xCodeGitHook = File.join(xCodeGitTemplates, item)
      if File.file?(xCodeGitHook) or File.symlink?(xCodeGitHook)
        %x(sudo rm -f "#{xCodeGitHook}")
      end
      target = File.join(share, "git-core/.hooks", item)
      %x(sudo ln -sfn "#{target}" "#{xCodeGitHook}")
    end

  end
end
