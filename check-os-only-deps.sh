#!/bin/bash
# Fail if any Mach-O executable under the given paths has a load-time
# dependency that is not an OS-installed library (/usr/lib with a stub in the
# macOS SDK, or /System/Library). @rpath dependencies are accepted only if one
# of the binary's LC_RPATHs resolves them to an OS library. All architecture
# slices of universal binaries are checked.
#
# Usage: check-os-only-deps.sh PATH...   (files, or directories searched recursively)
# Env:   CHECK_DYLIBS=1   also report dylibs/bundles (fail on them too if STRICT_DYLIBS=1)
#        STRICT_RPATHS=1  fail (instead of warn) on absolute LC_RPATHs outside the OS
#        ALLOW_REGEX=ERE  extra dependency install names to accept
#        SKIP_REGEX=ERE   file paths to skip (e.g. tools that are dynamic by design)
set -u
SDK=${SDKROOT:-$(xcrun --sdk macosx --show-sdk-path)}
fail=0

is_os_lib() {
  case "$1" in
    /System/Library/*) return 0 ;;
    /usr/lib/*) [[ -e "$SDK${1%.dylib}.tbd" ]] ;;
    *) return 1 ;;
  esac
}

check_file() {
  local f=$1 kind=$2 id d r ok bad=() warn=() rpaths deps
  id=$(otool -D "$f" 2>/dev/null | sed -n 2p)
  rpaths=($(otool -arch all -l "$f" 2>/dev/null | awk '/cmd LC_RPATH/{getline; getline; print $2}' | sort -u))
  deps=($(otool -arch all -L "$f" 2>/dev/null | grep -v ':$' | awk '{print $1}' | sort -u))
  for d in "${deps[@]}"; do
    [[ -n "$id" && "$d" == "$id" ]] && continue
    [[ -n "${ALLOW_REGEX:-}" && "$d" =~ ${ALLOW_REGEX} ]] && continue
    ok=1
    if [[ "$d" == @rpath/* ]]; then
      for r in "${rpaths[@]:-}"; do is_os_lib "$r/${d#@rpath/}" && { ok=0; break; }; done
    else
      is_os_lib "$d" && ok=0
    fi
    ((ok)) && bad+=("$d")
  done
  for r in "${rpaths[@]:-}"; do
    if [[ "$r" == /* && "$r" != /usr/lib/* && "$r" != /System/Library/* ]]; then
      if [[ ${STRICT_RPATHS:-0} == 1 ]]; then bad+=("LC_RPATH $r"); else warn+=("LC_RPATH $r"); fi
    fi
  done
  if ((${#bad[@]})); then
    if [[ $kind == exe || ${STRICT_DYLIBS:-0} == 1 ]]; then echo "FAIL $f"; fail=1; else echo "INFO $f"; fi
    printf '       %s\n' "${bad[@]}"
  fi
  if ((${#warn[@]})); then
    echo "WARN $f (unused build-machine rpaths can be removed with install_name_tool -delete_rpath)"
    printf '       %s\n' "${warn[@]}"
  fi
}

for root in "$@"; do
  while IFS= read -r -d '' f; do
    [[ -n "${SKIP_REGEX:-}" && "$f" =~ ${SKIP_REGEX} ]] && continue
    case "$(file -b "$f")" in
      *Mach-O*executable*) check_file "$f" exe ;;
      *Mach-O*shared\ library*|*Mach-O*bundle*) [[ ${CHECK_DYLIBS:-0} == 1 ]] && check_file "$f" lib ;;
    esac
  done < <(find -H "$root" -type f -print0)
done
((fail)) && { echo "Non-OS load-time dependencies found."; exit 1; }
echo "OK: checked executables depend only on OS libraries."
