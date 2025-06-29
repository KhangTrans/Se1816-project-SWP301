// membership.js
function renewMembership(membershipId, durationDays) {
    fetch('MembershipServlet', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: `action=renew&membershipId=${membershipId}&packageDuration=${durationDays}`
    })
            .then(r => r.json())
            .then(data => {
                if (data.success) {
                    alert('Gia hạn thành công!');
                    window.location.reload(); // hoặc update DOM nếu muốn
                } else {
                    alert('Gia hạn thất bại: ' + (data.message || 'Lỗi không xác định'));
                }
            });
}
function deleteMembership(membershipId) {
    fetch('MembershipServlet', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: `action=delete&membershipId=${membershipId}`
    })
            .then(r => r.json())
            .then(data => {
                if (data.success) {
                    alert('Đã hủy membership!');
                    window.location.reload();
                } else {
                    alert('Hủy thất bại: ' + (data.message || 'Lỗi không xác định'));
                }
            });
}
