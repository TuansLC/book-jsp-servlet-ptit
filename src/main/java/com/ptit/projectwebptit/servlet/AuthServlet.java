package com.ptit.projectwebptit.servlet;

import com.ptit.projectwebptit.dao.UserDAO;
import com.ptit.projectwebptit.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Date;

@WebServlet("/auth/*")
public class AuthServlet extends HttpServlet {
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getPathInfo();
        
        switch (action) {
            case "/login":
                showLoginForm(request, response);
                break;
            case "/register":
                showRegisterForm(request, response);
                break;
            case "/logout":
                logout(request, response);
                break;
            case "/forgot-password":
                showForgotPasswordForm(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/auth/login");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getPathInfo();
        
        switch (action) {
            case "/login":
                processLogin(request, response);
                break;
            case "/register":
                processRegister(request, response);
                break;
            case "/forgot-password":
                processForgotPassword(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/auth/login");
                break;
        }
    }

    private void showLoginForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String referrer = request.getHeader("Referer");
        if (referrer != null && !referrer.contains("/auth/")) {
            request.getSession().setAttribute("returnUrl", referrer);
        }
        request.getRequestDispatcher("/WEB-INF/auth/login.jsp").forward(request, response);
    }

    private void showRegisterForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/auth/register.jsp").forward(request, response);
    }

    private void processLogin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        boolean rememberMe = "on".equals(request.getParameter("rememberMe"));

        try {
            User user = userDAO.findByUsername(username);
            if (user != null && verifyPassword(password, user.getPassword())) {
                if (!user.isActive()) {
                    request.setAttribute("error", "Tài khoản đã bị khóa");
                    request.getRequestDispatcher("/WEB-INF/auth/login.jsp").forward(request, response);
                    return;
                }

                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getId());

                if (rememberMe) {
                    Cookie usernameCookie = new Cookie("username", username);
                    usernameCookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
                    response.addCookie(usernameCookie);
                }

                String returnUrl = (String) session.getAttribute("returnUrl");
                if (returnUrl != null) {
                    session.removeAttribute("returnUrl");
                    response.sendRedirect(returnUrl);
                } else {
                    response.sendRedirect(request.getContextPath() + "/");
                }
            } else {
                request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng");
                request.getRequestDispatcher("/WEB-INF/auth/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/auth/login.jsp").forward(request, response);
        }
    }

    private void processRegister(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        try {
            // Validate input
            if (!password.equals(confirmPassword)) {
                throw new Exception("Mật khẩu xác nhận không khớp");
            }

            if (userDAO.findByUsername(username) != null) {
                throw new Exception("Tên đăng nhập đã tồn tại");
            }

            if (userDAO.findByEmail(email) != null) {
                throw new Exception("Email đã được sử dụng");
            }

            // Create new user
            User user = new User(username, password, fullName, email);
            user.setPhone(phone);
            user.setCreatedAt(new Date());
            user.setUpdatedAt(new Date());
            
            userDAO.save(user);

            request.getSession().setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
            response.sendRedirect(request.getContextPath() + "/auth/login");
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("username", username);
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("/WEB-INF/auth/register.jsp").forward(request, response);
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("username".equals(cookie.getName())) {
                    cookie.setMaxAge(0);
                    response.addCookie(cookie);
                }
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/auth/login");
    }

    private void processForgotPassword(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {}

    private boolean verifyPassword(String inputPassword, String storedPassword) {
        // TODO: Implement proper password hashing and verification
        return inputPassword.equals(storedPassword);
    }

    private void showForgotPasswordForm(HttpServletRequest request, HttpServletResponse response){

    }
} 