package com.ptit.projectwebptit.model;

import java.util.Date;

public class BorrowRecord {
    private int id;
    private int bookId;
    private int userId;
    private Date borrowDate;
    private Date returnDate;
    private Date dueDate;  // Ngày phải trả
    private String status; // PENDING, BORROWING, RETURNED, OVERDUE, REJECTED
    private String note;   // Ghi chú cho mượn trả
    
    // Thông tin bổ sung từ join với bảng khác
    private String bookTitle;
    private String userName;
    private String userEmail;
    private double fineAmount; // Tiền phạt nếu trả muộn

    private Book book;
    private User user;

    public BorrowRecord() {}

    public BorrowRecord(int id, int bookId, int userId, Date borrowDate, 
                       Date returnDate, Date dueDate, String status) {
        this.id = id;
        this.bookId = bookId;
        this.userId = userId;
        this.borrowDate = borrowDate;
        this.returnDate = returnDate;
        this.dueDate = dueDate;
        this.status = status;
    }

    // Getters và Setters cơ bản
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Date getBorrowDate() { return borrowDate; }
    public void setBorrowDate(Date borrowDate) { this.borrowDate = borrowDate; }

    public Date getReturnDate() { return returnDate; }
    public void setReturnDate(Date returnDate) { this.returnDate = returnDate; }

    public Date getDueDate() { return dueDate; }
    public void setDueDate(Date dueDate) { this.dueDate = dueDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }

    public double getFineAmount() { return fineAmount; }
    public void setFineAmount(double fineAmount) { this.fineAmount = fineAmount; }

    public Book getBook() {
        return book;
    }

    public void setBook(Book book) {
        this.book = book;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    // Các phương thức tiện ích
    public boolean isOverdue() {
        if (status.equals("RETURNED")) {
            return false;
        }
        if (dueDate == null) {
            return false;
        }
        return new Date().after(dueDate);
    }

    public long getDaysOverdue() {
        if (!isOverdue()) {
            return 0;
        }
        long diff = new Date().getTime() - dueDate.getTime();
        return diff / (24 * 60 * 60 * 1000);
    }

    public void calculateFineAmount() {
        if (isOverdue()) {
            // Ví dụ: phạt 5000đ/ngày trễ hạn
            this.fineAmount = getDaysOverdue() * 5000;
        } else {
            this.fineAmount = 0;
        }
    }

    public String getStatusDisplay() {
        switch (status) {
            case "PENDING": return "Chờ xử lý";
            case "BORROWING": return "Đang mượn";
            case "RETURNED": return "Đã trả";
            case "OVERDUE": return "Quá hạn";
            case "REJECTED": return "Từ chối";
            default: return status;
        }
    }

    @Override
    public String toString() {
        return "BorrowRecord{" +
                "id=" + id +
                ", bookId=" + bookId +
                ", userId=" + userId +
                ", bookTitle='" + bookTitle + '\'' +
                ", userName='" + userName + '\'' +
                ", borrowDate=" + borrowDate +
                ", dueDate=" + dueDate +
                ", returnDate=" + returnDate +
                ", status='" + status + '\'' +
                '}';
    }
} 