#!/bin/bash

# src: /scripts/install-doc-tools.sh
# @(#) : Document linting and writing tools installation script
#
# Copyright (c) 2025 Furukawa Atsushi <atsushifx@gmail.com>
# Released under the MIT License.
# https://opensource.org/licenses/MIT
#
# @file install-doc-tools.sh
# @brief Install documentation and writing tools with configuration
# @description
#   Installs comprehensive documentation linting and writing support tools for Japanese and English.
#   Includes textlint with language-specific rules, markdownlint, and spell checker with configuration.
#
#   **Installed tools:**
#   - textlint: Japanese/English writing rule checker
#   - markdownlint-cli2: Markdown linting
#   - cspell: Spell checker for code and documentation
#
#   **Configuration:**
#   - Copies .textlintrc.yaml, .markdownlint.yaml, .textlint/, and .vscode/ from templates
#
# @param --global (optional) Install packages globally instead of locally
# @param TEMPLATE_DIR Template directory path (default: "./templates")
# @param DESTINATION_DIR Destination root directory (default: ".")
#
# @example
#   ./install-doc-tools.sh
#   # Installs tools locally with default template directory
#
#   ./install-doc-tools.sh --global
#   # Installs tools globally
#
#   ./install-doc-tools.sh --global ./custom-templates .
#   # Installs globally from custom template location
#
# @exitcode 0 Success
# @exitcode 1 Error during installation
#
# @author atsushifx
# @version 1.4.2
# @license MIT

set -euo pipefail

# ============================================================================
# Parameters
# ============================================================================

OPT_GLOBAL_INSTALL=false

# Parse options
while [[ $# -gt 0 ]]; do
  case "$1" in
    --global)
      OPT_GLOBAL_INSTALL=true
      shift
      ;;
    *)
      break
      ;;
  esac
done

TEMPLATE_DIR="${1:-.\/templates}"
DESTINATION_DIR="${2:-.}"

# ============================================================================
# Configuration
# ============================================================================

# Array of linter packages to install
# Includes:
# - Core textlint engine and rules
# - Japanese technical writing rules
# - AI writing enhancement rules
# - Spell checking and proofreading rules
# - Markdown linting
# - Spell checking tools
declare -a LINTER_PACKAGES=(
    # Core textlint engine and utilities
    "textlint"
    "textlint-filter-rule-allowlist"
    "textlint-filter-rule-comments"

    # Japanese technical writing rules
    "textlint-rule-preset-ja-technical-writing"
    "textlint-rule-preset-ja-spacing"
    "@textlint-ja/textlint-rule-preset-ai-writing"
    "textlint-rule-ja-no-orthographic-variants"
    "@textlint-ja/textlint-rule-no-synonyms"
    "sudachi-synonyms-dictionary"
    "@textlint-ja/textlint-rule-morpheme-match"
    "textlint-rule-ja-hiraku"
    "textlint-rule-no-mixed-zenkaku-and-hankaku-alphabet"

    # Common misspelling and proofreading
    "textlint-rule-common-misspellings"
    "@proofdict/textlint-rule-proofdict"
    "textlint-rule-prh"

    # Markdown linting
    "markdownlint-cli2"

    # Spell checking
    "cspell"
)

# Configuration files to copy from template
# Copies the following:
# - .textlintrc.yaml: textlint configuration
# - .textlint/: textlint custom rules and dictionaries directory
# - .markdownlint.yaml: markdown linting rules
# - .vscode/: VSCode extensions and settings
declare -a CONFIG_FILES_TO_COPY=(
    # textlint settings and rules
    ".textlintrc.yaml"
    ".textlint"

    # markdownlint
    ".markdownlint.yaml"

    # VSCode settings and extensions (special case: copies to root .vscode)
    ".vscode"
)

# ============================================================================
# Functions
# ============================================================================

##
# @description Copy linter configuration files from template to destination
# @details
#   **Behavior:**
#   - Creates configs directory if it doesn't exist
#   - Copies specified files/directories from template
#   - .vscode is special-cased to copy to root instead of configs/
#   - Skips already existing files
#   - Validates source files exist before copying
#
# @param $1 Item to copy (file or directory name)
# @param $2 Source template directory path
# @param $3 Target root directory path
#
# @return 0 Success
copy_linter_configs() {
    local item="$1"
    local template_dir="$2"
    local destination_dir="$3"

    # Create configs directory if needed
    local config_path="${destination_dir}/configs"
    if [[ ! -d "$config_path" ]]; then
        mkdir -p "$config_path"
        echo "[Created] Configs directory: $config_path"
    fi

    local src="${template_dir}/${item}"

    # Special handling for .vscode: copy to root instead of configs/
    local dst_base
    if [[ "$item" == ".vscode" ]]; then
        dst_base="$destination_dir"
    else
        dst_base="$config_path"
    fi

    local dst="${dst_base}/${item}"

    if [[ -e "$src" ]]; then
        if [[ ! -e "$dst" ]]; then
            if [[ -d "$src" ]]; then
                echo "[Copy] Copying directory: $item -> $dst"
                cp -r "$src" "$dst"
                echo "[OK] Directory copied: $item"
            else
                echo "[Copy] Copying file: $item -> $dst"
                cp "$src" "$dst"
                echo "[OK] File copied: $item"
            fi
        else
            echo "[Skip] Skipped (exists): $item"
        fi
    else
        echo "[Error] Not found in templates: $item" >&2
    fi
}

##
# @description Install packages via pnpm
# @details
#   Installs all provided packages using pnpm.
#   Uses global installation if OPT_GLOBAL_INSTALL flag is set, otherwise local installation.
#
# @param ... Package names to install
#
# @return 0 Success
install_pnpm_packages() {
    local -a packages=()

    # Filter out empty strings and comments
    for pkg in "$@"; do
        if [[ -n "$pkg" && ! "$pkg" =~ ^#.*$ ]]; then
            packages+=("$pkg")
        fi
    done

    if [[ ${#packages[@]} -eq 0 ]]; then
        echo "⚠️  No valid packages to install."
        return 0
    fi

    local cmd
    if [[ "$OPT_GLOBAL_INSTALL" == "true" ]]; then
        cmd="pnpm add --global ${packages[*]}"
    else
        cmd="pnpm add ${packages[*]}"
    fi
    echo "📦 Installing via pnpm: $cmd"
    eval "$cmd"
    echo "✅ pnpm packages installed."
}

##
# @description Main installation routine for writing environment setup
# @details
#   **Execution flow:**
#   1. Install linter packages via pnpm
#   2. Validate template directory exists
#   3. Copy configuration files to destination
#   4. Report completion
#
function install_writing_environment() {
    echo "[Installing] writer tooling..."

    # Install all writing tools via pnpm
    echo "Installing linter packages..."
    install_pnpm_packages "${LINTER_PACKAGES[@]}"

    # Copy configuration files if template exists
    if [[ -d "$TEMPLATE_DIR" ]]; then
        echo "Copying configuration files..."
        for config_file in "${CONFIG_FILES_TO_COPY[@]}"; do
            copy_linter_configs "$config_file" "$TEMPLATE_DIR" "$DESTINATION_DIR"
        done
    else
        echo "⚠️  Template directory not found: $TEMPLATE_DIR. Skipping config copy." >&2
    fi

    echo "[OK] Writer environment setup completed."
}

# ============================================================================
# Main Execution
# ============================================================================

install_writing_environment
