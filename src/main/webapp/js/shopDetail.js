// Product Card JavaScript
class ProductCard {
    constructor() {
        this.cartCount = 0;
        this.isWishlisted = false;
        this.isExpanded = false;

        this.init();
    }

    init() {
        this.bindEvents();
        this.updateCartDisplay();
        this.initFeatureToggle();
    }

    bindEvents() {
        // Wishlist button
        const wishlistBtn = document.querySelector('.product-card__wishlist');
        if (wishlistBtn) {
            wishlistBtn.addEventListener('click', this.toggleWishlist.bind(this));
        }

        // Buy now button
        const buyNowBtn = document.querySelector('.btn--primary');
        if (buyNowBtn) {
            buyNowBtn.addEventListener('click', this.handleBuyNow.bind(this));
        }

        // Add to cart button
        const cartBtn = document.querySelector('.btn--cart');
        if (cartBtn) {
            cartBtn.addEventListener('click', this.addToCart.bind(this));
        }

        // Product image hover effect
        const productImage = document.querySelector('.product-image__main');
        if (productImage) {
            productImage.addEventListener('mouseenter', this.handleImageHover.bind(this));
            productImage.addEventListener('mouseleave', this.handleImageLeave.bind(this));
        }

        // Toggle features button
        const toggleBtn = document.querySelector('#toggle-features');
        if (toggleBtn) {
            toggleBtn.addEventListener('click', this.toggleFeatures.bind(this));
        }
    }

    initFeatureToggle() {
        const featuresList = document.querySelector('#features-list');
        if (featuresList) {
            // Initially collapse the features
            featuresList.classList.add('collapsed');
        }
    }

    toggleFeatures() {
        const featuresList = document.querySelector('#features-list');
        const toggleBtn = document.querySelector('#toggle-features');
        const toggleText = toggleBtn.querySelector('.btn-toggle__text');

        this.isExpanded = !this.isExpanded;

        if (this.isExpanded) {
            featuresList.classList.remove('collapsed');
            toggleText.textContent = 'Thu gọn';
            toggleBtn.classList.add('expanded');

            // Smooth scroll to show more content
            setTimeout(() => {
                featuresList.scrollTop = featuresList.scrollHeight;
            }, 100);
        } else {
            featuresList.classList.add('collapsed');
            toggleText.textContent = 'Xem thêm';
            toggleBtn.classList.remove('expanded');

            // Scroll back to top
            featuresList.scrollTop = 0;
        }
    }

    toggleWishlist() {
        this.isWishlisted = !this.isWishlisted;

        const wishlistBtn = document.querySelector('.product-card__wishlist');
        if (this.isWishlisted) {
            wishlistBtn.innerHTML = '❤️';
            wishlistBtn.style.transform = 'scale(1.2)';

            // Show notification
            this.showNotification('Đã thêm vào danh sách yêu thích!', 'success');
        } else {
            wishlistBtn.innerHTML = '❤';
            wishlistBtn.style.transform = 'scale(1)';

            this.showNotification('Đã xóa khỏi danh sách yêu thích!', 'info');
        }

        // Reset scale after animation
        setTimeout(() => {
            wishlistBtn.style.transform = 'scale(1)';
        }, 200);
    }

    handleBuyNow() {
        // Add loading state
        const buyBtn = document.querySelector('.btn--primary');
        const originalContent = buyBtn.innerHTML;

        buyBtn.innerHTML = '<span class="btn__text">ĐANG XỬ LÝ...</span>';
        buyBtn.disabled = true;

        // Simulate API call
        setTimeout(() => {
            this.showNotification('Chuyển hướng đến trang thanh toán...', 'success');

            // In real application, redirect to checkout
            // window.location.href = '/checkout';

            // Reset button
            buyBtn.innerHTML = originalContent;
            buyBtn.disabled = false;
        }, 1500);
    }

    addToCart() {
        this.cartCount++;
        this.updateCartDisplay();

        // Add animation to cart button
        const cartBtn = document.querySelector('.btn--cart');
        cartBtn.style.transform = 'scale(0.95)';

        setTimeout(() => {
            cartBtn.style.transform = 'scale(1)';
        }, 150);

        this.showNotification('Đã thêm sản phẩm vào giỏ hàng!', 'success');
    }

    updateCartDisplay() {
        const cartCount = document.querySelector('.btn__count');
        if (cartCount) {
            cartCount.textContent = this.cartCount;

            if (this.cartCount > 0) {
                cartCount.style.display = 'flex';
            } else {
                cartCount.style.display = 'none';
            }
        }
    }

    handleImageHover() {
        const productImage = document.querySelector('.product-image__main');
        productImage.style.transform = 'scale(1.05) rotateY(5deg)';
        productImage.style.transition = 'transform 0.3s ease';
    }

    handleImageLeave() {
        const productImage = document.querySelector('.product-image__main');
        productImage.style.transform = 'scale(1) rotateY(0deg)';
    }

    showNotification(message, type = 'info') {
        // Remove existing notifications
        const existingNotification = document.querySelector('.notification');
        if (existingNotification) {
            existingNotification.remove();
        }

        // Create notification element
        const notification = document.createElement('div');
        notification.className = `notification notification--${type}`;
        notification.innerHTML = `
            <span class="notification__message">${message}</span>
            <button class="notification__close">×</button>
        `;

        // Add styles
        notification.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            background: ${type === 'success' ? '#34c759' : type === 'error' ? '#ff3b30' : '#007aff'};
            color: white;
            padding: 12px 16px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
            z-index: 1000;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 14px;
            font-weight: 500;
            animation: slideIn 0.3s ease;
        `;

        // Add animation keyframes if not exists
        if (!document.querySelector('#notification-styles')) {
            const style = document.createElement('style');
            style.id = 'notification-styles';
            style.textContent = `
                @keyframes slideIn {
                    from {
                        transform: translateX(100%);
                        opacity: 0;
                    }
                    to {
                        transform: translateX(0);
                        opacity: 1;
                    }
                }
                
                .notification__close {
                    background: none;
                    border: none;
                    color: white;
                    font-size: 18px;
                    cursor: pointer;
                    padding: 0;
                    line-height: 1;
                }
            `;
            document.head.appendChild(style);
        }

        document.body.appendChild(notification);

        // Close button functionality
        const closeBtn = notification.querySelector('.notification__close');
        closeBtn.addEventListener('click', () => {
            notification.remove();
        });

        // Auto remove after 3 seconds
        setTimeout(() => {
            if (notification.parentNode) {
                notification.remove();
            }
        }, 3000);
    }
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    new ProductCard();
});

// Utility functions for JSP integration
window.ProductUtils = {
    // Function to update product data from JSP
    updateProductData: function (productData) {
        // Update title
        const title = document.querySelector('.product-card__title');
        if (title && productData.title) {
            title.textContent = productData.title;
        }

        // Update image
        const mainImage = document.querySelector('.product-image__main');
        if (mainImage && productData.imageUrl) {
            mainImage.src = productData.imageUrl;
            mainImage.alt = productData.title || 'Product image';
        }

        // Update rating
        const ratingText = document.querySelector('.rating__text');
        if (ratingText && productData.reviewCount) {
            ratingText.textContent = `${productData.reviewCount} đánh giá`;
        }

        // Update specs
        if (productData.specs) {
            const chip = document.querySelector('.product-specs__chip');
            const gpu = document.querySelector('.product-specs__gpu');
            const storage = document.querySelector('.product-specs__storage');
            const display = document.querySelector('.product-specs__display');

            if (chip && productData.specs.chip)
                chip.textContent = productData.specs.chip;
            if (gpu && productData.specs.gpu)
                gpu.textContent = productData.specs.gpu;
            if (storage && productData.specs.storage)
                storage.textContent = productData.specs.storage;
            if (display && productData.specs.display)
                display.textContent = productData.specs.display;
        }

        // Update features with toggle functionality
        if (productData.features && Array.isArray(productData.features)) {
            const featuresContainer = document.querySelector('.product-info__features');
            if (featuresContainer) {
                featuresContainer.innerHTML = productData.features.map(feature => `
                    <div class="feature">
                        <div class="feature__text">${feature}</div>
                    </div>
                `).join('');

                // Re-initialize collapse state
                featuresContainer.classList.add('collapsed');
            }
        }
    },

    // Function to handle product actions from JSP
    setProductActions: function (actions) {
        if (actions.onBuyNow) {
            const buyBtn = document.querySelector('.btn--primary');
            if (buyBtn) {
                buyBtn.addEventListener('click', actions.onBuyNow);
            }
        }

        if (actions.onAddToCart) {
            const cartBtn = document.querySelector('.btn--cart');
            if (cartBtn) {
                cartBtn.addEventListener('click', actions.onAddToCart);
            }
        }
    }
};
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function closeBuyNowModal() {
    document.getElementById('buyNowModal').style.display = 'none';
}

document.addEventListener('DOMContentLoaded', function () {
    const origin = document.getElementById('originPrice');
    const discounted = document.getElementById('discountedPrice');
    const quantityInput = document.querySelector('input[name="quantity"]');
    const voucherSelect = document.getElementById('voucherIdDropdown');

    function formatMoney(num) {
        return num.toLocaleString('vi-VN', {maximumFractionDigits: 0});
    }

    function updateVoucherDropdown() {
        let quantity = parseInt(quantityInput.value) || 1;
        let total = productPrice * quantity;
        for (let i = 0; i < voucherSelect.options.length; i++) {
            let opt = voucherSelect.options[i];
            if (!opt.value)
                continue; // Bỏ qua option đầu (No Voucher chosen)
            let minOrder = parseFloat(opt.getAttribute('data-minorder')) || 0;
            if (total < minOrder) {
                opt.disabled = true;
                opt.style.color = '#ccc';
                opt.title = 'Order need to be at least' + minOrder.toLocaleString('vi-VN') + '₫ to use this voucher';
            } else {
                opt.disabled = false;
                opt.style.color = '';
                opt.title = '';
            }
        }
        // Nếu option đang chọn bị disable thì chuyển về mặc định
        if (voucherSelect.options[voucherSelect.selectedIndex] && voucherSelect.options[voucherSelect.selectedIndex].disabled) {
            voucherSelect.selectedIndex = 0;
        }
    }

    function updatePrice() {
        updateVoucherDropdown(); // <- Luôn update điều kiện voucher trước
        let quantity = parseInt(quantityInput.value) || 1;
        let voucherOpt = voucherSelect.options[voucherSelect.selectedIndex];
        let discountPercent = voucherOpt.getAttribute('data-discount');
        let maxDiscount = voucherOpt.getAttribute('data-max');
        let total = productPrice * quantity;
        let discountedPrice = total;

        if (discountPercent) {
            let discount = total * parseInt(discountPercent) / 100;
            if (maxDiscount) {
                discount = Math.min(discount, parseFloat(maxDiscount));
            }
            discountedPrice = total - discount;
        }

        origin.textContent = formatMoney(total);
        discounted.textContent = formatMoney(discountedPrice);
    }

    // Khi quantity thay đổi
    quantityInput.addEventListener('input', updatePrice);

    // Khi chọn voucher (cập nhật lại giá luôn)
    voucherSelect.addEventListener('change', updatePrice);

    // Khi mở modal "Buy Now"
    window.showBuyNowModal = function (productId) {
        var accountId = '<%= (session.getAttribute("accountId") != null) ? session.getAttribute("accountId") : "null"%>';
        if (accountId === "null") {
            showAlert("you need to be logged in to use this feature!");
            return;
        }
        document.getElementById('modalProductId').value = productId;
        document.getElementById('buyNowModal').style.display = 'block';

        setTimeout(() => {
            updatePrice(); // <-- Gọi updatePrice luôn để đồng bộ mọi thứ
        }, 30); // Cho chắc chắn input đã render
    };

    // Khởi tạo ban đầu (nếu modal mở sẵn)
    updatePrice();

// Xử lý gửi AJAX khi submit
    var buyNowForm = document.getElementById('buyNowForm');
    if (buyNowForm) {
        buyNowForm.addEventListener('submit', function (e) {
            e.preventDefault();

            // ----------- KIỂM TRA SỐ ĐIỆN THOẠI -----------
            var phoneInput = buyNowForm.querySelector('input[name="phone"]');
            var phone = phoneInput.value.trim();
            // Regex: Nhận số VN bắt đầu 09, 03, 08, 07, 05... (có thể mở rộng)
            var vietPhoneRegex = /^(0|\+84)(3[2-9]|5[6|8|9]|7[06-9]|8[1-5]|9[0-9])[0-9]{7}$/;

            if (!vietPhoneRegex.test(phone)) {
                showAlert("please enter a valid Vietnamese phone number!");
                phoneInput.focus();
                return false; // Không submit nếu sai
            }
            // Kiểm tra số lượng không vượt quá stock
            var stockQty = window.PRODUCT_STOCK; // <-- Lấy từ biến global đã render ra từ JSP
            var qtyInput = buyNowForm.querySelector('input[name="quantity"]');
            var qty = parseInt(qtyInput.value) || 1;
            if (qty > stockQty) {
                showAlert("Out of stock!");
                qtyInput.value = stockQty;
                qtyInput.focus();
                return false;
            }
            if (qty < 1) {
                qtyInput.value = 1;
                showAlert("Số lượng tối thiểu là 1!");
                qtyInput.focus();
                return false;
            }
            

            var formData = new FormData(buyNowForm);
            var xhr = new XMLHttpRequest();
            xhr.open('POST', window.APP_CONTEXT_PATH + '/BuyNow', true);

            xhr.onload = function () {
                if (xhr.status === 200) {
                    window.location.href = xhr.responseURL;
                } else {
                    showAlert("An error occurred while ordering!");
                }
            };
            xhr.onerror = function () {
                showAlert("can't connect to server!");
            };
            xhr.send(formData);
        });
    }
});