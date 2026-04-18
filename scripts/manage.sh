#!/usr/bin/env bash
# ================================================================
#   Diễn Đàn Sinh Viên — Script Quản Lý
#   Usage: ./scripts/manage.sh <lệnh>
# ================================================================
set -euo pipefail

COMPOSE="docker compose"
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="$PROJECT_DIR/.env"

# ─── Màu sắc terminal ─────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; NC='\033[0m'

log()  { echo -e "${GREEN}[✓]${NC} $*"; }
info() { echo -e "${CYAN}[i]${NC} $*"; }
warn() { echo -e "${YELLOW}[!]${NC} $*"; }
err()  { echo -e "${RED}[✗]${NC} $*"; exit 1; }

banner() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════╗"
    echo "║       DIỄN ĐÀN SINH VIÊN — Manager      ║"
    echo "╚══════════════════════════════════════════╝"
    echo -e "${NC}"
}

# ─── Kiểm tra .env ────────────────────────────────────────────
check_env() {
    if [[ ! -f "$ENV_FILE" ]]; then
        warn ".env chưa tồn tại. Đang tạo từ .env.example..."
        cp "$PROJECT_DIR/.env.example" "$ENV_FILE"
        warn "Hãy chỉnh sửa .env trước khi khởi động!"
        warn "  nano $ENV_FILE"
        exit 1
    fi
}

# ─── Lệnh: setup ──────────────────────────────────────────────
cmd_setup() {
    banner
    info "Kiểm tra Docker..."
    command -v docker &>/dev/null || err "Docker chưa được cài đặt!"
    docker compose version &>/dev/null || err "Docker Compose chưa được cài đặt!"
    log "Docker OK"

    if [[ ! -f "$ENV_FILE" ]]; then
        cp "$PROJECT_DIR/.env.example" "$ENV_FILE"
        log "Đã tạo .env từ .env.example"
        warn "Vui lòng chỉnh sửa $ENV_FILE trước khi tiếp tục"
        echo ""
        echo "  Các giá trị cần thay đổi:"
        echo "  - DB_ROOT_PASSWORD, DB_PASSWORD, REDIS_PASSWORD"
        echo "  - ADMIN_PASS, ADMIN_MAIL"
        echo "  - FLARUM_BASE_URL (nếu dùng domain thật)"
        echo ""
        exit 0
    fi

    log "Setup hoàn tất. Chạy: ./scripts/manage.sh start"
}

# ─── Lệnh: start ──────────────────────────────────────────────
cmd_start() {
    check_env
    info "Đang khởi động Diễn Đàn Sinh Viên..."
    cd "$PROJECT_DIR"
    $COMPOSE up -d --build
    log "Tất cả dịch vụ đã khởi động!"
    echo ""
    info "Truy cập diễn đàn:"
    source "$ENV_FILE" 2>/dev/null || true
    echo "  🌐 Diễn đàn: ${FLARUM_BASE_URL:-http://localhost}"
    echo "  🔧 Admin:    ${FLARUM_BASE_URL:-http://localhost}/admin"
    echo ""
}

# ─── Lệnh: stop ───────────────────────────────────────────────
cmd_stop() {
    cd "$PROJECT_DIR"
    info "Đang dừng tất cả dịch vụ..."
    $COMPOSE down
    log "Đã dừng."
}

# ─── Lệnh: restart ────────────────────────────────────────────
cmd_restart() {
    cmd_stop
    cmd_start
}

# ─── Lệnh: logs ───────────────────────────────────────────────
cmd_logs() {
    cd "$PROJECT_DIR"
    SERVICE="${2:-}"
    $COMPOSE logs -f --tail=100 $SERVICE
}

# ─── Lệnh: status ─────────────────────────────────────────────
cmd_status() {
    cd "$PROJECT_DIR"
    $COMPOSE ps
}

# ─── Lệnh: backup ─────────────────────────────────────────────
cmd_backup() {
    check_env
    source "$ENV_FILE"
    BACKUP_DIR="$PROJECT_DIR/backups/$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"

    info "Đang backup database..."
    cd "$PROJECT_DIR"
    $COMPOSE exec db mysqldump \
        -u root -p"${DB_ROOT_PASSWORD}" \
        "${DB_NAME}" > "$BACKUP_DIR/database.sql"
    log "Database: $BACKUP_DIR/database.sql"

    info "Đang backup assets & storage..."
    $COMPOSE exec flarum tar czf - /var/www/html/public/assets \
        > "$BACKUP_DIR/assets.tar.gz" 2>/dev/null || true
    $COMPOSE exec flarum tar czf - /var/www/html/storage \
        > "$BACKUP_DIR/storage.tar.gz" 2>/dev/null || true
    log "Backup hoàn tất tại: $BACKUP_DIR"
}

# ─── Lệnh: restore ────────────────────────────────────────────
cmd_restore() {
    SQL_FILE="${2:-}"
    [[ -z "$SQL_FILE" ]] && err "Usage: $0 restore <path/to/database.sql>"
    [[ ! -f "$SQL_FILE" ]] && err "File không tồn tại: $SQL_FILE"
    check_env
    source "$ENV_FILE"
    cd "$PROJECT_DIR"
    info "Đang restore database từ $SQL_FILE..."
    $COMPOSE exec -T db mysql \
        -u root -p"${DB_ROOT_PASSWORD}" \
        "${DB_NAME}" < "$SQL_FILE"
    log "Restore thành công!"
}

# ─── Lệnh: update ─────────────────────────────────────────────
cmd_update() {
    cd "$PROJECT_DIR"
    info "Đang kéo image mới nhất..."
    $COMPOSE pull
    info "Đang khởi động lại với image mới..."
    $COMPOSE up -d
    info "Chạy migration Flarum..."
    $COMPOSE exec flarum php /var/www/html/flarum migrate || true
    log "Cập nhật hoàn tất!"
}

# ─── Lệnh: shell ──────────────────────────────────────────────
cmd_shell() {
    cd "$PROJECT_DIR"
    SERVICE="${2:-flarum}"
    info "Mở shell vào container: $SERVICE"
    $COMPOSE exec "$SERVICE" sh
}

# ─── Lệnh: flarum ─────────────────────────────────────────────
cmd_flarum() {
    cd "$PROJECT_DIR"
    shift
    $COMPOSE exec flarum php /var/www/html/flarum "$@"
}

# ─── Help ─────────────────────────────────────────────────────
cmd_help() {
    banner
    echo "Cách dùng: $0 <lệnh> [tham số]"
    echo ""
    echo "Các lệnh:"
    echo "  setup          Khởi tạo dự án lần đầu"
    echo "  start          Khởi động tất cả dịch vụ"
    echo "  stop           Dừng tất cả dịch vụ"
    echo "  restart        Khởi động lại"
    echo "  status         Xem trạng thái container"
    echo "  logs [service] Xem log (mặc định: tất cả)"
    echo "  backup         Sao lưu database + assets"
    echo "  restore <file> Khôi phục database từ file SQL"
    echo "  update         Cập nhật lên phiên bản mới nhất"
    echo "  shell [svc]    Mở shell vào container"
    echo "  flarum <cmd>   Chạy lệnh Flarum CLI"
    echo "  help           Hiển thị trợ giúp này"
    echo ""
    echo "Ví dụ:"
    echo "  $0 setup"
    echo "  $0 start"
    echo "  $0 logs flarum"
    echo "  $0 flarum migrate"
    echo "  $0 backup"
}

# ─── Router ───────────────────────────────────────────────────
CMD="${1:-help}"
case "$CMD" in
    setup)   cmd_setup ;;
    start)   cmd_start ;;
    stop)    cmd_stop ;;
    restart) cmd_restart ;;
    logs)    cmd_logs "$@" ;;
    status)  cmd_status ;;
    backup)  cmd_backup ;;
    restore) cmd_restore "$@" ;;
    update)  cmd_update ;;
    shell)   cmd_shell "$@" ;;
    flarum)  cmd_flarum "$@" ;;
    help|--help|-h) cmd_help ;;
    *) err "Lệnh không hợp lệ: $CMD. Dùng 'help' để xem danh sách." ;;
esac
