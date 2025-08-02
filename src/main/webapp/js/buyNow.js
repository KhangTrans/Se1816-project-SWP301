
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
                showAlert("Minimum quanity is 1!");
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

function setupBuyNowEvents() {
    document.querySelectorAll('.btn-buy-now').forEach(function (btn) {
        btn.onclick = null;
        btn.addEventListener('click', function (e) {
            if (!window.IS_LOGGED_IN) {
                alert('You need to login to use this feature!');
                e.preventDefault();
                return false;
            } else {
                var productId = btn.getAttribute('data-productid');
                window.location.href = window.APP_CONTEXT_PATH + '/BuyNow?productId=' + productId;
            }
        });
    });
}
setupBuyNowEvents();


document.addEventListener('DOMContentLoaded', function () {
    if (window.ERROR_MESSAGE) {
        alert(window.ERROR_MESSAGE);
        window.ERROR_MESSAGE = null;
    }
    window.setupBuyNowEvents = setupBuyNowEvents;

});