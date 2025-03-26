<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<nav class="navbar navbar-expand-lg navbar-dark fixed-top">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/">
            <i class="fas fa-book-reader me-2"></i>
            Thư viện PTIT
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/books">
                        <i class="fas fa-books me-1"></i>Danh sách sách
                    </a>
                </li>
                <c:if test="${sessionScope.user != null}">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/borrow">
                            <i class="fas fa-bookmark me-1"></i>Sách đã mượn
                        </a>
                    </li>
                    <c:if test="${sessionScope.user.role == 'ADMIN'}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="adminDropdown" role="button" 
                               data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fas fa-cog me-1"></i>Quản lý
                            </a>
                            <ul class="dropdown-menu" aria-labelledby="adminDropdown">
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/users">
                                        <i class="fas fa-users me-2"></i>Quản lý người dùng
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/books">
                                        <i class="fas fa-book me-2"></i>Quản lý sách
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/borrows">
                                        <i class="fas fa-clipboard-list me-2"></i>Quản lý mượn trả
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:if>
                    <c:if test="${sessionScope.user.role == 'LIBRARIAN'}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="librarianDropdown" role="button" 
                               data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fas fa-tasks me-1"></i>Thủ thư
                            </a>
                            <ul class="dropdown-menu" aria-labelledby="librarianDropdown">
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/librarian/borrows">
                                        <i class="fas fa-exchange-alt me-2"></i>Xử lý mượn trả
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/librarian/books">
                                        <i class="fas fa-book-medical me-2"></i>Quản lý kho sách
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:if>
                </c:if>
            </ul>
            <ul class="navbar-nav">
                <c:choose>
                    <c:when test="${sessionScope.user != null}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" 
                               data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fas fa-user-circle me-1"></i>${sessionScope.user.fullName}
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/user/profile">
                                        <i class="fas fa-id-card me-2"></i>Thông tin cá nhân
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/user/change-password">
                                        <i class="fas fa-key me-2"></i>Đổi mật khẩu
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/auth/logout">
                                        <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/auth/login">
                                <i class="fas fa-sign-in-alt me-1"></i>Đăng nhập
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/auth/register">
                                <i class="fas fa-user-plus me-1"></i>Đăng ký
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<style>
    .navbar {
        background: linear-gradient(120deg, #2980b9, #8e44ad);
        padding: 1rem;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }
    
    .navbar-brand {
        font-weight: 600;
        font-size: 1.5rem;
    }
    
    .nav-link {
        font-weight: 500;
        padding: 0.5rem 1rem;
        transition: all 0.3s ease;
    }
    
    .nav-link:hover {
        transform: translateY(-2px);
    }
    
    .dropdown-menu {
        border: none;
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        border-radius: 10px;
    }
    
    .dropdown-item {
        padding: 0.7rem 1.5rem;
        transition: all 0.3s ease;
    }
    
    .dropdown-item:hover {
        background-color: #f8f9fa;
        transform: translateX(5px);
    }
    
    .dropdown-divider {
        margin: 0.5rem 0;
    }
    
    /* Fix for fixed-top navbar */
    body {
        padding-top: 76px;
    }
    
    @media (max-width: 991.98px) {
        .navbar-collapse {
            background: linear-gradient(120deg, #2980b9, #8e44ad);
            padding: 1rem;
            border-radius: 10px;
            margin-top: 1rem;
        }
    }
</style> 