function showMembershipMessage(success, message) {
    const msgDiv = document.getElementById('membership-message');
    if (msgDiv) {
        msgDiv.innerHTML = `<div class="${success ? "success-box" : "error-box"}">${message}</div>`;
        setTimeout(() => {
            msgDiv.innerHTML = "";
        }, 3500);
    }
}
function reloadMembershipCard() {
    fetch("MembershipServlet")
        .then(response => response.text())
        .then(html => {
            const container = document.querySelector('#membership-block'); // Đảm bảo id đúng!
            if (container) {
                container.innerHTML = html;
                reattachMembershipHandlers(); // Gắn lại nút bấm cho block mới
            }
        })
        .catch(error => {
            console.error('Lỗi khi tải lại thẻ membership:', error);
        });
}

// Hàm helper hiện message trong card
function showMembershipMessage(success, message) {
    const msgDiv = document.getElementById('membership-message');
    if (msgDiv) {
        msgDiv.innerHTML = `<div class="${success ? "success-box" : "error-box"}">${message}</div>`;
        setTimeout(() => {
            msgDiv.innerHTML = "";
        }, 3500); // Ẩn sau 3,5 giây (nếu muốn)
    }
}

function showCancelConfirm() {
    // Ẩn nút hủy, hiện confirm
    document.querySelector('.membership-btn-cancel').style.display = "none";
    document.getElementById('cancel-confirm-box').style.display = "inline-block";
}
function hideCancelConfirm() {
    document.querySelector('.membership-btn-cancel').style.display = "inline-block";
    document.getElementById('cancel-confirm-box').style.display = "none";
}
function doCancelMembership(id) {
    fetch('MembershipServlet', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'action=delete&membershipId=' + id
    })
            .then(response => response.json())
            .then(data => {
                showMembershipMessage(data.success, data.message || "Đã hủy gói thành công!");
                setTimeout(() => {
                    reloadMembershipCard();
                }, 2200); // delay 2.2 giây
            });
}


function reattachMembershipHandlers() {
    var showBtn = document.getElementById('show-packages-btn');
    if (showBtn) {
        showBtn.onclick = function () {
            document.getElementById('membershipInfoBox').style.display = 'none';
            document.getElementById('packageListContainer').style.display = 'flex';
        }
    }
}

// Payment modal handler
document.addEventListener('DOMContentLoaded', function() {
    const bookBtn = document.getElementById('bookPackageBtn');
    if (bookBtn) {
        bookBtn.addEventListener('click', function() {
            // Get data attributes from button
            const packageId = bookBtn.getAttribute('data-package-id');
            const packageName = bookBtn.getAttribute('data-package-name');
            const packagePrice = parseFloat(bookBtn.getAttribute('data-package-price'));
            const username = bookBtn.getAttribute('data-username');
            
            // Call the payment modal open function
            if (typeof openPaymentModal === 'function') {
                openPaymentModal(packageId, packageName, packagePrice, username);
            }
        });
    }
});
