document.addEventListener("DOMContentLoaded", function () {
    // Khi trang mở lên, gọi luôn showTab để hiển thị My Profile
    showTab('profileContent');  // Mặc định là 'profileContent'

    if (typeof errorMessage !== 'undefined') {
        showTab('changepassword');
        Swal.fire({
            icon: 'error',
            title: 'Password Change Failed',
            text: errorMessage,
            customClass: {
                confirmButton: "btn btn-login"
            }
        });
    }

    // Nếu có thông báo thành công, hiển thị thông báo thành công
    if (typeof successMessage !== 'undefined') {
        Swal.fire({
            icon: 'success',
            title: successMessage,
            text: 'Your password has been changed!',
            customClass: {
                confirmButton: "btn btn-login"
            }
        });
    }

    const tabs = document.querySelectorAll('.tab-btn');

    // Lắng nghe sự kiện click cho các tab
    tabs.forEach(function (tab) {
        tab.addEventListener('click', function (event) {
            event.preventDefault(); // Ngừng hành động mặc định của link

            // Lấy giá trị tab từ data-tab và gọi hàm showTab
            const tabName = this.getAttribute('data-tab');
            showTab(tabName);
        });
    });
});

function loadMembershipBlock() {
    fetch('MembershipServlet')
            .then(response => response.text())
            .then(html => {
                document.getElementById('membership-block').innerHTML = html;
            });
}

document.addEventListener('DOMContentLoaded', function () {
    document.querySelector('.tab-btn.package').addEventListener('click', function (e) {
        e.preventDefault();
        showTab('packages');
        loadMembershipBlock();
    });
});

console.log("Profile JS đã được nạp");
document.addEventListener('DOMContentLoaded', function () {
    console.log("DOMContentLoaded đã chạy");
    var btn = document.querySelector('.tab-btn.package');
    if (btn) {
        console.log("Đã tìm thấy nút My Packages");
        btn.addEventListener('click', function (e) {
            console.log("Đã click My Packages");
            e.preventDefault();
            showTab('packages');
            loadMembershipBlock();
        });
    } else {
        console.log("Không tìm thấy .tab-btn.package");
    }
});

// Hàm showTab hiển thị nội dung của tab đã chọn
function showTab(tabName) {
    // Ẩn tất cả các tab
    document.querySelectorAll('.tab-content').forEach(function (tabContent) {
        tabContent.style.display = 'none';
    });

    // Hiển thị tab được chọn
    const targetTab = document.getElementById(tabName);
    if (targetTab) {
        targetTab.style.display = 'block';
    }
}
