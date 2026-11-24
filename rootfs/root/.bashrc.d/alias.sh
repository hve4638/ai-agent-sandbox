alias claude="claude --dangerously-skip-permissions"
alias copilot="copilot --allow-all-tools"
alias codex="codex --yolo"
alias gemini="gemini --yolo"

alias pg='cd /workspace'

export LC_ALL=ko_KR.UTF-8
export LANG=ko_KR.UTF-8
export IS_SANDBOX=1

tarzip() {
  if [ "$#" -ne 1 ]; then
    echo "usage: tarzip <directory>"
    return 1
  fi

  local input="$1"
  local path="$input"

  # trailing slash 제거 (/ 하나만 남는 경우는 제외)
  while [ "$path" != "/" ] && [ "${path%/}" != "$path" ]; do
    path="${path%/}"
  done

  # 루트 디렉토리 금지
  if [ "$path" = "/" ]; then
    echo "error: root directory '/' is not allowed"
    return 1
  fi

  # 디렉토리만 허용
  if [ ! -d "$path" ]; then
    echo "error: '$input' is not a directory"
    return 1
  fi

  local base parent out
  base="$(basename "$path")"
  parent="$(dirname "$path")"
  out="${base}.tar.gz"

  # 출력 파일이 이미 있으면 실패
  if [ -e "$out" ]; then
    echo "error: output file '$out' already exists"
    return 1
  fi

  tar -czvf "$out" -C "$parent" "$base"
}
