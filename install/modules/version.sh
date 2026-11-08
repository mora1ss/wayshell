#!/usr/bin/env bash

MODULE_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
if [ -z "$WAYSHELL_DIR" ]; then
    if [ -d "$(dirname "$(dirname "$MODULE_DIR")")/src" ]; then
        export WAYSHELL_DIR="$(dirname "$(dirname "$MODULE_DIR")")/src"
    fi
fi

if [ -n "$WAYSHELL_DIR" ] && [ -f "$WAYSHELL_DIR/scripts/caching.sh" ]; then
    source "$WAYSHELL_DIR/scripts/caching.sh"
fi

STATE_DIR="${QS_STATE_DIR:-${XDG_STATE_HOME:-$HOME/.local/state}/wayshell}"
VERSION_FILE="$STATE_DIR/version"
DEFAULT_FALLBACK_VERSION="2.0.0"

format_uuid() {
    local raw
    raw=$(echo "$1" | tr -d '-' | tr '[:upper:]' '[:lower:]' | tr -cd '0-9a-f')
    if [[ ${#raw} -eq 32 ]]; then
        echo "$raw" | sed -E 's/(.{8})(.{4})(.{4})(.{4})(.{12})/\1-\2-\3-\4-\5/'
    else
        echo "$1"
    fi
}

get_telemetry_id() {
    if [ -f "$VERSION_FILE" ]; then
        local id
        id=$(awk -F= '/^TELEMETRY_ID=/{gsub(/"/, "", $2); print $2}' "$VERSION_FILE")
        if [ -n "$id" ]; then
            format_uuid "$id"
            return
        fi
    fi

    local raw_id=""
    if command -v uuidgen &> /dev/null; then
        raw_id=$(uuidgen)
    elif [ -f /proc/sys/kernel/random/uuid ]; then
        raw_id=$(cat /proc/sys/kernel/random/uuid 2>/dev/null)
    elif [ -f /etc/machine-id ]; then
        raw_id=$(cat /etc/machine-id 2>/dev/null)
    else
        raw_id=$(head -c 16 /dev/urandom | od -An -t x1 | tr -d ' \n')
    fi

    format_uuid "$raw_id"
}

get_telemetry_enabled() {
    echo "false"
}

get_saved_preference() {
    local key="$1"
    local fallback="$2"
    local value=""
    if [ -f "$VERSION_FILE" ]; then
        value=$(awk -F= -v k="$key" '$1 == k {gsub(/"/, "", $2); print $2}' "$VERSION_FILE")
    fi
    case "$value" in
        true|false) echo "$value" ;;
        *) echo "$fallback" ;;
    esac
}

get_installed_version() {
    local ver=""
    if [ -f "$VERSION_FILE" ]; then
        ver=$(awk -F= '/^WAYSHELL_VERSION=/{gsub(/"/, "", $2); print $2}' "$VERSION_FILE")
    fi
    if [ -z "$ver" ] && [ -n "$WAYSHELL_VERSION" ]; then
        ver="$WAYSHELL_VERSION"
    fi
    if [ -z "$ver" ]; then
        if [ -n "$WAYSHELL_DIR" ] && [ -f "$WAYSHELL_DIR/version.txt" ]; then
            ver=$(cat "$WAYSHELL_DIR/version.txt" 2>/dev/null | xargs)
        elif [ -n "$WAYSHELL_DIR" ] && [ -f "$(dirname "$WAYSHELL_DIR")/version.txt" ]; then
            ver=$(cat "$(dirname "$WAYSHELL_DIR")/version.txt" 2>/dev/null | xargs)
        elif [ -n "$REPO_ROOT" ] && [ -f "$REPO_ROOT/version.txt" ]; then
            ver=$(cat "$REPO_ROOT/version.txt" 2>/dev/null | xargs)
        fi
    fi
    if [ -z "$ver" ]; then
        ver="$DEFAULT_FALLBACK_VERSION"
    fi
    echo "$ver"
}

get_installed_commit() {
    if [ -f "$VERSION_FILE" ]; then
        awk -F= '/^WAYSHELL_COMMIT=/{gsub(/"/, "", $2); print $2}' "$VERSION_FILE"
    fi
}

get_target_version() {
    local repo_root="$1"
    local repo_slug="${2:-"${REPO_SLUG:-"mora1ss/wayshell"}"}"
    local target_ver=""

    if [ -f "$repo_root/version.txt" ]; then
        target_ver=$(cat "$repo_root/version.txt" 2>/dev/null | xargs)
    fi

    if [[ -z "$target_ver" || "$target_ver" == "null" ]]; then
        if command -v curl &>/dev/null; then
            target_ver=$(curl -s "https://raw.githubusercontent.com/${repo_slug}/HEAD/version.txt" 2>/dev/null | xargs)
        fi
    fi

    if [[ -z "$target_ver" || "$target_ver" == "null" ]]; then
        target_ver="$DEFAULT_FALLBACK_VERSION"
    fi

    echo "$target_ver"
}

get_target_commit() {
    local repo_root="$1"
    local repo_slug="${2:-"${REPO_SLUG:-"mora1ss/wayshell"}"}"
    local target_commit=""

    if [ -d "$repo_root/.git" ] && command -v git &>/dev/null; then
        target_commit=$(git -C "$repo_root" rev-parse --short HEAD 2>/dev/null || true)
    fi

    if [[ -z "$target_commit" || "$target_commit" == "null" ]]; then
        if command -v curl &>/dev/null && command -v jq &>/dev/null; then
            target_commit=$(curl -s "https://api.github.com/repos/${repo_slug}/commits/HEAD" 2>/dev/null | jq -r '.sha[:7] // empty')
        fi
    fi

    if [[ -z "$target_commit" || "$target_commit" == "null" ]]; then
        target_commit="unknown"
    fi

    echo "$target_commit"
}

write_version_state() {
    local version="${1:-"$DEFAULT_FALLBACK_VERSION"}"
    local commit="${2:-"unknown"}"
    local tel_id="$3"
    local tel_enabled="false"
    local compositors="$5"
    local opt_sddm="${6:-true}"
    local sddm_wayland="${7:-false}"
    local full_wallpapers="${8:-true}"

    if [[ -z "$commit" || "$commit" == "null" ]]; then
        commit="unknown"
    fi

    if [[ -z "$tel_id" ]]; then
        tel_id=$(get_telemetry_id)
    else
        tel_id=$(format_uuid "$tel_id")
    fi

    mkdir -p "$STATE_DIR"
    local tmp_file="${VERSION_FILE}.tmp.$$"
    cat <<EOF > "$tmp_file"
WAYSHELL_VERSION="$version"
WAYSHELL_COMMIT="$commit"
TELEMETRY_ID="$tel_id"
ENABLE_TELEMETRY="$tel_enabled"
SELECTED_COMPOSITORS="$compositors"
OPT_SDDM="$opt_sddm"
SDDM_WAYLAND="$sddm_wayland"
INSTALL_FULL_WALLPAPERS="$full_wallpapers"
EOF
    mv -f "$tmp_file" "$VERSION_FILE"
}
