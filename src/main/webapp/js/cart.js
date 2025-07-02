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
