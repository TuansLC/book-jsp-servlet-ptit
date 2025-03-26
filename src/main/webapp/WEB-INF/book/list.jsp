<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Danh sách sách - Hệ thống Quản lý Thư viện</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .modal-header {
            background: linear-gradient(45deg, #2980b9, #8e44ad);
            color: white;
        }
        .btn-action {
            margin: 0 2px;
        }
        .search-box {
            max-width: 300px;
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/includes/header.jsp" %>
<div class="container mt-4">
    <div class="row mb-3">
        <div class="col-md-6">
            <h2><i class="fas fa-book me-2"></i>Danh sách sách</h2>
        </div>
        <div class="col-md-6 text-end">
            <c:if test="${sessionScope.user.role == 'ADMIN'}">
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addBookModal">
                    <i class="fas fa-plus me-2"></i>Thêm sách mới
                </button>
            </c:if>
        </div>
    </div>

    <div class="row mb-3">
        <div class="col">
            <form action="${pageContext.request.contextPath}/books/search" method="get" class="d-flex search-box">
                <input type="text" name="title" class="form-control me-2" placeholder="Tìm kiếm theo tên sách..." 
                       value="${searchTitle}">
                <button type="submit" class="btn btn-outline-primary">
                    <i class="fas fa-search"></i>
                </button>
            </form>
        </div>
    </div>

    <!-- Add Book Modal -->
    <div class="modal fade" id="addBookModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-plus-circle me-2"></i>Thêm sách mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/books/add" method="post" id="addBookForm">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="title" class="form-label">Tên sách</label>
                            <input type="text" class="form-control" id="title" name="title" required>
                        </div>

                        <div class="mb-3">
                            <label for="author" class="form-label">Tác giả</label>
                            <input type="text" class="form-control" id="author" name="author" required>
                        </div>

                        <div class="mb-3">
                            <label for="category" class="form-label">Thể loại</label>
                            <select class="form-select" id="category" name="category" required>
                                <option value="">Chọn thể loại</option>
                                <option value="Công nghệ thông tin">Công nghệ thông tin</option>
                                <option value="Toán học">Toán học</option>
                                <option value="Văn học">Văn học</option>
                                <option value="Khoa học">Khoa học</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="quantity" class="form-label">Số lượng</label>
                            <input type="number" class="form-control" id="quantity" name="quantity" required min="0">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-2"></i>Hủy
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-2"></i>Thêm sách
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Book Modal -->
    <div class="modal fade" id="editBookModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-edit me-2"></i>Chỉnh sửa sách</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/books/edit" method="post" id="editBookForm">
                    <input type="hidden" id="editBookId" name="id">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="editTitle" class="form-label">Tên sách</label>
                            <input type="text" class="form-control" id="editTitle" name="title" required>
                        </div>

                        <div class="mb-3">
                            <label for="editAuthor" class="form-label">Tác giả</label>
                            <input type="text" class="form-control" id="editAuthor" name="author" required>
                        </div>

                        <div class="mb-3">
                            <label for="editCategory" class="form-label">Thể loại</label>
                            <select class="form-select" id="editCategory" name="category" required>
                                <option value="">Chọn thể loại</option>
                                <option value="Công nghệ thông tin">Công nghệ thông tin</option>
                                <option value="Toán học">Toán học</option>
                                <option value="Văn học">Văn học</option>
                                <option value="Khoa học">Khoa học</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="editQuantity" class="form-label">Số lượng</label>
                            <input type="number" class="form-control" id="editQuantity" name="quantity" required min="0">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-2"></i>Hủy
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-2"></i>Lưu thay đổi
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <table class="table table-striped table-hover">
        <thead class="table-primary">
            <tr>
                <th>ID</th>
                <th>Tên sách</th>
                <th>Tác giả</th>
                <th>Số lượng</th>
                <th>Thể loại</th>
                <th>Thao tác</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="book" items="${books}">
                <tr>
                    <td>${book.id}</td>
                    <td>${book.title}</td>
                    <td>${book.author}</td>
                    <td>${book.quantity}</td>
                    <td>${book.category}</td>
                    <td>
                        <c:if test="${sessionScope.user.role == 'ADMIN'}">
                            <button type="button" class="btn btn-warning btn-sm btn-action" 
                                    onclick="editBook(${book.id}, '${book.title}', '${book.author}', '${book.category}', ${book.quantity})">
                                <i class="fas fa-edit"></i>
                            </button>
                            <a href="${pageContext.request.contextPath}/books/delete?id=${book.id}" 
                               class="btn btn-danger btn-sm btn-action"
                               onclick="return confirm('Bạn có chắc muốn xóa sách này?')">
                                <i class="fas fa-trash"></i>
                            </a>
                        </c:if>
                        <c:if test="${sessionScope.user != null}">
                            <a href="${pageContext.request.contextPath}/borrow/add?bookId=${book.id}" 
                               class="btn btn-success btn-sm btn-action">
                                <i class="fas fa-book-reader"></i>
                            </a>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
function editBook(id, title, author, category, quantity) {
    document.getElementById('editBookId').value = id;
    document.getElementById('editTitle').value = title;
    document.getElementById('editAuthor').value = author;
    document.getElementById('editCategory').value = category;
    document.getElementById('editQuantity').value = quantity;
    
    new bootstrap.Modal(document.getElementById('editBookModal')).show();
}

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
