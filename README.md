👀 peek - Smart File Previewer

A modern, colorful terminal tool for Linux that displays files and directories much more beautifully than ls!






✨ Features

🎨 Colorful grid layout – neatly displays files in columns

📁 Smart icons – automatic icons based on file type

📊 Flexible sorting – by name, size, or date

⭐ Favorites – save frequently visited directories

📈 Statistics – shows file count, folder count, and total size

🎯 File preview – preview file contents with syntax highlighting

🌈 Color coding – different colors for different file types

📸 Screenshots
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📁 Documents (15 items)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📝 notes.txt     2.3K   📘 report.docx   45K    🐍 script.py    1.2K
📁 Projects      4.0K   🖼️  photo.jpg     1.2M   📦 archive.zip  890K
🎬 video.mp4     120M   📕 manual.pdf    3.4M   ⚙️  install.sh   456
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🚀 Installation
Quick install
# Download script
curl -o peek https://raw.githubusercontent.com/YOUR-USERNAME/peek/main/peek

# Make executable and install
chmod +x peek
sudo mv peek /usr/local/bin/

# Done! Test it:
peek

Manual installation
# 1. Create file
sudo nano /usr/local/bin/peek

# 2. Paste script content (see peek script)

# 3. Make it executable
sudo chmod +x /usr/local/bin/peek

📖 Usage
Basic commands
# Show current directory
peek

# Specific directory
peek /home/user/Documents

# File preview
peek script.py

# With more lines
peek file.txt -l 50

Sorting
# Sort by size
peek -s size

# Sort by date
peek -s date

# Reverse order
peek -r

# Combined: largest files first
peek -s size -r

Favorites
# Save as favorite
peek /home/user/projects -f

# List all favorites
peek -F

# Delete favorite (e.g. #2)
peek -d 2

# Open favorite directly
peek /saved/path

Statistics
# Show directory statistics
peek --stats

# Combine with view
peek ~/Downloads --stats

🎨 Icon legend
Icon	File type	Icon	File type
📁	Directory	📄	Regular file
🐍	Python	☕	Java
📦	JavaScript/TypeScript	🦀	Rust
🐹	Go	⚡	C/C++
📜	Shell Script	📝	Text/Markdown
🖼️	Image	🎬	Video
🎵	Audio	📕	PDF
📘	Word	📗	Excel
🔗	Symlink	⚙️	Executable
🎯 Options
Option	Description
-l, --lines N	Show N lines in file preview (default: 20)
-s, --sort MODE	Sort by: name, size, date (default: name)
-r, --reverse	Reverse sorting order
-f, --fav	Save as favorite
-F, --favorites	List all favorites
-d, --delfav N	Delete favorite #N
--stats	Show directory statistics
-h, --help	Show help
🔧 Requirements

Linux (tested on Zorin OS, Ubuntu, Debian)

Bash 4.0 or higher

Standard Unix tools: ls, stat, du, file, tput

💡 Tips & Tricks
Create aliases
# In ~/.bashrc or ~/.zshrc
alias p='peek'
alias ps='peek --stats'
alias pf='peek -F'

Use as ls replacement
alias ls='peek'

Combine with other tools
# With find
find . -name "*.py" -exec peek {} \;

# With fzf for interactive selection
peek $(find . -type d | fzf)

🤝 Contributing

Contributions are welcome!

Fork the repository

Create a feature branch (git checkout -b feature/AmazingFeature)

Commit your changes (git commit -m 'Add some AmazingFeature')

Push to the branch (git push origin feature/AmazingFeature)

Open a Pull Request

📝 Changelog
Version 2.0

✨ Grid layout for horizontal view

📊 Sorting by size and date

📈 Statistics feature

🎨 More icons for various file types

🐛 Bug fixes and performance improvements

Version 1.1

⭐ Added favorites system

📋 List and manage saved paths

Version 1.0

🎉 First release

📁 Directory view with icons

📄 File preview with syntax highlighting

📄 License

MIT License – see LICENSE
 for details

🙏 Acknowledgments

Inspired by exa, lsd, and colorls

Icons based on Unicode emoji

📮 Contact

GitHub: @YOUR-USERNAME

Issues: GitHub Issues
