// Admin Dashboard JavaScript - BEM Methodology

// Global variables for managing state
let currentDeleteItem = null;
let currentEditItem = null;
let adminUsername = 'ADMIN'; // Sẽ được load từ database

// Initialize dashboard
document.addEventListener('DOMContentLoaded', function() {
    loadAdminInfo();
    loadAllData();
});

// Navigation functionality
document.addEventListener('click', function(e) {
    if (e.target.matches('.sidebar__nav-link')) {
        const target = e.target.getAttribute('data-target');
        showTable(target);
        
        // Update active nav link
        document.querySelectorAll('.sidebar__nav-link').forEach(link => {
            link.classList.remove('sidebar__nav-link--active');
        });
        e.target.classList.add('sidebar__nav-link--active');
    }
});

// Show specific table
function showTable(tableId) {
    // Hide all tables with fade effect
    document.querySelectorAll('.table-container').forEach(container => {
        container.style.opacity = '0';
        setTimeout(() => {
            container.classList.remove('table-container--active');
        }, 150);
    });
    
    // Show target table with fade effect
    setTimeout(() => {
        const targetTable = document.getElementById(tableId);
        if (targetTable) {
            targetTable.classList.add('table-container--active');
            setTimeout(() => {
                targetTable.style.opacity = '1';
            }, 50);
        }
    }, 200);
}

// Modal functionality
function openModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.classList.add('modal--active');
        document.body.style.overflow = 'hidden';
    }
}

function closeModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.classList.remove('modal--active');
        document.body.style.overflow = 'auto';
        
        // Reset form if exists
        const form = modal.querySelector('form');
        if (form) {
            form.reset();
        }
        
        currentEditItem = null;
    }
}

// Load admin info from database
async function loadAdminInfo() {
    try {
        // Thay thế bằng API call thực tế
        // const response = await fetch('/api/admin/info');
        // const adminData = await response.json();
        // adminUsername = adminData.username;
        
        // Temporary demo data
        adminUsername = 'ADMIN_USER';
        document.getElementById('adminName').textContent = adminUsername.toUpperCase();
        document.querySelector('.sidebar__avatar').textContent = adminUsername.charAt(0).toUpperCase();
    } catch (error) {
        console.error('Error loading admin info:', error);
    }
}

// Load all data from database
async function loadAllData() {
    await loadStaffData();
    await loadProductsData();
    // Thêm các function load khác khi cần
}

// Load staff data from database
async function loadStaffData() {
    try {
        // Thay thế bằng API call thực tế
        // const response = await fetch('/api/staff');
        // const staffData = await response.json();
        
        // Temporary demo data
        const staffData = [
            { id: 1, username: 'nguyenvana', email: 'nguyenvana@email.com', code: 'NV001' },
            { id: 2, username: 'tranthib', email: 'tranthib@email.com', code: 'NV002' }
        ];
        
        renderStaffTable(staffData);
    } catch (error) {
        console.error('Error loading staff data:', error);
    }
}

// Load products data from database
async function loadProductsData() {
    try {
        // Thay thế bằng API call thực tế
        // const response = await fetch('/api/products');
        // const productsData = await response.json();
        
        // Temporary demo data
        const productsData = [
            { 
                id: 1, 
                name: 'Laptop Dell XPS 13', 
                image: 'https://via.placeholder.com/50', 
                quantity: 25, 
                category: 'Laptop', 
                price: 25000000, 
                description: 'Laptop cao cấp cho doanh nhân' 
            },
            { 
                id: 2, 
                name: 'iPhone 15 Pro', 
                image: 'https://via.placeholder.com/50', 
                quantity: 50, 
                category: 'Smartphone', 
                price: 30000000, 
                description: 'Điện thoại thông minh mới nhất' 
            }
        ];
        
        renderProductsTable(productsData);
    } catch (error) {
        console.error('Error loading products data:', error);
    }
}

// Render staff table
function renderStaffTable(data) {
    const tbody = document.getElementById('staffTableBody');
    tbody.innerHTML = '';
    
    if (data.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="5" class="data-table__cell" style="text-align: center; padding: 40px;">
                    <div class="empty-state">
                        <div class="empty-state__icon">📋</div>
                        <div class="empty-state__message">Chưa có dữ liệu nhân viên</div>
                        <div class="empty-state__description">Hãy thêm nhân viên đầu tiên</div>
                    </div>
                </td>
            </tr>
        `;
        return;
    }
    
    data.forEach((staff, index) => {
        const row = `
            <tr class="data-table__row">
                <td class="data-table__cell">${staff.id}</td>
                <td class="data-table__cell">${staff.username}</td>
                <td class="data-table__cell">${staff.email}</td>
                <td class="data-table__cell">${staff.code}</td>
                <td class="data-table__cell">
                    <div class="action-buttons">
                        <button class="action-buttons__btn action-buttons__btn--edit" onclick="editStaff(${staff.id})">Edit</button>
                        <button class="action-buttons__btn action-buttons__btn--delete" onclick="deleteStaff(${staff.id})">Delete</button>
                    </div>
                </td>
            </tr>
        `;
        tbody.innerHTML += row;
    });
}

// Render products table
function renderProductsTable(data) {
    const tbody = document.getElementById('productsTableBody');
    tbody.innerHTML = '';
    
    if (data.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="8" class="data-table__cell" style="text-align: center; padding: 40px;">
                    <div class="empty-state">
                        <div class="empty-state__icon">📦</div>
                        <div class="empty-state__message">Chưa có sản phẩm nào</div>
                        <div class="empty-state__description">Hãy thêm sản phẩm đầu tiên</div>
                    </div>
                </td>
            </tr>
        `;
        return;
    }
    
    data.forEach((product, index) => {
        const row = `
            <tr class="data-table__row">
                <td class="data-table__cell">${product.id}</td>
                <td class="data-table__cell">
                    <img src="${product.image}" alt="${product.name}" class="data-table__image">
                </td>
                <td class="data-table__cell">${product.name}</td>
                <td class="data-table__cell">${product.quantity}</td>
                <td class="data-table__cell">${product.category}</td>
                <td class="data-table__cell">${formatCurrency(product.price)}</td>
                <td class="data-table__cell">${product.description}</td>
                <td class="data-table__cell">
                    <div class="action-buttons">
                        <button class="action-buttons__btn action-buttons__btn--edit" onclick="editProduct(${product.id})">Edit</button>
                        <button class="action-buttons__btn action-buttons__btn--delete" onclick="deleteProduct(${product.id})">Delete</button>
                    </div>
                </td>
            </tr>
        `;
        tbody.innerHTML += row;
    });
}

// Format currency
function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(amount);
}

// Staff management functions
function editStaff(id) {
    // Load staff data và hiển thị modal
    currentEditItem = { type: 'staff', id: id };
    // Tại đây bạn sẽ load dữ liệu từ database và fill vào form
    openModal('addStaffModal');
    document.querySelector('#addStaffModal .modal__title').textContent = 'Sửa Nhân Viên';
}

function deleteStaff(id) {
    currentDeleteItem = { type: 'staff', id: id };
    openModal('deleteModal');
}

function saveStaff() {
    const username = document.getElementById('staffUsername').value;
    const email = document.getElementById('staffEmail').value;
    const code = document.getElementById('staffCode').value;
    
    if (!username || !email || !code) {
        alert('Vui lòng điền đầy đủ thông tin');
        return;
    }
    
    // Tại đây bạn sẽ gửi dữ liệu lên server
    console.log('Saving staff:', { username, email, code });
    
    closeModal('addStaffModal');
    loadStaffData(); // Reload data
}

// Product management functions
function editProduct(id) {
    currentEditItem = { type: 'product', id: id };
    openModal('addProductModal');
    document.querySelector('#addProductModal .modal__title').textContent = 'Sửa Sản Phẩm';
}

function deleteProduct(id) {
    currentDeleteItem = { type: 'product', id: id };
    openModal('deleteModal');
}

function saveProduct() {
    const name = document.getElementById('productName').value;
    const quantity = document.getElementById('productQuantity').value;
    const category = document.getElementById('productCategory').value;
    const price = document.getElementById('productPrice').value;
    const description = document.getElementById('productDescription').value;
    
    if (!name || !quantity || !category || !price) {
        alert('Vui lòng điền đầy đủ thông tin bắt buộc');
        return;
    }
    
    // Tại đây bạn sẽ gửi dữ liệu lên server
    console.log('Saving product:', { name, quantity, category, price, description });
    
    closeModal('addProductModal');
    loadProductsData(); // Reload data
}

// Delete confirmation
function confirmDelete() {
    if (currentDeleteItem) {
        console.log('Deleting:', currentDeleteItem);
        // Tại đây bạn sẽ gửi request xóa lên server
        
        closeModal('deleteModal');
        
        // Reload appropriate data
        if (currentDeleteItem.type === 'staff') {
            loadStaffData();
        } else if (currentDeleteItem.type === 'product') {
            loadProductsData();
        }
        
        currentDeleteItem = null;
    }
}

// Logout function
function logout() {
    if (confirm('Bạn có chắc chắn muốn đăng xuất?')) {
        // Redirect to login page
        window.location.href = '/login';
    }
}

// Additional utility functions

// Show loading state
function showLoading(tableId) {
    const tbody = document.querySelector(`#${tableId} tbody`);
    if (tbody) {
        tbody.innerHTML = `
            <tr>
                <td colspan="100%" class="data-table__cell" style="text-align: center; padding: 40px;">
                    <div class="loading-state">
                        <div class="loading-spinner"></div>
                        <div>Đang tải dữ liệu...</div>
                    </div>
                </td>
            </tr>
        `;
    }
}

// Show error state
function showError(tableId, message) {
    const tbody = document.querySelector(`#${tableId} tbody`);
    if (tbody) {
        tbody.innerHTML = `
            <tr>
                <td colspan="100%" class="data-table__cell" style="text-align: center; padding: 40px;">
                    <div class="error-state">
                        <div class="error-state__icon">⚠️</div>
                        <div class="error-state__message">Có lỗi xảy ra</div>
                        <div class="error-state__description">${message}</div>
                        <button class="add-button" onclick="loadAllData()">Thử lại</button>
                    </div>
                </td>
            </tr>
        `;
    }
}

// Form validation
function validateForm(formId) {
    const form = document.getElementById(formId);
    const inputs = form.querySelectorAll('input[required], textarea[required]');
    let isValid = true;
    
    inputs.forEach(input => {
        if (!input.value.trim()) {
            input.style.borderColor = '#dc3545';
            isValid = false;
        } else {
            input.style.borderColor = '#ddd';
        }
    });
    
    return isValid;
}

// Debounce function for search
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Search functionality (to be implemented)
function searchTable(query, tableType) {
    // Implementation for table search
    console.log(`Searching ${tableType} for: ${query}`);
}

// Export functions for external use
window.AdminDashboard = {
    showTable,
    openModal,
    closeModal,
    loadAllData,
    formatCurrency,
    validateForm
};