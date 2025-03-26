package com.ptit.projectwebptit.dao;

import com.ptit.projectwebptit.config.DatabaseConfig;
import com.ptit.projectwebptit.model.BorrowRecord;
import com.ptit.projectwebptit.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BorrowRecordDAO implements DAO<BorrowRecord> {
    
    private static final String SELECT_WITH_JOINS = 
        "SELECT br.*, b.title as book_title, u.full_name as user_name, u.email as user_email " +
        "FROM borrow_records br " +
        "JOIN books b ON br.book_id = b.id " +
        "JOIN users u ON br.user_id = u.id";

    @Override
    public BorrowRecord get(int id) {
        String sql = SELECT_WITH_JOINS + " WHERE br.id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return extractFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<BorrowRecord> getAll() {
        List<BorrowRecord> records = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(SELECT_WITH_JOINS)) {
            
            while (rs.next()) {
                records.add(extractFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return records;
    }

    @Override
    public void save(BorrowRecord record) {
        String sql = "INSERT INTO borrow_records (book_id, user_id, borrow_date, due_date, status, note) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, record.getBookId());
            ps.setInt(2, record.getUserId());
            ps.setDate(3, new java.sql.Date(record.getBorrowDate().getTime()));
            ps.setDate(4, record.getDueDate() != null ? 
                         new java.sql.Date(record.getDueDate().getTime()) : null);
            ps.setString(5, record.getStatus());
            ps.setString(6, record.getNote());
            
            ps.executeUpdate();
            
            // Lấy ID được tạo tự động
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    record.setId(generatedKeys.getInt(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void update(BorrowRecord record) {
        String sql = "UPDATE borrow_records SET return_date = ?, due_date = ?, " +
                    "status = ?, note = ? WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setDate(1, record.getReturnDate() != null ? 
                         new java.sql.Date(record.getReturnDate().getTime()) : null);
            ps.setDate(2, record.getDueDate() != null ? 
                         new java.sql.Date(record.getDueDate().getTime()) : null);
            ps.setString(3, record.getStatus());
            ps.setString(4, record.getNote());
            ps.setInt(5, record.getId());
            
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(int id) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM borrow_records WHERE id = ?")) {
            
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<BorrowRecord> getByUserId(int userId) {
        List<BorrowRecord> records = new ArrayList<>();
        String sql = SELECT_WITH_JOINS + " WHERE br.user_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                records.add(extractFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return records;
    }

    public List<BorrowRecord> getOverdueRecords() {
        List<BorrowRecord> records = new ArrayList<>();
        String sql = SELECT_WITH_JOINS + 
                    " WHERE br.due_date < CURRENT_DATE AND br.status = 'BORROWING'";
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                records.add(extractFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return records;
    }

    private BorrowRecord extractFromResultSet(ResultSet rs) throws SQLException {
        BorrowRecord record = new BorrowRecord();
        record.setId(rs.getInt("id"));
        record.setBookId(rs.getInt("book_id"));
        record.setUserId(rs.getInt("user_id"));
        record.setBorrowDate(rs.getDate("borrow_date"));
        record.setReturnDate(rs.getDate("return_date"));
        record.setDueDate(rs.getDate("due_date"));
        record.setStatus(rs.getString("status"));
        record.setNote(rs.getString("note"));
        record.setBookTitle(rs.getString("book_title"));
        record.setUserName(rs.getString("user_name"));
        record.setUserEmail(rs.getString("user_email"));
        
        // Tính toán tiền phạt nếu quá hạn
        if (record.isOverdue()) {
            record.calculateFineAmount();
        }
        
        return record;
    }
} 