# Release Notes

## Version 2.0.0 - Python Implementation (2025-12-01)

### 🎉 Major Release: Python Implementation Added

This release adds a complete Python implementation of AutoSkipInbox alongside the existing Ruby codebase. The project has been reorganized for better maintainability and both implementations can coexist independently.

### 🐍 New Features

#### Python Implementation
- **Complete Python port** of all 8 Ruby scripts:
  - `authorize.py` - OAuth2 authorization for Gmail API
  - `labels.py` - Label mapping helper functions
  - `filters.py` - Filter mapping helper functions
  - `autoskipinbox.py` - Main inbox processing script
  - `get_filters.py` - List all Gmail filters
  - `get_label_report.py` - Generate label statistics report
  - `get_todump_from.py` - Process emails marked for dumping
  - `get_tofix_from.py` - Process emails marked for review
- **Modern Python stack**: Uses `google-api-python-client` library
- **Token format**: Changed from `token.yaml` to `token.json`

#### Project Organization
- **New directory structure**:
  - `python/` - All Python scripts, configuration, Makefile, and documentation
  - `ruby/` - All Ruby scripts, configuration, Makefile, install.sh, and documentation
- **Improved maintainability**: Clear separation between implementations
- **Ruby reorganization**: All Ruby files moved to `ruby/` directory with updated paths
  - Ruby scripts now use `../config/` and `../log/` paths
  - Ruby Makefile, install.sh, and wrapper scripts moved to `ruby/`

#### Security Enhancements
- **Secure credential storage**: Credentials moved from `config/` to `~/.secure/AutoSkipInbox/`
- **Credential validation**: Makefile checks for credentials before running scripts
- **Better security practices**: Credentials stored outside project directory

#### Developer Experience
- **Python Makefile**: Comprehensive build and run targets
  - pyenv support for Python version management
  - Virtual environment management
  - Credential validation
  - Individual script targets
- **Setup automation**: `make setup` installs pyenv, Python, and dependencies
- **Documentation**: Comprehensive README with setup instructions

### 📦 Installation

#### For Python Users (New)
```bash
cd python
make setup                    # Install pyenv, Python, and dependencies
# Download client_secret.json to ~/.secure/AutoSkipInbox/
make run                      # Run the main script
```

#### For Ruby Users (Existing)
- Ruby scripts continue to work from `ruby/` directory
- No changes required to existing workflows
- All Ruby functionality preserved

### 🔧 Configuration Changes

#### Credential Location
- **Old**: `config/client_secret.json` and `config/token.yaml`
- **New (Python)**: `~/.secure/AutoSkipInbox/client_secret.json` and `~/.secure/AutoSkipInbox/token.json`
- **Ruby**: Still uses `config/` directory (backward compatible)

### 📚 Documentation

- Added `python/README.md` with complete setup guide
- Added `ruby/README.md` with Ruby-specific installation and usage instructions
- Added `RELEASE_NOTES.md` with comprehensive release information
- Updated main `README.md` with overview, release notes section, and links to detailed docs
- Fixed all documentation to accurately match codebase:
  - Corrected Python version requirements (3.11+)
  - Fixed run-it.sh descriptions to list all 4 scripts it calls
  - Updated all path references for new directory structure
- Fixed all code comments to accurately reflect script functionality:
  - Updated header comments in all scripts
  - Fixed incomplete comments
  - Improved descriptions of script operations
- Updated troubleshooting section
- Added migration notes
- Included examples for all scripts

### 🛠️ Build & Dependencies

#### Python Requirements
- Python 3.11+ (specified in `.python-version`)
- Dependencies listed in `requirements.txt`:
  - `google-auth>=2.0.0`
  - `google-auth-oauthlib>=0.5.0`
  - `google-auth-httplib2>=0.1.0`
  - `google-api-python-client>=2.0.0`

#### Ruby Requirements
- No changes to Ruby dependencies
- Still requires `google-api-client ~> 0.8`

### 🔄 Migration Guide

#### From Ruby to Python
1. Install Python dependencies: `cd python && make setup`
2. Move credentials: Copy `config/client_secret.json` to `~/.secure/AutoSkipInbox/client_secret.json`
3. Run authorization: First run will prompt for OAuth
4. Update cron jobs: Change paths from `ruby/run-it.sh` to `python/run-it.sh`

#### Staying with Ruby
- No action required
- All Ruby scripts work from `ruby/` directory
- Existing cron jobs continue to work

### 📝 Files Added

#### Python Implementation
- `python/authorize.py` - OAuth2 authorization
- `python/labels.py` - Label mapping helper
- `python/filters.py` - Filter mapping helper
- `python/autoskipinbox.py` - Main inbox processing script
- `python/get_filters.py` - List all Gmail filters
- `python/get_label_report.py` - Generate label statistics report
- `python/get_todump_from.py` - Process todump emails and create filters
- `python/get_tofix_from.py` - Process tofix emails and create filters
- `python/run-it.sh` - Wrapper script that calls all Python scripts
- `python/get-label-report.sh` - Wrapper script for label report generation
- `python/Makefile` - Build and run targets with pyenv support
- `python/README.md` - Complete setup and usage guide
- `python/requirements.txt` - Python dependencies
- `python/.python-version` - Python version specification (3.11)

#### Project Organization
- All Ruby files moved to `ruby/` directory:
  - `ruby/run-it.sh` - Wrapper script that calls all Ruby scripts
  - `ruby/get-label-report.sh` - Wrapper script for label report generation
  - `ruby/Makefile` - Ruby build and run configuration
  - `ruby/install.sh` - Ruby installation script
  - `ruby/README.md` - Ruby-specific documentation
- Updated `.gitignore` for Python files (__pycache__, venv, etc.)
- Updated all path references throughout codebase

### 🐛 Bug Fixes
- Improved error handling in credential validation
- Better path resolution for cross-platform compatibility
- Fixed all code comments to accurately describe script functionality
- Fixed documentation discrepancies (Python version, script descriptions, etc.)

### ⚠️ Breaking Changes
- **None for Ruby users**: All Ruby functionality preserved
- **Python users**: New credential location required (`~/.secure/AutoSkipInbox/`)

### 🔮 Future Enhancements
- Potential deprecation of Ruby implementation (future release)
- Additional Python features and optimizations
- Enhanced error reporting and logging

### 🙏 Acknowledgments
- Conversion from Ruby to Python
- Improved project organization
- Enhanced security practices

---

## Previous Releases

### Version 1.0.0 - Initial Ruby Release
- Original Ruby implementation
- Gmail API integration
- Basic inbox automation
- Filter management
