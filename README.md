
# ChatGPT (Unofficial Desktop Wrapper)

English is the default language of this README. See the [简体中文](#简体中文) section below for the Chinese version.

An unofficial ChatGPT desktop wrapper for Linux.

This project uses [Tauri](https://tauri.app/) to display the official ChatGPT web application at [https://chatgpt.com/](https://chatgpt.com/) in a native desktop window. It is intended for personal Linux desktop use and for maintaining the Arch Linux AUR package.

## Features

- Lightweight native Tauri window using the system WebKitGTK renderer
- Direct access to [https://chatgpt.com/](https://chatgpt.com/)
- Linux and WebKitGTK font-rendering adjustments, including CJK fonts
- Wayland compatibility handling
- Arch Linux and AUR packaging support

## What this project does not do

- It does not provide ChatGPT or any AI service.
- It does not reimplement or modify ChatGPT's core functionality.
- It does not include any ChatGPT server-side code.
- It does not redistribute the official website or its content.

## Install on Arch Linux

Install the AUR package with an AUR helper such as `yay`:

```bash
yay -S chatgpt-webapp-desktop-bin
```

The package metadata and build files are maintained in the [AUR package repository](https://aur.archlinux.org/packages/chatgpt-webapp-desktop-bin).

## Build from source

Requirements include Rust, `cargo-tauri`, and WebKitGTK 4.1 development libraries.

```bash
cargo tauri build --bundles deb
```

The frontend is configured to load `https://chatgpt.com/` directly. The release helper packages the Linux binary and icons for a GitHub Release:

```bash
./release.sh <github-user> <github-repo>
```

## Disclaimer

This is an unofficial third-party project. It is not affiliated with, sponsored by, authorized by, or endorsed by OpenAI or ChatGPT's owners.

The names, trademarks, logos, website content, user interface, AI services, and other related resources belong to their respective rights holders. This repository contains only the desktop wrapper, Linux integration, and packaging files.

If a rights holder believes that this project uses their materials inappropriately, please open a GitHub issue and the project will be reviewed promptly.

## License

Original desktop-wrapper and packaging code in this repository is available under the license declared by the project. ChatGPT and related names, trademarks, logos, website content, and services are not covered by that license.

## 简体中文

一个面向 Linux 的非官方 ChatGPT 桌面封装。

本项目使用 [Tauri](https://tauri.app/) 将 ChatGPT 官方 Web 页面（[https://chatgpt.com/](https://chatgpt.com/)）封装为桌面应用，主要用于个人 Linux 桌面环境，并方便制作和维护 AUR 软件包。

## 说明

本项目：

- 不提供 ChatGPT 的 AI/服务；
- 不修改或重新实现其核心功能；
- 不包含其服务端代码；
- 直接加载官方 Web 页面（https://chatgpt.com/）；
- 仅提供桌面窗口、Linux 适配及相关打包配置。

## 功能

- Tauri 原生桌面窗口（轻量，~5MB，系统 WebKitGTK 渲染）
- 直接访问 https://chatgpt.com/
- Linux / WebKitGTK 中文字体显示优化
- Wayland 兼容处理
- 适合 Arch Linux / AUR 打包使用

## 构建

```bash
# 需要: rust, cargo-tauri, webkit2gtk-4.1 等
cargo tauri build --bundles deb
```

## 打包发布

```bash
./release.sh <github-user> <github-repo>
```

## Arch Linux

安装:

```bash
yay -S chatgpt-webapp-desktop-bin
```

## Disclaimer

**本项目为非官方第三方项目，与 ChatGPT 及其所属公司不存在官方合作、授权、认可或隶属关系。**

相关名称、商标、Logo、网站内容、界面、AI 服务及其他相关资源的知识产权归其各自权利人所有。

本仓库仅包含第三方桌面封装、Linux 适配及打包相关代码。

本项目不会对官方网页、服务或内容进行重新分发，使用过程中实际加载的内容来自官方服务（https://chatgpt.com/）。

如果相关权利人认为本项目存在不适当使用，请通过 GitHub Issue 联系，我会及时处理。

## License

本仓库中由项目维护者原创的桌面封装及相关代码，可按照本仓库所声明的开源许可证使用。

相关商标、Logo、网页内容及服务不属于本项目开源许可证的授权范围。
