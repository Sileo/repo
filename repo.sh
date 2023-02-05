#!/bin/bash
script_full_path=$(dirname "$0")
cd $script_full_path || exit 1

rm Packages Packages.bz2 Packages.xz Packages.zst Release Release.gpg

echo "[Repository] Generating Packages..."
apt-ftparchive packages ./pool > Packages
zstd -q -c19 Packages > Packages.zst
xz -c9 Packages > Packages.xz
bzip2 -c9 Packages > Packages.bz2

echo "[Repository] Generating Release..."
apt-ftparchive \
		-o APT::FTPArchive::Release::Origin="Sileo" \
		-o APT::FTPArchive::Release::Label="Sileo" \
		-o APT::FTPArchive::Release::Suite="stable" \
		-o APT::FTPArchive::Release::Version="2.0" \
		-o APT::FTPArchive::Release::Codename="ios" \
		-o APT::FTPArchive::Release::Architectures="iphoneos-arm iphoneos-arm64" \
		-o APT::FTPArchive::Release::Components="main" \
		-o APT::FTPArchive::Release::Description="Sileo for Checkra1n and Unc0ver" \
		release . > Release

echo "[Repository] Signing Release using Amy's GPG Key..."
gpg -abs -u 816C7A50B575162DC29288CD72339224580758CE -o Release.gpg Release

echo "[Repository] Finished"
