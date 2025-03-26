# Hệ thống Quản lý Thư viện PTIT

## Các bước cài đặt và chạy project

### 1. Clone Project
git clone https://github.com/TuansLC/book-jsp-servlet-ptit.git

### 2. Cấu hình và chạy Docker

Build và start các containers
docker-compose up -d
Kiểm tra các containers đang chạy
docker ps

### 3. Khởi tạo Database
Thông tin đăng nhập MYSQL
      MYSQL_DATABASE: library_management
      MYSQL_USER: ptit
      MYSQL_PASSWORD: ptit123
COPY nội dung file init.sql. => Run các câu lệnh SQL

### 4. Chạy Project
- Truy cập đường dẫn: http://localhost:8080/library-management

1. Admin
- Username: admin
- Password: admin123

2. Thủ thư
- Username: librarian
- Password: lib123

3. Người dùng
- Username: user1
- Password: user123
