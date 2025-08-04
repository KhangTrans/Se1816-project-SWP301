function addToCart(productId) {
    console.log(`Bắt đầu thêm sản phẩm ID: ${productId}`);

    fetch("CartServlet", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "X-Requested-With": "XMLHttpRequest"
        },
        body: `action=add&productId=${productId}&quantity=1`
    })
            .then(res => {
                console.log(`Phản hồi từ server: status ${res.status}`);
                if (!res.ok) {
                    throw new Error(`Server error: ${res.status}`);
                }
                return res.json();
            })
            .then(data => {
                const result = data.status;
                if (result === "added") {
                    const cartCount = data.cartCount;
                    const cartBadge = document.querySelector('.cart-count-badge');
                    if (cartBadge) {
                        cartBadge.textContent = cartCount > 99 ? "99+" : cartCount;
                        cartBadge.style.display = cartCount > 0 ? "inline-block" : "none";
                        console.log(`Cập nhật badge thành công: ${cartCount}`);
                    } else {
                        console.warn("Không tìm thấy .cart-count-badge trong DOM.");
                    }
                    alert("Đã thêm sản phẩm vào giỏ hàng!");
                } else if (result === "error") {
                    alert(data.message);
                } else {
                    alert("Thêm sản phẩm thất bại.");
                }
            })
            .catch(err => {
                console.error("Lỗi khi gửi yêu cầu Ajax:", err);
                alert("Có lỗi xảy ra khi thêm sản phẩm: " + err.message);
            })
            .finally(() => {
                console.log("Kết thúc hàm addToCart");
            });
}

function updateQuantity(productId, action) {
    console.log(`Bắt đầu cập nhật số lượng cho sản phẩm ID: ${productId}, action: ${action}`);
    fetch("CartServlet", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "X-Requested-With": "XMLHttpRequest"
        },
        body: `action=${action}&productId=${productId}`
    })
            .then(res => {
                if (!res.ok) {
                    throw new Error(`HTTP error! Status: ${res.status}`);
                }
                return res.json();
            })
            .then(data => {
                console.log("Server response:", data);

                if (data.status === "success") {
                    const quantityElement = document.querySelector(`#quantity-${productId}`);
                    
                    if (!quantityElement) {
                        console.error(`Quantity element with ID 'quantity-${productId}' not found`);
                        alert(`Error: Quantity element for product ${productId} not found in the DOM`);
                        return;
                    }

                    if (typeof data.quantity !== 'number' || isNaN(data.quantity)) {
                        console.error(`Invalid quantity value: ${data.quantity}`);
                        alert(`Error: Invalid quantity value received from server: ${data.quantity}`);
                        return;
                    }

                    quantityElement.textContent = data.quantity;

                    const subtotalElement = document.querySelector(`#subtotal-${productId}`);
                    if (subtotalElement) {
                        const formatted = new Intl.NumberFormat('vi-VN', {style: 'decimal'}).format(data.subtotal);
                        subtotalElement.textContent = `Total: ${formatted}₫`;
                    } else {
                        console.warn(`Subtotal element with ID 'subtotal-${productId}' not found`);
                    }

                    const cartSubtotalElement = document.querySelector('.subtotal');
                    if (cartSubtotalElement) {
                        const formattedTotal = new Intl.NumberFormat('vi-VN', {style: 'decimal'}).format(data.cartTotal);
                        cartSubtotalElement.textContent = `${formattedTotal}₫`;
                    } else {
                        console.warn("Cart subtotal element (.subtotal) not found");
                    }

                    const cartBadge = document.querySelector('.cart-count-badge');
                    if (cartBadge) {
                        cartBadge.textContent = data.cartCount > 99 ? "99+" : data.cartCount;
                        cartBadge.style.display = data.cartCount > 0 ? "inline-block" : "none";
                    } else {
                        console.warn("Cart badge element (.cart-count-badge) not found");
                    }

                    if (data.quantity === 0) {
                        const cartItem = document.querySelector(`#cart-item-${productId}`);
                        if (cartItem) {
                            cartItem.remove();
                            console.log(`Removed cart item with ID 'cart-item-${productId}'`);
                        } else {
                            console.warn(`Cart item with ID 'cart-item-${productId}' not found`);
                        }
                    }

                    if (data.cartCount === 0) {
                        const cartItemsContainer = document.querySelector('.cart-items');
                        if (cartItemsContainer) {
                            cartItemsContainer.innerHTML = '<p>Your cart is empty.</p>';
                            console.log("Cart is empty, updated UI with empty message");
                        } else {
                            console.warn("Cart items container (.cart-items) not found");
                        }
                    }
                    updateDisplayedSubtotal();
                } else {
                    console.error("Server error:", data.message);
                    alert(`Error: ${data.message}`);
                }
            })
            .catch(err => {
                console.error("Error updating quantity:", err);
                alert("An error occurred while updating the quantity. Check the console for details.");
            });
}

function removeFromCart(productId) {
    console.log(`Bắt đầu xóa sản phẩm ID: ${productId}`);
    if (!productId) {
        console.error("productId is undefined or null");
        alert("Lỗi: Không thể xác định sản phẩm để xóa.");
        return;
    }

    fetch("CartServlet", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "X-Requested-With": "XMLHttpRequest"
        },
        body: `action=remove&productId=${encodeURIComponent(productId)}`
    })
            .then(res => {
                console.log(`Phản hồi từ server: status ${res.status}`);
                if (!res.ok) {
                    throw new Error(`HTTP error! Status: ${res.status}`);
                }
                return res.json();
            })
            .then(data => {
                console.log("Server response:", data);
                if (data && data.status === "success") {
                    const cartItem = document.querySelector(`#cart-item-${productId}`);
                    if (cartItem) {
                        cartItem.remove();
                        console.log(`Removed cart item with ID 'cart-item-${productId}'`);
                    } else {
                        console.warn(`Cart item with ID 'cart-item-${productId}' not found`);
                    }

                    const cartBadge = document.querySelector('.cart-count-badge');
                    if (cartBadge) {
                        cartBadge.textContent = data.cartCount > 99 ? "99+" : data.cartCount;
                        cartBadge.style.display = data.cartCount > 0 ? "inline-block" : "none";
                    }

                    const cartSubtotalElement = document.querySelector('.subtotal');
                    if (cartSubtotalElement && data.cartTotal !== undefined) {
                        const formattedTotal = new Intl.NumberFormat('vi-VN', {style: 'decimal'}).format(data.cartTotal);
                        cartSubtotalElement.textContent = `${formattedTotal}₫`;
                    }

                    if (data.cartCount === 0) {
                        const cartItemsContainer = document.querySelector('.cart-items');
                        if (cartItemsContainer) {
                            cartItemsContainer.innerHTML = '<p>Your cart is empty.</p>';
                        }
                    }
                } else {
                    console.error("Server error:", data ? data.message : "No data returned");
                    alert(`Error: ${data ? data.message : "Không thể xóa sản phẩm."}`);
                }
            })
            .catch(err => {
                console.error("Error removing item:", err);
                alert("An error occurred while removing the item. Check the console for details: " + err.message);
            });
}

function clearCart() {
    console.log("Bắt đầu xóa toàn bộ giỏ hàng");
    const cartItemsContainer = document.querySelector('.cart-items');
    if (!cartItemsContainer) {
        console.warn("Cart items container (.cart-items) not found");
        return;
    }

    const hasItems = cartItemsContainer.querySelectorAll('.cart-item').length > 0;
    if (!hasItems) {
        alert("Your cart is empty");
        return;
    }

    if (confirm('Bạn có chắc chắn muốn xóa toàn bộ giỏ hàng?')) {
        fetch("CartServlet", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded",
                "X-Requested-With": "XMLHttpRequest"
            },
            body: `action=clearCart`
        })
                .then(res => {
                    if (!res.ok) {
                        throw new Error(`HTTP error! Status: ${res.status}`);
                    }
                    return res.json();
                })
                .then(data => {
                    console.log("Server response:", data);
                    if (data.status === "success") {
                        cartItemsContainer.innerHTML = '<p>Your cart is empty.</p>';
                        const cartBadge = document.querySelector('.cart-count-badge');
                        if (cartBadge) {
                            cartBadge.textContent = "0";
                            cartBadge.style.display = "none";
                        }
                        const cartSubtotalElement = document.querySelector('.subtotal');
                        if (cartSubtotalElement) {
                            cartSubtotalElement.textContent = "0₫";
                        }
                    } else {
                        console.error("Server error:", data.message);
                        alert(`Error: ${data.message}`);
                    }
                })
                .catch(err => {
                    console.error("Error clearing cart:", err);
                    alert("An error occurred while clearing the cart. Check the console for details.");
                });
    }
}

// Formatter tái sử dụng
const currencyFormatter = new Intl.NumberFormat('vi-VN', {style: 'decimal'});

// Function tính và cập nhật subtotal dựa trên checked items
function updateDisplayedSubtotal() {
    let selectedTotal = 0;
    document.querySelectorAll('input[name="cartItemsToCheckout"]:checked').forEach(checkbox => {
        const itemElement = checkbox.closest('.cart-item');
        if (itemElement) {
            // Parse số từ text "Total: 123₫" → loại bỏ chữ và ký tự không phải số
            const subtotalText = itemElement.querySelector('.total').textContent.replace(/[^0-9]/g, '');
            selectedTotal += parseInt(subtotalText, 10) || 0;
        }
    });
    const cartSubtotalElement = document.querySelector('.subtotal');
    if (cartSubtotalElement) {
        cartSubtotalElement.textContent = `${currencyFormatter.format(selectedTotal)}₫`;
    } else {
        console.warn("Cart subtotal element (.subtotal) not found");
    }
}

// Function cho Select All
function toggleAllCheckboxes(source) {
    document.querySelectorAll('input[name="cartItemsToCheckout"]').forEach(checkbox => {
        checkbox.checked = source.checked;
    });
    updateDisplayedSubtotal();  // Cập nhật subtotal ngay khi toggle
}

// Thêm listeners cho checkbox changes và validation form
document.addEventListener("DOMContentLoaded", function () {
    loadCartBadge();

    // Gọi ban đầu để set subtotal = 0 (hoặc nếu có checked mặc định, nhưng hiện không)
    updateDisplayedSubtotal();

    // Listener cho mỗi checkbox change
    document.querySelectorAll('input[name="cartItemsToCheckout"]').forEach(checkbox => {
        checkbox.addEventListener('change', updateDisplayedSubtotal);
    });

    // Validation trước submit (nếu chưa có)
    document.querySelector('form[action="${pageContext.request.contextPath}/checkout"]').addEventListener('submit', function (event) {
        const checkedItems = document.querySelectorAll('input[name="cartItemsToCheckout"]:checked');
        if (checkedItems.length === 0) {
            alert('Please select at least one item to proceed to checkout.');
            event.preventDefault();
        }
    });
});

function loadCartBadge() {
    fetch("CartServlet?action=view", {
        method: "GET",
        headers: {
            "X-Requested-With": "XMLHttpRequest"
        }
    })
            .then(res => {
                if (!res.ok) {
                    throw new Error(`Server error: ${res.status}`);
                }
                return res.json();
            })
            .then(data => {
                if (data.status === "success") {
                    const cartCount = data.cartCount;
                    const cartBadge = document.querySelector('.cart-count-badge');
                    if (cartBadge) {
                        cartBadge.textContent = cartCount > 99 ? "99+" : cartCount;
                        cartBadge.style.display = cartCount > 0 ? "inline-block" : "none";
                        console.log(`Loaded cart badge on page load: ${cartCount}`);
                    }
                } else if (data.status === "error") {
                    console.warn(data.message);
                }
            })
            .catch(err => {
                console.error("Lỗi load cart badge:", err);
            });
}

document.addEventListener("DOMContentLoaded", function () {
    loadCartBadge();
});