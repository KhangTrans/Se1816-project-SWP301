function addToCart(productId) {
    fetch("CartServlet", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "X-Requested-With": "XMLHttpRequest"
        },
        body: `action=add&productId=${productId}&quantity=1`
    })
            .then(res => res.json())  // Đảm bảo nhận phản hồi dưới dạng JSON
            .then(data => {
                const result = data.status;
                if (result === "added") {
                    // Cập nhật số lượng giỏ hàng ngay lập tức
                    const cartCount = data.cartCount;
                    const cartBadge = document.querySelector('.cart-count-badge');

                    // Nếu giỏ hàng có sản phẩm
                    if (cartCount > 0) {
                        cartBadge.textContent = cartCount > 99 ? "99+" : cartCount;
                        cartBadge.style.display = "inline-block";  // Hiển thị badge
                    } else {
                        cartBadge.style.display = "none";  // Ẩn badge nếu không có sản phẩm
                    }

                    alert("Đã thêm sản phẩm vào giỏ hàng!");
                } else if (result === "error") {
                    alert(data.message);  // Hiển thị thông báo lỗi nếu chưa đăng nhập
                } else {
                    alert("Thêm sản phẩm thất bại.");
                }
            })
            .catch(err => {
                console.error("Lỗi khi gửi yêu cầu Ajax:", err);
                alert("Có lỗi xảy ra khi thêm sản phẩm.");
            });
}

function updateQuantity(productId, action) {
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
        console.log("Server response:", data); // Debugging: Log the full response

        if (data.status === "success") {
            // Select DOM elements
            const quantityElement = document.querySelector(`#quantity-${productId}`);
            const subtotalElement = document.querySelector(`#subtotal-${productId}`);
            const cartSubtotalElement = document.querySelector('.subtotal');
            const cartBadge = document.querySelector('.cart-count-badge');

            // Verify quantityElement exists
            if (!quantityElement) {
                console.error(`Quantity element with ID 'quantity-${productId}' not found`);
                alert(`Error: Quantity element for product ${productId} not found in the DOM`);
                return;
            }

            // Verify data.quantity is a valid number
            if (typeof data.quantity !== 'number' || isNaN(data.quantity)) {
                console.error(`Invalid quantity value: ${data.quantity}`);
                alert(`Error: Invalid quantity value received from server: ${data.quantity}`);
                return;
            }

            // Update quantity in the UI
            quantityElement.textContent = data.quantity;

            // Update subtotal for the item
            if (subtotalElement) {
                subtotalElement.textContent = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(data.subtotal);
            } else {
                console.warn(`Subtotal element with ID 'subtotal-${productId}' not found`);
            }

            // Update cart subtotal
            if (cartSubtotalElement) {
                cartSubtotalElement.textContent = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(data.cartTotal);
            } else {
                console.warn("Cart subtotal element (.subtotal) not found");
            }

            // Update cart badge
            if (cartBadge) {
                cartBadge.textContent = data.cartCount > 99 ? "99+" : data.cartCount;
                cartBadge.style.display = data.cartCount > 0 ? "inline-block" : "none";
            } else {
                console.warn("Cart badge element (.cart-count-badge) not found");
            }

            // Handle item removal (quantity = 0)
            if (data.quantity === 0) {
                const cartItem = document.querySelector(`#cart-item-${productId}`);
                if (cartItem) {
                    cartItem.remove();
                    console.log(`Removed cart item with ID 'cart-item-${productId}'`);
                } else {
                    console.warn(`Cart item with ID 'cart-item-${productId}' not found`);
                }
            }

            // Handle empty cart
            if (data.cartCount === 0) {
                const cartItemsContainer = document.querySelector('.cart-items');
                if (cartItemsContainer) {
                    cartItemsContainer.innerHTML = '<p>Your cart is empty.</p>';
                    console.log("Cart is empty, updated UI with empty message");
                } else {
                    console.warn("Cart items container (.cart-items) not found");
                }
            }
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