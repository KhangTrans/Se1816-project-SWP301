<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard</title>
        <%
            String contextPath = request.getContextPath();
        %>
        <link rel="stylesheet" href="<%= contextPath%>/css/Admin.css">
    </head>
    <body>
        <div class="dashboard">
            <!-- Sidebar -->
            <nav class="sidebar">
                <div class="sidebar__header">
                    <div class="sidebar__user">
                        <div class="sidebar__avatar">A</div>
                        <div class="sidebar__greeting">
                            WELCOME<br>
                            <span class="sidebar__admin-name" id="adminName">ADMIN</span>
                        </div>
                    </div>
                </div>

                <ul class="sidebar__nav">
                    <li class="sidebar__nav-item">
                        <button class="sidebar__nav-link sidebar__nav-link--active" data-target="staff">
                            VIEW STAFF LIST
                        </button>
                    </li>
                    <li class="sidebar__nav-item">
                        <button class="sidebar__nav-link" data-target="products">
                            VIEW PRODUCTS LIST
                        </button>
                    </li>
                    <li class="sidebar__nav-item">
                        <button class="sidebar__nav-link" data-target="orders">
                            VIEW ORDER LIST
                        </button>
                    </li>
                    <li class="sidebar__nav-item">
                        <button class="sidebar__nav-link" data-target="accounts">
                            VIEW ACCOUNT LIST
                        </button>
                    </li>
                    <li class="sidebar__nav-item">
                        <button class="sidebar__nav-link" data-target="vouchers">
                            VIEW VOUCHERS LIST
                        </button>
                    </li>
                </ul>

                <button class="sidebar__logout" onclick="logout()">
                    LOGOUT
                </button>
            </nav>

            <!-- Main Content -->
            <main class="main-content">
                <div class="main-content__header">
                    <h1 class="main-content__title">Admin Dashboard</h1>
                    <p class="main-content__subtitle">System and Data Management</p>
                </div>

                <!-- Staff Table -->
                <div class="table-container table-container--active" id="staff">
                    <div class="table-container__header">
                        <h2 class="table-container__title">Staff List</h2>
                        <p class="table-container__description">Manage staff information in the system</p>
                    </div>
                    <div class="table-container__content">
                        <button class="add-button" onclick="openModal('addStaffModal')">+ Add Staff</button>
                        <table class="data-table">
                            <thead class="data-table__header">
                                <tr>
                                    <th class="data-table__header-cell">No</th>
                                    <th class="data-table__header-cell">Username</th>
                                    <th class="data-table__header-cell">Email</th>
                                    <th class="data-table__header-cell">Staff Code</th>
                                    <th class="data-table__header-cell">Action</th>
                                </tr>
                            </thead>
                            <tbody id="staffTableBody">
                                <tr class="data-table__row">
                                    <td class="data-table__cell">1</td>
                                    <td class="data-table__cell">nguyenvana</td>
                                    <td class="data-table__cell">nguyenvana@email.com</td>
                                    <td class="data-table__cell">STF001</td>
                                    <td class="data-table__cell">
                                        <div class="action-buttons">
                                            <button class="action-buttons__btn action-buttons__btn--edit" onclick="editStaff(1)">Edit</button>
                                            <button class="action-buttons__btn action-buttons__btn--delete" onclick="deleteStaff(1)">Delete</button>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Products Table -->
                <div class="table-container" id="products">
                    <div class="table-container__header">
                        <h2 class="table-container__title">Product List</h2>
                        <p class="table-container__description">Manage inventory and product details</p>
                    </div>
                    <div class="table-container__content">
                        <button class="add-button" onclick="openModal('addProductModal')">+ Add Product</button>
                        <table class="data-table">
                            <thead class="data-table__header">
                                <tr>
                                    <th class="data-table__header-cell">No</th>
                                    <th class="data-table__header-cell">Image</th>
                                    <th class="data-table__header-cell">Product Name</th>
                                    <th class="data-table__header-cell">Quantity</th>
                                    <th class="data-table__header-cell">Category</th>
                                    <th class="data-table__header-cell">Price</th>
                                    <th class="data-table__header-cell">Description</th>
                                    <th class="data-table__header-cell">Action</th>
                                </tr>
                            </thead>
                            <tbody id="productsTableBody">
                                <tr class="data-table__row">
                                    <td class="data-table__cell">1</td>
                                    <td class="data-table__cell">
                                        <img src="https://via.placeholder.com/50" alt="Product" class="data-table__image">
                                    </td>
                                    <td class="data-table__cell">Sample Product</td>
                                    <td class="data-table__cell">100</td>
                                    <td class="data-table__cell">Electronics</td>
                                    <td class="data-table__cell">500,000₫</td>
                                    <td class="data-table__cell">Product description...</td>
                                    <td class="data-table__cell">
                                        <div class="action-buttons">
                                            <button class="action-buttons__btn action-buttons__btn--edit" onclick="editProduct(1)">Edit</button>
                                            <button class="action-buttons__btn action-buttons__btn--delete" onclick="deleteProduct(1)">Delete</button>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Orders Table -->
                <div class="table-container" id="orders">
                    <div class="table-container__header">
                        <h2 class="table-container__title">Order List</h2>
                        <p class="table-container__description">Track and manage customer orders</p>
                    </div>
                    <div class="table-container__content">
                        <button class="add-button" onclick="openModal('addOrderModal')">+ Add Order</button>
                        <table class="data-table">
                            <thead class="data-table__header">
                                <tr>
                                    <th class="data-table__header-cell">No</th>
                                    <th class="data-table__header-cell">Order ID</th>
                                    <th class="data-table__header-cell">Customer</th>
                                    <th class="data-table__header-cell">Order Date</th>
                                    <th class="data-table__header-cell">Total</th>
                                    <th class="data-table__header-cell">Status</th>
                                    <th class="data-table__header-cell">Action</th>
                                </tr>
                            </thead>
                            <tbody id="ordersTableBody"></tbody>
                        </table>
                    </div>
                </div>

                <!-- Accounts Table -->
                <div class="table-container" id="accounts">
                    <div class="table-container__header">
                        <h2 class="table-container__title">Account List</h2>
                        <p class="table-container__description">Manage user accounts</p>
                    </div>
                    <div class="table-container__content">
                        <button class="add-button" onclick="openModal('addAccountModal')">+ Add Account</button>
                        <table class="data-table">
                            <thead class="data-table__header">
                                <tr>
                                    <th class="data-table__header-cell">No</th>
                                    <th class="data-table__header-cell">Username</th>
                                    <th class="data-table__header-cell">Email</th>
                                    <th class="data-table__header-cell">Full Name</th>
                                    <th class="data-table__header-cell">Role</th>
                                    <th class="data-table__header-cell">Status</th>
                                    <th class="data-table__header-cell">Action</th>
                                </tr>
                            </thead>
                            <tbody id="accountsTableBody"></tbody>
                        </table>
                    </div>
                </div>

                <!-- Vouchers Table -->
                <div class="table-container" id="vouchers">
                    <div class="table-container__header">
                        <h2 class="table-container__title">Voucher List</h2>
                        <p class="table-container__description">Manage discount codes and promotions</p>
                    </div>
                    <div class="table-container__content">
                        <button class="add-button" onclick="openModal('addVoucherModal')">+ Add Voucher</button>
                        <table class="data-table">
                            <thead class="data-table__header">
                                <tr>
                                    <th class="data-table__header-cell">No</th>
                                    <th class="data-table__header-cell">Voucher Code</th>
                                    <th class="data-table__header-cell">Voucher Name</th>
                                    <th class="data-table__header-cell">Discount</th>
                                    <th class="data-table__header-cell">Start Date</th>
                                    <th class="data-table__header-cell">End Date</th>
                                    <th class="data-table__header-cell">Status</th>
                                    <th class="data-table__header-cell">Action</th>
                                </tr>
                            </thead>
                            <tbody id="vouchersTableBody"></tbody>
                        </table>
                    </div>
                </div>
            </main>
        </div>

        <!-- Modals -->

        <!-- Add/Edit Staff Modal -->
        <div class="modal" id="addStaffModal">
            <div class="modal__content">
                <div class="modal__header">
                    <h3 class="modal__title">Add/Edit Staff</h3>
                    <button class="modal__close" onclick="closeModal('addStaffModal')">&times;</button>
                </div>
                <div class="modal__body">
                    <form id="staffForm">
                        <div class="modal__form-group">
                            <label class="modal__label">Username:</label>
                            <input type="text" class="modal__input" id="staffUsername" required>
                        </div>
                        <div class="modal__form-group">
                            <label class="modal__label">Email:</label>
                            <input type="email" class="modal__input" id="staffEmail" required>
                        </div>
                        <div class="modal__form-group">
                            <label class="modal__label">Staff Code:</label>
                            <input type="text" class="modal__input" id="staffCode" required>
                        </div>
                    </form>
                </div>
                <div class="modal__footer">
                    <button class="modal__btn modal__btn--secondary" onclick="closeModal('addStaffModal')">Cancel</button>
                    <button class="modal__btn modal__btn--primary" onclick="saveStaff()">Save</button>
                </div>
            </div>
        </div>

        <!-- Add/Edit Product Modal -->
        <div class="modal" id="addProductModal">
            <div class="modal__content">
                <div class="modal__header">
                    <h3 class="modal__title">Add/Edit Product</h3>
                    <button class="modal__close" onclick="closeModal('addProductModal')">&times;</button>
                </div>
                <div class="modal__body">
                    <form id="productForm">
                        <div class="modal__form-group">
                            <label class="modal__label">Product Name:</label>
                            <input type="text" class="modal__input" id="productName" required>
                        </div>
                        <div class="modal__form-group">
                            <label class="modal__label">Image:</label>
                            <input type="file" class="modal__input" id="productImage" accept="image/*">
                        </div>
                        <div class="modal__form-group">
                            <label class="modal__label">Quantity:</label>
                            <input type="number" class="modal__input" id="productQuantity" required>
                        </div>
                        <div class="modal__form-group">
                            <label class="modal__label">Category:</label>
                            <input type="text" class="modal__input" id="productCategory" required>
                        </div>
                        <div class="modal__form-group">
                            <label class="modal__label">Price:</label>
                            <input type="number" class="modal__input" id="productPrice" required>
                        </div>
                        <div class="modal__form-group">
                            <label class="modal__label">Description:</label>
                            <textarea class="modal__textarea" id="productDescription"></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal__footer">
                    <button class="modal__btn modal__btn--secondary" onclick="closeModal('addProductModal')">Cancel</button>
                    <button class="modal__btn modal__btn--primary" onclick="saveProduct()">Save</button>
                </div>
            </div>
        </div>

        <!-- Delete Confirmation Modal -->
        <div class="modal" id="deleteModal">
            <div class="modal__content">
                <div class="modal__header">
                    <h3 class="modal__title">Delete Confirmation</h3>
                    <button class="modal__close" onclick="closeModal('deleteModal')">&times;</button>
                </div>
                <div class="modal__body">
                    <p>Are you sure you want to delete this item?</p>
                </div>
                <div class="modal__footer">
                    <button class="modal__btn modal__btn--secondary" onclick="closeModal('deleteModal')">Cancel</button>
                    <button class="modal__btn modal__btn--primary" style="background-color: #dc3545;" onclick="confirmDelete()">Delete</button>
                </div>
            </div>
        </div>

        <script src="./js/Admin.js"></script>
    </body>
</html>
