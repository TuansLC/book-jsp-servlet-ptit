package com.ptit.projectwebptit.config;

public class DatabaseConfig {
    public static final String URL = "jdbc:mysql://localhost:3306/library_management?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    public static final String USERNAME = "ptit";
    public static final String PASSWORD = "ptit123";

    // Các thông số kết nối khác nếu cần
    public static final int MAX_POOL_SIZE = 10;
    public static final int TIMEOUT = 30000;
    
    private DatabaseConfig() {
        // Private constructor để ngăn khởi tạo
    }
} 