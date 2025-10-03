# 👀 peek - Smart File Previewer

A modern, colorful terminal tool for Linux that displays files and directories much nicer than ls!

![peek demo](screenshots/demo1.png)
![peek grid view](screenshots/demo2.png)
![peek preview](screenshots/demo3.png)

## ✨ Features

- 🎨 **Colorful Grid Layout** - Files displayed neatly in columns
- 📁 **Smart Icons** - Automatic icons based on file type
- 📊 **Flexible Sorting** - By name, size, or date
- ⭐ **Favorites** - Save frequently visited directories
- 📈 **Statistics** - Shows file count, folders, and total size
- 🎯 **File Preview** - Display file contents with syntax highlighting
- 🌈 **Color Coding** - Different colors for different file types

## 📸 Screenshots

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📁 Documents (15 items)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📝 notes.txt     2.3K   📘 report.docx   45K    🐍 script.py    1.2K
📁 Projects      4.0K   🖼️  photo.jpg     1.2M   📦 archive.zip  890K
🎬 video.mp4     120M   📕 manual.pdf    3.4M   ⚙️  install.sh   456
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## 🚀 Installation

### Quick Installation

```bash
# Download script
curl -o peek https://raw.githubusercontent.com/reakkkk/peek-a-ls-replacer/main/peek

# Make executable and install
chmod +x peek
sudo mv peek /usr/local/bin/

# Done! Test it:
peek
```

### Manual Installation

```bash
# 1. Create file
sudo nano /usr/local/bin/peek

# 2. Paste script content (see peek script)

# 3. Make executable
sudo chmod +x /usr/local/bin/peek
```

## 📖 Usage

### Basic Commands

```bash
# Show current directory
peek

# Show specific directory
peek /home/user/Documents

# File preview
peek script.py

# With more lines
peek file.txt -l 50
```

### Sorting

```bash
# Sort by size
peek -s size

# Sort by date
peek -s date

# Reverse sorting
peek -r

# Combined: Largest files first
peek -s size -r
```

### Favorites

```bash
# Save favorite
peek /home/user/projects -f

# Show all favorites
peek -F

# Delete favorite (e.g. #2)
peek -d 2

# Open favorite directly
peek /saved/path
```

### Statistics

```bash
# Show directory statistics
peek --stats

# Combined with view
peek ~/Downloads --stats
```

## 🎨 Icon Legend

| Icon | File Type | Icon | File Type |
|------|-----------|------|-----------|
| 📁 | Directory | 📄 | Regular File |
| 🐍 | Python | ☕ | Java |
| 📦 | JavaScript/TypeScript | 🦀 | Rust |
| 🐹 | Go | ⚡ | C/C++ |
| 📜 | Shell Script | 📝 | Text/Markdown |
| 🖼️ | Image | 🎬 | Video |
| 🎵 | Audio | 📕 | PDF |
| 📘 | Word | 📗 | Excel |
| 🔗 | Symlink | ⚙️ | Executable |

## 🎯 Options

| Option | Description |
|--------|-------------|
| `-l, --lines N` | Show N lines for file preview (default: 20) |
| `-s, --sort MODE` | Sort by: name, size, date (default: name) |
| `-r, --reverse` | Reverse sort order |
| `-f, --fav` | Save as favorite |
| `-F, --favorites` | List all favorites |
| `-d, --delfav N` | Delete favorite #N |
| `--stats` | Show directory statistics |
| `-h, --help` | Show help |

## 🔧 System Requirements

- Linux (tested on Zorin OS, Ubuntu, Debian)
- Bash 4.0 or higher
- Standard Unix tools: `ls`, `stat`, `du`, `file`, `tput`

## 💡 Tips & Tricks

### Create Aliases

```bash
# In ~/.bashrc or ~/.zshrc
alias p='peek'
alias ps='peek --stats'
alias pf='peek -F'
```

### Replace ls

```bash
alias ls='peek'
```

### Combine with Other Tools

```bash
# With find
find . -name "*.py" -exec peek {} \;

# With fzf for interactive selection
peek $(find . -type d | fzf)
```

## 🤝 Contributing

Contributions are welcome!

1. Fork the repository
2. Create a Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 Changelog

### Version 2.0
- ✨ Grid layout for horizontal display
- 📊 Sorting by size and date
- 📈 Statistics feature
- 🎨 More icons for different file types
- 🐛 Bugfixes and performance improvements

### Version 1.1
- ⭐ Added favorites system
- 📋 List and manage saved paths

### Version 1.0
- 🎉 Initial release
- 📁 Directory view with icons
- 📄 File preview with syntax highlighting

## 📄 License

MIT License - see [LICENSE](LICENSE) for details

## 🙏 Acknowledgments

- Inspired by [exa](https://github.com/ogham/exa), [lsd](https://github.com/lsd-rs/lsd), and [colorls](https://github.com/athityakumar/colorls)
- Icons based on Unicode emoji

## 📮 Contact

- **GitHub**: [@reakkkk](https://github.com/reakkkk)
- **Issues**: [GitHub Issues](https://github.com/reakkkk/peek-a-ls-replacer/issues)

---

⭐ If you like peek, give the repo a star!

Made with ❤️ for the terminal community
