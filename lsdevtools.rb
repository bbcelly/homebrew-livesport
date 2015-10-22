require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
# Example: /opt/brew/Library/Contributions/example-formula.rb

class Lsdevtools < Formula
  package = "lsdevtools"
  version = "1.15.29-1-d+trusty_all"
  urlPrefix = "http://#{package}.belakos/"

  version version

  url "#{urlPrefix}#{version}/#{package}_#{version}.tar.xz"
  sha1 "9e08c0d91698f297cfdddf9e05c73d7a7985f2bd"
  depends_on "bash"
  depends_on "coreutils"

  patch do
    url "#{urlPrefix}#{version}/#{package}_#{version}.diff"
    sha1 "1bfc9106f1490f6a41f8ecbfd569d62929634394"
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

    # Xcode gitconfig

    userHome = %x(greadlink -f ~#{ENV["USER"]}).strip

    xCodeUser = File.join(userHome, "Library/Developer/Xcode")
    xCodeUserBin = File.join(xCodeUser, "usr/bin")
    xCodeUserEtc = File.join(xCodeUser, "usr/etc")
    xCodeUserTemplates = File.join(xCodeUser, "usr/share/git-core/templates")

    xCodeUserGit = File.join(xCodeUserBin, "git")
    xCodeUserGitconfig = File.join(xCodeUserEtc, "gitconfig")
    xCodeUserHooks = File.join(xCodeUserTemplates, "hooks")

    mkdir_p(xCodeUser)
    mkdir_p(xCodeUserBin)
    mkdir_p(xCodeUserEtc)
    mkdir_p(xCodeUserTemplates)

    if File.symlink?(xCodeUserGit)
      File.unlink(xCodeUserGit)
    end

    if File.symlink?(xCodeUserGitconfig)
      File.unlink(xCodeUserGitconfig)
    end

    if File.symlink?(xCodeUserHooks)
      File.unlink(xCodeUserHooks)
    end

    ln_s(File.join(%x(xcode-select --print-path).strip, "usr/bin/git"), xCodeUserGit)
    ln_s(File.join(HOMEBREW_PREFIX, "etc/gitconfig"), xCodeUserGitconfig)
    ln_s(File.join(HOMEBREW_PREFIX, "share/git-core/.hooks"), xCodeUserHooks)

    binPath = "${HOME}/Library/Developer/Xcode/usr/bin"

    bashRc = File.join(userHome, ".bashrc")
    bashProfile = File.join(userHome, ".bash_profile")

    if File.file?(bashRc) or File.file?(bashProfile)
      rcFile = File.file?(bashRc) ? bashRc : bashProfile
      if File.readlines(rcFile).grep(Regexp.new(Regexp.escape(binPath))).size == 0
        open(rcFile, 'a') do |f|
          f << "\n"
          f << "# added automatically by lsdevtools"
          f << "\n"
          f << "PATH=\"#{binPath}:${PATH}\""
          f << "\n"
        end
        ohai "Automatically added '#{binPath}' to PATH in '#{rcFile}'."
      end
    else
      opoo "No .bashrc nor .bash_profile found. Please add '#{binPath}' to PATH manually."
    end

  end
end
