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
            .then(response => {
                if (!response.ok)
                    throw new Error(`HTTP ${response.status}`);
                return response.text();
            })
            .then(html => {
                const container = document.querySelector('#membershipInfoBox');
                if (container) {
                    container.innerHTML = html;
                    // Gắn lại event handler cho nút Gia hạn/Hủy (vì block đã bị replace)
                    reattachMembershipHandlers();
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
//
//function renewMembership(id, duration) {
//    fetch('MembershipServlet', {
//        method: 'POST',
//        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
//        body: `action=renew&membershipId=${id}&packageDuration=${duration}`
//    })
//            .then(response => response.json())
//            .then(data => {
//                showMembershipMessage(data.success, data.message || "Gia hạn thành công!");
//                setTimeout(() => {
//                    reloadMembershipCard();
//                }, 2200); // delay 2.2 giây
//            });
//}

function renewMembership() {
    const packageId = document.getElementById('membershipInfoBox').dataset.packageid;
    if (!packageId) {
        alert("Không lấy được packageId!");
        return;
    }
    // Chuyển trang, để user xác nhận và thanh toán lại
    window.location.href = `payment?cardId=${packageId}&renew=1`;
}


document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById('book-membership-form');
    const errorDiv = document.getElementById('membership-error-msg');
    form.addEventListener('submit', function (e) {
        e.preventDefault(); // Ngăn reload trang mặc định

        const formData = new FormData(form);
        for (let [key, value] of formData.entries()) {
            console.log(key, value);
        }
        fetch('payment', {
            method: 'POST',
            body: formData
        })

                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        window.location.href = '<%= request.getContextPath() %>/homepage';
                    } else {
                        errorDiv.innerText = data.message || "Đã có lỗi xảy ra, vui lòng thử lại!";
                    }
                })
                .catch(err => {
                    errorDiv.innerText = "Có lỗi kết nối đến server!";
                });
    });
});


function reattachMembershipHandlers() {
    var showBtn = document.getElementById('show-packages-btn');
    if (showBtn) {
        showBtn.onclick = function () {
            document.getElementById('membershipInfoBox').style.display = 'none';
            document.getElementById('packageListContainer').style.display = 'flex';
        }
    }
}
