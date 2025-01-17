# XHSTranslator

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A tweak for automatically translating English content to Chinese in XiaoHongShu (小红书/RED) app.

[中文文档](README_zh.md)

## Features

- Automatically detects and translates English text to Chinese
- Preserves original text format and special characters
- Handles mixed Chinese-English content intelligently
- Shows both original and translated text
- Real-time translation using Google Translate API

## Requirements

- iOS 5.0 or later
- XiaoHongShu (小红书/RED) app installed
- Jailbroken device with MobileSubstrate

## Installation

1. Add the repository to your package manager
2. Search for "XHSTranslator"
3. Install the package
4. Respring your device

## Usage

After installation, the tweak will automatically work in XiaoHongShu app:

- When viewing comments containing English text, you'll see both the original text and its Chinese translation
- Format: 
  ```
  原文：[Original Text]
  翻译：[Translated Text]
  ```
- Special characters and emojis are preserved in their original positions

## Building from Source

1. Make sure you have Theos installed
2. Clone the repository:
   ```bash
   git clone https://github.com/huami1314/xhstranslator.git
   ```
3. Build the package:
   ```bash
   make package
   ```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/huami1314/XHSTranslator?tab=MIT-1-ov-file) file for details.

## Author

- huami
- Homepage: https://github.com/huami1314/xhstranslator

## Acknowledgments

- Thanks to the Theos team for the development framework
- Thanks to Google Translate for the translation service 