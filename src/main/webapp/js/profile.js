document.addEventListener("DOMContentLoaded", function () {
    // Lấy URL hiện tại
    const currentURL = window.location.href;
    console.log("Current URL: ", currentURL);  // In URL để kiểm tra

    // Kiểm tra tham số 'tab' trong URL
    const urlParams = new URLSearchParams(window.location.search);
    const tabParam = urlParams.get('tab');
    console.log("Tab Parameter: ", tabParam);  // Kiểm tra giá trị của 'tab'

    // Nếu có tham số 'tab' trong URL, mở tab đó
    if (tabParam) {
        showTab(tabParam);  // Hiển thị tab dựa trên tham số trong URL

        // Cập nhật tab hiện tại
        const activeTab = document.querySelector(`.tab-btn[data-tab="${tabParam}"]`);
        if (activeTab) {
            // Loại bỏ active class khỏi tất cả tab
            const tabs = document.querySelectorAll('.tab-btn');
            tabs.forEach(tab => tab.classList.remove('active'));
            // Thêm active class cho tab hiện tại
            activeTab.classList.add('active');
        }
    } else {
        showTab('profileContent');
    }

    // Thêm sự kiện click cho tất cả các tab
    const tabs = document.querySelectorAll('.tab-btn');
    tabs.forEach(function (tab) {
        tab.addEventListener('click', function (event) {
            event.preventDefault();

            // Loại bỏ active class khỏi tất cả các tab
            tabs.forEach(tab => tab.classList.remove('active'));

            // Thêm active class vào tab đã click
            this.classList.add('active');

            // Lấy tên tab và hiển thị nội dung tương ứng
            const tabName = this.getAttribute('data-tab');
            showTab(tabName);

            // Nếu tab là 'packages', load dữ liệu membership
            if (tabName === 'packages') {
                loadMembershipBlock();
            }
        });
    });
});

// Hàm hiển thị nội dung của tab
function showTab(tabName) {
    // Ẩn tất cả các nội dung của các tab
    document.querySelectorAll('.tab-content').forEach(function (tabContent) {
        tabContent.style.display = 'none';
    });

    // Hiển thị nội dung của tab hiện tại
    const targetTab = document.getElementById(tabName);
    if (targetTab) {
        targetTab.style.display = 'block';
    }

    // Cập nhật URL mà không cần tải lại trang
    const url = new URL(window.location.href);
    url.searchParams.set('tab', tabName);  // Cập nhật tham số 'tab' trong URL
    window.history.replaceState({}, '', url);  // Thay đổi URL mà không làm mới trang
}

// Hàm load dữ liệu membership nếu tab là 'packages'
function loadMembershipBlock() {
    fetch('MembershipServlet')
        .then(response => response.text())
        .then(html => {
            document.getElementById('membership-block').innerHTML = html;
        })
        .catch(error => {
            console.error('Error loading membership data:', error);
        });
}
