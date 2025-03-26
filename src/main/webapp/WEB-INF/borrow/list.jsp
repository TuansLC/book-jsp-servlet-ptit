<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý mượn sách - Hệ thống Quản lý Thư viện</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .status-badge {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.9em;
        }
        .status-pending { background-color: #ffeeba; }
        .status-borrowed { background-color: #c3e6cb; }
        .status-returned { background-color: #bee5eb; }
        .status-overdue { background-color: #f5c6cb; }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/includes/header.jsp" %>
<div class="container mt-4">
    <div class="row mb-4">
        <div class="col-md-6">
            <h2><i class="fas fa-book-reader me-2"></i>Danh sách mượn sách</h2>
        </div>
        <div class="col-md-6 text-end">
            <a href="${pageContext.request.contextPath}/books" class="btn btn-primary">
                <i class="fas fa-book me-2"></i>Danh sách sách
            </a>
        </div>
    </div>

    <div class="card mb-4">
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/borrow/search" method="get" class="row g-3">
                <div class="col-md-4">
                    <input type="text" class="form-control" name="keyword" placeholder="Tìm kiếm..." value="${param.keyword}">
                </div>
                <div class="col-md-3">
                    <select class="form-select" name="status">
                        <option value="">Tất cả trạng thái</option>
                        <option value="PENDING" ${param.status == 'PENDING' ? 'selected' : ''}>Chờ duyệt</option>
                        <option value="BORROWED" ${param.status == 'BORROWED' ? 'selected' : ''}>Đang mượn</option>
                        <option value="RETURNED" ${param.status == 'RETURNED' ? 'selected' : ''}>Đã trả</option>
                        <option value="OVERDUE" ${param.status == 'OVERDUE' ? 'selected' : ''}>Quá hạn</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="fas fa-search me-2"></i>Tìm kiếm
                    </button>
                </div>
            </form>
        </div>
    </div>

    <div class="table-responsive">
        <table class="table table-striped table-hover">
            <thead class="table-primary">
                <tr>
                    <th>ID</th>
                    <th>Tên sách</th>
                    <th>Người mượn</th>
                    <th>Ngày mượn</th>
                    <th>Hạn trả</th>
                    <th>Ngày trả</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="record" items="${borrowRecords}">
                    <tr>
                        <td>${record.id}</td>
                        <td>${record.book.title}</td>
                        <td>${record.user.fullName}</td>
                        <td><fmt:formatDate value="${record.borrowDate}" pattern="dd/MM/yyyy"/></td>
                        <td><fmt:formatDate value="${record.dueDate}" pattern="dd/MM/yyyy"/></td>
                        <td>
                            <c:if test="${record.returnDate != null}">
                                <fmt:formatDate value="${record.returnDate}" pattern="dd/MM/yyyy"/>
                            </c:if>
                        </td>
                        <td>
                            <span class="status-badge status-${record.status.toLowerCase()}">
                                <c:choose>
                                    <c:when test="${record.status == 'PENDING'}">Chờ duyệt</c:when>
                                    <c:when test="${record.status == 'BORROWED'}">Đang mượn</c:when>
                                    <c:when test="${record.status == 'RETURNED'}">Đã trả</c:when>
                                    <c:when test="${record.status == 'OVERDUE'}">Quá hạn</c:when>
                                    <c:otherwise>${record.status}</c:otherwise>
                                </c:choose>
                            </span>
                        </td>
                        <td>
                            <c:if test="${sessionScope.user.role == 'ADMIN' || sessionScope.user.role == 'LIBRARIAN'}">
                                <c:if test="${record.status == 'PENDING'}">
                                    <a href="${pageContext.request.contextPath}/borrow/approve?id=${record.id}" 
                                       class="btn btn-success btn-sm"
                                       onclick="return confirm('Xác nhận duyệt yêu cầu mượn sách?')">
                                        <i class="fas fa-check"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/borrow/reject?id=${record.id}" 
                                       class="btn btn-danger btn-sm"
                                       onclick="return confirm('Xác nhận từ chối yêu cầu mượn sách?')">
                                        <i class="fas fa-times"></i>
                                    </a>
                                </c:if>
                            </c:if>
                            
                            <c:if test="${record.status == 'BORROWED'}">
                                <a href="${pageContext.request.contextPath}/borrow/return?id=${record.id}" 
                                   class="btn btn-primary btn-sm"
                                   onclick="return confirm('Xác nhận trả sách?')">
                                    <i class="fas fa-undo-alt"></i> Trả sách
                                </a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <c:if test="${empty borrowRecords}">
        <div class="alert alert-info text-center">
            <i class="fas fa-info-circle me-2"></i>Không có dữ liệu mượn sách
        </div>
    </c:if>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
// Show success/error messages
<c:if test="${not empty sessionScope.successMessage}">
    alert("${sessionScope.successMessage}");
    <c:remove var="successMessage" scope="session" />
</c:if>
<c:if test="${not empty sessionScope.errorMessage}">
    alert("${sessionScope.errorMessage}");
    <c:remove var="errorMessage" scope="session" />
</c:if>
</script>
</body>
</html> 