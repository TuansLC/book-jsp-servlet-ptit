package com.ptit.projectwebptit.servlet;

import com.ptit.projectwebptit.dao.BookDAO;
import com.ptit.projectwebptit.model.Book;
import com.ptit.projectwebptit.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/books/*")
public class BookServlet extends HttpServlet {
    private BookDAO bookDAO;

    public void init() {
        bookDAO = new BookDAO();
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
                    if (isAdmin(request)) {
                        showAddForm(request, response);
                    } else {
                        sendError(request, response, "Không có quyền truy cập");
                    }
                    break;
                case "/edit":
                    if (isAdmin(request)) {
                        showEditForm(request, response);
                    } else {
                        sendError(request, response, "Không có quyền truy cập");
                    }
                    break;
                case "/delete":
                    if (isAdmin(request)) {
                        deleteBook(request, response);
                    } else {
                        sendError(request, response, "Không có quyền truy cập");
                    }
                    break;
                case "/search":
                    searchBooks(request, response);
                    break;
                case "/view":
                    viewBookDetail(request, response);
                    break;
                case "/category":
                    listBooksByCategory(request, response);
                    break;
                default:
                    listBooks(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendError(request, response, "Đã xảy ra lỗi: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getPathInfo();
        if (action == null) {
            action = "/";
        }

        try {
            switch (action) {
                case "/add":
                    if (isAdmin(request)) {
                        addBook(request, response);
                    } else {
                        sendError(request, response, "Không có quyền truy cập");
                    }
                    break;
                case "/edit":
                    if (isAdmin(request)) {
                        updateBook(request, response);
                    } else {
                        sendError(request, response, "Không có quyền truy cập");
                    }
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/books");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendError(request, response, "Đã xảy ra lỗi: " + e.getMessage());
        }
    }

    private void listBooks(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pageStr = request.getParameter("page");
        int page = (pageStr != null) ? Integer.parseInt(pageStr) : 1;
        int pageSize = 10;

        List<Book> books = bookDAO.getAll(page, pageSize);
        int totalBooks = bookDAO.getTotalBooks();
        int totalPages = (int) Math.ceil((double) totalBooks / pageSize);

        request.setAttribute("books", books);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("categories", bookDAO.getAllCategories());
        request.getRequestDispatcher("/WEB-INF/book/list.jsp").forward(request, response);
    }

    private void viewBookDetail(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Book book = bookDAO.get(id);
        if (book != null) {
            request.setAttribute("book", book);
            request.getRequestDispatcher("/WEB-INF/book/detail.jsp").forward(request, response);
        } else {
            sendError(request, response, "Không tìm thấy sách");
        }
    }

    private void listBooksByCategory(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String category = request.getParameter("category");
        List<Book> books = bookDAO.getByCategory(category);
        request.setAttribute("books", books);
        request.setAttribute("selectedCategory", category);
        request.setAttribute("categories", bookDAO.getAllCategories());
        request.getRequestDispatcher("/WEB-INF/book/list.jsp").forward(request, response);
    }

    private void addBook(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        try {
            String title = request.getParameter("title");
            String author = request.getParameter("author");
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String category = request.getParameter("category");
            String description = request.getParameter("description");

            if (title == null || title.trim().isEmpty() || 
                author == null || author.trim().isEmpty()) {
                throw new IllegalArgumentException("Vui lòng điền đầy đủ thông tin");
            }

            Book book = new Book();
            book.setTitle(title);
            book.setAuthor(author);
            book.setQuantity(quantity);
            book.setCategory(category);
            book.setDescription(description);

            bookDAO.save(book);
            request.getSession().setAttribute("success", "Thêm sách thành công");
            response.sendRedirect(request.getContextPath() + "/books");
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            showAddForm(request, response);
        }
    }

    private void updateBook(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String title = request.getParameter("title");
            String author = request.getParameter("author");
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String category = request.getParameter("category");
            String description = request.getParameter("description");

            if (title == null || title.trim().isEmpty() || 
                author == null || author.trim().isEmpty()) {
                throw new IllegalArgumentException("Vui lòng điền đầy đủ thông tin");
            }

            Book book = new Book();
            book.setId(id);
            book.setTitle(title);
            book.setAuthor(author);
            book.setQuantity(quantity);
            book.setCategory(category);
            book.setDescription(description);

            bookDAO.update(book);
            request.getSession().setAttribute("success", "Cập nhật sách thành công");
            response.sendRedirect(request.getContextPath() + "/books");
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            showEditForm(request, response);
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("user");
            return user != null && "ADMIN".equals(user.getRole());
        }
        return false;
    }

    private void sendError(HttpServletRequest request, HttpServletResponse response, String message) 
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("/WEB-INF/error.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        List<String> categories = bookDAO.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/WEB-INF/book/add.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Book book = bookDAO.get(id);
            if (book != null) {
                request.setAttribute("book", book);
                List<String> categories = bookDAO.getAllCategories();
                request.setAttribute("categories", categories);
                request.getRequestDispatcher("/WEB-INF/book/edit.jsp").forward(request, response);
            } else {
                sendError(request, response, "Không tìm thấy sách");
            }
        } catch (NumberFormatException e) {
            sendError(request, response, "ID sách không hợp lệ");
        }
    }

    private void deleteBook(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Book book = bookDAO.get(id);
            if (book != null) {
                bookDAO.delete(id);
                request.getSession().setAttribute("success", "Xóa sách thành công");
            } else {
                request.getSession().setAttribute("error", "Không tìm thấy sách để xóa");
            }
            response.sendRedirect(request.getContextPath() + "/books");
        } catch (NumberFormatException e) {
            sendError(request, response, "ID sách không hợp lệ");
        }
    }

    private void searchBooks(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String category = request.getParameter("category");

        List<Book> books;
        if (keyword != null && !keyword.trim().isEmpty()) {
            books = bookDAO.search(keyword);
        } else if (category != null && !category.trim().isEmpty()) {
            books = bookDAO.getByCategory(category);
        } else {
            books = bookDAO.getAll();
        }

        request.setAttribute("books", books);
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedCategory", category);
        request.setAttribute("categories", bookDAO.getAllCategories());
        request.getRequestDispatcher("/WEB-INF/book/list.jsp").forward(request, response);
    }
} 