# Đồ án chuyên ngành "Diễn Đàn Sinh Viên" trên nền tảng Flarum

**Mã đồ án:** cn-dx23tt9-nguyenquocthongtung-diendansinhvien
**Sinh viên thực hiện:** Nguyễn Quốc Thông Tùng
**MSSV:** 170123046
**Lớp:** DX23TT9
**Giảng viên hướng dẫn:** ThS. Nguyễn Hoàng Duy Thiện

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

## Cấu trúc thư mục trong repository

flarum-forum/
├── README.md # Hướng dẫn chung
├── docker-compose.yml # (nếu dùng Docker)
├── setup/ # Script cài đặt, dữ liệu mẫu
├── src/ # Mã nguồn tùy chỉnh (extension, theme)
├── thesis/ # Tài liệu đồ án
│ ├── doc/ # File .docx
│ ├── pdf/ # File .pdf
│ ├── abs/ # Slide báo cáo (.ppt, .pptx)
│ └── refs/ # Tài liệu tham khảo (đặt tên theo chuẩn IEEE)
├── progress-report/ # Báo cáo tiến độ tuần (bắt buộc)
└── soft/ # Công cụ hỗ trợ (nếu có)

---

## Hướng dẫn cài đặt (không dùng Docker)

### 1. Yêu cầu hệ thống

- PHP ≥ 7.4 (các extension: curl, dom, gd, json, mbstring, openssl, pdo_mysql, tokenizer, zip)
- MySQL ≥ 5.7 hoặc MariaDB ≥ 10.2
- Composer
- Web server (Nginx / Apache)

### 2. Các bước cài đặt

```bash
# Tải mã nguồn Flarum
composer create-project flarum/flarum .

# Cấu hình database (tạo database và user tương ứng)
# Thiết lập quyền truy cập file
chmod -R 755 storage assets

# Truy cập domain đã cấu hình và hoàn tất cài đặt qua web installer
```

### 3. Cấu hình thêm

Bật chế độ debug (khi phát triển)

Cài đặt extension hỗ trợ xác thực email sinh viên (ví dụ: flarum-lang/english, fof/oauth)

Tùy chỉnh giao diện cơ bản (logo, màu sắc, CSS)

## Hướng dẫn cài đặt bằng Docker (khuyến khích)

### 1. Yêu cầu

Docker + Docker Compose

### 2. Các bước

```bash
# Clone repository
git clone https://github.com/[your-username]/[repo-name].git
cd [repo-name]

# Khởi động container
docker-compose up -d

# Truy cập http://localhost:8080 để hoàn tất cài đặt
📌 File docker-compose.yml đã được cấu hình sẵn với Flarum + MySQL + Nginx (xem trong thư mục setup/).
```
# Dữ liệu thử nghiệm

Trong thư mục setup/demo-data/ có file sample_discussions.sql để import dữ liệu mẫu (20 chủ đề, 50 bình luận) phục vụ chạy thử nghiệm và báo cáo.

# Thông tin liên lạc

Email sinh viên: tungnqt031291@sv-onuni.edu.vn

GitHub: [https://github.com/nguyenvana]

GVHD: [ts.tranvanb@university.edu.vn]

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
