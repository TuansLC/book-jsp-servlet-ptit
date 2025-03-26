<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Thư viện PTIT - Trang chủ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #2980b9;
            --secondary-color: #8e44ad;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .hero-section {
            background: linear-gradient(120deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 100px 0;
            margin-bottom: 50px;
        }
        
        .hero-title {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 20px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }
        
        .hero-subtitle {
            font-size: 1.5rem;
            opacity: 0.9;
            margin-bottom: 30px;
        }
        
        .feature-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            transition: transform 0.3s ease;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .feature-card:hover {
            transform: translateY(-10px);
        }
        
        .feature-icon {
            font-size: 40px;
            margin-bottom: 20px;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .search-section {
            background: #f8f9fa;
            padding: 50px 0;
            margin: 50px 0;
            border-radius: 15px;
        }
        
        .search-box {
            max-width: 600px;
            margin: 0 auto;
        }
        
        .btn-custom {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            border: none;
            color: white;
            padding: 12px 30px;
            border-radius: 10px;
            transition: all 0.3s ease;
        }
        
        .btn-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            color: white;
        }
        
        .stats-section {
            padding: 50px 0;
        }
        
        .stat-card {
            text-align: center;
            padding: 20px;
        }
        
        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 10px;
        }
        
        footer {
            background: #2c3e50;
            color: white;
            padding: 30px 0;
            margin-top: 50px;
        }
        
        .social-links a {
            color: white;
            margin: 0 10px;
            font-size: 20px;
            transition: color 0.3s ease;
        }
        
        .social-links a:hover {
            color: var(--secondary-color);
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/includes/header.jsp" %>

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container text-center">
            <h1 class="hero-title">Chào mừng đến với Thư viện PTIT</h1>
            <p class="hero-subtitle">Khám phá kho tàng tri thức với hàng nghìn đầu sách</p>
            <c:if test="${empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-custom btn-lg">
                    <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập ngay
                </a>
            </c:if>
        </div>
    </section>

    <!-- Features Section -->
    <section class="container">
        <div class="row">
            <div class="col-md-4">
                <div class="feature-card text-center">
                    <i class="fas fa-book feature-icon"></i>
                    <h3>Kho sách đa dạng</h3>
                    <p>Hàng nghìn đầu sách từ nhiều lĩnh vực khác nhau, đáp ứng mọi nhu cầu học tập và nghiên cứu.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-card text-center">
                    <i class="fas fa-clock feature-icon"></i>
                    <h3>Mượn sách dễ dàng</h3>
                    <p>Quy trình mượn trả sách đơn giản, nhanh chóng với hệ thống quản lý hiện đại.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-card text-center">
                    <i class="fas fa-users feature-icon"></i>
                    <h3>Hỗ trợ 24/7</h3>
                    <p>Đội ngũ nhân viên thân thiện, sẵn sàng hỗ trợ bạn mọi lúc mọi nơi.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Search Section -->
    <section class="search-section">
        <div class="container">
            <div class="search-box">
                <h2 class="text-center mb-4">Tìm kiếm sách</h2>
                <form action="${pageContext.request.contextPath}/books/search" method="get">
                    <div class="input-group">
                        <input type="text" class="form-control" placeholder="Nhập tên sách, tác giả..." name="keyword">
                        <button class="btn btn-custom" type="submit">
                            <i class="fas fa-search me-2"></i>Tìm kiếm
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </section>

    <!-- Stats Section -->
    <section class="stats-section">
        <div class="container">
            <div class="row">
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-number">1000+</div>
                        <div class="stat-label">Đầu sách</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-number">500+</div>
                        <div class="stat-label">Độc giả</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-number">24/7</div>
                        <div class="stat-label">Hỗ trợ</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="row">
                <div class="col-md-6 text-center text-md-start">
                    <p>&copy; 2024 Thư viện PTIT. All rights reserved.</p>
                </div>
                <div class="col-md-6 text-center text-md-end social-links">
                    <a href="#"><i class="fab fa-facebook"></i></a>
                    <a href="#"><i class="fab fa-twitter"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                    <a href="#"><i class="fab fa-youtube"></i></a>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>