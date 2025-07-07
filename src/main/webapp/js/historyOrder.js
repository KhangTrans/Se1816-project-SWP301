/**
 * History Order JavaScript
 * Xử lý các chức năng chỉnh sửa và xóa đơn hàng trong trang lịch sử đơn hàng
 */

// DOM Elements - We'll initialize these after the DOM is fully loaded
let editModal;
let editForm;
let closeModalBtn;
let responseMessage;

// Dữ liệu đơn hàng hiện tại đang được chỉnh sửa
let currentOrder = null;

// Modal functions similar to admin.js
function openModal(id) {
    const modal = document.getElementById(id);
    if (modal) {
        modal.style.display = 'flex';
    }
}

function closeModal(id) {
    const modal = document.getElementById(id);
    if (modal)
        modal.style.display = 'none';
}

/**
 * Mở modal chỉnh sửa đơn hàng
 * @param {number} orderId - ID của đơn hàng cần chỉnh sửa
 */
function openEditModal(orderId) {
    // Kiểm tra xem đơn hàng có bị hủy hoặc đã giao hàng không
    const orderCard = document.getElementById(`order-${orderId}`);
    if (orderCard) {
        const statusElement = orderCard.querySelector('.product-info__status');
        if (statusElement && (statusElement.classList.contains('product-info__status--cancelled') || 
                             statusElement.classList.contains('product-info__status--shipped'))) {
            // Hiển thị thông báo và không mở modal nếu đơn hàng đã bị hủy hoặc đã giao hàng
            const status = statusElement.textContent.trim().toLowerCase();
            const message = status === 'cancelled' ? 
                'Không thể chỉnh sửa đơn hàng đã hủy' : 
                'Không thể chỉnh sửa đơn hàng đã giao';
            showToast(message, 'error');
            return; // Dừng hàm, không mở modal
        }
    }
    
    // Xây dựng URL đúng format
    const baseUrl = window.location.origin;
    const pathArray = window.location.pathname.split('/');
    const contextPath = pathArray[1] ? '/' + pathArray[1] : '';
    
    // Ghi log giá trị orderId
    console.log("Opening edit modal for orderId:", orderId);
    
    // Đảm bảo đường dẫn URL đầy đủ và chính xác
    const url = `${baseUrl}${contextPath}/historyorder/details?id=${orderId}`;
    console.log("Requesting order data from URL:", url);
    
    fetch(url)
        .then(response => {
            console.log("Response status:", response.status);
            if (!response.ok) {
                throw new Error(`HTTP error! Status: ${response.status}`);
            }
            return response.json();
        })
        .then(data => {
            console.log("Order data received:", data);
            
            if (data.success) {
                const order = data.order;
                console.log("Order details:", order);
                
                // Log all price-related fields
                console.log("Price fields in order data:");
                console.log("- unitPrice:", order.unitPrice);
                console.log("- price:", order.price);
                console.log("- formattedUnitPrice:", order.formattedUnitPrice);
                console.log("- formattedPrice:", order.formattedPrice);
                console.log("- totalPrice:", order.totalPrice);
                console.log("- formattedTotalPrice:", order.formattedTotalPrice);
                
                // Kiểm tra lại trạng thái từ server
                if (order.status) {
                    const status = order.status.toLowerCase();
                    if (status === 'cancelled' || status === 'shipped') {
                        const message = status === 'cancelled' ? 
                            'Không thể chỉnh sửa đơn hàng đã hủy' : 
                            'Không thể chỉnh sửa đơn hàng đã giao';
                        showToast(message, 'error');
                        return;
                    }
                }
                
                // Fill in the form fields with order data
                document.getElementById('editOrderId').value = order.orderId || '';
                document.getElementById('editStatus').value = formatStatus(order.status || 'pending');
                document.getElementById('editShippingAddress').value = order.shippingAddress || '';
                document.getElementById('editCustomerName').value = order.customerName || '';
                document.getElementById('editCustomerPhone').value = order.customerPhone || '';
                document.getElementById('editReferralCode').value = order.referralCode || '';
                document.getElementById('productNameDisplay').value = order.productName || 'Unknown Product';
                document.getElementById('editOrderQuantity').value = order.quantity || 1;
                
                // Make sure the price field exists and is visible
                const priceField = document.getElementById('editOrderPrice');
                if (priceField) {
                    // Get the price from order data
                    let priceValue = '';
                    
                    // Use totalPrice for display (as requested)
                    if (order.formattedTotalPrice) {
                        priceValue = order.formattedTotalPrice;
                        console.log("Using formattedTotalPrice:", order.formattedTotalPrice);
                    } else if (order.totalPrice) {
                        priceValue = '$' + parseFloat(order.totalPrice).toFixed(2);
                        console.log("Using totalPrice:", order.totalPrice);
                    } else if (order.formattedPrice) {
                        priceValue = order.formattedPrice;
                        console.log("Using formattedPrice:", order.formattedPrice);
                    } else if (order.price) {
                        priceValue = '$' + parseFloat(order.price).toFixed(2);
                        console.log("Using price:", order.price);
                    } else {
                        priceValue = '$0.00';
                        console.log("No price found, using default");
                    }
                    
                    // Set the price value
                    priceField.value = priceValue;
                    console.log("Set price field value to:", priceValue);
                } else {
                    console.error("Price field not found in the DOM!");
                }
                
                // Open the modal
                openModal('editOrderModal');
                
                // Set the price again after the modal is opened
                setTimeout(() => {
                    const priceFieldAfter = document.getElementById('editOrderPrice');
                    if (priceFieldAfter && priceField) {
                        priceFieldAfter.value = priceField.value;
                        console.log("Price field after modal open:", priceFieldAfter.value);
                    }
                }, 200);
            } else {
                showToast('Không thể lấy thông tin đơn hàng', 'error');
            }
        })
        .catch(error => {
            console.error('Error fetching order details:', error);
            showToast('Đã xảy ra lỗi khi lấy thông tin đơn hàng', 'error');
        });
}

/**
 * Xử lý submit form chỉnh sửa
 * @param {HTMLFormElement} form - Form chỉnh sửa
 */
function submitEditOrder(form) {
    event.preventDefault();
    console.log("Submitting edit order form");

    const formData = new FormData(form);
    const params = new URLSearchParams();

    for (let [key, value] of formData.entries()) {
        console.log(`Form field: ${key}=${value}`);
        params.append(key, value);
    }

    const resultDiv = document.getElementById("resultEditOrder");
    resultDiv.innerHTML = `<p style="color:blue; font-weight:bold;">Đang xử lý yêu cầu cập nhật...</p>`;
    
    console.log("Form action URL:", form.action);
    console.log("Request body:", params.toString());

    fetch(form.action, {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
        },
        body: params,
    })
    .then(res => {
        console.log("Response status:", res.status);
        if (!res.ok) {
            throw new Error(`Server responded with status: ${res.status}`);
        }
        return res.text();
    })
    .then(text => {
        console.log("Raw response:", text);
        let data;
        try {
            data = JSON.parse(text);
            console.log("Parsed JSON response:", data);
        } catch (err) {
            console.error("Error parsing JSON:", err);
            throw new Error("Phản hồi không hợp lệ từ server: " + text);
        }

        if (data.success) {
            resultDiv.innerHTML = `<p style="color:green; font-weight:bold;">${data.message || "Cập nhật đơn hàng thành công!"}</p>`;
            
            setTimeout(() => {
                closeModal("editOrderModal");
                window.location.reload(); // Reload trang để hiển thị dữ liệu mới
            }, 800);
        } else {
            resultDiv.innerHTML = `<p style="color:red; font-weight:bold;">Cập nhật thất bại: ${data.message}</p>`;
        }
    })
    .catch(error => {
        console.error("Lỗi:", error);
        resultDiv.innerHTML = `<p style="color:red; font-weight:bold;">Lỗi khi cập nhật đơn hàng: ${error.message}</p>`;
    });

    return false;
}

/**
 * Xóa đơn hàng
 * @param {number} orderId - ID của đơn hàng cần xóa
 */
function deleteOrder(orderId) {
    // Kiểm tra xem đơn hàng có bị hủy hoặc đã giao hàng không
    const orderCard = document.getElementById(`order-${orderId}`);
    if (orderCard) {
        const statusElement = orderCard.querySelector('.product-info__status');
        if (statusElement && (statusElement.classList.contains('product-info__status--cancelled') || 
                             statusElement.classList.contains('product-info__status--shipped'))) {
            // Hiển thị thông báo và không cho phép hủy
            const status = statusElement.textContent.trim().toLowerCase();
            const message = status === 'cancelled' ? 
                'Không thể hủy đơn hàng đã hủy' : 
                'Không thể hủy đơn hàng đã giao';
            showToast(message, 'error');
            return; // Dừng hàm, không xóa
        }
    }
    
    if (confirm('Bạn có chắc chắn muốn hủy đơn hàng này không?')) {
        // Xây dựng URL đúng format
        const baseUrl = window.location.origin;
        const pathArray = window.location.pathname.split('/');
        const contextPath = pathArray[1] ? '/' + pathArray[1] : '';
        
        fetch(`${baseUrl}${contextPath}/historyorder/delete?id=${orderId}`, {
            method: 'POST'
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showToast('Đơn hàng đã được hủy thành công!', 'success');
                
                // Thay đổi trạng thái đơn hàng trên UI thành "CANCELLED" thay vì xóa phần tử
                const orderElement = document.getElementById(`order-${orderId}`);
                if (orderElement) {
                    // Tìm phần tử hiển thị trạng thái
                    const statusElement = orderElement.querySelector('.product-info__status');
                    if (statusElement) {
                        // Xóa tất cả các class trạng thái hiện tại
                        statusElement.classList.remove(
                            'product-info__status--pending',
                            'product-info__status--processing',
                            'product-info__status--shipped'
                        );
                        // Thêm class trạng thái cancelled
                        statusElement.classList.add('product-info__status--cancelled');
                        // Cập nhật nội dung
                        statusElement.textContent = 'CANCELLED';
                    }
                    
                    // Vô hiệu hóa các nút
                    const editButton = orderElement.querySelector('.edit-button');
                    const deleteButton = orderElement.querySelector('.delete-button');
                    
                    if (editButton) {
                        editButton.classList.add('disabled');
                        editButton.disabled = true;
                        editButton.onclick = null;
                    }
                    
                    if (deleteButton) {
                        deleteButton.classList.add('disabled');
                        deleteButton.disabled = true;
                        deleteButton.onclick = null;
                    }
                } else {
                    // Nếu không tìm thấy phần tử, reload trang
                    window.location.reload();
                }
            } else {
                showToast(`Lỗi: ${data.message}`, 'error');
            }
        })
        .catch(error => {
            console.error('Error deleting order:', error);
            showToast('Đã xảy ra lỗi khi hủy đơn hàng', 'error');
        });
    }
}

/**
 * Hiển thị toast notification
 * @param {string} message - Nội dung thông báo
 * @param {string} type - Loại thông báo (success/error)
 */
function showToast(message, type) {
    // Kiểm tra nếu đã có toast container
    let toastContainer = document.querySelector('.toast-container');
    
    if (!toastContainer) {
        toastContainer = document.createElement('div');
        toastContainer.className = 'toast-container';
        document.body.appendChild(toastContainer);
    }
    
    const toast = document.createElement('div');
    toast.className = `toast toast--${type}`;
    toast.textContent = message;
    
    toastContainer.appendChild(toast);
    
    // Hiển thị toast
    setTimeout(() => {
        toast.classList.add('toast--visible');
    }, 10);
    
    // Tự động ẩn toast sau 3 giây
    setTimeout(() => {
        toast.classList.remove('toast--visible');
        setTimeout(() => {
            toast.remove();
        }, 300);
    }, 3000);
}

/**
 * Format trạng thái đơn hàng
 * @param {string} status - Trạng thái đơn hàng
 * @returns {string} Trạng thái đã được định dạng
 */
function formatStatus(status) {
    const statusMap = {
        'pending': 'Chờ xử lý',
        'processing': 'Đang xử lý',
        'shipped': 'Đã giao hàng',
        'cancelled': 'Đã hủy'
    };
    
    return statusMap[status.toLowerCase()] || status;
}

/**
 * Format ngày tháng
 * @param {string} dateString - Chuỗi ngày tháng
 * @returns {string} Ngày tháng đã được định dạng
 */
function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('vi-VN', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    });
}

/**
 * Format tiền tệ
 * @param {number|string} amount - Số tiền
 * @returns {string} Số tiền đã được định dạng
 */
function formatCurrency(amount) {
    console.log("formatCurrency called with:", amount, "type:", typeof amount);
    
    // Check if amount is already a string with currency symbol
    if (typeof amount === 'string') {
        if (amount.includes('$') || amount.includes('₫')) {
            console.log("Amount already has currency symbol, returning as is:", amount);
            return amount;
        }
        // Try to parse the string as a number
        amount = parseFloat(amount.replace(/[^\d.-]/g, ''));
    }
    
    // If the amount is a number or a string representing a number
    if (isNaN(amount)) {
        console.log("Amount is NaN, returning default");
        return '$0.00'; // Default value if parsing fails
    }
    
    console.log("Formatting amount:", amount);
    
    // Format as USD
    return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD',
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
    }).format(amount);
}

// Event Listeners
document.addEventListener('DOMContentLoaded', () => {
    console.log("DOM fully loaded");
    
    // Lấy context path từ một phần tử meta
    const metaContextPath = document.querySelector('meta[name="context-path"]');
    window.contextPath = metaContextPath ? metaContextPath.getAttribute('content') : '';
    console.log("Context path:", window.contextPath);
}); 