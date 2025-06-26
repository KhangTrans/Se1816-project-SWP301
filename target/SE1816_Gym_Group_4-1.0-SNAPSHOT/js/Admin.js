// Admin Dashboard JavaScript - BEM Methodology
document.addEventListener('DOMContentLoaded', function () {
    loadAccounts();
    reloadProductList();
    loadVouchers();
    loadStaffData();
    reloadTrainerList();
    reloadBlogList();
    loadCustomers();
    ;
});

// Show specific table
function showTable(tableId) {
    // Hide all tables with fade effect
    document.querySelectorAll('.table-container').forEach(container => {
        container.style.opacity = '0';
        setTimeout(() => {
            container.classList.remove('table-container--active');
        }, 150);
    });

    // Show target table with fade effect
    setTimeout(() => {
        const targetTable = document.getElementById(tableId);
        if (targetTable) {
            targetTable.classList.add('table-container--active');
            setTimeout(() => {
                targetTable.style.opacity = '1';
            }, 50);
        }
    }, 200);
}




// Load all data from database
async function loadAllData() {
    await loadStaffData();
    await loadProductsData();
    // Thêm các function load khác khi cần
}



// Format currency
function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(amount);
}

// Form validation
function validateForm(formId) {
    const form = document.getElementById(formId);
    const inputs = form.querySelectorAll('input[required], textarea[required]');
    let isValid = true;

    inputs.forEach(input => {
        if (!input.value.trim()) {
            input.style.borderColor = '#dc3545';
            isValid = false;
        } else {
            input.style.borderColor = '#ddd';
        }
    });

    return isValid;
}

// Export functions for external use
window.AdminDashboard = {
    showTable,
    openModal,
    closeModal,
    loadAllData,
    formatCurrency,
    validateForm
};

function openModal(id) {
    const modal = document.getElementById(id);
    if (modal)
        modal.style.display = 'flex';
}


function closeModal(id) {
    const modal = document.getElementById(id);
    if (modal)
        modal.style.display = 'none';
}






function openEditAccountModal(id, username, role, avatarUrl) {
    document.getElementById('editAccountId').value = id;
    document.getElementById('editUsername').value = username;
    document.getElementById('editRole').value = role;

    // Xử lý avatar hiện tại
    if (avatarUrl && avatarUrl.trim() !== "") {
        document.getElementById('currentAvatar').src = avatarUrl;
        document.getElementById('currentAvatarContainer').style.display = 'block';
    } else {
        document.getElementById('currentAvatarContainer').style.display = 'none';
    }

    document.getElementById('editAccountModal').style.display = 'flex';
}


function openDeleteAccountModal(id) {
    document.getElementById('deleteAccountId').value = id;
    openModal('deleteAccountModal');
}

//chức năng xử lý gửi form bằng AJAX mà không reload lại trang==============================================================================================================
function submitFormAjax(form, resultContainerId, event) {
    if (event)
        event.preventDefault();
    const selectedCategory = document.getElementById("editProductCategory").value;
    console.log("📤 Sending categoryId:", selectedCategory);

    const formData = new FormData(form);
    console.log("✅ Dữ liệu gửi đi:");
    for (let [key, val] of formData.entries()) {
        console.log(`${key}: ${val}`);
    }
    const action = form.getAttribute('action');
    const method = form.getAttribute('method') || 'post';

    if (!action) {
        console.error("❌ Form không có thuộc tính 'action'");
        const resultDiv = document.getElementById(resultContainerId);
        if (resultDiv) {
            resultDiv.innerHTML = `<p style="color:red; font-weight:bold;">Lỗi: form không có action!</p>`;
        }
        return false;
    }

    form.querySelectorAll('input, select, textarea, button').forEach(el => el.disabled = true);

    fetch(action, {
        method: method.toUpperCase(),
        body: formData
    })
            .then(response => {
                form.querySelectorAll('input, select, textarea, button').forEach(el => el.disabled = false);
                if (!response.ok)
                    return response.text().then(errorMessage => {
                        throw new Error(errorMessage || `HTTP error! Status: ${response.status}`);
                    });
                return response.text();
            })
            .then(data => {
                const resultDiv = document.getElementById(resultContainerId);
                if (resultDiv)
                    resultDiv.innerHTML = `<p style="color:green; font-weight:bold;">Thành công!</p>`;
                const modal = form.closest('.modal');
                if (modal)
                    setTimeout(() => closeModal(modal.id), 800);
                setTimeout(() => {
                    if (typeof loadAccounts === 'function')
                        loadAccounts();
                    if (typeof reloadProductList === 'function')
                        reloadProductList();
                    if (typeof loadVouchers === 'function')
                        loadVouchers();
                    if (typeof loadStaffData === 'function')
                        loadStaffData();
                    if (typeof reloadTrainerList === 'function')
                        reloadTrainerList();
                    if (typeof reloadBlogList === 'function') //cminh
                        reloadBlogList();
                    if (typeof loadCustomers() === 'function') //cminh
                        loadCustomers();
                    ;
                }, 500);
            })
            .catch(error => {
                form.querySelectorAll('input, select, textarea, button').forEach(el => el.disabled = false);
                console.error('Lỗi khi gửi form:', error);
                const resultDiv = document.getElementById(resultContainerId);
                if (resultDiv)
                    resultDiv.innerHTML = `<p style="color:red; font-weight:bold;">Lỗi: ${error.message}</p>`;
            });
    return false;
}






//có nhiệm vụ gửi yêu cầu lấy danh sách tài khoản từ server bằng AJAX và sau đó hiển thị danh sách đó vào bảng HTML (không cần reload trang).=======================================
function loadAccounts() {
    const contextPath = window.location.pathname.split('/')[1] ? `/${window.location.pathname.split('/')[1]}` : '';
    const baseUrl = `${window.location.origin}${contextPath}/admin/accounts?action=ajaxList`;

    const search = document.getElementById("searchInput").value;
    const role = document.getElementById("roleFilter").value;
    const fromDate = document.getElementById("fromDate").value;
    const toDate = document.getElementById("toDate").value;

    const url = `${baseUrl}&search=${encodeURIComponent(search)}&role=${encodeURIComponent(role)}&fromDate=${fromDate}&toDate=${toDate}`;

    fetch(url)
            .then(response => {
                if (!response.ok)
                    throw new Error(`HTTP ${response.status}`);
                return response.json();
            })
            .then(data => {
                const tbody = document.querySelector('#accountTable tbody');
                tbody.innerHTML = '';

                if (data.length === 0) {
                    tbody.innerHTML = `<tr><td colspan="6" style="text-align:center;">Chưa có tài khoản nào</td></tr>`;
                    return;
                }

                data.forEach((acc, index) => {
                    const avatarUrl = `${window.location.origin}${contextPath}/AvatarServlet?user=${acc.username}&t=${Date.now()}`;
                    const row = `
                    <tr>
                        <td>${index + 1}</td>
                        <td><img src="${avatarUrl}" alt="Avatar" style="width:40px;height:40px;border-radius:50%;"></td>
                        <td>${acc.username}</td>
                        <td>${acc.role}</td>
                        <td>${acc.createdAt}</td>
                        <td>
                            <button class="action-buttons__btn action-buttons__btn--edit"
                                onclick="openEditAccountModal('${acc.accountId}', '${acc.username}', '${acc.role}', '${avatarUrl}')">
                                Edit
                            </button>
                            <button class="action-buttons__btn action-buttons__btn--delete"
                                onclick="openDeleteAccountModal('${acc.accountId}')">
                                Delete
                            </button>
                        </td>
                    </tr>
                `;
                    tbody.innerHTML += row;
                });
            })
            .catch(error => {
                console.error('Lỗi khi load account:', error);
            });
}

function filterAccounts() {
    const contextPath = window.location.pathname.split('/')[1] ? `/${window.location.pathname.split('/')[1]}` : '';
    const url = new URL(`${window.location.origin}${contextPath}/admin/accounts`);

    url.searchParams.append("action", "ajaxList");

    // Lấy dữ liệu từ input
    const search = document.getElementById("searchInput").value;
    const role = document.getElementById("roleFilter").value;
    const fromDate = document.getElementById("fromDate").value;
    const toDate = document.getElementById("toDate").value;

    if (search)
        url.searchParams.append("search", search);
    if (role)
        url.searchParams.append("role", role);
    if (fromDate)
        url.searchParams.append("fromDate", fromDate);
    if (toDate)
        url.searchParams.append("toDate", toDate);

    fetch(url)
            .then(response => response.json())
            .then(data => {
                const tbody = document.querySelector('#accountTable tbody');
                tbody.innerHTML = '';

                if (data.length === 0) {
                    tbody.innerHTML = `<tr><td colspan="6" style="text-align:center;">Không tìm thấy tài khoản nào</td></tr>`;
                    return;
                }

                data.forEach((acc, index) => {
                    const avatarUrl = `${window.location.origin}${contextPath}/AvatarServlet?user=${acc.username}&t=${Date.now()}`;
                    const row = `
                    <tr>
                        <td>${index + 1}</td>
                        <td><img src="${avatarUrl}" style="width:40px;height:40px;border-radius:50%;"></td>
                        <td>${acc.username}</td>
                        <td>${acc.role}</td>
                        <td>${acc.createdAt}</td>
                        <td>
                            <button onclick="openEditAccountModal('${acc.accountId}', '${acc.username}', '${acc.role}', '${avatarUrl}')">Edit</button>
                            <button onclick="openDeleteAccountModal('${acc.accountId}')">Delete</button>
                        </td>
                    </tr>
                `;
                    tbody.innerHTML += row;
                });
            })
            .catch(error => {
                console.error("Lỗi khi lọc tài khoản:", error);
            });
}


//GUI YEU CAU XOA DEN SERVER BANG AJAX KHONG CAN RELOAD L?I TRANG========================================================
function deleteAccountAjax(accountId) {
    const formData = new FormData();
    formData.append("action", "delete");
    formData.append("accountId", accountId);

    fetch(contextPath + "/admin/accounts", {
        method: "POST",
        body: formData
    }).then(res => res.text())
            .then(result => {
                if (result === "OK") {
                    loadAccounts();
                    closeModal("deleteAccountModal");
                } else {
                    alert("Xóa thất bại.");
                }
            }).catch(err => {
        console.error("Lỗi khi xóa:", err);
        alert("Có lỗi xảy ra khi xóa.");
    });
}

// DUNG DE MO MODAL XOA===================================================================================
function openDeleteAccountModal(accountId) {
    document.getElementById('deleteAccountId').value = accountId;
    document.getElementById('deleteAccountModal').style.display = 'flex';
}

//DOAN CODE DUNG CHO CHUC NANG XÓA ========================================================================
function submitDeleteAccount(form) {
    event.preventDefault(); // Ngăn form gửi mặc định

    const formData = new FormData();
    formData.append("action", "delete");
    formData.append("accountId", form.accountId.value);
    const contextPath = "/" + window.location.pathname.split("/")[1];

    const resultDiv = document.getElementById("resultDelete");

    fetch(`${window.location.origin}${contextPath}/admin/accounts`, {
        method: "POST",
        body: formData
    })
            .then(res => {
                if (!res.ok) {
                    throw new Error(`HTTP error! Status: ${res.status}`);
                }
                return res.text();
            })
            .then(result => {
                if (result === "OK") {
                    if (resultDiv) {
                        resultDiv.innerHTML = `<p style="color:green; font-weight:bold;">Xóa thành công!</p>`;
                    }
                    setTimeout(() => {
                        closeModal("deleteAccountModal");
                        loadAccounts(); // Reload danh sách tài khoản
                    }, 800);
                } else {
                    if (resultDiv) {
                        resultDiv.innerHTML = `<p style="color:red; font-weight:bold;">Xóa thất bại.</p>`;
                    }
                }
            })
            .catch(err => {
                console.error("Lỗi khi xóa:", err);
                if (resultDiv) {
                    resultDiv.innerHTML = `<p style="color:red; font-weight:bold;">Lỗi khi xóa: ${err.message}</p>`;
                }
            });

    return false; // Ngăn submit mặc định
}

//===================================================================================================================================================================================================
//===================================================================================================================================================================================================
// ✅ Bổ sung sau khi fetch dữ liệu sản phẩm trong openEditProductModal
function openEditProductModal(productId) {
    fetch(`/SE1816_Gym_Group_4/CategoryServlet?id=${productId}`)
            .then(res => {
                if (!res.ok)
                    throw new Error("Không thể tải dữ liệu sản phẩm");
                return res.json();
            })
            .then(data => {
                const product = data.product;
                const categories = data.categories;

                // ✅ Gán dữ liệu vào form
                document.getElementById('editProductId').value = product.productId;
                document.getElementById('editProductName').value = product.name;
                document.getElementById('editProductDescription').value = product.description;
                document.getElementById('editProductPrice').value = product.price;
                document.getElementById('editProductStock').value = product.stockQuantity;

                // Gán dropdown Category
                const select = document.getElementById('editProductCategory');
                select.innerHTML = '';

                const selectedCategoryId = product.categoryId; // Giả sử server trả số nguyên
                console.log("📌 Selected Category ID:", selectedCategoryId);

                // Gắn các option trước
                categories.forEach(cat => {
                    const option = document.createElement('option');
                    option.value = String(cat.categoryId); // ép thành chuỗi chắc cú
                    option.textContent = cat.name;
                    select.appendChild(option);
                });

                // Sau khi gắn option xong mới gán select.value
                select.value = String(selectedCategoryId);

                // Nếu không khớp, chọn option đầu tiên và cảnh báo
                if (!select.value) {
                    console.warn("⚠ Không tìm thấy category khớp, chọn giá trị mặc định đầu tiên");
                    if (select.options.length > 0) {
                        select.selectedIndex = 0;
                    }
                }

                // Kiểm tra cuối cùng
                console.log("✔️ Gán lại select.value =", select.value);


                //  Hiển thị ảnh chính
                const imagePreview = document.getElementById('editProductImagePreview');
                const imageFilenameLabel = document.getElementById('mainImageFilename');

                if (product.primaryImageId) {
                    imagePreview.src = `/SE1816_Gym_Group_4/ImagesServlet?type=product&imageId=${product.primaryImageId}`;
                    imagePreview.style.display = "block";
                    imageFilenameLabel.textContent = "(ảnh hiện tại)";
                } else {
                    imagePreview.src = "";
                    imagePreview.style.display = "none";
                    imageFilenameLabel.textContent = "";
                }

                //  Danh sách ảnh
                const imageListDiv = document.getElementById('editProductImageList');
                imageListDiv.innerHTML = '';

                if (Array.isArray(data.images)) {
                    data.images.forEach(img => {
                        const imgWrapper = document.createElement('div');
                        imgWrapper.style.position = "relative";
                        imgWrapper.style.display = "inline-block";

                        const imgEl = document.createElement('img');
                        imgEl.src = `/SE1816_Gym_Group_4/ImagesServlet?type=product&imageId=${img.imageId}`;
                        imgEl.style.width = "60px";
                        imgEl.style.margin = "5px";
                        imgEl.style.borderRadius = "6px";
                        imgEl.style.border = img.isPrimary ? "2px solid red" : "1px solid #ccc";
                        imgEl.title = img.isPrimary ? "Ảnh chính (double click để đổi)" : "Click đúp để chọn ảnh chính";

                        imgEl.ondblclick = () => {
                            if (confirm("Chọn ảnh này làm ảnh đại diện chính?")) {
                                setPrimaryImage(product.productId, img.imageId);
                            }
                        };

                        const deleteBtn = document.createElement('button');
                        deleteBtn.textContent = "✖";
                        deleteBtn.style.position = "absolute";
                        deleteBtn.style.top = "0";
                        deleteBtn.style.right = "0";
                        deleteBtn.style.background = "red";
                        deleteBtn.style.color = "white";
                        deleteBtn.style.border = "none";
                        deleteBtn.style.cursor = "pointer";
                        deleteBtn.style.fontSize = "12px";
                        deleteBtn.title = "Xóa ảnh";
                        deleteBtn.onclick = () => {
                            if (confirm("Bạn có chắc chắn muốn xóa ảnh này không?")) {
                                deleteProductImage(img.imageId);
                            }
                        };

                        imgWrapper.appendChild(imgEl);
                        imgWrapper.appendChild(deleteBtn);
                        imageListDiv.appendChild(imgWrapper);
                    });
                }

                //  Mở modal
                openModal('editProductModal');
            })
            .catch(error => {
                console.error("❌ Lỗi khi load product:", error);
            });
}



// ======================== XÓA ẢNH SẢN PHẨM ========================
function deleteProductImage(imageId) {
    const formData = new FormData();
    formData.append("formAction", "deleteImage");
    formData.append("imageId", imageId);

    fetch(`${window.location.origin}/SE1816_Gym_Group_4/admin/products`, {
        method: "POST",
        body: formData
    })
            .then(res => res.text())
            .then(result => {
                if (result === "image_deleted") {
                    alert("Đã xóa ảnh.");
                    const pid = document.getElementById('editProductId').value;
                    openEditProductModal(pid); // Tải lại modal
                } else {
                    alert("Không xóa được ảnh.");
                }
            })
            .catch(err => alert("Lỗi khi xóa ảnh: " + err));
}

// ======================== CHỌN ẢNH LÀM ĐẠI DIỆN ========================
function setPrimaryImage(productId, imageId) {
    const formData = new FormData();
    formData.append("formAction", "setPrimaryImage");
    formData.append("productId", productId);
    formData.append("imageId", imageId);

    fetch(`${window.location.origin}/SE1816_Gym_Group_4/admin/products`, {
        method: "POST",
        body: formData
    })
            .then(res => res.text())
            .then(result => {
                if (result === "primary_set") {
                    alert("Đã cập nhật ảnh đại diện.");
                    openEditProductModal(productId); // Tải lại modal
                } else {
                    alert("Không cập nhật được.");
                }
            })
            .catch(err => alert("Lỗi khi đặt ảnh đại diện: " + err));
}


// Mở và đổ dữ liệu vào Delete Product Modal
function openDeleteProductModal(productId) {
    document.getElementById("deleteProductId").value = productId;
    openModal('deleteProductModal');
}
const contextPath = '${pageContext.request.contextPath}';

function reloadProductList() {
    const contextPath = window.location.pathname.split('/')[1] ? `/${window.location.pathname.split('/')[1]}` : '';
    const url = `${window.location.origin}${contextPath}/admin/products?action=ajaxList`;

    fetch(url)
            .then(response => {
                if (!response.ok)
                    throw new Error(`HTTP ${response.status}`);
                return response.json();
            })
            .then(data => {
                const tbody = document.querySelector('#productsTable tbody');
                tbody.innerHTML = '';

                if (data.length === 0) {
                    tbody.innerHTML = `<tr><td colspan="8" style="text-align:center;">Chưa có sản phẩm nào</td></tr>`;
                    return;
                }

                data.forEach((product, index) => {
                    const imageUrl = product.primaryImageId
                            ? `${window.location.origin}${contextPath}/ImagesServlet?type=product&imageId=${product.primaryImageId}&t=${Date.now()}`
                            : `${contextPath}/avatar/default.png`;

                    const row = `
                    <tr>
                        <td style="width:60px;">${index + 1}</td>
                        <td><img src="${imageUrl}" alt="Image" style="width:60px; height:60px; border-radius:10px; margin-top: 5px"></td>
                        <td>${product.name}</td>
                        <td>${product.categoryName}</td>
                        <td>${product.price.toLocaleString('vi-VN')} đ</td>
                        <td>${product.stockQuantity}</td>
                        <td>${product.description || ''}</td>
                        <td>
                            <button class="action-buttons__btn action-buttons__btn--edit"
                                onclick="openEditProductModal('${product.productId}', '${product.name}', '${product.description}', '${product.price}', '${product.stockQuantity}', '${product.categoryId}', '${imageUrl}')">
                                Edit
                            </button>
                            <button class="action-buttons__btn action-buttons__btn--delete"
                                onclick="openDeleteProductModal('${product.productId}')">
                                Delete
                            </button>
                        </td>
                    </tr>
                `;
                    tbody.innerHTML += row;
                });
            })
            .catch(error => {
                console.error('Lỗi khi tải danh sách sản phẩm:', error);
                fetch(url)
                        .then(r => r.text())
                        .then(text => console.warn("Nội dung không phải JSON:", text));
            });
}

function validateProductForm(form) {
    const price = parseFloat(form.price.value);
    const stock = parseInt(form.stockQuantity.value);

    if (price <= 0 || stock <= 0) {
        alert("Giá và số lượng trong kho phải lớn hơn 0.");
        return false;
    }

    if (form.categoryId.value === "") {
        alert("Vui lòng chọn thể loại.");
        return false;
    }

    return submitFormAjax(form, 'resultEditProduct'); // Gọi AJAX nếu cần
}

function previewEditProductImage(input) {
    const preview = document.getElementById('editProductImagePreview');
    const fileLabel = document.getElementById('mainImageFilename');

    if (input.files && input.files[0]) {
        const file = input.files[0];
        preview.src = URL.createObjectURL(file);
        preview.style.display = "block";
        fileLabel.textContent = file.name;
    } else {
        preview.style.display = "none";
        fileLabel.textContent = "";
    }
}
function previewNewImages(input) {
    const container = document.getElementById('editNewImagePreviewList');
    container.innerHTML = '';

    if (input.files && input.files.length > 0) {
        Array.from(input.files).forEach(file => {
            const img = document.createElement('img');
            img.src = URL.createObjectURL(file);
            img.style.width = "60px";
            img.style.borderRadius = "6px";
            img.style.border = "1px solid #ccc";
            container.appendChild(img);
        });
    }
}

function previewNewImages(input) {
    const container = document.getElementById('editNewImagePreviewList');
    container.innerHTML = '';

    if (input.files && input.files.length > 0) {
        Array.from(input.files).forEach(file => {
            const img = document.createElement('img');
            img.src = URL.createObjectURL(file);
            img.style.width = "60px";
            img.style.borderRadius = "6px";
            img.style.border = "1px solid #ccc";
            container.appendChild(img);
        });
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///
///                                            NHAT  KHANG
///
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Function to load the list of vouchers from the server
// Function to load the list of vouchers from the server
function loadVouchers() {
    console.log('Loading voucher list with filters...');
    ///NHATKHANG - Modified to handle search, date filters and status correctly
    const contextPath = window.location.pathname.split('/')[1] ? `/${window.location.pathname.split('/')[1]}` : '';

    // Get filter values
    const searchTerm = document.getElementById('searchVoucher') ? document.getElementById('searchVoucher').value : '';
    const status = document.getElementById('statusFilter') ? document.getElementById('statusFilter').value : '';
    const startDate = document.getElementById('startDate') ? document.getElementById('startDate').value : '';
    const endDate = document.getElementById('endDate') ? document.getElementById('endDate').value : '';

    // Build URL with query parameters
    let url = `${window.location.origin}${contextPath}/admin/vouchers?action=ajaxList`;
    url += `&search=${encodeURIComponent(searchTerm)}`;
    url += `&status=${encodeURIComponent(status)}`;
    url += `&startDate=${encodeURIComponent(startDate)}`;
    url += `&endDate=${encodeURIComponent(endDate)}`;

    console.log('Fetching vouchers from URL:', url);

    fetch(url)
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP error! Status: ${response.status}`);
                }
                return response.json();
            })
            .then(data => {
                console.log('Voucher data received:', data);
                const tbody = document.querySelector('#voucherTable tbody');
                if (!tbody) {
                    console.error('Cannot find tbody in #voucherTable');
                    return;
                }
                tbody.innerHTML = ''; // Clear current content

                if (data.length === 0) {
                    tbody.innerHTML = `<tr><td colspan="12" style="text-align:center;">No vouchers available</td></tr>`;
                    return;
                }

                data.forEach((voucher, index) => {
                    const startDate = voucher.startDate
                            ? new Date(voucher.startDate + 'T00:00:00').toLocaleDateString('vi-VN', {
                        day: '2-digit', month: '2-digit', year: 'numeric'
                    })
                            : 'N/A';

                    const endDate = voucher.endDate
                            ? new Date(voucher.endDate + 'T00:00:00').toLocaleDateString('vi-VN', {
                        day: '2-digit', month: '2-digit', year: 'numeric'
                    })
                            : 'N/A';

                    // Escape strings for JavaScript
                    const safeDescription = voucher.description ? voucher.description.replace(/'/g, "\\'") : '';
                    const safeCode = voucher.code ? voucher.code.replace(/'/g, "\\'") : '';

                    const row = `
                <tr>
                    <td>${index + 1}</td>
                    <td>${voucher.code}</td>
                    <td>${voucher.description}</td>
                    <td>${voucher.discountPercent}</td>
                    <td>${voucher.maxDiscount}</td>
                    <td>${voucher.usageLimit}</td>
                    <td>${voucher.usedCount}</td>
                    <td>${voucher.minOrderAmount}</td>
                    <td>${startDate}</td>
                    <td>${endDate}</td>
                    <td>${voucher.isActive ? 'Active' : 'Inactive'}</td>
                    <td>
                        <button class="action-buttons__btn action-buttons__btn--edit" style="margin-top: 5px;"
                            onclick="openEditVoucherModal('${voucher.voucherId}', '${safeCode}', '${safeDescription}', '${voucher.discountPercent}', '${voucher.maxDiscount}', '${voucher.usageLimit}', '${voucher.usedCount}', '${voucher.minOrderAmount}', '${voucher.startDate}', '${voucher.endDate}', '${voucher.isActive}')">
                            Edit
                        </button>
                        <button class="action-buttons__btn action-buttons__btn--delete" style="margin-top: 5px;"
                            onclick="openDeleteVoucherModal('${voucher.voucherId}')">
                            Delete
                        </button>
                    </td>
                </tr>`;
                    tbody.innerHTML += row;
                });
            })
            .catch(error => {
                console.error('Error loading voucher list:', error);
                // Try to get text response for troubleshooting
                fetch(url)
                        .then(r => r.text())
                        .then(text => console.warn("Server response is not JSON:", text))
                        .catch(err => console.error("Failed to get error details:", err));
            });
}




function submitDeleteVouchers(form) {
    event.preventDefault();

    const formData = new FormData(form);
    const params = new URLSearchParams();

    for (let [key, value] of formData.entries()) {
        console.log(`${key}: ${value}`);
        params.append(key, value);
    }

    const resultDiv = document.getElementById("resultDeleteVoucher");

    fetch(form.action, {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded", // Đảm bảo sử dụng đúng Content-Type
        },
        body: params,
    })
            .then(res => res.text())
            .then(text => {
                console.log("🔍 Raw response:", text);
                let data;
                try {
                    data = JSON.parse(text);
                } catch (err) {
                    throw new Error("Phản hồi không hợp lệ từ server: " + text);
                }

                if (data.status === "deleted") {
                    resultDiv.innerHTML = `<p style="color:green; font-weight:bold;">${data.message}</p>`;
                    setTimeout(() => {
                        closeModal("deleteVoucherModal");
                        loadVouchers();
                    }, 800);
                } else {
                    resultDiv.innerHTML = `<p style="color:red; font-weight:bold;">Xóa thất bại: ${data.message}</p>`;
                }
            })
            .catch(error => {
                console.error("Lỗi:", error);
                resultDiv.innerHTML = `<p style="color:red; font-weight:bold;">Lỗi khi xóa: ${error.message}</p>`;
            });

    return false;
}

// Mở và đổ dữ liệu vào Delete Voucher Modal
function openDeleteVoucherModal(voucherId) {
    console.log("voucherId = ", voucherId); // ✅ Log để kiểm tra
    document.getElementById("deleteVoucherId").value = voucherId;
    openModal('deleteVoucherModal');
}
//
function submitFormAjaxx(event, form, resultDiv) {
    event.preventDefault();  // Ngừng hành động gửi form mặc định

    const formData = new FormData(form);
    const params = new URLSearchParams();

    // Chuyển FormData thành URLSearchParams
    for (let [key, value] of formData.entries()) {
        params.append(key, value);
    }

    const resultDivElement = document.getElementById(resultDiv);

    // Clear any previous messages before submitting the form
    resultDivElement.innerHTML = '';  // Xóa thông báo cũ trước khi gửi

    fetch(form.action, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params,
    })
            .then(res => res.text())
            .then(text => {
                let data;
                try {
                    data = JSON.parse(text);  // Parse phản hồi thành JSON
                } catch (err) {
                    throw new Error("Phản hồi không hợp lệ từ server: " + text);
                }

                if (data.status === "created") {
                    // Hiển thị thông báo thành công
                    resultDivElement.innerHTML = `<p style="color:green; font-weight:bold;">Voucher created successfully!</p>`;

                    // Sau một thời gian ngắn, đóng modal và tải lại danh sách voucher
                    setTimeout(() => {
                        // Đóng modal
                        closeModal(form.closest('.modal').id);  // Đóng modal hiện tại

                        // Cập nhật lại danh sách voucher
                        loadVouchers();  // Tải lại danh sách voucher

                        // Reset form sau khi gửi thành công
                        form.reset(); // Đặt lại giá trị của các trường trong form về mặc định
                    }, 1000);  // Đợi 1 giây trước khi đóng modal và cập nhật lại dữ liệu
                } else {
                    resultDivElement.innerHTML = `<p style="color:red; font-weight:bold;">Lỗi: ${data.message}</p>`;
                }
            })
            .catch(error => {
                console.error('Lỗi:', error);
                resultDivElement.innerHTML = `<p style="color:red; font-weight:bold;">Lỗi khi tạo voucher: ${error.message}</p>`;
            });

    return false;
}








// Add the new voucher to the table without reloading the entire data
function addVoucherToTable(voucher) {
    const tbody = document.querySelector('#vouchersTable .data-table tbody');
    if (tbody) {
        // Chuyển đổi ngày thành chuỗi
        const startDate = new Date(voucher.startDate).toLocaleDateString();  // Chuyển startDate thành chuỗi
        const endDate = new Date(voucher.endDate).toLocaleDateString();  // Chuyển endDate thành chuỗi

        const row = `
            <tr>
                <td>${voucher.voucherId}</td> <!-- Đảm bảo bạn sử dụng đúng tên thuộc tính -->
                <td>${voucher.code}</td>
                <td>${voucher.description}</td>
                <td>${voucher.discountPercent}</td>
                <td>${voucher.maxDiscount}</td>
                <td>${voucher.usageLimit}</td>
                <td>${voucher.usedCount}</td>
                <td>${voucher.minOrderAmount}</td>
                <td>${startDate}</td> <!-- Hiển thị startDate đã chuyển thành chuỗi -->
                <td>${endDate}</td>   <!-- Hiển thị endDate đã chuyển thành chuỗi -->
                <td>${voucher.isActive ? 'Active' : 'Inactive'}</td> <!-- Hiển thị trạng thái đúng -->
                <td>
                    <button class="action-buttons__btn action-buttons__btn--edit">Edit</button>
                    <button class="action-buttons__btn action-buttons__btn--delete">Delete</button>
                </td>
            </tr>
        `;
        tbody.insertAdjacentHTML('beforeend', row); // Chèn dòng mới vào bảng
    }
}



function openModal(id) {
    const modal = document.getElementById(id);
    if (modal) {
        modal.style.display = 'flex';
        if (id === 'addTrainer') {
            loadTrainerAccountOptions();
        }
    }
}
//const formData = new FormData(form);
//const params = new URLSearchParams();
//for (let [key, value] of formData.entries()) {
//    console.log(`${key}: ${value}`);
//    params.append(key, value);
//}




function openEditVoucherModal(voucherId, code, description, discountPercent, maxDiscount, usageLimit, usedCount, minOrderAmount, startDate, endDate, isActive) {
// Điền dữ liệu vào các trường trong modal
    document.getElementById('editVoucherCode').value = code;
    document.getElementById('editVoucherId').value = voucherId;
    document.getElementById('editVoucherDescription').value = description;
    document.getElementById('editVoucherDiscount').value = discountPercent;
    document.getElementById('editVoucherMaxDiscount').value = maxDiscount;
    document.getElementById('editVoucherUsageLimit').value = usageLimit;
    document.getElementById('editVoucherUsedCount').value = usedCount;
    document.getElementById('editVoucherMinOrderAmount').value = minOrderAmount;
    document.getElementById('editVoucherStartDate').value = startDate;
    document.getElementById('editVoucherEndDate').value = endDate;
    document.getElementById('editVoucherActive').value = isActive === "true" ? "true" : "false";

    // Mở modal
    openModal('editVoucherModal');
}


function submitEditVoucher(form) {
    event.preventDefault();

    const formData = new FormData(form);
    const params = new URLSearchParams();

    // Duyệt qua các cặp key-value trong FormData và thêm vào params
    for (let [key, value] of formData.entries()) {
        console.log(`${key}: ${value}`);
        params.append(key, value);
    }

    const resultDiv = document.getElementById("resultEditVoucher");

    fetch(form.action, {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded", // Đảm bảo sử dụng đúng Content-Type
        },
        body: params,
    })
            .then(res => res.text())
            .then(text => {
                console.log("🔍 Raw response:", text);
                let data;
                try {
                    data = JSON.parse(text);
                } catch (err) {
                    throw new Error("Phản hồi không hợp lệ từ server: " + text);
                }

                if (data.status === "updated") {
                    resultDiv.innerHTML = `<p style="color:green; font-weight:bold;">${data.message}</p>`;
                    setTimeout(() => {
                        closeModal("editVoucherModal");
                        loadVouchers();  // Tải lại danh sách voucher sau khi cập nhật thành công
                    }, 800);
                } else {
                    resultDiv.innerHTML = `<p style="color:red; font-weight:bold;">Cập nhật thất bại: ${data.message}</p>`;
                }
            })
            .catch(error => {
                console.error("Lỗi:", error);
                resultDiv.innerHTML = `<p style="color:red; font-weight:bold;">Lỗi khi cập nhật: ${error.message}</p>`;
            });

    return false;
}

// Get context path for AJAX URL
function getContextPath() {
    return window.location.pathname.substring(0, window.location.pathname.indexOf("/admin"));
}

// Function to handle real-time search as the user types
var searchTimeout;
function initVoucherSearch() {
    ///NHATKHANG - Modified to prevent page reload when searching
    // Add event listeners when DOM is loaded
    document.getElementById('searchVoucher').addEventListener('input', function () {
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(loadVouchers, 300); // Use loadVouchers instead of searchVouchers
    });
}

// Initialize search when DOM is fully loaded
document.addEventListener('DOMContentLoaded', function () {
    if (document.getElementById('searchVoucher')) {
        initVoucherSearch();
    }
});
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                    HOANG KHANG       
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


function loadStaffData() {
    const contextPath = window.location.pathname.split('/')[1] ? `/${window.location.pathname.split('/')[1]}` : '';
    const url = `${window.location.origin}${contextPath}/admin/staffs?action=ajaxList`;

    fetch(url)
            .then(response => {
                if (!response.ok)
                    throw new Error(`HTTP ${response.status}`);
                return response.json();
            })
            .then(data => {
                const tbody = document.querySelector('#staffsTable tbody');
                tbody.innerHTML = '';

                if (data.length === 0) {
                    tbody.innerHTML = `<tr><td colspan="9" style="text-align:center;">Chưa có nhân viên nào</td></tr>`;
                    return;
                }

                data.forEach((staff, index) => {
                    console.log("🧪 Staff Object:", staff);
                    console.log("➡ Username:", staff.account.username);
                    console.log("➡ Full Name:", staff.fullName);
                    console.log("➡ Account:", staff.account); // <== nếu xài object có account bên trong
                    const avatarUrl = `${window.location.origin}${contextPath}/AvatarServlet?user=${staff.account.username}&t=${Date.now()}`;
                    const row = `
                    <tr>
                        <td>${index + 1}</td>                  
                        <td><img src="${avatarUrl}" alt="Avatar" style="width:40px;height:40px;border-radius:50%;"></td>
                        <td>${staff.account.username}</td>
                        <td>${staff.fullName}</td>
                        <td>${staff.email}</td>
                        <td>${staff.phone}</td>
                        <td>${staff.position}</td>
                        <td>${staff.status}</td>
                        <td>${staff.staffCode}</td>
                        <td>
            
                            <button class="action-buttons__btn action-buttons__btn--edit"
                                onclick="openEditStaffModal('${staff.staffId}', '${staff.account.accountId}',
                                 '${staff.account.username}', '${staff.fullName}',
                                 '${staff.email}', '${staff.phone}', '${staff.position}', '${staff.status}')">
                                  Edit
                            </button>
                            <button class="action-buttons__btn action-buttons__btn--delete"
                                onclick="openDeleteStaffModal('${staff.staffId}')">
                                Delete
                            </button>
                        </td>
                    </tr>
                `;
                    tbody.innerHTML += row;
                });
            })
            .catch(error => {
                console.error('Lỗi khi load staff:', error);
                fetch(url)
                        .then(r => r.text())
                        .then(text => console.warn("Nội dung server trả về không phải JSON:", text));
            });
}

document.addEventListener("DOMContentLoaded", function () {
    // Khi modal được mở
    window.openModal = function (id) {
        document.getElementById(id).style.display = 'block';
        if (id === 'addStaffModal') {
            loadStaffAccountOptions();
        }
        if (id === 'addTrainer') {
            loadTrainerAccountOptions();
        }
        if (id === 'addCustomerModal') {
            loadCustomerAccountOptions();
        }
    }
    function loadCustomerAccountOptions() {
        const contextPath = window.location.pathname.split('/')[1];
        const url = `/${contextPath}/admin/customer?action=loadAccounts`;

        fetch(url)
                .then(res => {
                    if (!res.ok)
                        throw new Error(`HTTP error ${res.status}`);
                    return res.json();
                })
                .then(data => {
                    console.log("Dữ liệu nhận được:", data);  // Kiểm tra xem dữ liệu có chính xác không
                    const select = document.querySelector('select[name="accountCusId"]');
                    select.innerHTML = '<option value="">-- Select Customer Account --</option>'; // Reset lại giá trị
                    console.log("Dữ liệu nhận được:", select);
                    if (data.length === 0) {
                        const opt = document.createElement('option');
                        opt.textContent = '-- No Available Customer Accounts --';
                        opt.disabled = true;
                        select.appendChild(opt);
                        return;
                    }

                    // Cập nhật danh sách các option vào select
                    data.forEach(acc => {
                        const opt = document.createElement('option');
                        opt.value = acc.accountId;
                        opt.textContent = acc.username;  // Hiển thị tên tài khoản
                        select.appendChild(opt);
                    });
                })
                .catch(err => {
                    console.error("❌ Lỗi khi load account staff:", err);
                });
    }
    // Gọi API để lấy account chưa là staff
    function loadStaffAccountOptions() {
        const contextPath = window.location.pathname.split('/')[1];
        const url = `/${contextPath}/admin/staffs?action=loadAccounts`;

        fetch(url)
                .then(res => {
                    if (!res.ok)
                        throw new Error(`HTTP error ${res.status}`);
                    return res.json();
                })
                .then(data => {
                    const select = document.querySelector('select[name="accountId"]');
                    select.innerHTML = '<option value="">-- Select Staff Account --</option>';

                    if (data.length === 0) {
                        const opt = document.createElement('option');
                        opt.textContent = '-- No Available Staff Accounts --';
                        opt.disabled = true;
                        select.appendChild(opt);
                        return;
                    }

                    data.forEach(acc => {
                        const opt = document.createElement('option');
                        opt.value = acc.accountId;
                        opt.textContent = acc.username;
                        select.appendChild(opt);
                    });
                })
                .catch(err => {
                    console.error("❌ Lỗi khi load account staff:", err);
                });
    }
});

function openEditStaffModal(staffId, accountId, username, fullName, email, phone, position, status) {


    document.getElementById('editStaffId').value = staffId;
    document.getElementById('editStaffAccountId').value = accountId;
    document.getElementById('editFullName').value = fullName;
    document.getElementById('editPhone').value = phone;
    document.getElementById('editPosition').value = position;
    document.getElementById('editStatus').value = status;

    document.querySelector('input[name="action"]').value = 'edit';

    const avatarUrl = `${window.location.origin}${contextPath}/AvatarServlet?user=${username}&t=${Date.now()}`;
    if (avatarUrl && avatarUrl.trim() !== "") {
        document.getElementById('currentAvatar').src = avatarUrl;
        document.getElementById('currentAvatarContainer').style.display = 'block';
    } else {
        document.getElementById('currentAvatarContainer').style.display = 'none';
    }

    document.getElementById('editStaffModal').style.display = 'flex';
}

//
//function submitFormForStaff(form, resultContainerId, event) {
//    // Ngừng hành động mặc định của form (ngăn gửi form theo cách thông thường)
//    if (event) {
//        event.preventDefault();
//    }
//
//    // Lấy giá trị action từ thuộc tính của form
//    const action = form.getAttribute('action');
//    console.log("Form action:", action);
//
//    if (!action) {
//        console.error("❌ Form không có thuộc tính 'action'");
//        const resultDiv = document.getElementById(resultContainerId);
//        if (resultDiv) {
//            resultDiv.innerHTML = `<p style="color:red; font-weight:bold;">Lỗi: Form không có action!</p>`;
//        }
//        return false;
//    }
//
//    // Lấy dữ liệu từ form (bao gồm cả file avatar nếu có)
//    const formData = new FormData(form);
//    console.log("✅ Dữ liệu gửi đi:");
//    for (let [key, val] of formData.entries()) {
//        console.log(`${key}: ${val}`);
//    }
//
//    // Vô hiệu hóa các input trong form khi đang gửi
//    form.querySelectorAll('input, select, textarea, button').forEach(el => el.disabled = true);
//
//    // Gửi dữ liệu form qua fetch
//    fetch(action, {
//        method: 'POST', // Phương thức gửi form
//        body: formData, // Dữ liệu form
//    })
//            .then(response => {
//                // Kích hoạt lại các input sau khi gửi xong
//                form.querySelectorAll('input, select, textarea, button').forEach(el => el.disabled = false);
//
//                // Kiểm tra xem response có thành công không
//                if (!response.ok) {
//                    throw new Error(`HTTP error! Status: ${response.status}`);
//                }
//                return response.text();
//            })
//            .then(data => {
//                // Hiển thị kết quả thành công
//                const resultDiv = document.getElementById(resultContainerId);
//                if (resultDiv) {
//                    resultDiv.innerHTML = `<p style="color:green; font-weight:bold;">Thành công!</p>`;
//                }
//
//                // Đóng modal sau khi thành công
//                const modal = form.closest('.modal');
//                if (modal) {
//                    setTimeout(() => closeModal(modal.id), 800);
//                }
//
//                // Sau khi gửi thành công, làm mới danh sách nhân viên
//                setTimeout(() => {
//                    if (typeof loadStaffData === 'function') {
//                        loadStaffData();  // Hàm này tải lại dữ liệu nhân viên
//                    }
//                }, 500);
//            })
//            .catch(error => {
//                // Kích hoạt lại các input nếu có lỗi
//                form.querySelectorAll('input, select, textarea, button').forEach(el => el.disabled = false);
//
//                // Hiển thị thông báo lỗi nếu có
//                console.error('Lỗi khi gửi form:', error);
//                const resultDiv = document.getElementById(resultContainerId);
//                if (resultDiv) {
//                    resultDiv.innerHTML = `<p style="color:red; font-weight:bold;">Lỗi: ${error.message}</p>`;
//                }
//            });
//
//    return false;
//}

function openDeleteStaffModal(staffId) {
    document.getElementById('deleteStaffId').value = staffId;
    openModal('deleteStaffModal');
}

//function submitDeleteStaff(form, event) {
//    event.preventDefault();
//
//    const formData = new FormData(form);
//    const resultDiv = document.getElementById("resultDeleteStaff");
//    const contextPath = window.location.pathname.split('/')[1] ? `/${window.location.pathname.split('/')[1]}` : '';
//
//    fetch(`${window.location.origin}${contextPath}/admin/staffs`, {
//        method: 'POST',
//        body: formData
//    })
//            .then(res => res.text())
//            .then(result => {
//                console.log("📥 Server returned:", JSON.stringify(result));
//
//                if (result.trim() === "OK") {
//                    resultDiv.innerHTML = `<p style="color:green; font-weight:bold;">Xóa thành công!</p>`;
//                    setTimeout(() => {
//                        closeModal('deleteStaffModal');
//                        loadStaffData();
//                        setTimeout(() => location.reload(), 1000);
//                    }, 800);
//                } else {
//                    resultDiv.innerHTML = `<p style="color:red; font-weight:bold;">Xóa thất bại.</p>`;
//                }
//            })
//            .catch(error => {
//                console.error("Error delete staff:", error);
//                resultDiv.innerHTML = `<p style="color:red; font-weight:bold;">Lỗi: ${error.message}</p>`;
//            });
//
//    return false;
//}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                              HA PHUONG                                                                                   /////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////                                              

function reloadTrainerList() {
    const contextPath = window.location.pathname.split('/')[1] ? `/${window.location.pathname.split('/')[1]}` : '';
    const url = `${window.location.origin}${contextPath}/TrainerServlet?action=json`;

    fetch(url)
            .then(response => {
                if (!response.ok)
                    throw new Error(`HTTP ${response.status}`);
                return response.json();
            })
            .then(data => {
                const tbody = document.querySelector('#trainerTable tbody');
                tbody.innerHTML = '';

                if (data.length === 0) {
                    tbody.innerHTML = `<tr><td colspan="10" style="text-align:center;">Chưa có huấn luyện viên nào</td></tr>`;
                    return;
                }

                data.forEach((trainer, index) => {
                    const account = trainer.accountId; // Đây là object Account
                    const avatarUrl = account && account.username
                            ? `${window.location.origin}${contextPath}/AvatarServlet?user=${account.username}&t=${Date.now()}`
                            : `${contextPath}/avatar/default.png`;


                    const row = `
                    <tr>
                        <td>${index + 1}</td>
                        <td><img src="${avatarUrl}" alt="Avatar" style="width:40px;height:40px;border-radius:50%"></td>
                        <td>${account.username}</td>
                        <td>${trainer.fullName}</td>
                        <td>${trainer.email || ''}</td>
                        <td>${trainer.phone || ''}</td>
                        <td>${trainer.bio || ''}</td>
                        <td>${trainer.experienceYears} year</td>
                        <td>${trainer.rating.toFixed(1)} ★</td>
                        <td>
                            <button class="action-buttons__btn action-buttons__btn--edit"
                               onclick="openEditTrainerModal(${trainer.trainerId})">Edit</button>
                            <button class="action-buttons__btn action-buttons__btn--delete"
                                onclick="openDeleteTrainerModal(${trainer.trainerId})">Delete</button>

                        </td>
                    </tr>
                `;
                    tbody.innerHTML += row;
                });
            })
            .catch(error => {
                console.error('Lỗi khi tải danh sách trainer:', error);
                fetch(url)
                        .then(r => r.text())
                        .then(text => console.warn("Nội dung không phải JSON:", text));
            });
}


function submitEditTrainerForm(form, resultContainerId) {
    const formData = new FormData(form);
    formData.append('formAction', 'edit');

    // Debug
    for (let [key, val] of formData.entries()) {
        console.log(`✏️ Edit: ${key} = ${val}`);
    }

    const actionUrl = form.getAttribute("action");
    const resultContainer = document.getElementById(resultContainerId);

    fetch(actionUrl, {
        method: 'POST',
        body: formData
    })
            .then(async response => {
                const rawText = await response.text();
                console.log("📥 Raw response (edit):", rawText);

                if (!rawText)
                    throw new Error("Empty response");

                let result = JSON.parse(rawText);
                if (result.status === 'success') {
                    resultContainer.innerHTML = `<p style="color:green;">${result.message}</p>`;
                    form.reset();
                    closeModal('editTrainerModal');
                    reloadTrainerList();
                } else {
                    resultContainer.innerHTML = `<p style="color:red;">${result.message}</p>`;
                }
            })
            .catch(error => {
                console.error("❌ Edit Trainer error:", error);
                resultContainer.innerHTML = `<p style="color:red;">Lỗi server: ${error.message}</p>`;
            });

    return false;
}


function openEditTrainerModal(trainerId) {
    // Gọi AJAX lấy trainer từ server
    const contextPath = window.location.pathname.split('/')[1] ? `/${window.location.pathname.split('/')[1]}` : '';
    fetch(`${window.location.origin}${contextPath}/TrainerServlet?action=getById&trainerId=${trainerId}`)
            .then(res => {
                if (!res.ok)
                    throw new Error("Network error");
                return res.json();
            })
            .then(trainer => {
                if (trainer) {
                    document.getElementById('editTrainerId').value = trainer.trainerId || '';
                    document.getElementById('editTrainerFullName').value = trainer.fullName || '';
                    document.getElementById('editTrainerEmail').value = trainer.email || '';
                    document.getElementById('editTrainerPhone').value = trainer.phone || '';
                    document.getElementById('editTrainerBio').value = trainer.bio || '';
                    document.getElementById('editTrainerExperience').value = trainer.experienceYears || '';
                    document.getElementById('editTrainerRating').value = trainer.rating || '';
                    document.getElementById('editTrainerModal').style.display = 'flex';
                } else {
                    alert("Không tìm thấy trainer.");
                }
            })
            .catch(err => {
                alert("Lỗi khi lấy trainer: " + err);
            });
}



function openDeleteTrainerModal(trainerId) {
    const contextPath = window.location.pathname.split('/')[1] ? `/${window.location.pathname.split('/')[1]}` : '';
    fetch(`${window.location.origin}${contextPath}/TrainerServlet?action=getById&trainerId=${trainerId}`)
            .then(res => {
                if (!res.ok)
                    throw new Error("Network error");
                return res.json();
            })
            .then(trainerData => {
                if (trainerData) {
                    document.getElementById('trainerName').innerText = trainerData.fullName;
                    document.getElementById('deleteTrainerId').value = trainerId;
                    document.getElementById('deleteTrainerModal').style.display = 'flex';
                } else {
                    alert("Không tìm thấy trainer.");
                }
            })
            .catch(err => {
                alert("Lỗi khi lấy trainer: " + err);
            });
}

function submitDeleteTrainer() {
    const trainerId = document.getElementById('deleteTrainerId').value;
    const contextPath = window.location.pathname.split('/')[1] ? `/${window.location.pathname.split('/')[1]}` : '';
    const url = `${window.location.origin}${contextPath}/TrainerServlet`;
    const formData = new FormData();
    formData.append('formAction', 'delete');
    formData.append('trainerId', trainerId);

    const resultDiv = document.getElementById('deleteTrainerResult');
    fetch(url, {
        method: 'POST',
        body: formData
    })
            .then(async response => {
                const rawText = await response.text();
                let result;
                try {
                    result = JSON.parse(rawText);
                } catch (err) {
                    resultDiv.innerHTML = `<p style="color:red;">Lỗi server: ${rawText}</p>`;
                    return;
                }
                if (result.status === 'success') {
                    resultDiv.innerHTML = `<p style="color:green;">${result.message}</p>`;
                    setTimeout(() => {
                        closeModal('deleteTrainerModal');
                        reloadTrainerList();
                    }, 700);
                } else {
                    resultDiv.innerHTML = `<p style="color:red;">${result.message}</p>`;
                }
            })
            .catch(error => {
                resultDiv.innerHTML = `<p style="color:red;">Lỗi server: ${error.message}</p>`;
            });
}


function loadTrainerAccountOptions() {
    const contextPath = window.location.pathname.split('/')[1];
    const url = `/${contextPath}/TrainerServlet?action=getAccountsWithoutTrainer`;

    fetch(url)
            .then(res => {
                if (!res.ok)
                    throw new Error(`HTTP error ${res.status}`);
                return res.json();
            })
            .then(data => {
                console.log("✅ Trainer Accounts loaded:", data);
                const modal = document.getElementById("addTrainer");
                const select = modal.querySelector('select[name="accountId"]');
                select.innerHTML = '<option value="">-- Choose Username --</option>';

                if (data.length === 0) {
                    const opt = document.createElement('option');
                    opt.textContent = '-- No Available Trainer Accounts --';
                    opt.disabled = true;
                    select.appendChild(opt);
                    return;
                }

                data.forEach(acc => {
                    console.log("➕ Adding option:", acc.username);
                    const opt = document.createElement('option');
                    opt.value = acc.accountId;               // <-- Đây là giá trị gửi đi
                    opt.textContent = acc.username;          // <-- Đây là nội dung hiển thị
                    select.appendChild(opt);
                });
            })
            .catch(err => {
                console.error("❌ Error loading trainer accounts:", err);
            });
}

function openAddTrainerModal() {
    loadTrainerAccountOptions(); // Gọi API để nạp dropdown
    document.getElementById('addTrainer').style.display = 'flex';
}


function submitFormAjaxTrainers(form, resultContainerId) {
    console.log("🚀 Submitting form via AJAX...");

    const formData = new FormData(form);
    for (let [key, val] of formData.entries()) {
        console.log(`🔍 ${key} = ${val}`);
    }

    const actionUrl = form.getAttribute("action");
    const resultContainer = document.getElementById(resultContainerId);

    fetch(actionUrl, {
        method: 'POST',
        body: formData
    })
            .then(async response => {
                const rawText = await response.text();
                console.log("📥 Raw response from server:", rawText);

                if (!rawText)
                    throw new Error("Empty response");

                let result = JSON.parse(rawText);
                console.log("✅ Parsed JSON:", result);

                if (result.status === 'success') {
                    resultContainer.innerHTML = `<p style="color:green;">${result.message}</p>`;
                    form.reset();
                    closeModal('addTrainer');
                    reloadTrainerList();
                } else {
                    resultContainer.innerHTML = `<p style="color:red;">${result.message}</p>`;
                }
            })
            .catch(error => {
                console.error("❌ Lỗi xử lý response:", error);
                resultContainer.innerHTML = `<p style="color:red;">Lỗi server: ${error.message}</p>`;
            });

    return false;
}


//=============================================================================================================================
//||                                                                                                                         ||
//||                                           BaoMinh                                                                       ||
//||                                                                                                                         ||
//=============================================================================================================================
let customerDataMap = {};
function loadCustomers() {
    const contextPath = window.location.pathname.split('/')[1] ? `/${window.location.pathname.split('/')[1]}` : '';
    const url = `${window.location.origin}${contextPath}/admin/customer?action=ajaxList`;

    fetch(url)
            .then(response => {
                if (!response.ok)
                    throw new Error(`HTTP ${response.status}`);
                return response.json();
            })
            .then(data => {
                customerDataMap = {};
                const tbody = document.querySelector('#customerTable tbody');
                tbody.innerHTML = '';

                if (data.length === 0) {
                    tbody.innerHTML = `<tr><td colspan="7" style="text-align:center;">Chưa có khách hàng nào</td></tr>`;
                    return;
                }

                data.forEach((cus, index) => {
                    customerDataMap[cus.customerId] = cus;
                    const avatarUrl = `${window.location.origin}${contextPath}/AvatarServlet?user=${cus.account.username}&t=${Date.now()}`;
                    const row = `
                    <tr>
                        <td>${index + 1}</td>
                        <td><img src="${avatarUrl}" alt="Avatar" style="width:40px;height:40px;border-radius:50%;"></td>
                        <td>${cus.account.username}</td>
                        <td>${cus.fullName}</td>
                        <td>${cus.email}</td>
                        <td>${cus.phone}</td>
                        <td>${cus.customerCode || ''}</td>
                        <td>
                         <button class="action-buttons__btn action-buttons__btn--edit"
                            onclick="openEditCustomerModal('${cus.customerId}')">
                            Edit</button>


                            <button class="action-buttons__btn action-buttons__btn--delete"
                                onclick="openDeleteCustomerModal('${cus.customerId}')">Delete</button>
                        </td>
                    </tr>
                `;
                    tbody.innerHTML += row;
                });
                console.log("DEBUG: customerDataMap", customerDataMap);
                // --- In thử 1 object (nếu có) ---
                for (let key in customerDataMap) {
                    console.log("Customer:", key, customerDataMap[key]);
                    break; // chỉ in 1 để xem mẫu
                }
            })
            .catch(error => {
                console.error('Lỗi khi tải danh sách khách hàng:', error);
                fetch(url)
                        .then(r => r.text())
                        .then(text => console.warn("Phản hồi không phải JSON:", text));
            });
}


function openEditCustomerModal(customerId) {
    const cus = customerDataMap[customerId];
    if (!cus) {
        alert("Không tìm thấy dữ liệu khách hàng!");
        return;
    }
    document.getElementById("editCustomerId").value = cus.customerId || '';
    document.getElementById("editCustomerFullName").value = cus.fullName || '';
    document.getElementById("editCustomerEmail").value = cus.email || '';
    document.getElementById("editCustomerPhone").value = cus.phone || '';
    document.getElementById("editCustomerCode").value = cus.customerCode || '';
    document.getElementById("editCustomerAddress").value = cus.address || '';
    document.getElementById("editCustomerAccountId").value = cus.account.accountId || '';
    document.getElementById("editCustomerAvatarPreview").src =
            `${window.location.origin}${window.location.pathname.split('/')[1] ? `/${window.location.pathname.split('/')[1]}` : ''}/AvatarServlet?user=${cus.account.username}&t=${Date.now()}`;
    openModal("editCustomerModal");
}




function openDeleteCustomerModal(customerId) {
    document.getElementById('deleteCustomerId').value = customerId;
    openModal('deleteCustomerModal');
}

function submitDeleteCustomer(event) {
    event.preventDefault();

    const form = document.getElementById('deleteCustomerForm');
    const formData = new FormData(form);

    const contextPath = window.location.pathname.split('/')[1] ? `/${window.location.pathname.split('/')[1]}` : '';
    const url = `${window.location.origin}${contextPath}/admin/customer`;

    fetch(url, {
        method: 'POST',
        body: formData
    })
            .then(res => {
                if (!res.ok)
                    throw new Error(`HTTP ${res.status}`);
                return res.text();
            })
            .then(result => {
                if (result.trim() === "OK") {
                    document.getElementById("resultDeleteCustomer").innerHTML = `<p style="color:green;font-weight:bold;">Xóa thành công!</p>`;
                    setTimeout(() => {
                        closeModal("deleteCustomerModal");
                        loadCustomers(); // Tải lại danh sách
                    }, 800);
                } else {
                    document.getElementById("resultDeleteCustomer").innerText = "Xóa thất bại: " + result;
                }
            })
            .catch(error => {
                console.error("❌ Lỗi khi xóa:", error);
                document.getElementById("resultDeleteCustomer").innerText = `Lỗi khi gửi yêu cầu xóa: ${error.message}`;
            });

    return false;
}


/////////////////////////////////////////////////////////////////////////////////
//                                  Cong Minh
////////////////////////////////////////////////////////////////////////////////


function openDeleteBlogModal(blogId) {
    const deleteBlogIdInput = document.getElementById('deleteBlogId');
    console.log(deleteBlogIdInput);
    if (deleteBlogIdInput) {
        deleteBlogIdInput.value = blogId; // Gán ID blog vào input
        openModal('deleteBlogModal'); // Mở modal
    } else {
        console.error('Không tìm thấy phần tử input với id "deleteBlogId"');
    }
}
function reloadBlogList() {
    const contextPath = '/' + window.location.pathname.split('/')[1];
    const url = `${window.location.origin}${contextPath}/admin/blogs?action=ajaxList`;
    console.log(" URL được gọi:", url);
    fetch(url)
            .then(response => {
                if (!response.ok)
                    throw new Error(`HTTP ${response.status}`);
                return response.json();
            })
            .then(data => {
                console.log("✅ JSON Blog Data:", data); // ← debug
                const tbody = document.querySelector('#blogsTable tbody');
                tbody.innerHTML = '';

                if (!Array.isArray(data) || data.length === 0) {
                    tbody.innerHTML = `<tr><td colspan="7" style="text-align:center;">Chưa có blog nào</td></tr>`;
                    return;
                }

                data.forEach((blog, index) => {
                    const imageUrl = blog.primaryImageId
                            ? `${window.location.origin}${contextPath}/ImagesServlet?type=blog&imageId=${blog.primaryImageId}&t=${Date.now()}`
                            : `${contextPath}/avatar/default.png`;

                    const escapedTitle = escapeHtml(blog.title);
                    const escapedContent = escapeHtml(blog.content);

                    const row = `
                    <tr>
                        <td>${index + 1}</td>
                        <td><img src="${imageUrl}" alt="Blog Image" style="width:60px;height:60px;border-radius:10px;"></td>
                        <td>${escapedTitle}</td>
                        <td>${escapedContent}</td>
                        <td>${new Date(blog.createdAt).toLocaleString('vi-VN')}</td>
                        <td>${new Date(blog.updatedAt).toLocaleString('vi-VN')}</td>
                        <td>
                            <button class="action-buttons__btn action-buttons__btn--edit"
                                onclick="openEditBlogModal(${blog.blogId}, \`${escapedTitle}\`, \`${escapedContent}\`, '${imageUrl}')">
                                Edit
                            </button>
                            <button class="action-buttons__btn action-buttons__btn--delete"
                                onclick="openDeleteBlogModal(${blog.blogId})">
                                Delete
                            </button>
                        </td>
                    </tr>
                `;
                    tbody.innerHTML += row;
                });
            })
            .catch(error => {
                console.error('Lỗi khi load blogs:', error);
                // Debug: in ra nội dung HTML nếu không phải JSON
                fetch(url)
                        .then(r => r.text())
                        .then(text => console.warn("Nội dung không phải JSON:", text));
            });
}

// Hàm thoát ký tự đặc biệt để tránh lỗi injection hoặc hỏng layout
function escapeHtml(text) {
    if (typeof text !== 'string')
        return '';
    return text
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#039;");
}

function setPrimaryImageForBlog(blogId, imageId) {
    const formData = new FormData();
    formData.append("action", "setPrimaryImage");
    formData.append("blogId", blogId);
    formData.append("imageId", imageId);

    fetch(`${window.location.origin}/SE1816_Gym_Group_4/admin/blogs`, {
        method: "POST",
        body: formData
    })
            .then(res => res.text())
            .then(result => {
                if (result === "primary_set") {
                    alert("Đã cập nhật ảnh chính cho blog.");
                    reloadBlogList(); // Tải lại danh sách blog
                } else {
                    alert("Không cập nhật được ảnh chính.");
                }
            })
            .catch(err => alert("Lỗi khi đặt ảnh chính: " + err));
}


function previewEditBlogImage(input) {
    const preview = document.getElementById('editBlogImagePreview');
    const fileLabel = document.getElementById('mainImageFilename');

    if (input.files && input.files[0]) {
        const file = input.files[0];
        preview.src = URL.createObjectURL(file);
        preview.style.display = "block";
        fileLabel.textContent = file.name;
    } else {
        preview.style.display = "none";
        fileLabel.textContent = "";
    }
}

function openEditBlogModal(blogId) {
    console.log(`/SE1816_Gym_Group_4/admin/blogs?action=edit&id=${blogId}`);
    fetch(`/SE1816_Gym_Group_4/admin/blogs?action=edit&id=${blogId}`)
            .then(res => {
                if (!res.ok)
                    throw new Error("Không thể tải dữ liệu blog");
                return res.json();
            })
            .then(data => {
                const blog = data.blog;
                const images = data.images;

                // ✅ Gán dữ liệu vào form
                document.getElementById('editBlogId').value = blog.blogId;
                document.getElementById('editBlogTitle').value = blog.title;
                document.getElementById('editBlogContent').value = blog.content;
//                // Gán caption từ bảng blog_images (có thể lấy từ ảnh đầu tiên, vì tất cả ảnh có caption chung)
//                const captionInput = document.getElementById('editBlogCaption');
//                const captionValue = images.length > 0 && images[0].caption ? images[0].caption : '';  // Lấy caption từ ảnh đầu tiên
//                captionInput.value = captionValue;  // Gán caption vào input
                // ✅ Gán ảnh chính của blog
                const imagePreview = document.getElementById('editBlogImagePreview');
                const imageFilenameLabel = document.getElementById('mainImageFilename');
                if (blog.primaryImageId) {
                    imagePreview.src = `/SE1816_Gym_Group_4/ImagesServlet?type=blog&imageId=${blog.primaryImageId}`;
                    imagePreview.style.display = "block";
                    imageFilenameLabel.textContent = "(Ảnh hiện tại)";
                } else {
                    imagePreview.src = "";
                    imagePreview.style.display = "none";
                    imageFilenameLabel.textContent = "";
                }

                // ✅ Hiển thị các ảnh phụ
                const imageListDiv = document.getElementById('editBlogImageList');
                imageListDiv.innerHTML = '';  // Xóa danh sách ảnh cũ
                images.forEach(img => {
                    const imgWrapper = document.createElement('div');
                    imgWrapper.style.position = "relative";
                    imgWrapper.style.display = "inline-block";

                    const imgEl = document.createElement('img');
                    imgEl.src = `/SE1816_Gym_Group_4/ImagesServlet?type=blog&imageId=${img.imageId}`;
                    imgEl.style.width = "60px";
                    imgEl.style.margin = "5px";
                    imgEl.style.borderRadius = "6px";
                    imgEl.style.border = img.isPrimary ? "2px solid red" : "1px solid #ccc";
                    imgEl.title = img.isPrimary ? "Ảnh chính (double click để đổi)" : "Click đúp để chọn ảnh chính";

                    imgEl.ondblclick = () => {
                        if (confirm("Chọn ảnh này làm ảnh đại diện chính?")) {
                            setPrimaryImageForBlog(blog.blogId, img.imageId);
                        }
                        // Cập nhật viền đỏ cho ảnh chính
                        document.querySelectorAll('#editBlogImageList img').forEach(image => {
                            image.style.border = '1px solid #ccc';  // Reset viền mặc định
                        });
                        imgEl.style.border = '2px solid red';
                    };

                    const deleteBtn = document.createElement('button');
                    deleteBtn.textContent = "✖";
                    deleteBtn.style.position = "absolute";
                    deleteBtn.style.top = "0";
                    deleteBtn.style.right = "0";
                    deleteBtn.style.background = "red";
                    deleteBtn.style.color = "white";
                    deleteBtn.style.border = "none";
                    deleteBtn.style.cursor = "pointer";
                    deleteBtn.style.fontSize = "12px";
                    deleteBtn.title = "Xóa ảnh";
                    deleteBtn.onclick = () => {
                        if (confirm("Bạn có chắc chắn muốn xóa ảnh này không?")) {
                            deleteBlogImage(img.imageId);
                        }
                    };

                    imgWrapper.appendChild(imgEl);
                    imgWrapper.appendChild(deleteBtn);
                    imageListDiv.appendChild(imgWrapper);
                });

                // ✅ Mở modal chỉnh sửa blog
                openModal('editBlogModal');
            })
            .catch(error => {
                console.error("❌ Lỗi khi load blog:", error);
            });
}

function deleteBlogImage(imageId) {
    const formData = new FormData();
    formData.append("action", "deleteImage");
    formData.append("imageId", imageId);

    fetch(`${window.location.origin}/SE1816_Gym_Group_4/admin/blogs`, {
        method: "POST",
        body: formData
    })
            .then(res => res.text())
            .then(result => {
                if (result === "image_deleted") {
                    alert("Đã xóa ảnh.");
                    const pid = document.getElementById('editBlogId').value;
                    openEditProductModal(pid); // Tải lại modal
                } else {
                    alert("Không xóa được ảnh.");
                }
            })
            .catch(err => alert("Lỗi khi xóa ảnh: " + err));
}


function openAddBlogModal() {
    const form = document.querySelector('#addBlogModal form');
    if (form)
        form.reset(); // reset dữ liệu cũ nếu có

    document.getElementById('resultAddBlog').innerHTML = ''; // clear thông báo cũ
    openModal('addBlogModal');
}