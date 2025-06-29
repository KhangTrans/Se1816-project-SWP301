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
                const container = document.querySelector('#membershipCardContainer');
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

function showCancelConfirm(id) {
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

function renewMembership(id, duration) {
    fetch('MembershipServlet', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: `action=renew&membershipId=${id}&packageDuration=${duration}`
    })
            .then(response => response.json())
            .then(data => {
                showMembershipMessage(data.success, data.message || "Gia hạn thành công!");
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
