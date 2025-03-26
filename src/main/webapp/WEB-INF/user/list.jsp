<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý người dùng - Hệ thống Quản lý Thư viện</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .modal-header {
            background: linear-gradient(45deg, #2980b9, #8e44ad);
            color: white;
        }
        .status-badge {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.9em;
        }
        .status-active { background-color: #d4edda; }
        .status-inactive { background-color: #f8d7da; }
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/includes/header.jsp" %>

<div class="container mt-4">
    <div class="row mb-3">
        <div class="col-md-6">
            <h2><i class="fas fa-users me-2"></i>Quản lý người dùng</h2>
        </div>
        <div class="col-md-6 text-end">
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addUserModal">
                <i class="fas fa-user-plus me-2"></i>Thêm người dùng mới
            </button>
        </div>
    </div>

    <!-- Search Form -->
    <div class="card mb-4">
        <div class="card-body">
            <form class="row g-3">
                <div class="col-md-4">
                    <input type="text" class="form-control" name="search" placeholder="Tìm kiếm..." value="${param.search}">
                </div>
                <div class="col-md-3">
                    <select class="form-select" name="role">
                        <option value="">Tất cả vai trò</option>
                        <option value="ADMIN" ${param.role == 'ADMIN' ? 'selected' : ''}>Admin</option>
                        <option value="LIBRARIAN" ${param.role == 'LIBRARIAN' ? 'selected' : ''}>Thủ thư</option>
                        <option value="USER" ${param.role == 'USER' ? 'selected' : ''}>Người dùng</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <select class="form-select" name="status">
                        <option value="">Tất cả trạng thái</option>
                        <option value="ACTIVE" ${param.status == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option>
                        <option value="INACTIVE" ${param.status == 'INACTIVE' ? 'selected' : ''}>Không hoạt động</option>
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

    <!-- Users Table -->
    <div class="table-responsive">
        <table class="table table-striped table-hover">
            <thead class="table-primary">
                <tr>
                    <th>Avatar</th>
                    <th>Tên đăng nhập</th>
                    <th>Họ tên</th>
                    <th>Email</th>
                    <th>Số điện thoại</th>
                    <th>Vai trò</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="user" items="${users}">
                    <tr>
                        <td>
                            <img src="${not empty user.avatar ? user.avatar : 'https://via.placeholder.com/40'}" 
                                 alt="Avatar" class="user-avatar">
                        </td>
                        <td>${user.username}</td>
                        <td>${user.fullName}</td>
                        <td>${user.email}</td>
                        <td>${user.phone}</td>
                        <td>${user.role}</td>
                        <td>
                            <span class="status-badge status-${user.status.toLowerCase()}">
                                ${user.status}
                            </span>
                        </td>
                        <td>
                            <button class="btn btn-warning btn-sm" onclick="editUser(${user.id})">
                                <i class="fas fa-edit"></i>
                            </button>
                            <c:if test="${sessionScope.user.id != user.id}">
                                <a href="${pageContext.request.contextPath}/admin/users/delete?id=${user.id}" 
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('Bạn có chắc muốn xóa người dùng này?')">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Add User Modal -->
    <div class="modal fade" id="addUserModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Thêm người dùng mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="${pageContext.request.contextPath}/admin/users/add" method="post">
                        <div class="mb-3">
                            <label for="username" class="form-label">Tên đăng nhập</label>
                            <input type="text" class="form-control" id="username" name="username" required>
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label">Mật khẩu</label>
                            <input type="password" class="form-control" id="password" name="password" required>
                        </div>
                        <div class="mb-3">
                            <label for="fullName" class="form-label">Họ tên</label>
                            <input type="text" class="form-control" id="fullName" name="fullName" required>
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" name="email">
                        </div>
                        <div class="mb-3">
                            <label for="phone" class="form-label">Số điện thoại</label>
                            <input type="tel" class="form-control" id="phone" name="phone">
                        </div>
                        <div class="mb-3">
                            <label for="role" class="form-label">Vai trò</label>
                            <select class="form-select" id="role" name="role" required>
                                <option value="USER">Người dùng</option>
                                <option value="LIBRARIAN">Thủ thư</option>
                                <option value="ADMIN">Admin</option>
                            </select>
                        </div>
                        <div class="text-end">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">Thêm</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit User Modal -->
    <div class="modal fade" id="editUserModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Chỉnh sửa người dùng</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="${pageContext.request.contextPath}/admin/users/edit" method="post">
                        <input type="hidden" id="editId" name="id">
                        <div class="mb-3">
                            <label for="editUsername" class="form-label">Tên đăng nhập</label>
                            <input type="text" class="form-control" id="editUsername" name="username" required>
                        </div>
                        <div class="mb-3">
                            <label for="editPassword" class="form-label">Mật khẩu (để trống nếu không đổi)</label>
                            <input type="password" class="form-control" id="editPassword" name="password">
                        </div>
                        <div class="mb-3">
                            <label for="editFullName" class="form-label">Họ tên</label>
                            <input type="text" class="form-control" id="editFullName" name="fullName" required>
                        </div>
                        <div class="mb-3">
                            <label for="editEmail" class="form-label">Email</label>
                            <input type="email" class="form-control" id="editEmail" name="email">
                        </div>
                        <div class="mb-3">
                            <label for="editPhone" class="form-label">Số điện thoại</label>
                            <input type="tel" class="form-control" id="editPhone" name="phone">
                        </div>
                        <div class="mb-3">
                            <label for="editRole" class="form-label">Vai trò</label>
                            <select class="form-select" id="editRole" name="role" required>
                                <option value="USER">Người dùng</option>
                                <option value="LIBRARIAN">Thủ thư</option>
                                <option value="ADMIN">Admin</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="editStatus" class="form-label">Trạng thái</label>
                            <select class="form-select" id="editStatus" name="status" required>
                                <option value="ACTIVE">Hoạt động</option>
                                <option value="INACTIVE">Không hoạt động</option>
                            </select>
                        </div>
                        <div class="text-end">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">Lưu</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
  function editUser(id) {
    fetch('${pageContext.request.contextPath}/admin/users/get?id=' + id)
    .then(response => {
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      return response.json();
    })
    .then(user => {
      if (user.error) {
        throw new Error(user.error);
      }

      document.getElementById('editId').value = user.id;
      document.getElementById('editUsername').value = user.username;
      document.getElementById('editFullName').value = user.fullName;
      document.getElementById('editEmail').value = user.email || '';
      document.getElementById('editPhone').value = user.phone || '';
      document.getElementById('editRole').value = user.role;
      document.getElementById('editStatus').value = user.status;

      new bootstrap.Modal(document.getElementById('editUserModal')).show();
    })
    .catch(error => {
      alert('Lỗi khi tải thông tin người dùng: ' + error.message);
      console.error('Error:', error);
    });
  }

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