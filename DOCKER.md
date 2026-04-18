# Hướng dẫn sử dụng Docker Compose

### 1. Yêu cầu

Docker Desktop (Windows/Mac) hoặc Docker Engine + Docker Compose (Linux)

Port 8080 và 8081 chưa bị chiếm dụng

### 2. Các bước chạy

```bash
# Clone repository (nếu chưa có)
git clone https://github.com/[your-username]/[repo-name].git
cd [repo-name]

# Tạo thư mục cần thiết
mkdir -p setup/nginx src/extensions src/assets setup/demo-data

# Lưu file docker-compose.yml vào thư mục gốc
# Lưu file default.conf vào setup/nginx/default.conf

# Khởi động tất cả container
docker-compose up -d

# Kiểm tra trạng thái
docker-compose ps

# Xem log (nếu cần debug)
docker-compose logs -f
```

### 3. Truy cập

| Dịch vụ | URL | Tài khoản mặc định |
|------------|------------|------------|
|Diễn đàn Flarum|http://localhost:8080|admin / admin123|
|phpMyAdmin|[localhost:8081](http://localhost:8081)|root / root123|

### 4. Các lệnh quản lý thường dùng

```bash
# Dừng container
docker-compose down

# Khởi động lại
docker-compose restart

# Xóa toàn bộ container + volume (mất dữ liệu)
docker-compose down -v

# Chạy lệnh Flarum CLI (ví dụ: cài extension)
docker exec -it flarum_app php flarum list
```

