package com.ptit.projectwebptit.servlet;

import com.ptit.projectwebptit.dao.UserDAO;
import com.ptit.projectwebptit.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/users/*")
public class UserServlet extends HttpServlet {
    private UserDAO userDAO;

    public void init() {
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
                case "/delete":
                    deleteUser(request, response);
                    break;
                case "/get":
                    getUserJson(request, response);
                    break;
                default:
                    listUsers(request, response);
                    break;
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    // Thêm phương thức mới để trả về thông tin user dạng JSON
    private void getUserJson(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            User user = userDAO.get(id);

            if (user != null) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                // Tạo JSON object
                String json = String.format(
                    "{\"id\": %d, \"username\": \"%s\", \"fullName\": \"%s\", " +
                        "\"email\": \"%s\", \"phone\": \"%s\", \"role\": \"%s\", \"status\": \"%s\"}",
                    user.getId(),
                    user.getUsername(),
                    user.getFullName(),
                    user.getEmail() != null ? user.getEmail() : "",
                    user.getPhone() != null ? user.getPhone() : "",
                    user.getRole(),
                    user.getStatus()
                );

                response.getWriter().write(json);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\": \"User not found\"}");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
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
                    addUser(request, response);
                    break;
                case "/edit":
                    updateUser(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/users");
                    break;
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<User> users = userDAO.getAll();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/WEB-INF/user/list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/user/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        User user = userDAO.get(id);
        request.setAttribute("user", user);
        request.getRequestDispatcher("/WEB-INF/user/form.jsp").forward(request, response);
    }

    private void addUser(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String role = request.getParameter("role");
            String status = "ACTIVE"; // Default status

            // Validate required fields
            if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                fullName == null || fullName.trim().isEmpty()) {
                throw new Exception("Vui lòng điền đầy đủ thông tin bắt buộc");
            }

            // Check if username exists
            if (userDAO.findByUsername(username) != null) {
                throw new Exception("Tên đăng nhập đã tồn tại");
            }

            User user = new User();
            user.setUsername(username);
            user.setPassword(password); // Should encrypt password in production
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone);
            user.setRole(role);
            user.setStatus(status);

            userDAO.save(user);
            request.getSession().setAttribute("successMessage", "Thêm người dùng thành công!");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String role = request.getParameter("role");
            String status = request.getParameter("status");

            User existingUser = userDAO.get(id);
            if (existingUser == null) {
                throw new Exception("Không tìm thấy người dùng");
            }

            // Update user fields
            existingUser.setUsername(username);
            if (password != null && !password.trim().isEmpty()) {
                existingUser.setPassword(password); // Should encrypt password in production
            }
            existingUser.setFullName(fullName);
            existingUser.setEmail(email);
            existingUser.setPhone(phone);
            existingUser.setRole(role);
            existingUser.setStatus(status);

            userDAO.update(existingUser);
            request.getSession().setAttribute("successMessage", "Cập nhật người dùng thành công!");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            User currentUser = (User) request.getSession().getAttribute("user");
            
            if (currentUser.getId() == id) {
                throw new Exception("Không thể xóa tài khoản đang đăng nhập");
            }
            
            userDAO.delete(id);
            request.getSession().setAttribute("successMessage", "Xóa người dùng thành công!");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
} 