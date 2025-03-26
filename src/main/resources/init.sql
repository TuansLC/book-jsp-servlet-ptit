-- Xóa các bảng cũ nếu tồn tại
DROP TABLE IF EXISTS borrow_records;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS users;

-- Tạo bảng users
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    role VARCHAR(20) DEFAULT 'USER',
    status VARCHAR(20) DEFAULT 'ACTIVE',
    address TEXT,
    avatar VARCHAR(255),
    borrow_count INT DEFAULT 0,
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tạo bảng books
CREATE TABLE IF NOT EXISTS books (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(100) NOT NULL,
    isbn VARCHAR(20),
    publisher VARCHAR(100),
    category VARCHAR(50),
    description TEXT,
    quantity INT NOT NULL DEFAULT 0,
    available_quantity INT NOT NULL DEFAULT 0,
    location VARCHAR(50),
    cover_image VARCHAR(255),
    status VARCHAR(20) DEFAULT 'AVAILABLE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tạo bảng borrow_records
CREATE TABLE IF NOT EXISTS borrow_records (
    id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT NOT NULL,
    user_id INT NOT NULL,
    borrow_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    note TEXT,
    fine_amount DECIMAL(10,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES books(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Thêm dữ liệu mẫu cho users
INSERT INTO users (username, password, full_name, email, role, status) VALUES
('admin', 'admin123', 'Administrator', 'admin@ptit.edu.vn', 'ADMIN', 'ACTIVE'),
('librarian', 'lib123', 'Thủ Thư', 'librarian@ptit.edu.vn', 'LIBRARIAN', 'ACTIVE'),
('user1', 'user123', 'Nguyễn Văn A', 'user1@ptit.edu.vn', 'USER', 'ACTIVE');

-- Thêm dữ liệu mẫu cho books
INSERT INTO books (title, author, category, quantity, available_quantity, status) VALUES
('Java Programming', 'John Smith', 'Công nghệ thông tin', 5, 5, 'AVAILABLE'),
('Đại số tuyến tính', 'Nguyễn Văn B', 'Toán học', 3, 3, 'AVAILABLE'),
('Truyện Kiều', 'Nguyễn Du', 'Văn học', 2, 2, 'AVAILABLE'),
('Vật lý đại cương', 'Trần Văn C', 'Khoa học', 4, 4, 'AVAILABLE');

-- Thêm dữ liệu mẫu cho borrow_records
INSERT INTO borrow_records (book_id, user_id, borrow_date, due_date, status) VALUES
(1, 3, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY), 'PENDING'),
(2, 3, DATE_SUB(CURDATE(), INTERVAL 7 DAY), DATE_ADD(CURDATE(), INTERVAL 7 DAY), 'BORROWED'),
(3, 3, DATE_SUB(CURDATE(), INTERVAL 30 DAY), DATE_SUB(CURDATE(), INTERVAL 16 DAY), 'RETURNED');

-- Tạo indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_status ON users(status);

CREATE INDEX idx_books_isbn ON books(isbn);
CREATE INDEX idx_books_category ON books(category);
CREATE INDEX idx_books_status ON books(status);

CREATE INDEX idx_borrow_records_status ON borrow_records(status);
CREATE INDEX idx_borrow_records_user ON borrow_records(user_id);
CREATE INDEX idx_borrow_records_book ON borrow_records(book_id);
CREATE INDEX idx_borrow_records_dates ON borrow_records(borrow_date, due_date, return_date); 