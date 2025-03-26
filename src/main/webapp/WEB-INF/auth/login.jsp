<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng nhập - Thư viện PTIT</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(120deg, #2980b9, #8e44ad);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
        }
        
        .login-container {
            background: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            box-shadow: 0 15px 25px rgba(0,0,0,0.2);
            padding: 40px;
            width: 100%;
            max-width: 400px;
            margin: 20px;
        }
        
        .login-header {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .login-header i {
            font-size: 60px;
            background: linear-gradient(45deg, #2980b9, #8e44ad);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 15px;
        }
        
        .form-floating {
            margin-bottom: 20px;
        }
        
        .form-floating input {
            border-radius: 10px;
            border: 2px solid #e3e3e3;
            padding-left: 45px;
        }
        
        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #95a5a6;
            z-index: 2;
        }
        
        .btn-login {
            background: linear-gradient(45deg, #2980b9, #8e44ad);
            border: none;
            border-radius: 10px;
            padding: 12px;
            font-size: 16px;
            font-weight: 500;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
        }
        
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .remember-me {
            margin-bottom: 20px;
        }
        
        .links a {
            color: #2980b9;
            text-decoration: none;
            transition: color 0.3s ease;
        }
        
        .links a:hover {
            color: #8e44ad;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <i class="fas fa-user-circle"></i>
            <h2>Đăng nhập</h2>
            <p class="text-muted">Thư viện PTIT</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/auth/login" method="post">
            <div class="form-floating position-relative">
                <i class="fas fa-user input-icon"></i>
                <input type="text" class="form-control" id="username" name="username" 
                       placeholder="Tên đăng nhập" required>
                <label for="username">Tên đăng nhập</label>
            </div>
            
            <div class="form-floating position-relative">
                <i class="fas fa-lock input-icon"></i>
                <input type="password" class="form-control" id="password" name="password" 
                       placeholder="Mật khẩu" required>
                <label for="password">Mật khẩu</label>
            </div>

            <div class="form-check remember-me">
                <input type="checkbox" class="form-check-input" id="rememberMe" name="rememberMe">
                <label class="form-check-label" for="rememberMe">Ghi nhớ đăng nhập</label>
            </div>

            <button type="submit" class="btn btn-primary w-100 btn-login mb-3">
                <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập
            </button>
        </form>

        <div class="text-center links">
            <p class="mb-2">
                <a href="${pageContext.request.contextPath}/auth/forgot-password">
                    <i class="fas fa-key me-1"></i>Quên mật khẩu?
                </a>
            </p>
            <p class="mb-2">
                Chưa có tài khoản? 
                <a href="${pageContext.request.contextPath}/auth/register">
                    <i class="fas fa-user-plus me-1"></i>Đăng ký
                </a>
            </p>
            <a href="${pageContext.request.contextPath}/">
                <i class="fas fa-home me-1"></i>Quay về trang chủ
            </a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>