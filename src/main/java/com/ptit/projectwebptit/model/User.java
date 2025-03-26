package com.ptit.projectwebptit.model;

import java.util.Date;

public class User {
    private int id;
    private String username;
    private String password;
    private String fullName;
    private String email;
    private String phone;
    private String role;      // ADMIN, LIBRARIAN, USER
    private String status;    // ACTIVE, INACTIVE, BLOCKED
    private Date createdAt;
    private Date updatedAt;
    private String address;
    private String avatar;    // URL của ảnh đại diện
    private int borrowCount;  // Số lượng sách đang mượn
    private boolean isVerified; // Trạng thái xác thực email

    // Constructors
    public User() {}

    public User(String username, String password, String fullName, String email) {
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.email = email;
        this.status = "ACTIVE";
        this.role = "USER";
        this.createdAt = new Date();
        this.updatedAt = new Date();
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }

    public int getBorrowCount() { return borrowCount; }
    public void setBorrowCount(int borrowCount) { this.borrowCount = borrowCount; }

    public boolean isVerified() { return isVerified; }
    public void setVerified(boolean verified) { isVerified = verified; }

    // Utility methods
    public boolean isAdmin() {
        return "ADMIN".equals(role);
    }

    public boolean isLibrarian() {
        return "LIBRARIAN".equals(role);
    }

    public boolean isActive() {
        return "ACTIVE".equals(status);
    }

    public boolean isBlocked() {
        return "BLOCKED".equals(status);
    }

    public String getStatusDisplay() {
        switch (status) {
            case "ACTIVE": return "Hoạt động";
            case "INACTIVE": return "Không hoạt động";
            case "BLOCKED": return "Bị khóa";
            default: return status;
        }
    }

    public String getRoleDisplay() {
        switch (role) {
            case "ADMIN": return "Quản trị viên";
            case "LIBRARIAN": return "Thủ thư";
            case "USER": return "Độc giả";
            default: return role;
        }
    }

    public boolean canBorrowMore() {
        // Giả sử mỗi user chỉ được mượn tối đa 5 cuốn
        return borrowCount < 5;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", role='" + role + '\'' +
                ", status='" + status + '\'' +
                '}';
    }

    // Validation methods
    public boolean isValidEmail() {
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@(.+)$");
    }

    public boolean isValidPhone() {
        return phone != null && phone.matches("^[0-9]{10}$");
    }

    public boolean isValidPassword(String password) {
        // Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số
        return password != null && 
               password.length() >= 8 && 
               password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).+$");
    }
} 