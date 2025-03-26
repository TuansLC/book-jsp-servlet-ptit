package com.ptit.projectwebptit.servlet;

import com.ptit.projectwebptit.dao.BookDAO;
import com.ptit.projectwebptit.dao.BorrowRecordDAO;
import com.ptit.projectwebptit.dao.UserDAO;
import com.ptit.projectwebptit.model.Book;
import com.ptit.projectwebptit.model.BorrowRecord;
import com.ptit.projectwebptit.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

@WebServlet("/borrow/*")
public class BorrowServlet extends HttpServlet {
    private BorrowRecordDAO borrowRecordDAO;
    private BookDAO bookDAO;
    private UserDAO userDAO;

    public void init() {
        borrowRecordDAO = new BorrowRecordDAO();
        bookDAO = new BookDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getPathInfo();
        if (action == null) {
            action = "/";
        }

        try {
            switch (action) {
                case "/add":
                    showBorrowForm(request, response);
                    break;
                case "/return":
                    returnBook(request, response);
                    break;
                case "/approve":
                    approveRequest(request, response);
                    break;
                case "/reject":
                    rejectRequest(request, response);
                    break;
                default:
                    listBorrowRecords(request, response);
                    break;
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/borrow");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getPathInfo();
        if (action == null) {
            action = "/";
        }

        try {
            switch (action) {
                case "/add":
                    borrowBook(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/borrow");
                    break;
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/borrow");
        }
    }

    private void listBorrowRecords(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        List<BorrowRecord> records;

        if (user.isAdmin() || "LIBRARIAN".equals(user.getRole())) {
            records = borrowRecordDAO.getAll(); // Lấy tất cả bản ghi cho admin/thủ thư
        } else {
            records = borrowRecordDAO.getByUserId(user.getId()); // Lấy bản ghi của user
        }

        // Load book and user details
        for (BorrowRecord record : records) {
            Book book = bookDAO.get(record.getBookId());
            User borrower = userDAO.get(record.getUserId());

            record.setBook(book);
            record.setUser(borrower);
        }

        request.setAttribute("borrowRecords", records);
        request.getRequestDispatcher("/WEB-INF/borrow/list.jsp").forward(request, response);
    }

    private void showBorrowForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        int bookId = Integer.parseInt(request.getParameter("bookId"));
        Book book = bookDAO.get(bookId);
        
        if (book != null && book.getQuantity() > 0) {
            request.setAttribute("book", book);
            request.getRequestDispatcher("/WEB-INF/borrow/form.jsp").forward(request, response);
        } else {
            request.getSession().setAttribute("errorMessage", "Sách không có sẵn để mượn");
            response.sendRedirect(request.getContextPath() + "/books");
        }
    }

    private void borrowBook(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        int bookId = Integer.parseInt(request.getParameter("bookId"));
        Book book = bookDAO.get(bookId);
        
        if (book != null && book.getQuantity() > 0) {
            // Tạo bản ghi mượn sách
            BorrowRecord record = new BorrowRecord();
            record.setBookId(bookId);
            record.setUserId(user.getId());
            record.setBorrowDate(new Date());
            
            // Set due date (14 days from now)
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.DAY_OF_MONTH, 14);
            record.setDueDate(calendar.getTime());
            
            record.setStatus("PENDING");
            borrowRecordDAO.save(record); // Sử dụng phương thức add thay vì save
            
            request.getSession().setAttribute("successMessage", "Yêu cầu mượn sách đã được gửi!");
        } else {
            request.getSession().setAttribute("errorMessage", "Sách không có sẵn để mượn");
        }
        
        response.sendRedirect(request.getContextPath() + "/borrow");
    }

    private void returnBook(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        int recordId = Integer.parseInt(request.getParameter("id"));
        BorrowRecord record = borrowRecordDAO.get(recordId);
        
        if (record != null && ("BORROWED".equals(record.getStatus()) || "OVERDUE".equals(record.getStatus()))) {
            // Cập nhật bản ghi mượn sách
            record.setReturnDate(new Date());
            record.setStatus("RETURNED");
            borrowRecordDAO.update(record);

            // Cập nhật số lượng sách
            Book book = bookDAO.get(record.getBookId());
            book.setQuantity(book.getQuantity() + 1);
            bookDAO.update(book);
            
            request.getSession().setAttribute("successMessage", "Trả sách thành công!");
        } else {
            request.getSession().setAttribute("errorMessage", "Không thể trả sách này");
        }
        
        response.sendRedirect(request.getContextPath() + "/borrow");
    }

    private void approveRequest(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || (!user.isAdmin() && !"LIBRARIAN".equals(user.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        int recordId = Integer.parseInt(request.getParameter("id"));
        BorrowRecord record = borrowRecordDAO.get(recordId);
        
        if (record != null && "PENDING".equals(record.getStatus())) {
            Book book = bookDAO.get(record.getBookId());
            if (book.getQuantity() > 0) {
                // Cập nhật bản ghi mượn sách
                record.setStatus("BORROWED");
                borrowRecordDAO.update(record);

                // Cập nhật số lượng sách
                book.setQuantity(book.getQuantity() - 1);
                bookDAO.update(book);
                
                request.getSession().setAttribute("successMessage", "Đã duyệt yêu cầu mượn sách!");
            } else {
                request.getSession().setAttribute("errorMessage", "Sách đã hết!");
            }
        } else {
            request.getSession().setAttribute("errorMessage", "Không thể duyệt yêu cầu này");
        }
        
        response.sendRedirect(request.getContextPath() + "/borrow");
    }

    private void rejectRequest(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || (!user.isAdmin() && !"LIBRARIAN".equals(user.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        int recordId = Integer.parseInt(request.getParameter("id"));
        BorrowRecord record = borrowRecordDAO.get(recordId);
        
        if (record != null && "PENDING".equals(record.getStatus())) {
            record.setStatus("REJECTED");
            borrowRecordDAO.update(record);
            request.getSession().setAttribute("successMessage", "Đã từ chối yêu cầu mượn sách!");
        } else {
            request.getSession().setAttribute("errorMessage", "Không thể từ chối yêu cầu này");
        }
        
        response.sendRedirect(request.getContextPath() + "/borrow");
    }
} 