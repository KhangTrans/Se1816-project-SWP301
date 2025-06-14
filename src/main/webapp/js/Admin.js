// Admin Dashboard JavaScript - BEM Methodology
document.addEventListener('DOMContentLoaded', function () {
    loadAccounts();
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
                    throw new Error(`HTTP error! Status: ${response.status}`);
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
    const url = `${window.location.origin}${contextPath}/admin/accounts?action=ajaxList`;

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
                // Nếu lỗi xảy ra, debug nội dung thực tế server trả về
                fetch(url)
                        .then(r => r.text())
                        .then(text => console.warn("Nội dung server trả về không phải JSON:", text));
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


                // ✅ Hiển thị ảnh chính
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

                // ✅ Danh sách ảnh
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

                // ✅ Mở modal
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
                        <td>${index + 1}</td>
                        <td><img src="${imageUrl}" alt="Image" style="width:40px;height:40px;border-radius:6px; margin-top: 5px;"></td>
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




////////////////////////////////////////////////////////////////////////
////////////////////////Nhat Khang//////////////////////////////////////
////////////////////////////////////////////////////////////////////////


// Function to load the list of vouchers from the server
function loadVouchers() {
    console.log('Đang tải danh sách voucher...');
    const contextPath = window.location.pathname.split('/')[1] ? `/${window.location.pathname.split('/')[1]}` : '';
    const url = `${window.location.origin}${contextPath}/admin/vouchers?action=ajaxList`;

    fetch(url)
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP error! Status: ${response.status}`);
                }
                return response.json(); // Đảm bảo trả về dữ liệu JSON
            })
            .then(data => {
                console.log('Dữ liệu voucher nhận được:', data);
                const tbody = document.querySelector('#vouchersTable .data-table tbody');
                if (!tbody) {
                    console.error('Không tìm thấy tbody trong #vouchersTable .data-table');
                    return;
                }
                tbody.innerHTML = ''; // Xóa nội dung hiện tại

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
                        <button class="action-buttons__btn action-buttons__btn--edit"
                            onclick="openEditVoucherModal('${voucher.voucherId}', '${voucher.code}', '${voucher.description}', '${voucher.discountPercent}', '${voucher.maxDiscount}', '${voucher.usageLimit}', '${voucher.usedCount}', '${voucher.minOrderAmount}', '${voucher.startDate}', '${voucher.endDate}', '${voucher.isActive}')">
                            Edit
                        </button>
                        <button class="action-buttons__btn action-buttons__btn--delete"
                            onclick="openDeleteVoucherModal('${voucher.voucherId}')">
                            Delete
                        </button>
                    </td>
                </tr>`;
                    tbody.innerHTML += row;
                });
            })
            .catch(error => {
                console.error('Lỗi khi tải danh sách voucher:', error);
                fetch(url)
                        .then(r => r.text())
                        .then(text => console.warn("Phản hồi server không phải JSON:", text));
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

function submitFormAjax(event, form, resultDiv) {
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
    }

    // Clear any previous success message when opening the modal
    const resultDivElement = document.getElementById("resultAddVoucher");  // Đảm bảo đúng ID của phần hiển thị thông báo
    if (resultDivElement) {
        resultDivElement.innerHTML = '';  // Xóa thông báo cũ khi mở modal
    }
}



const formData = new FormData(form);
const params = new URLSearchParams();
for (let [key, value] of formData.entries()) {
    console.log(`${key}: ${value}`);
    params.append(key, value);
}




































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






//
//function openModal(id) {
//    const modal = document.getElementById(id);
//    if (modal) {
//        modal.style.display = 'flex';  // Đảm bảo modal hiển thị với display 'flex'
//    } else {
//        console.error(`Không tìm thấy modal với ID: ${id}`);
//    }
//}
//
//function closeModal(id) {
//    const modal = document.getElementById(id);
//    if (modal) {
//        modal.style.display = 'none';  // Ẩn modal khi đóng
//    } else {
//        console.error(`Không tìm thấy modal với ID: ${id}`);
//    }
//}
//    