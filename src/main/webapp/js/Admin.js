// Admin Dashboard JavaScript - BEM Methodology
document.addEventListener('DOMContentLoaded', function () {
    loadAccounts();
    reloadProductList();
    loadVouchers();
    loadStaffData();
    reloadTrainerList();
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
    console.log("Form action:", form.action);

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
                    if (typeof loadStaffData === 'function')
                        loadStaffData();
                    if (typeof reloadTrainerList === 'function')
                        reloadTrainerList();
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
                        <td>${index + 1}</td>
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
                const tbody = document.querySelector('#voucherTable tbody');
                if (!tbody) {
                    console.error('Không tìm thấy tbody trong ##voucherTable tbody');
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
                        <button class="action-buttons__btn action-buttons__btn--edit" style=" margin-top: 5px;"
                            onclick="openEditVoucherModal('${voucher.voucherId}', '${voucher.code}', '${voucher.description}', '${voucher.discountPercent}', '${voucher.maxDiscount}', '${voucher.usageLimit}', '${voucher.usedCount}', '${voucher.minOrderAmount}', '${voucher.startDate}', '${voucher.endDate}', '${voucher.isActive}')">
                            Edit
                        </button>
                        <button class="action-buttons__btn action-buttons__btn--delete" style=" margin-top: 5px;"
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
    }

    // Clear any previous success message when opening the modal
    const resultDivElement = document.getElementById("resultAddVoucher");  // Đảm bảo đúng ID của phần hiển thị thông báo
    if (resultDivElement) {
        resultDivElement.innerHTML = '';  // Xóa thông báo cũ khi mở modal
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
                        <td>${staff.account.accountId}</td>
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
                                onclick="openEditStaffModal('${staff.staffId}', '${staff.account.accountId}', '${staff.account.username}', '${staff.fullName}', '${staff.email}', '${staff.phone}', '${staff.position}', '${staff.status}')"
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
                    const account = trainer.accountId; // vì bạn dùng accountId là object Account
                    const avatarUrl = account && account.accountId
                            ? `${window.location.origin}${contextPath}/AvatarServlet?id=${account.accountId}&t=${Date.now()}`
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
                        <td>${trainer.experienceYears} năm</td>
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



////////////////////////////////////////////////////////////////////////


// Hàm để mở modal và hiển thị thông tin huấn luyện viên cần chỉnh sửa
function openEditTrainerModal(trainerId) {
    // Giả sử bạn có một API hoặc dữ liệu để lấy thông tin huấn luyện viên theo ID
    var trainerData = getTrainerById(trainerId);

    // Kiểm tra nếu dữ liệu huấn luyện viên không rỗng
    if (trainerData) {
        document.getElementById('trainerName').value = trainerData.fullName;
        document.getElementById('trainerEmail').value = trainerData.email;
        document.getElementById('trainerExperience').value = trainerData.experienceYears;
        document.getElementById('trainerRating').value = trainerData.rating;
        document.getElementById('trainerId').value = trainerData.trainerId;

        // Mở modal chỉnh sửa
        document.getElementById('editTrainerModal').style.display = 'flex';
    }
}

// Hàm để mở modal và hiển thị thông tin huấn luyện viên cần xóa
function openDeleteTrainerModal(trainerId) {
    // Giả sử bạn có một API hoặc dữ liệu để lấy thông tin huấn luyện viên theo ID
    var trainerData = getTrainerById(trainerId);

    // Hiển thị tên huấn luyện viên trong modal
    if (trainerData) {
        document.getElementById('trainerName').innerText = trainerData.fullName;

        // Lưu lại ID của huấn luyện viên cần xóa trong thuộc tính của nút Xóa
        document.getElementById('confirmDeleteBtn').setAttribute("data-trainer-id", trainerId);

        // Mở modal xóa
        document.getElementById('deleteTrainerModal').style.display = 'flex';
    }
}


// Mở modal và lấy danh sách username chưa tạo trainer
function openAddTrainerModal() {
    fetch('/admin/trainers?action=getAccountsWithoutTrainer') // Lấy danh sách tài khoản chưa có huấn luyện viên
            .then(response => response.json())
            .then(usernames => {
                const selectElement = document.getElementById('trainerUsername');
                selectElement.innerHTML = '<option value="">Choose a username for the Trainer</option>'; // Reset dropdown

                // Điền các username vào dropdown
                usernames.forEach(username => {
                    const option = document.createElement('option');
                    option.value = username;
                    option.textContent = username;
                    selectElement.appendChild(option);
                });
            })
            .catch(error => {
                console.error('Error loading accounts without trainer:', error);
            });

    // Mở modal
    document.getElementById('addTrainer').style.display = 'flex';
}

//=============================================================================================================================
//||                                                                                                                         ||
//||                                           BaoMinh                                                                       ||
//||                                                                                                                         ||
//=============================================================================================================================

function openEditCustomerModal(customerId, fullName, email, phone, customerCode, address, accountId, username, avatarUrl) {
    document.getElementById("editCustomerId").value = customerId;
    document.getElementById("editFullName").value = fullName;
    document.getElementById("editEmail").value = email;
    document.getElementById("editPhone").value = phone;
    document.getElementById("editCustomerCode").value = customerCode;
    document.getElementById("editAddress").value = address;

    document.getElementById("editAccountId").value = accountId;
    document.getElementById("editUsername").value = username;
    document.getElementById("editAvatarPreview").src = avatarUrl;

    openModal("editCustomerModal");
}

function openDeleteCustomerModal(customerId) {
    document.getElementById('deleteCustomerId').value = customerId;
    openModal('deleteCustomerModal');
}


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
                const tbody = document.querySelector('#customerTable tbody');
                tbody.innerHTML = '';

                if (data.length === 0) {
                    tbody.innerHTML = `<tr><td colspan="7" style="text-align:center;">Chưa có khách hàng nào</td></tr>`;
                    return;
                }

                data.forEach((cus, index) => {
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
<td>${cus.address || ''}</td>
                        <td>
                            <button class="action-buttons__btn action-buttons__btn--edit"
                                onclick="openEditCustomerModal(
                                    '${cus.customerId}', '${cus.fullName}', '${cus.email}', '${cus.phone}', '${cus.customerCode}', '${cus.address}',
                                    '${cus.account.accountId}', '${cus.account.username}', '${avatarUrl}'
                                )">Edit</button>
                            <button class="action-buttons__btn action-buttons__btn--delete"
                                onclick="openDeleteCustomerModal('${cus.customerId}')">Delete</button>
                        </td>
                    </tr>
                `;
                    tbody.innerHTML += row;
                });
            })
            .catch(error => {
                console.error('Lỗi khi tải danh sách khách hàng:', error);
                fetch(url)
                        .then(r => r.text())
                        .then(text => console.warn("Phản hồi không phải JSON:", text));
            });
}
