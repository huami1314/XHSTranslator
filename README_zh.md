# XHSTranslator

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

一个用于在小红书应用中自动将英文内容翻译成中文的插件。

[English](README.md)

## 功能特点

- 自动检测并将英文翻译成中文
- 保留原文格式和特殊字符
- 智能处理中英混合内容
- 同时显示原文和翻译
- 使用谷歌翻译API进行实时翻译

## 系统要求

- iOS 5.0 或更高版本
- 已安装小红书应用
- 已越狱设备并安装 MobileSubstrate

## 安装方法

1. 在包管理器中添加软件源
2. 搜索 "XHSTranslator"
3. 安装插件
4. 重启设备插件生效

## 使用说明

安装完成后，插件会在小红书应用中自动工作：

- 查看包含英文的评论时，你会同时看到原文和中文翻译
- 显示格式：
  ```
  原文：[原始文本]
  翻译：[翻译文本]
  ```
- 特殊字符和表情符号会保持在原始位置

## 从源码构建

1. 确保已安装 Theos
2. 克隆仓库：
   ```bash
   git clone https://github.com/huami1314/xhstranslator.git
   ```
3. 构建软件包：
   ```bash
   make package
   ```

## 参与贡献

欢迎提交 Pull Request 来帮助改进这个项目！

## 开源协议

本项目采用 MIT 协议开源 - 查看 [LICENSE](https://github.com/huami1314/XHSTranslator?tab=MIT-1-ov-file) 文件了解详情。

## 作者

- huami
- 主页：https://github.com/huami1314/xhstranslator

## 致谢

- 感谢 Theos 团队提供的开发框架
- 感谢 Google Translate 提供的翻译服务 