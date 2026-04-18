# Đồ án chuyên ngành "Diễn Đàn Sinh Viên" trên nền tảng Flarum

- **Mã đồ án:** cn-dx23tt9-nguyenquocthongtung-diendansinhvien
- **Sinh viên thực hiện:** Nguyễn Quốc Thông Tùng
- **MSSV:** 170123046
- **Lớp:** DX23TT9
- **Giảng viên hướng dẫn:** ThS. Nguyễn Hoàng Duy Thiện

---

## Giới thiệu đồ án

Đồ án này xây dựng một **diễn đàn thảo luận dành riêng cho sinh viên** dựa trên nền tảng **Flarum** – một hệ thống diễn đàn mã nguồn mở, hiện đại, nhẹ và nhanh. Mục tiêu là tạo ra một không gian trao đổi học thuật, hỏi đáp, chia sẻ tài liệu và kết nối cộng đồng sinh viên trong trường.

---

## Tính năng chính

- Đăng ký / đăng nhập bằng email sinh viên (domain trường)
- Tạo chủ đề (discussion) theo các danh mục: Học tập, Kỹ năng, Việc làm, Sự kiện,...
- Bình luận, trả lời, trích dẫn, cảm ơn bài viết
- Tìm kiếm bài viết theo từ khóa, theo tag
- Phân quyền: quản trị viên, điều hành viên (mod), thành viên
- Giao diện responsive (hỗ trợ mobile)
- Thống kê thành viên, bài viết mới, chủ đề nổi bật

---

## Công nghệ sử dụng

| Thành phần | Công nghệ |
|------------|------------|
| Nền tảng diễn đàn | Flarum (PHP + MySQL) |
| Web server | Nginx / Apache |
| Cơ sở dữ liệu | MySQL / MariaDB |
| Môi trường chạy | PHP ≥ 7.4 |
| Container (tùy chọn) | Docker + Docker Compose |
| Quản lý phiên bản | Git + GitHub |

---

## Kiến Trúc

```
┌─────────────────────────────────────────────────────┐
│                    Internet / Browser                │
└──────────────────────────┬──────────────────────────┘
                           │ :80 / :443
┌──────────────────────────▼──────────────────────────┐
│                  Nginx (Reverse Proxy)               │
│            Static assets · Gzip · SSL               │
└──────────────────────────┬──────────────────────────┘
                           │ FastCGI :9000
┌──────────────────────────▼──────────────────────────┐
│                   Flarum (PHP-FPM)                   │
│         Forum engine · Extensions · Queue           │
└──────────┬───────────────────────────┬──────────────┘
           │                           │
┌──────────▼──────────┐   ┌────────────▼─────────────┐
│   MariaDB 10.11     │   │      Redis 7             │
│   (Database)        │   │  (Cache / Sessions)      │
└─────────────────────┘   └──────────────────────────┘
```

---

## Yêu Cầu

- **Docker** ≥ 24.0
- **Docker Compose** ≥ 2.0 (plugin, không phải `docker-compose` cũ)
- RAM: tối thiểu **1 GB** (khuyến nghị 2 GB)
- Disk: tối thiểu **5 GB** trống

---

## Bắt Đầu Nhanh

### 1. Clone / tải về dự án

```bash
git clone https://github.com/tungnqt031291/cn-dx23tt9-nguyenquocthongtung-diendansinhvien
cd cn-dx23tt9-nguyenquocthongtung-diendansinhvien
```

### 2. Khởi tạo cấu hình

```bash
./scripts/manage.sh setup
```

Script sẽ tạo file `.env` từ `.env.example`.

### 3. Chỉnh sửa `.env`

```bash
nano .env
```

Bắt buộc thay đổi:

| Biến | Mô tả |
|------|-------|
| `DB_ROOT_PASSWORD` | Mật khẩu root MariaDB |
| `DB_PASSWORD` | Mật khẩu user database |
| `REDIS_PASSWORD` | Mật khẩu Redis |
| `ADMIN_USER` | Tên đăng nhập admin |
| `ADMIN_PASS` | Mật khẩu admin |
| `ADMIN_MAIL` | Email admin |
| `FLARUM_BASE_URL` | URL của diễn đàn (VD: `https://ddsv.edu.vn`) |

### 4. Khởi động

```bash
./scripts/manage.sh start
```

Lần đầu chạy, Flarum sẽ tự động cài đặt (~2–3 phút). Truy cập:
- **Diễn đàn:** `http://localhost`
- **Admin panel:** `http://localhost/admin`

---

## Quản Lý

```bash
./scripts/manage.sh <lệnh>
```

| Lệnh | Mô tả |
|------|-------|
| `setup` | Khởi tạo lần đầu |
| `start` | Khởi động tất cả dịch vụ |
| `stop` | Dừng tất cả dịch vụ |
| `restart` | Khởi động lại |
| `status` | Xem trạng thái container |
| `logs [service]` | Xem log realtime |
| `backup` | Sao lưu DB + assets |
| `restore <file>` | Khôi phục từ backup |
| `update` | Cập nhật phiên bản |
| `shell [service]` | Mở terminal vào container |
| `flarum <cmd>` | Chạy Flarum CLI |

### Ví dụ thực tế

```bash
# Xem log Flarum
./scripts/manage.sh logs flarum

# Backup hàng ngày
./scripts/manage.sh backup

# Restore từ backup
./scripts/manage.sh restore backups/20240101_120000/database.sql

# Chạy migration sau khi cài extension
./scripts/manage.sh flarum migrate

# Xóa cache
./scripts/manage.sh flarum cache:clear
```

---

## Cài Extension Phổ Biến

Vào container Flarum để cài extension qua Composer:

```bash
./scripts/manage.sh shell flarum

# Trong container:
composer require flarum-lang/vietnamese     # Tiếng Việt
composer require fof/user-bio               # Bio người dùng
composer require fof/uploads                # Upload file
composer require fof/moderator-notes        # Ghi chú mod
composer require flarum/mentions            # Mention @người dùng
composer require flarum/likes               # Like bài viết
composer require flarum/tags                # Tags / danh mục
composer require flarum/subscriptions       # Đăng ký nhận thông báo
composer require flarum/sticky              # Ghim bài viết
composer require flarum/lock                # Khóa chủ đề

# Sau khi cài xong
php flarum migrate
php flarum cache:clear
exit
```

---

## Cài HTTPS (Production)

### Dùng Certbot (Let's Encrypt)

```bash
# Cài certbot
apt install certbot

# Lấy chứng chỉ (dừng nginx trước)
./scripts/manage.sh stop
certbot certonly --standalone -d yourdomain.com

# Sao chép cert vào thư mục ssl
cp /etc/letsencrypt/live/yourdomain.com/fullchain.pem ./nginx/ssl/
cp /etc/letsencrypt/live/yourdomain.com/privkey.pem ./nginx/ssl/
```

Sau đó cập nhật `nginx/conf.d/flarum.conf` thêm server block HTTPS:

```nginx
server {
    listen 443 ssl http2;
    server_name yourdomain.com;

    ssl_certificate     /etc/nginx/ssl/fullchain.pem;
    ssl_certificate_key /etc/nginx/ssl/privkey.pem;

    # ... giữ nguyên các location từ cấu hình HTTP
}
```

---

## Backup Tự Động (Cron)

```bash
# Crontab — backup mỗi ngày lúc 2 giờ sáng
crontab -e

# Thêm dòng:
0 2 * * * /path/to/dien-dan-sinh-vien/scripts/manage.sh backup >> /var/log/ddsv-backup.log 2>&1
```

---

## Cấu Trúc Dự Án

```
dien-dan-sinh-vien/
├── docker-compose.yml          # Định nghĩa services
├── .env.example                # Mẫu biến môi trường
├── .env                        # (tự tạo, không commit!)
├── .gitignore
├── README.md
├── nginx/
│   ├── nginx.conf              # Cấu hình Nginx chính
│   └── conf.d/
│       └── flarum.conf         # Virtual host Flarum
├── flarum-config/
│   └── config.php              # Override config Flarum
├── scripts/
│   └── manage.sh               # Script quản lý
└── backups/                    # Thư mục backup (tự tạo)
```

---

## Xử Lý Sự Cố

### Flarum không khởi động được

```bash
./scripts/manage.sh logs flarum
```

### Lỗi kết nối database

```bash
# Kiểm tra db đã healthy chưa
./scripts/manage.sh status

# Xem log db
./scripts/manage.sh logs db
```

### Reset hoàn toàn (mất dữ liệu)

```bash
docker compose down -v    # Xóa cả volumes!
docker compose up -d
```

### Phân quyền file

```bash
./scripts/manage.sh shell flarum
chown -R www-data:www-data /var/www/html/storage
chown -R www-data:www-data /var/www/html/public/assets
chmod -R 775 /var/www/html/storage
```

---

## .gitignore

```
.env
backups/
nginx/ssl/
```

---

## Giấy Phép

MIT — Tự do sử dụng cho mục đích cá nhân và thương mại.

# Thông tin liên lạc

Email sinh viên: tungnqt031291@sv-onuni.edu.vn

GitHub: https://github.com/tungnqt031291

GVHD: 

Repository chính của đồ án: [https://github.com/your-username/flarum-forum] (sẽ fork về bộ môn khi kết thúc)

# Tài liệu tham khảo (trích dẫn theo chuẩn IEEE)
[1] T. Z. Q. Flarum, “Flarum Documentation,” Flarum Foundation, 2024. [Online]. Available: https://docs.flarum.org/
[2] M. L. Johnson, “Building modern forums with PHP and MySQL,” Journal of Open Source Web Applications, vol. 12, no. 3, pp. 45–58, Aug. 2023.
[3] D. E. Knuth, The Art of Computer Programming, 3rd ed., Addison-Wesley, 1997, pp. 412–425.
[4] L. N. Group, “Flarum extension development guide,” GitHub repository, 2024. [Online]. Available: https://github.com/flarum/extension-tutorial

### Danh mục đầy đủ được lưu trong thư mục thesis/refs/ với tên file theo quy ước: [họ tên tác giả]_[năm]_[tiêu đề ngắn].pdf

# Tiến độ thực hiện (cập nhật qua progress-report/)

Tuần 1: Tạo repo, cấu trúc thư mục, README

Tuần 2: Nghiên cứu Flarum, cài đặt môi trường

Tuần 3: Viết chương 1, 2 (tổng quan, lý thuyết)

Tuần 4: Hiện thực & cấu hình diễn đàn, thêm extension

Tuần 5: Viết chương 3, 4 (hiện thực hóa, kết quả)

Tuần 6: Hoàn thiện đồ án, kiểm tra lỗi

Tuần 7: Nộp bản in, fork repo, báo cáo hội đồng

# Ghi chú
Đồ án được thực hiện theo đúng Quy định chung học phần của Bộ môn.

Commit code ít nhất 1 lần/tuần, kèm báo cáo tiến độ trong thư mục progress-report/.

Sử dụng Zotero để quản lý tài liệu tham khảo theo chuẩn IEEE.

Mọi thắc mắc vui lòng liên hệ qua email sinh viên hoặc GVHD.
