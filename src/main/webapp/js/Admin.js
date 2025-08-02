// Admin Dashboard JavaScript - BEM Methodology
function escapeHTML(str) {
    // Ép kiểu sang string, nếu là null/undefined trả về rỗng
    if (str === undefined || str === null)
        return '';
    str = String(str);
    return str.replace(/[&<>"']/g, function (m) {
        switch (m) {
            case '&':
                return '&amp;';
            case '<':
                return '&lt;';
            case '>':
                return '&gt;';
            case '"':
                return '&quot;';
            case "'":
                return '&#39;';
            default:
                return m;
        }
    });
}
function escapeJSAttr(str) {
    // Đảm bảo là string, tránh lỗi .replace is not a function
    str = (str === undefined || str === null) ? '' : String(str);
    // Escape các ký tự đặc biệt cho thuộc tính JS trong HTML (tránh đóng quote và XSS)
    return str.replace(/['"\\\n\r\u2028\u2029]/g, function (m) {
        switch (m) {
            case "'":
                return "\\'";
            case '"':
                return '\\"';
            case '\\':
                return '\\\\';
            case '\n':
                return '\\n';
            case '\r':
                return '\\r';
            case '\u2028':
                return '\\u2028';
            case '\u2029':
                return '\\u2029';
            default:
                return m;
        }
    });
}

document.addEventListener('DOMContentLoaded', function () {
    loadAccounts(); //
    reloadProductList(); //
    loadVouchers(); //
    loadStaffData(); //
    reloadTrainerList(); //
    reloadBlogList(); //
    loadCustomers(); //
    loadLoginLogs(); //
    loadPackages(); //
    loadMemberPackage();//
    loadCategori(); //
    ;
});
function validateInput(input) {
    // Kiểm tra nếu giá trị nhập vào chứa ký tự đặc biệt
    const forbiddenChars = /script/gi;

    // Nếu chứa ký tự đặc biệt, hiển thị thông báo lỗi và xóa toàn bộ nội dung
    if (forbiddenChars.test(input.value)) {
        alert("Must not contain special characters that affect system security.");
        input.value = '';  // Xóa toàn bộ dữ liệu nhập vào (lưu dữ liệu rỗng)
    }
}

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
    if (isNaN(parseFloat(amount))) {
        return '0 ₫';
    }
    return new Intl.NumberFormat('vi-VN', {
        style: 'decimal',
        maximumFractionDigits: 0
    }).format(amount) + ' ₫';
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
    console.log("Sending categoryId:", selectedCategory);

    const formData = new FormData(form);
    console.log(" Dữ liệu gửi đi:");
    for (let [key, val] of formData.entries()) {
        console.log(`${key}: ${val}`);
    }
    const action = form.getAttribute('action');
    const method = form.getAttribute('method') || 'post';

    if (!action) {
        console.error(" Form không có thuộc tính 'action'");
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
                    if (typeof loadCustomers === 'function') //cminh
                        loadCustomers();
                    if (typeof loadPackages === 'function')
                        loadPackages();
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
                    tbody.innerHTML = `<tr><td colspan="6" style="text-align:center;">No account yet</td></tr>`;
                    return;
                }

                data.forEach((acc, index) => {
                    const createdAtDate = new Date(acc.createdAt);
                    const formattedDate = `${createdAtDate.getMonth() + 1}/${createdAtDate.getDate()}/${createdAtDate.getFullYear()}`;
                    const avatarUrl = `${window.location.origin}${contextPath}/AvatarServlet?user=${encodeURIComponent(acc.username)}&t=${Date.now()}`;

                    const isCustomer = acc.role === 'customer';
                    const deleteBtnHTML = `
                    <button class="action-buttons__btn action-buttons__btn--delete account-delete"
                        data-account-id='${acc.accountId}'
                        ${isCustomer ? 'disabled title="Unable to delete customer account" style="background-color: #6c757d; border-color: #6c757d; color: white;"' : ''}>
                        <i class="fas fa-trash-alt"></i>
                    </button>
                `;

                    const row = `
                    <tr>
                        <td>${index + 1}</td>
                        <td><img src="${escapeHTML(avatarUrl)}" alt="Avatar" style="width:60px;height:60px;border-radius:50%;"></td>
                        <td>${escapeHTML(acc.username)}</td>
                        <td>${escapeHTML(acc.role)}</td>
                        <td>${formattedDate}</td>
                        <td>
                            <button class="action-buttons__btn action-buttons__btn--edit account-edit"
                                data-account-id='${acc.accountId}'
                                data-username='${acc.username.replace(/'/g, "&#39;")}'
                                data-role='${acc.role.replace(/'/g, "&#39;")}'
                                data-avatar-url='${avatarUrl.replace(/'/g, "&#39;")}'
>
                                <i class="fas fa-edit"></i>
                            </button>
                            ${deleteBtnHTML}
                        </td>
                    </tr>
                `;
                    tbody.innerHTML += row;
                });

                // Gắn sự kiện cho nút Edit
                document.querySelectorAll('.account-edit').forEach(btn => {
                    btn.addEventListener('click', function () {
                        openEditAccountModal(
                                this.dataset.accountId,
                                this.dataset.username.replace(/&#39;/g, "'"),
                                this.dataset.role.replace(/&#39;/g, "'"),
                                this.dataset.avatarUrl.replace(/&#39;/g, "'")
                                );
                    });
                });

                // Gắn sự kiện cho nút Delete (bỏ qua nếu bị disable)
                document.querySelectorAll('.account-delete').forEach(btn => {
                    btn.addEventListener('click', function () {
                        if (btn.disabled)
                            return;
                        openDeleteAccountModal(this.dataset.accountId);
                    });
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
                    const avatarUrl = `${window.location.origin}${contextPath}/AvatarServlet?user=${encodeURIComponent(acc.username)}&t=${Date.now()}`;
                    const row = `
                    <tr>
                        <td>${index + 1}</td>
                        <td><img src="${escapeHTML(avatarUrl)}" style="width:40px;height:40px;border-radius:50%;"></td>
                        <td>${escapeHTML(acc.username)}</td>
                        <td>${escapeHTML(acc.role)}</td>
                        <td>${escapeHTML(acc.createdAt)}</td>
                        <td>
                 <button class="action-buttons__btn action-buttons__btn--edit account-edit"
                    data-account-id='${acc.accountId}'
                    data-username='${acc.username.replace(/'/g, "&#39;")}'
                    data-role='${acc.role.replace(/'/g, "&#39;")}'
                    data-avatar-url='${avatarUrl.replace(/'/g, "&#39;")}'
                >
                    <i class="fas fa-edit"></i>
                </button>
                <button class="action-buttons__btn action-buttons__btn--delete account-delete"
                    data-account-id='${acc.accountId}'>
                    <i class="fas fa-trash-alt"></i>
                </button>
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

                //  Gán dữ liệu vào form
                document.getElementById('editProductId').value = product.productId;
                document.getElementById('editProductName').value = product.name;
                document.getElementById('editProductDescription').value = product.description;
                document.getElementById('editProductPrice').value = product.price;
                document.getElementById('editProductStock').value = product.stockQuantity;

                // Gán dropdown Category
                const select = document.getElementById('editProductCategory');
                select.innerHTML = '';

                const selectedCategoryId = product.categoryId; // Giả sử server trả số nguyên
                console.log(" Selected Category ID:", selectedCategoryId);

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
                    console.warn(" Không tìm thấy category khớp, chọn giá trị mặc định đầu tiên");
                    if (select.options.length > 0) {
                        select.selectedIndex = 0;
                    }
                }

                // Kiểm tra cuối cùng
                console.log("️ Gán lại select.value =", select.value);


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
                        deleteBtn.textContent = "X";
                        deleteBtn.style.position = "absolute";
                        deleteBtn.style.top = "0";
                        deleteBtn.style.padding = "5px";
                        deleteBtn.style.borderradius = "5px";
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
                console.error(" Lỗi khi load product:", error);
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
    const search = document.getElementById('searchKeyword').value;
    const category = document.getElementById('categoryFilter').value;
    const contextPath = window.location.pathname.split('/')[1] ? `/${window.location.pathname.split('/')[1]}` : '';
    const url = `${window.location.origin}${contextPath}/admin/products?action=ajaxList&search=${encodeURIComponent(search)}&category=${category}`;

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
                    tbody.innerHTML = `<tr><td colspan="7" style="text-align:center;">Chưa có sản phẩm nào</td></tr>`;
                    return;
                }

                data.forEach((product, index) => {
                    const imageUrl = product.primaryImageId
                            ? `${window.location.origin}${contextPath}/ImagesServlet?type=product&imageId=${product.primaryImageId}&t=${Date.now()}`
                            : `${contextPath}/avatar/default.png`;

                    const truncatedDescription = product.description && product.description.length > 150
                            ? product.description.slice(0, 150) + "..."
                            : product.description;

                    const row = `
                <tr>
                    <td style="width:60px;">${index + 1}</td>
                    <td><img src="${escapeHTML(imageUrl)}" alt="Hình ảnh" style="width:100px; height:100px; border-radius:10px; margin-top: 5px"></td>
                    <td>${escapeHTML(product.name)}</td>
                    <td>${escapeHTML(product.categoryName)}</td>
                    <td>${escapeHTML(product.price.toLocaleString('vi-VN'))} đ</td>
                    <td>${escapeHTML(product.stockQuantity + '')}</td>
                    <td>
                        <button class="action-buttons__btn action-buttons__btn--view product-view"
                            data-product-id='${product.productId}'
                            data-name='${product.name.replace(/'/g, "&#39;")}'
                            data-description='${product.description.replace(/'/g, "&#39;")}'
                            data-price='${product.price}'
                            data-stock-quantity='${product.stockQuantity}'
                            data-category-name='${product.categoryName.replace(/'/g, "&#39;")}'
                            data-image-url='${imageUrl.replace(/'/g, "&#39;")}'>
                            <i class="fas fa-eye"></i>
                        </button>
                        <button class="action-buttons__btn action-buttons__btn--edit product-edit"
data-product-id='${product.productId}'
                            data-name='${product.name.replace(/'/g, "&#39;")}'
                            data-description='${product.description.replace(/'/g, "&#39;")}'
                            data-price='${product.price}'
                            data-stock-quantity='${product.stockQuantity}'
                            data-category-id='${product.categoryId}'
                            data-image-url='${imageUrl.replace(/'/g, "&#39;")}'>
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="action-buttons__btn action-buttons__btn--delete product-delete"
                            data-product-id='${product.productId}'>
                            <i class="fas fa-trash-alt"></i>
                        </button>
                    </td>
                </tr>
                `;
                    tbody.innerHTML += row;
                });

                document.querySelectorAll('.product-edit').forEach(btn => {
                    btn.addEventListener('click', function () {
                        openEditProductModal(
                                this.dataset.productId,
                                this.dataset.name.replace(/&#39;/g, "'"),
                                this.dataset.description.replace(/&#39;/g, "'"),
                                this.dataset.price,
                                this.dataset.stockQuantity,
                                this.dataset.categoryId,
                                this.dataset.imageUrl.replace(/&#39;/g, "'")
                                );
                    });
                });

                document.querySelectorAll('.product-delete').forEach(btn => {
                    btn.addEventListener('click', function () {
                        openDeleteProductModal(this.dataset.productId);
                    });
                });

                document.querySelectorAll('.product-view').forEach(btn => {
                    btn.addEventListener('click', function () {
                        openViewProductModal(
                                this.dataset.productId,
                                this.dataset.name.replace(/&#39;/g, "'"),
                                this.dataset.description.replace(/&#39;/g, "'"),
                                this.dataset.price,
                                this.dataset.stockQuantity,
                                this.dataset.categoryName.replace(/&#39;/g, "'"),
                                this.dataset.imageUrl.replace(/&#39;/g, "'")
                                );
                    });
                });
            })
            .catch(error => {
                console.error('Lỗi khi tải danh sách sản phẩm:', error);
                fetch(url)
                        .then(r => r.text())
                        .then(text => console.warn("Nội dung không phải JSON:", text));
            });
}

// Thêm trình nghe sự kiện cho tìm kiếm động và bộ lọc danh mục
document.getElementById('searchKeyword').addEventListener('input', function () {
    reloadProductList();
});

document.getElementById('categoryFilter').addEventListener('change', function () {
    reloadProductList();
});
//-----------------------------------------


function openViewProductModal(productId, name, description, price, stock, categoryId, imageUrl) {
    document.getElementById('viewProductName').innerText = name;
    document.getElementById('viewProductDescription').innerText = description;
    document.getElementById('viewProductPrice').innerText = price;
    document.getElementById('viewProductStock').innerText = stock;
    document.getElementById('viewProductCategory').innerText = categoryId.name || categoryId;

    const imageList = document.getElementById('viewProductImageList');
    imageList.innerHTML = '';
    if (imageUrl) {
        const img = document.createElement('img');
        img.src = imageUrl;
        img.style.maxWidth = '100px';
        img.style.height = 'auto';
        imageList.appendChild(img);
    }

    document.getElementById('viewProductModal').style.display = 'flex';
}

//--------------------------------------------
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
                    tbody.innerHTML = `<tr><td colspan="6" style="text-align:center;">No vouchers available</td></tr>`;
                    return;
                }

                data.forEach((voucher, index) => {
                    // Escape strings for JavaScript
                    const safeDescription = voucher.description ? voucher.description.replace(/'/g, "\\'") : '';
                    const safeCode = voucher.code ? voucher.code.replace(/'/g, "\\'") : '';

                    const row = `
                <tr>
                    <td>${index + 1}</td>
                    <td>${escapeHTML(voucher.code)}</td>
                    <td>${escapeHTML(voucher.description)}</td>
                    <td>${voucher.discountPercent}</td>
                    <td>${voucher.isActive ? 'Active' : 'Inactive'}</td>
                    <td>
                        <button class="action-buttons__btn action-buttons__btn--view" 
                            onclick="viewVoucherDetail('${voucher.voucherId}')">
                            <i class="bi bi-eye"></i>
                        </button>
                        <button class="action-buttons__btn action-buttons__btn--edit" 
                            onclick="openEditVoucherModal('${voucher.voucherId}', '${safeCode}', '${safeDescription}', '${voucher.discountPercent}', '${voucher.maxDiscount}', '${voucher.usageLimit}', '${voucher.usedCount}', '${voucher.minOrderAmount}', '${voucher.startDate}', '${voucher.endDate}', '${voucher.isActive}')">
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="action-buttons__btn action-buttons__btn--delete" 
                            onclick="openDeleteVoucherModal('${voucher.voucherId}')">
                            <i class="fas fa-trash-alt"></i>
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

// Function to view voucher details
function viewVoucherDetail(voucherId) {
    const contextPath = window.location.pathname.split('/')[1] ? `/${window.location.pathname.split('/')[1]}` : '';

    // Get voucher details from server
    fetch(`${window.location.origin}${contextPath}/admin/vouchers?action=ajaxList`)
            .then(response => response.json())
            .then(data => {
                const voucher = data.find(v => v.voucherId == voucherId);

                if (!voucher) {
                    console.error('Voucher not found');
                    return;
                }

                // Format dates
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

                // Populate the detail view
//            document.getElementById('detail-voucher-id').textContent = voucher.voucherId;
//            document.getElementById('detail-voucher-code').textContent = voucher.code;
//            document.getElementById('detail-voucher-description').textContent = voucher.description;
                document.getElementById('detail-voucher-discount').textContent = `${voucher.discountPercent}%`;
                document.getElementById('detail-voucher-max-discount').textContent = formatVndPrice(voucher.maxDiscount);
                document.getElementById('detail-voucher-usage-limit').textContent = voucher.usageLimit;
                document.getElementById('detail-voucher-used-count').textContent = voucher.usedCount;
                document.getElementById('detail-voucher-min-amount').textContent = formatVndPrice(voucher.minOrderAmount);
                document.getElementById('detail-voucher-start-date').textContent = startDate;
                document.getElementById('detail-voucher-end-date').textContent = endDate;
//            document.getElementById('detail-voucher-status').textContent = voucher.isActive ? 'Active' : 'Inactive';

                // Removed the code that sets up edit and delete button event handlers

                // Open the modal
                openModal('viewVoucherModal');
            })
            .catch(error => console.error('Error fetching voucher details:', error));
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
                console.log(" Raw response:", text);
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
    console.log("voucherId = ", voucherId); // Log để kiểm tra
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
                console.log(" Raw response:", text);
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

// Order Management Functions

// Function to load orders data
function loadOrders() {
    console.log('Loading order list with filters...');
    const contextPath = window.location.pathname.split('/')[1] ? `/${window.location.pathname.split('/')[1]}` : '';

    // Get filter values
    const searchTerm = document.getElementById('searchOrder') ? document.getElementById('searchOrder').value : '';
    const status = document.getElementById('orderStatusFilter') ? document.getElementById('orderStatusFilter').value : '';

    // Build URL with query parameters
    let url = `${window.location.origin}${contextPath}/admin/orders?action=ajaxList`;
    url += `&search=${encodeURIComponent(searchTerm)}`;
    url += `&status=${encodeURIComponent(status)}`;

    console.log('Fetching orders from URL:', url);

    fetch(url)
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP error! Status: ${response.status}`);
                }
                return response.json();
            })
            .then(data => {
                const tbody = document.querySelector('#orderTableBody');
                if (!tbody) {
                    console.error('Cannot find tbody in #orderTable');
                    return;
                }
                tbody.innerHTML = '';

                if (data.length === 0) {
                    tbody.innerHTML = `<tr><td colspan="6" style="text-align:center;">No orders available</td></tr>`;
                    return;
                }

                // Group orders by referral code
                const ordersByReferralCode = {};

                data.forEach(order => {
                    const refCode = order.referralCode || '';
                    if (!ordersByReferralCode[refCode]) {
                        ordersByReferralCode[refCode] = {
                            orders: [],
                            products: [],
                            totalAmount: 0
                        };
                    }

                    ordersByReferralCode[refCode].orders.push(order);

                    // Add products to the grouped data
                    if (order.orderItems && order.orderItems.length > 0) {
                        order.orderItems.forEach(item => {
                            ordersByReferralCode[refCode].products.push({
                                productName: item.productName || 'Unknown Product',
                                quantity: item.quantity || 0,
                                unitPrice: item.unitPrice || 0,
                                price: item.price || (item.quantity * item.unitPrice) || 0
                            });

                            ordersByReferralCode[refCode].totalAmount += (item.price || (item.quantity * item.unitPrice) || 0);
                        });
                    }
                });

                // Render grouped orders (CHỈ THÊM escape cho bảng & nút)
                Object.keys(ordersByReferralCode).forEach(refCode => {
                    const groupData = ordersByReferralCode[refCode];
                    const firstOrder = groupData.orders[0];

                    // Check if the order is cancelled or shipped to disable status dropdown and edit button
                    const isLocked = firstOrder.status === 'cancelled' || firstOrder.status === 'shipped';
                    const disabledAttr = isLocked ? 'disabled' : '';
                    const disabledStyle = isLocked ? 'background-color: #f0f0f0; cursor: not-allowed;' : '';

                    const statusDropdown = `
                    <select class="status-dropdown" name="status_${escapeHTML(firstOrder.orderId)}" 
                            onchange="updateOrderStatus('${escapeJSAttr(firstOrder.orderId)}', this.value)"
                            ${disabledAttr} style="${disabledStyle}">
                        <option value="pending" ${firstOrder.status === 'pending' ? 'selected' : ''} class="status-pending">Pending</option>
                        <option value="processing" ${firstOrder.status === 'processing' ? 'selected' : ''} class="status-processing">Processing</option>
                        <option value="shipped" ${firstOrder.status === 'shipped' ? 'selected' : ''} class="status-shipped">Shipped</option>
                        <option value="cancelled" ${firstOrder.status === 'cancelled' ? 'selected' : ''} class="status-cancelled">Cancelled</option>
                    </select>
                    `;

                    const row = `
                 <tr>
                   <td>${escapeHTML(refCode || '')}</td>
                   <td>${escapeHTML(firstOrder.customerName)}</td>
                   <td>${escapeHTML(firstOrder.customerPhoneNumber)}</td>
                   <td>${escapeHTML(firstOrder.shippingAddress)}</td>
                   <td>${statusDropdown}</td>
                   <td>
                  <button class="action-buttons__btn action-buttons__btn--view order-view"
                  data-referral-code="${String(refCode || '').replace(/'/g, "&#39;")}"
                  >
                  <i class="bi bi-eye"></i>
                  </button>
                  <button class="action-buttons__btn action-buttons__btn--edit order-edit ${isLocked ? 'disabled' : ''}"
                  data-order-id="${String(firstOrder.orderId || '').replace(/'/g, "&#39;")}"
                  ${isLocked ? 'disabled' : ''}
                  style="${isLocked ? 'opacity: 0.5; cursor: not-allowed;' : ''}"
                  >
                  <i class="fas fa-edit"></i>
                  </button>
                   </td>
                 </tr>`;

                    tbody.innerHTML += row;
                });
                // Gán event cho nút View
                document.querySelectorAll('.order-view').forEach(btn => {
                    btn.addEventListener('click', function () {
                        // Lấy referral code đã escape
                        const referralCode = this.dataset.referralCode.replace(/&#39;/g, "'");
                        viewOrderDetail(referralCode);
                    });
                });
// Gán event cho nút Edit
                document.querySelectorAll('.order-edit').forEach(btn => {
                    btn.addEventListener('click', function () {
                        // Skip if button is disabled (cancelled order)
                        if (this.disabled || this.classList.contains('disabled')) {
                            return;
                        }
                        const orderId = this.dataset.orderId.replace(/&#39;/g, "'");
                        openEditOrderModal(orderId);
                    });
                });
            })
            .catch(error => {
                console.error('Error loading order list:', error);
                const tbody = document.querySelector('#orderTableBody');
                if (tbody) {
                    tbody.innerHTML = `<tr><td colspan="6" style="text-align:center;">Error loading orders: ${error.message}</td></tr>`;
                }
            });
}

// Function to format VND price correctly
function formatVndPrice(price) {
    // If price is less than 1000 and greater than 0, multiply by 1000
    if (price < 1000 && price > 0) {
        price = price * 1000;
    }
    return price.toLocaleString() + ' ₫';
}

// Function to view order details by referral code
function viewOrderDetail(referralCode) {
    if (!referralCode) {
        console.error('No referral code provided');
        return;
    }

    console.log('Viewing details for order with referral code:', referralCode);
    const contextPath = window.location.pathname.split('/')[1] ? `/${window.location.pathname.split('/')[1]}` : '';

    // Build URL with query parameters
    let url = `${window.location.origin}${contextPath}/admin/orders?action=ajaxList`;

    fetch(url)
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP error! Status: ${response.status}`);
                }
                return response.json();
            })
            .then(data => {
                // Filter orders by referral code
                const ordersWithSameRefCode = data.filter(order => order.referralCode === referralCode);

                if (ordersWithSameRefCode.length === 0) {
                    alert('No orders found with this referral code');
                    return;
                }

                // Collect all products from these orders
                const products = [];
                let totalAmount = 0;

                ordersWithSameRefCode.forEach(order => {
                    if (order.orderItems && order.orderItems.length > 0) {
                        order.orderItems.forEach(item => {
                            const productPrice = item.price || (item.quantity * item.unitPrice) || 0;
                            products.push({
                                productName: item.productName || 'Unknown Product',
                                quantity: item.quantity || 0,
                                price: productPrice
                            });
                            totalAmount += productPrice;
                        });
                    }
                });

                // Display in modal
                document.getElementById('detailReferralCode').textContent = referralCode;

                const productsTable = document.getElementById('orderDetailProducts');
                productsTable.innerHTML = '';

                products.forEach(product => {
                    productsTable.innerHTML += `
                <tr>
                    <td>${product.productName}</td>
                    <td>${product.quantity}</td>
                    <td>${formatVndPrice(product.price)}</td>
                </tr>
                `;
                });

                document.getElementById('orderDetailTotal').textContent = formatVndPrice(totalAmount);

                // Show modal
                document.getElementById('orderDetailModal').style.display = 'block';
            })
            .catch(error => {
                console.error('Error loading order details:', error);
                alert('Error loading order details: ' + error.message);
            });
}

function closeOrderDetailModal() {
    document.getElementById('orderDetailModal').style.display = 'none';
}

// Function to update order status
function updateOrderStatus(orderId, newStatus) {
    // Check if the select is disabled (cancelled or shipped order)
    const statusDropdown = document.querySelector(`select[name="status_${orderId}"]`);
    if (statusDropdown && statusDropdown.disabled) {
        // Get the current status
        const currentStatus = statusDropdown.value;

        // Create notification to inform user that cancelled or shipped orders can't be edited
        const notification = document.createElement('div');
        notification.textContent = `${currentStatus === 'cancelled' ? 'Cancelled' : 'Shipped'} orders cannot be modified`;
        notification.style.position = 'fixed';
        notification.style.top = '20px';
        notification.style.right = '20px';
        notification.style.color = 'red';
        notification.style.fontWeight = 'bold';
        notification.style.zIndex = '1000';
        notification.style.backgroundColor = '#ffe6e6';
        notification.style.padding = '10px';
        notification.style.borderRadius = '5px';

        document.body.appendChild(notification);

        // Remove notification after 3 seconds
        setTimeout(() => {
            notification.style.opacity = '0';
            notification.style.transition = 'opacity 0.5s';
            setTimeout(() => {
                document.body.removeChild(notification);
            }, 500);
        }, 3000);

        // Reset to previous value
        setTimeout(() => {
            if (statusDropdown) {
                statusDropdown.value = currentStatus;
            }
        }, 0);

        return;
    }

    const contextPath = window.location.pathname.split('/')[1] ? `/${window.location.pathname.split('/')[1]}` : '';
    const url = `${window.location.origin}${contextPath}/admin/orders`;

    const params = new URLSearchParams();
    params.append('orderId', orderId);
    params.append('status', newStatus);
    params.append('formAction', 'updateStatus');

    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params
    })
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP error! Status: ${response.status}`);
                }
                return response.json();
            })
            .then(data => {
                if (data.status === "updated") {
                    // Update the UI for this specific row
                    const statusCell = document.querySelector(`select[name="status_${orderId}"]`);
                    const editButton = document.querySelector(`button.order-edit[data-order-id="${orderId}"]`);

                    if (statusCell) {
                        statusCell.value = newStatus;

                        // If status changed to cancelled or shipped, disable the controls
                        if (newStatus === 'cancelled' || newStatus === 'shipped') {
                            // Disable the dropdown
                            statusCell.disabled = true;
                            statusCell.style.backgroundColor = '#f0f0f0';
                            statusCell.style.cursor = 'not-allowed';

                            // Disable the edit button
                            if (editButton) {
                                editButton.disabled = true;
                                editButton.classList.add('disabled');
                                editButton.style.opacity = '0.5';
                                editButton.style.cursor = 'not-allowed';
                            }


                        }
                    }

                    // Create simple text notification in the corner
                    const notification = document.createElement('div');
                    notification.textContent = 'Order updated successfully';
                    notification.style.position = 'fixed';
                    notification.style.top = '20px';
                    notification.style.right = '20px';
                    notification.style.color = 'green';
                    notification.style.fontWeight = 'bold';
                    notification.style.zIndex = '1000';

                    document.body.appendChild(notification);

                    // Remove notification after 3 seconds
                    setTimeout(() => {
                        notification.style.opacity = '0';
                        notification.style.transition = 'opacity 0.5s';
                        setTimeout(() => {
                            document.body.removeChild(notification);
                        }, 500);
                    }, 3000);
                } else {
                    console.error('Failed to update order status:', data.message);
                    alert('Failed to update order status: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error updating order status:', error);
                alert('Error updating order status: ' + error.message);
            });
}

// Function to open the edit order modal
function openEditOrderModal(orderId) {
    // Xây dựng URL đúng format
    const baseUrl = window.location.origin;
    const pathArray = window.location.pathname.split('/');
    const contextPath = pathArray[1] ? '/' + pathArray[1] : '';

    // Ghi log giá trị orderId
    console.log("Opening edit modal for orderId:", orderId);

    // Đảm bảo đường dẫn URL đầy đủ và chính xác
    const url = `${baseUrl}${contextPath}/admin/orders?action=getOrder&orderId=${orderId}`;
    console.log("Requesting order data from URL:", url);

    fetch(url)
            .then(response => {
                console.log("Response status:", response.status);
                if (!response.ok) {
                    throw new Error(`HTTP error! Status: ${response.status}`);
                }
                return response.json();
            })
            .then(order => {
                console.log("Order data received:", order);

                // Fill in the form fields with order data
                document.getElementById('editOrderId').value = order.orderId || '';
                // Make Quantity readonly like Referral Code & Product Name
                const quantityField = document.getElementById('editOrderQuantity');
                quantityField.readOnly = true;

                // Create a hidden input to store the status value since the select is removed
                let hiddenStatus = document.getElementById('hiddenStatusField');
                if (!hiddenStatus) {
                    hiddenStatus = document.createElement('input');
                    hiddenStatus.type = 'hidden';
                    hiddenStatus.id = 'hiddenStatusField';
                    hiddenStatus.name = 'status';
                    document.getElementById('editOrderForm').appendChild(hiddenStatus);
                }
                hiddenStatus.value = order.status || 'pending';

                // Remove any existing notices first to avoid duplicates
                const formBody = document.querySelector('#editOrderForm');
                const existingNotices = formBody.querySelectorAll('.edit-notice');
                existingNotices.forEach(notice => notice.remove());

                // If the order status is "shipped" or "cancelled", disable all form fields
                const isLocked = order.status === 'cancelled' || order.status === 'shipped';
                if (isLocked) {
                    // Disable all form fields
                    document.getElementById('editShippingAddress').readOnly = true;
                    document.getElementById('editCustomerName').readOnly = true;
                    document.getElementById('editCustomerPhone').readOnly = true;

                    // No information box needed as requested
                }
                document.getElementById('editShippingAddress').value = order.shippingAddress || '';
                document.getElementById('editCustomerName').value = order.customerName || '';
                document.getElementById('editCustomerPhone').value = order.customerPhoneNumber || '';
                console.log("Customer phone number set to:", order.customerPhoneNumber);
                document.getElementById('editReferralCode').value = order.referralCode || '';

                // Hiển thị thông tin sản phẩm
                if (order.orderItems && order.orderItems.length > 0) {
                    const firstItem = order.orderItems[0];

                    // Hiển thị tên sản phẩm
                    document.getElementById('productNameDisplay').value = firstItem.productName || 'Unknown Product';

                    // Set quantity và item ID
                    document.getElementById('editOrderQuantity').value = firstItem.quantity || 1;
                    document.getElementById('editOrderQuantity').disabled = false;
                    document.getElementById('hiddenOrderItemId').value = firstItem.orderItemId || '';

                    // Set unit price for calculations
                    if (firstItem.unitPrice) {
                        const unitPriceHidden = document.createElement('input');
                        unitPriceHidden.type = 'hidden';
                        unitPriceHidden.id = 'unitPriceHidden';
                        unitPriceHidden.value = Number(firstItem.unitPrice);
                        document.getElementById('editOrderForm').appendChild(unitPriceHidden);
                    }
                } else {
                    // If no items, disable the quantity field
                    document.getElementById('productNameDisplay').value = 'No product available';
                    document.getElementById('editOrderQuantity').value = '';
                    document.getElementById('editOrderQuantity').disabled = true;
                    document.getElementById('hiddenOrderItemId').value = '';

                    // Add hidden unit price field with 0 value
                    const unitPriceHidden = document.createElement('input');
                    unitPriceHidden.type = 'hidden';
                    unitPriceHidden.id = 'unitPriceHidden';
                    unitPriceHidden.value = '0';
                    document.getElementById('editOrderForm').appendChild(unitPriceHidden);
                }

                // Open the modal
                openModal('editOrderModal');
            })
            .catch(error => {
                console.error('Error fetching order details:', error);
                alert('Error fetching order details: ' + error.message);
            });
}

// Function to submit order edit form
function submitEditOrder(form) {
    event.preventDefault();
    console.log("Submitting edit order form");

    // Check if the order status is "shipped" or "cancelled"
    const hiddenStatus = document.getElementById('hiddenStatusField');
    if (hiddenStatus && (hiddenStatus.value === 'shipped' || hiddenStatus.value === 'cancelled')) {
        const resultDiv = document.getElementById("resultEditOrder");
        resultDiv.innerHTML = `<p style="color:red; font-weight:bold;">${hiddenStatus.value === 'cancelled' ? 'Cancelled' : 'Shipped'} orders cannot be modified</p>`;
        return false;
    }

    // Ensure disabled fields' values are still included in the form submission
    // This is necessary because browsers don't include disabled fields in form submissions
    const orderQuantity = document.getElementById('editOrderQuantity');
    if (orderQuantity && orderQuantity.disabled) {
        // Create a hidden input to ensure the quantity is submitted
        let hiddenQuantity = document.getElementById('hiddenQuantity');
        if (!hiddenQuantity) {
            hiddenQuantity = document.createElement('input');
            hiddenQuantity.type = 'hidden';
            hiddenQuantity.id = 'hiddenQuantity';
            hiddenQuantity.name = 'quantity';
            form.appendChild(hiddenQuantity);
        }
        hiddenQuantity.value = orderQuantity.value;
    }

    // Hidden status field is already created in openEditOrderModal function
    // No need to create another hidden status field here

    // Validate quantity if present
    const quantityInput = document.getElementById('editOrderQuantity');
    if (quantityInput && !quantityInput.disabled) {
        const quantity = parseInt(quantityInput.value);
        if (isNaN(quantity) || quantity <= 0) {
            alert('Please enter a valid quantity (must be greater than 0)');
            quantityInput.focus();
            return false;
        }
    }

    const formData = new FormData(form);
    const params = new URLSearchParams();

    for (let [key, value] of formData.entries()) {
        console.log(`Form field: ${key}=${value}`);
        params.append(key, value);
    }

    const resultDiv = document.getElementById("resultEditOrder");
    resultDiv.innerHTML = `<p style="color:blue; font-weight:bold;">Đang xử lý yêu cầu cập nhật...</p>`;

    console.log("Form action URL:", form.action);
    console.log("Request body:", params.toString());

    fetch(form.action, {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
        },
        body: params,
    })
            .then(res => {
                console.log("Response status:", res.status);
                if (!res.ok) {
                    throw new Error(`Server responded with status: ${res.status}`);
                }
                return res.text();
            })
            .then(text => {
                console.log("🔍 Raw response:", text);
                let data;
                try {
                    data = JSON.parse(text);
                    console.log("Parsed JSON response:", data);
                } catch (err) {
                    console.error("Error parsing JSON:", err);
                    throw new Error("Phản hồi không hợp lệ từ server: " + text);
                }

                // Kiểm tra cả hai trạng thái có thể có từ server
                if (data.status === "success" || data.message === "Order updated successfully") {
                    resultDiv.innerHTML = `<p style="color:green; font-weight:bold;">${data.message}</p>`;

                    setTimeout(() => {
                        closeModal("editOrderModal");
                        loadOrders(); // Reload bảng để đảm bảo hiển thị dữ liệu mới nhất
                    }, 800);
                } else {
                    resultDiv.innerHTML = `<p style="color:red; font-weight:bold;">Cập nhật thất bại: ${data.message}</p>`;
                }
            })
            .catch(error => {
                console.error("Lỗi:", error);
                resultDiv.innerHTML = `<p style="color:red; font-weight:bold;">Lỗi khi cập nhật đơn hàng: ${error.message}</p>`;
            });

    return false;
}

// Function to open delete order modal
function openDeleteOrderModal(orderId) {
    console.log("orderId = ", orderId);
    // Set the form for single order deletion
    document.getElementById("deleteOrderId").value = orderId;
    document.getElementById("deleteReferralCode").value = "";
    document.getElementById("deleteFormAction").value = "deleteOrder";
    document.getElementById("deleteModalTitle").textContent = "Delete Order";
    document.getElementById("deleteConfirmMessage").textContent = "Are you sure you want to delete this order?";
    document.getElementById("deleteConfirmButton").textContent = "Delete";

    openModal('deleteOrderModal');
}

// Function to open delete orders by referral code modal
function openDeleteOrdersByReferralCodeModal(referralCode) {
    console.log("referralCode = ", referralCode);
    // Set the form for referral code deletion
    document.getElementById("deleteOrderId").value = "";
    document.getElementById("deleteReferralCode").value = referralCode;
    document.getElementById("deleteFormAction").value = "deleteByReferralCode";
    document.getElementById("deleteModalTitle").textContent = "Delete All Orders";
    document.getElementById("deleteConfirmMessage").textContent =
            "Are you sure you want to delete ALL orders with this referral code? This action cannot be undone.";
    document.getElementById("deleteConfirmButton").textContent = "Delete All";

    openModal('deleteOrderModal');
}

// Function to submit order deletion (handles both single order and referral code deletion)
function submitDeleteOrder(form) {
    event.preventDefault();
    const deleteType = document.getElementById("deleteFormAction").value;
    console.log(`Submitting ${deleteType} form`);

    const formData = new FormData(form);
    const params = new URLSearchParams();

    for (let [key, value] of formData.entries()) {
        console.log(`Form parameter: ${key}=${value}`);
        params.append(key, value);
    }

    const resultDiv = document.getElementById("resultDeleteOrder");
    resultDiv.innerHTML = `<p style="color:blue; font-weight:bold;">Processing delete request...</p>`;

    console.log("Form action URL:", form.action);
    console.log("Request body:", params.toString());

    fetch(form.action, {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
        },
        body: params,
    })
            .then(res => {
                console.log("Response status:", res.status);
                if (!res.ok) {
                    throw new Error(`Server responded with status: ${res.status}`);
                }
                return res.text();
            })
            .then(text => {
                console.log("Raw response:", text);
                let data;
                try {
                    data = JSON.parse(text);
                    console.log("Parsed JSON response:", data);
                } catch (err) {
                    console.error("Error parsing JSON:", err);
                    throw new Error("Invalid response from server: " + text);
                }

                if (data.status === "deleted") {
                    resultDiv.innerHTML = `<p style="color:green; font-weight:bold;">${data.message}</p>`;

                    const tbody = document.querySelector('#orderTableBody');
                    if (tbody) {
                        if (deleteType === "deleteOrder") {
                            // For single order deletion
                            const deletedOrderId = document.getElementById("deleteOrderId").value;
                            const rows = tbody.querySelectorAll('tr');
                            rows.forEach(row => {
                                const editButton = row.querySelector('button.action-buttons__btn--edit');
                                if (editButton && editButton.getAttribute('onclick').includes(deletedOrderId)) {
                                    row.remove();
                                }
                            });
                        } else if (deleteType === "deleteByReferralCode") {
                            // For referral code deletion
                            const deletedRefCode = document.getElementById("deleteReferralCode").value;
                            const rows = tbody.querySelectorAll('tr');
                            rows.forEach(row => {
                                const firstCell = row.querySelector('td:first-child');
                                if (firstCell && firstCell.textContent.trim() === deletedRefCode) {
                                    row.remove();
                                }
                            });
                        }

                        // If no rows left, show message
                        if (tbody.querySelectorAll('tr').length === 0) {
                            tbody.innerHTML = `<tr><td colspan="6" style="text-align:center;">No orders available</td></tr>`;
                        }
                    }

                    setTimeout(() => {
                        closeModal("deleteOrderModal");
                    }, 800);
                } else {
                    resultDiv.innerHTML = `<p style="color:red; font-weight:bold;">Delete failed: ${data.message}</p>`;
                }
            })
            .catch(error => {
                console.error("Error:", error);
                resultDiv.innerHTML = `<p style="color:red; font-weight:bold;">Error deleting order(s): ${error.message}</p>`;
            });

    return false;
}

// Add loadOrders to the DOMContentLoaded event
document.addEventListener('DOMContentLoaded', function () {
    // Existing code already includes these
    // loadAccounts();
    // reloadProductList();
    // loadVouchers();
    // loadStaffData();
    // reloadTrainerList();
    // reloadBlogList();
    // loadCustomers();

    // Add loadOrders
    loadOrders();
});

// Xóa hàm trùng lặp

// Đã xóa hàm initOrderSearch vì không cần thiết nữa

// Function to update the total price in the edit form (internal calculations only)
function updateTotalPrice() {
    // This function is kept for compatibility with the onchange event
    // but doesn't need to display anything now
    const quantity = parseInt(document.getElementById('editOrderQuantity').value) || 0;
    const unitPriceElement = document.getElementById('unitPriceHidden');

    if (unitPriceElement) {
        const unitPrice = parseFloat(unitPriceElement.value) || 0;
        // We can still calculate the total price for internal use if needed
        const totalPrice = quantity * unitPrice;
        console.log(`Total price updated: ${formatVndPrice(totalPrice)}`);
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                    HOANG KHANG       
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                    HOANG KHANG       
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


function loadStaffData() {
    const contextPath = window.location.pathname.split('/')[1] ? `/${window.location.pathname.split('/')[1]}` : '';
    const staffSearchUrl = `${window.location.origin}${contextPath}/admin/staffs?action=ajaxList`;

    const searchStaff = document.getElementById("searchStaff").value;
    const searchPhone = document.getElementById("searchPhone").value;
    const staffFilter = document.getElementById("staffFilter").value;

    const url = `${staffSearchUrl}&searchStaff=${encodeURIComponent(searchStaff)}&searchPhone=${encodeURIComponent(searchPhone)}&staffFilter=${encodeURIComponent(staffFilter)}`;

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
                    const avatarUrl = `${window.location.origin}${contextPath}/AvatarServlet?user=${encodeURIComponent(staff.account.username)}&t=${Date.now()}`;
                    const row = `
                <tr>
                    <td>${index + 1}</td>                  
                    <td><img src="${escapeHTML(avatarUrl)}" alt="Avatar" style="width:40px;height:40px;border-radius:50%;"></td>
                    <td>${escapeHTML(staff.account.username)}</td>
                    <td>${escapeHTML(staff.fullName)}</td>
                    <td>${escapeHTML(staff.email)}</td>
                    <td>${escapeHTML(staff.phone)}</td>
                    <td>${escapeHTML(staff.position)}</td>
                    <td>${escapeHTML(staff.status)}</td>
                    <td>${escapeHTML(staff.staffCode)}</td>
                    <td>
                        <button class="action-buttons__btn action-buttons__btn--edit staff-edit"
                            data-staff-id='${staff.staffId}'
                            data-account-id='${staff.account.accountId}'
                            data-username='${staff.account.username.replace(/'/g, "&#39;")}'
                            data-fullname='${staff.fullName.replace(/'/g, "&#39;")}'
                            data-email='${staff.email.replace(/'/g, "&#39;")}'
                            data-phone='${staff.phone.replace(/'/g, "&#39;")}'
                            data-position='${staff.position.replace(/'/g, "&#39;")}'
                            data-status='${staff.status.replace(/'/g, "&#39;")}'
                        >
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="action-buttons__btn action-buttons__btn--delete staff-delete"
                            data-staff-id='${staff.staffId}'>
                            <i class="fas fa-trash-alt"></i>
                        </button>
                    </td>
                </tr>
                `;
                    tbody.innerHTML += row;
                });

                document.querySelectorAll('.staff-edit').forEach(btn => {
                    btn.addEventListener('click', function () {
                        openEditStaffModal(
                                this.dataset.staffId,
                                this.dataset.accountId,
                                this.dataset.username.replace(/&#39;/g, "'"),
                                this.dataset.fullname.replace(/&#39;/g, "'"),
                                this.dataset.email.replace(/&#39;/g, "'"),
                                this.dataset.phone.replace(/&#39;/g, "'"),
                                this.dataset.position.replace(/&#39;/g, "'"),
                                this.dataset.status.replace(/&#39;/g, "'")
                                );
                    });
                });
                document.querySelectorAll('.staff-delete').forEach(btn => {
                    btn.addEventListener('click', function () {
                        openDeleteStaffModal(this.dataset.staffId);
                    });
                });
            })
            .catch(error => {
                console.error('Lỗi khi load staff:', error);
                fetch(url)
                        .then(r => r.text())
                        .then(text => console.warn("Nội dung server trả về không phải JSON:", text));
            });
}


// Gọi hàm loadStaffData khi thay đổi các trường tìm kiếm và lọc
document.getElementById('searchStaff').addEventListener('input', loadStaffData);
document.getElementById('searchPhone').addEventListener('input', loadStaffData);
document.getElementById('staffFilter').addEventListener('change', loadStaffData);


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
    document.getElementById('editEmail').value = email;
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

function openDeleteStaffModal(staffId) {
    document.getElementById('deleteStaffId').value = staffId;
    openModal('deleteStaffModal');
}

function submitFormAjaxStaff(form, resultDivId) {
    const formData = new FormData(form);
    const resultDiv = document.getElementById(resultDivId);
    resultDiv.innerHTML = ''; // Xóa message cũ

    const contextPath = window.location.pathname.split('/')[1] ? `/${window.location.pathname.split('/')[1]}` : '';
    const url = `${window.location.origin}${contextPath}/admin/staffs`;

    fetch(url, {
        method: 'POST',
        body: formData
    })
            .then(response => {
                if (!response.ok)
                    throw new Error(`HTTP ${response.status}`);
                return response.json();
            })
            .then(data => {
                if (data.status === 'success') {
                    resultDiv.style.color = 'green';
                    resultDiv.innerHTML = data.message;

                    setTimeout(() => {
                        closeModal(form.closest('.modal').id || 'editStaffModal');
                        loadStaffData(); // reload lại danh sách staff
                    }, 1000); // Tải lại danh sách ngay
                } else {
                    resultDiv.style.color = 'red';
                    resultDiv.innerHTML = data.message;
                }
            })
            .catch(error => {
                resultDiv.style.color = 'red';
                resultDiv.innerHTML = `Lỗi kết nối: ${error.message}`;
            });

    return false;
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                              HA PHUONG                                                                                   /////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////                                              


// Regex constants
const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/; // Email hợp lệ
const phoneRegex = /^(0|\+84)[1-9]\d{8,9}$/; // SĐT VN: 0 hoặc +84, theo sau 9-10 chữ số

function validateAddTrainerForm() {
    let valid = true;

    // Clear old errors
    document.getElementById('emailError').innerText = '';
    document.getElementById('phoneError').innerText = '';

    // Email
    const email = document.getElementById('email').value.trim();
    if (!emailRegex.test(email)) {
        document.getElementById('emailError').innerText = 'Email không hợp lệ.';
        valid = false;
    }

    // Phone
    const phone = document.getElementById('phone_number').value.trim();
    if (!phoneRegex.test(phone)) {
        document.getElementById('phoneError').innerText = 'Số điện thoại phải là định dạng Việt Nam (bắt đầu bằng 0 hoặc +84, 9-10 chữ số).';
        valid = false;
    }

    return valid;
}



// Hàm validate cho edit form
function validateEditTrainerForm() {
    let valid = true;

    // Email
    const email = document.getElementById('editTrainerEmail').value.trim();
    if (!emailRegex.test(email)) {
        alert('Email không hợp lệ.');
        valid = false;
    }

    // Phone
    const phone = document.getElementById('editTrainerPhone').value.trim();
    if (!phoneRegex.test(phone)) {
        alert('Số điện thoại phải là định dạng Việt Nam (bắt đầu bằng 0 hoặc +84, 9-10 chữ số).');
        valid = false;
    }

    return valid;
}

// Hàm tải danh sách Trainer với các bộ lọc và tìm kiếm
function reloadTrainerList() {
    const contextPath = window.location.pathname.split('/')[1] ? `/${window.location.pathname.split('/')[1]}` : '';
    const baseUrl = `${window.location.origin}${contextPath}/TrainerServlet?action=json`;

    const searchTerm = document.getElementById("searchTerm").value;
    const experience = document.getElementById("experienceFilter").value;
    const rating = document.getElementById("ratingFilter").value;

    const url = `${baseUrl}&searchTerm=${encodeURIComponent(searchTerm)}&experience=${encodeURIComponent(experience)}&rating=${encodeURIComponent(rating)}`;

    fetch(url)
            .then(response => {
                if (!response.ok)
                    throw new Error(`HTTP ${response.status}`);
                return response.json();
            })
            .then(data => {
                const tbody = document.querySelector('#trainerTableBody');
                tbody.innerHTML = '';

                if (data.length === 0) {
                    tbody.innerHTML = `<tr><td colspan="7" style="text-align:center;">Không có huấn luyện viên nào</td></tr>`;
                    return;
                }

                data.forEach((trainer, index) => {
                    const account = trainer.accountId;
                    const avatarUrl = account && account.username
                            ? `${window.location.origin}${contextPath}/AvatarServlet?user=${encodeURIComponent(account.username)}&t=${Date.now()}`
                            : `${contextPath}/avatar/default.png`;

                    const formattedPrice = (trainer.price != null && !isNaN(trainer.price))
                            ? trainer.price.toLocaleString('vi-VN') + ' ₫'
                            : '0 ₫';

                    const row = `
                <tr>
                    <td><img src="${escapeHTML(avatarUrl)}" alt="Avatar" style="width:40px;height:40px;border-radius:50%"></td>
                    <td>${escapeHTML(account.username)}</td>  
                    <td>${escapeHTML(trainer.fullName)}</td>
                    <td>${escapeHTML(String(trainer.experienceYears))} year</td>
                    <td>${escapeHTML(trainer.rating.toFixed(1))} ★</td>
                    <td>${escapeHTML(formattedPrice)}</td>
                    <td>
                        <button class="action-buttons__btn action-buttons__btn--view trainer-view"
                            data-trainer-id='${trainer.trainerId}'>
                            <i class="bi bi-eye"></i>
                        </button>
                        <button class="action-buttons__btn action-buttons__btn--edit trainer-edit"
                            data-trainer-id='${trainer.trainerId}'>
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="action-buttons__btn action-buttons__btn--delete trainer-delete"
                            data-trainer-id='${trainer.trainerId}'>
                            <i class="fas fa-trash-alt"></i>
                        </button>
                    </td>
                </tr>
                `;
                    tbody.innerHTML += row;
                });

                // Thêm event cho các nút sau khi render (bảo vệ chắc)
                document.querySelectorAll('.trainer-view').forEach(btn => {
                    btn.addEventListener('click', function () {
                        openDetailTrainerModal(this.dataset.trainerId);
                    });
                });
                document.querySelectorAll('.trainer-edit').forEach(btn => {
                    btn.addEventListener('click', function () {
                        openEditTrainerModal(this.dataset.trainerId);
                    });
                });
                document.querySelectorAll('.trainer-delete').forEach(btn => {
                    btn.addEventListener('click', function () {
                        openDeleteTrainerModal(this.dataset.trainerId);
                    });
                });

            })
            .catch(error => {
                console.error('Lỗi khi tải danh sách trainer:', error);
            });
}


// Gọi hàm loadTrainers khi thay đổi các trường tìm kiếm và lọc
document.getElementById('searchTerm').addEventListener('input', reloadTrainerList);
document.getElementById('experienceFilter').addEventListener('change', reloadTrainerList);
document.getElementById('ratingFilter').addEventListener('change', reloadTrainerList);

// Gọi hàm để load danh sách Trainer khi trang được tải lần đầu
document.addEventListener('DOMContentLoaded', reloadTrainerList);



function submitEditTrainerForm(form, resultContainerId) {
    if (!validateEditTrainerForm()) {
        return false; // Dừng nếu validation fail
    }

    const formData = new FormData(form);
    formData.append('formAction', 'edit');

    // Debug
    for (let [key, val] of formData.entries()) {
        console.log(`️ Edit: ${key} = ${val}`);
    }

    const actionUrl = form.getAttribute("action");
    const resultContainer = document.getElementById(resultContainerId);

    fetch(actionUrl, {
        method: 'POST',
        body: formData
    })
            .then(async response => {
                const rawText = await response.text();
                console.log("Raw response (edit):", rawText);

                if (!rawText)
                    throw new Error("Empty response");

                let result = JSON.parse(rawText);
                if (result.status === 'success') {
                    resultContainer.innerHTML = `<p style="color:green;">${result.message}</p>`;
                    form.reset();
                    setTimeout(() => {
                        closeModal('editTrainerModal');
                        reloadTrainerList();
                    }, 700);

                } else {
                    resultContainer.innerHTML = `<p style="color:red;">${result.message}</p>`;
                }
            })
            .catch(error => {
                console.error(" Edit Trainer error:", error);
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
                    document.getElementById("editTrainerPrice").value = trainer.price || '0';
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
                console.log(" Trainer Accounts loaded:", data);
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
                    console.log("Adding option:", acc.username);
                    const opt = document.createElement('option');
                    opt.value = acc.accountId;               // <-- Đây là giá trị gửi đi
                    opt.textContent = acc.username;          // <-- Đây là nội dung hiển thị
                    select.appendChild(opt);
                });
            })
            .catch(err => {
                console.error(" Error loading trainer accounts:", err);
            });
}

function openAddTrainerModal() {
    loadTrainerAccountOptions(); // Gọi API để nạp dropdown
    document.getElementById('addTrainer').style.display = 'flex';
}


function submitFormAjaxTrainers(form, resultContainerId) {
    console.log("? Submitting form via AJAX...");

    // Kiểm tra tính hợp lệ của form
    if (!validateAddTrainerForm()) {
        return false; // Dừng nếu validation fail
    }

    const formData = new FormData(form);
    for (let [key, val] of formData.entries()) {
        console.log(`? ${key} = ${val}`);
    }

    const actionUrl = form.getAttribute("action");
    const resultContainer = document.getElementById(resultContainerId);

    fetch(actionUrl, {
        method: 'POST',
        body: formData
    })
            .then(async response => {
                const rawText = await response.text();
                console.log("? Raw response from server:", rawText);

                if (!rawText)
                    throw new Error("Empty response");

                let result = JSON.parse(rawText);
                console.log("Parsed JSON:", result);

                // Kiểm tra kết quả trả về từ server
                if (result.status === 'success') {
                    resultContainer.innerHTML = `<p style="color:green;">${result.message}</p>`;
                    console.log(result.message);
                    form.reset();
                    setTimeout(() => {
                        closeModal('addTrainer');
                        reloadTrainerList();  // Tải lại danh sách trainer
                    }, 500);
                } else {
                    // Hiển thị thông báo lỗi
                    resultContainer.innerHTML = `<p style="color:red;">${result.message}</p>`;
                }
            })
            .catch(error => {
                console.error("Error handling response:", error);
                resultContainer.innerHTML = `<p style="color:red;">Server Error: ${error.message}</p>`;
            });

    return false;
}




function openDetailTrainerModal(trainerId) {
    const contextPath = window.location.pathname.split('/')[1] ? `/${window.location.pathname.split('/')[1]}` : '';

    // Gọi API lấy thông tin chi tiết huấn luyện viên từ server
    fetch(`${window.location.origin}${contextPath}/TrainerServlet?action=getById&trainerId=${trainerId}`)
            .then(res => {
                if (!res.ok)
                    throw new Error("Network error");
                return res.json();
            })
            .then(trainer => {
                if (trainer) {


                    // Cập nhật avatar từ URL (dùng base64 hoặc đường dẫn URL)
                    const avatarUrl = trainer.accountId
                            ? `${window.location.origin}${contextPath}/AvatarServlet?user=${trainer.accountId.username}&t=${Date.now()}`
                            : `${contextPath}/avatar/default.png`; // Default avatar nếu không có avatar

                    // Cập nhật thông tin vào modal
                    document.getElementById('detailTrainerAvatar').src = avatarUrl;
                    document.getElementById('detailTrainerId').innerText = trainer.trainerId || '';
                    document.getElementById('detailTrainerUsername').innerText = trainer.accountId.username || '';
                    document.getElementById('detailTrainerFullName').innerText = trainer.fullName || '';
                    document.getElementById('detailTrainerEmail').innerText = trainer.email || '';
                    document.getElementById('detailTrainerPhone').innerText = trainer.phone || '';
                    document.getElementById('detailTrainerBio').innerText = trainer.bio || '';
                    document.getElementById('detailTrainerExperience').innerText = trainer.experienceYears || '';
                    document.getElementById('detailTrainerRating').innerText = trainer.rating || '';
                    document.getElementById('detailTrainerPrice').innerText = (trainer.price || 0).toLocaleString('vi-VN') + ' ₫';
                    document.getElementById('detailTrainerCode').innerText = trainer.trainer_code || '';



                    // Mở modal chi tiết
                    document.getElementById('detailTrainerModal').style.display = 'block';
                } else {
                    alert("Không tìm thấy trainer.");
                }
            })
            .catch(err => {
                alert("Lỗi khi lấy trainer: " + err);
            });
}


function closeDetailTrainerModal() {
    document.getElementById('detailTrainerModal').style.display = 'none';
}

function loadMemberPackage() {
    const contextPath = window.location.pathname.split('/')[1] ? `/${window.location.pathname.split('/')[1]}` : '';
    const baseUrl = `${window.location.origin}${contextPath}/MemberShipPackageServlet?action=json`;

    const username = document.getElementById('username').value;
    const packageName = document.getElementById('packageName').value;
    const paymentStatus = document.getElementById('paymentStatus').value;

    let url = baseUrl;
    const params = [];
    if (username)
        params.push(`username=${encodeURIComponent(username)}`);
    if (packageName)
        params.push(`packageName=${encodeURIComponent(packageName)}`);
    if (paymentStatus)
        params.push(`paymentStatus=${encodeURIComponent(paymentStatus)}`);

    if (params.length > 0) {
        url += `&${params.join('&')}`;
    }

    fetch(url)
            .then(response => {
                if (!response.ok) {
                    console.error(`Lỗi khi gọi API, mã lỗi: ${response.status}`);
                    throw new Error(`HTTP ${response.status}`);
                }
                return response.json();
            })
            .then(data => {
                console.log("Dữ liệu trả về từ API: ", data);
                const tbody = document.querySelector('#trainerPackageTableBody');
                tbody.innerHTML = '';

                if (!Array.isArray(data) || data.length === 0) {
                    tbody.innerHTML = `<tr><td colspan="6" style="text-align:center;">Không có gói thành viên nào</td></tr>`;
                    return;
                }

                const currentDate = new Date();
                currentDate.setHours(0, 0, 0, 0); // Bỏ giờ phút để so sánh chỉ theo ngày

                const rows = data.map((packageItem, index) => {
                    const accountUsername = packageItem.customer && packageItem.customer.fullName ? packageItem.customer.fullName : 'N/A';
                    const packageName = packageItem.membershipPackage ? packageItem.membershipPackage.name : 'N/A';
                    const startDateObj = packageItem.startDate ? new Date(packageItem.startDate.year, packageItem.startDate.month - 1, packageItem.startDate.day) : null;
                    const endDateObj = packageItem.endDate ? new Date(packageItem.endDate.year, packageItem.endDate.month - 1, packageItem.endDate.day) : null;
                    const startDate = startDateObj ? startDateObj.toLocaleDateString() : 'Invalid Date';
                    const endDate = endDateObj ? endDateObj.toLocaleDateString() : 'Invalid Date';
                    let paymentStatus = packageItem.paymentStatus || 'pending';
                    const membershipId = packageItem.membershipId || null;

                    // Kiểm tra hết hạn
                    let isExpired = false;
                    if (endDateObj) {
                        const endDateOnly = new Date(endDateObj);
                        endDateOnly.setHours(0, 0, 0, 0);
                        isExpired = endDateOnly < currentDate;
                    }

                    // Debug log để kiểm tra
                    console.log(`Membership ID ${membershipId}: endDate = ${endDate}, currentDate = ${currentDate.toLocaleDateString()}, isExpired = ${isExpired}`);

                    // Nếu hết hạn, buộc trạng thái cancelled
                    if (isExpired && paymentStatus !== 'cancelled') {
                        paymentStatus = 'cancelled';
                    }

                    // Disable dropdown nếu hết hạn
                    const disabledAttr = isExpired ? 'disabled' : '';

                    return `
                <tr>
                    <td>${index + 1}</td>
                    <td>${accountUsername}</td>
                    <td>${packageName}</td>
                    <td>${startDate}</td>
                    <td>${endDate}</td>
                    <td>
                        <select class="status-dropdown" data-membership-id="${membershipId}" ${disabledAttr} style="${isExpired ? 'background-color: #f0f0f0; cursor: not-allowed;' : ''}">
                            <option value="pending" ${paymentStatus === 'pending' ? 'selected' : ''}>Pending</option>
                            <option value="paid" ${paymentStatus === 'paid' ? 'selected' : ''}>Paid</option>
                            <option value="cancelled" ${paymentStatus === 'cancelled' ? 'selected' : ''}>Cancelled</option>
                        </select>
                    </td>         
                </tr>`;
                });

                tbody.innerHTML = rows.join('');

                // Lắng nghe change, ngăn nếu disabled
                document.querySelectorAll('.status-dropdown').forEach(select => {
                    select.addEventListener('change', function (event) {
                        if (this.disabled) {
                            event.preventDefault();
                            event.stopPropagation();
                            console.log('Dropdown bị khóa do hết hạn.');
                            return;
                        }
                        const membershipId = this.getAttribute('data-membership-id');
                        const newStatus = this.value;
                        updateStatus(membershipId, newStatus);
                    });
                });
            })
            .catch(error => {
                console.error('Lỗi khi tải danh sách gói thành viên:', error);
            });
}

// Hàm updateStatus (hiển thị error trên giao diện)
function updateStatus(membershipId, newStatus) {
    const contextPath = window.location.pathname.split('/')[1] ? `/${window.location.pathname.split('/')[1]}` : '';
    const url = `${window.location.origin}${contextPath}/MemberShipPackageServlet?action=updateStatus`;

    console.log('Updating status for membershipId:', membershipId, 'with status:', newStatus);

    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            membershipId: membershipId,
            status: newStatus,
        })
    })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    document.getElementById('successMessage').style.display = 'block';
                    setTimeout(() => {
                        document.getElementById('successMessage').style.display = 'none';
                    }, 2000);
                    console.log('Trạng thái đã được cập nhật thành công!');
                    loadMemberPackage();
                } else {
                    // Hiển thị thông báo lỗi trên giao diện
                    const errorMsg = document.getElementById('errorMessage');
                    errorMsg.textContent = data.error || 'Lỗi khi cập nhật trạng thái!';
                    errorMsg.style.display = 'block';
                    setTimeout(() => {
                        errorMsg.style.display = 'none';
                    }, 3000);
                    console.error('Lỗi khi cập nhật trạng thái: ', data.error);
                }
            })
            .catch(error => {
                console.error('Lỗi khi gửi yêu cầu cập nhật trạng thái:', error);
                const errorMsg = document.getElementById('errorMessage');
                errorMsg.textContent = 'Lỗi kết nối khi cập nhật!';
                errorMsg.style.display = 'block';
                setTimeout(() => {
                    errorMsg.style.display = 'none';
                }, 3000);
            });
}

function loadCategori() {
    const searchTerm = document.getElementById("searchTermCategory").value.trim();
    const contextPath = window.location.pathname.split('/')[1] ? `/${window.location.pathname.split('/')[1]}` : '';
    const baseUrl = `${window.location.origin}${contextPath}/Categori?action=json`;
    const url = `${baseUrl}&searchTerm=${encodeURIComponent(searchTerm)}`;

    fetch(url)
            .then(response => {
                if (!response.ok)
                    throw new Error(`HTTP ${response.status}`);
                return response.json();
            })
            .then(data => {
                const tbody = document.querySelector('#categoryTableBody');
                tbody.innerHTML = '';

                if (data.length === 0) {
                    tbody.innerHTML = `<tr><td colspan="4" style="text-align:center;">Không có danh mục nào</td></tr>`;
                    return;
                }

                data.forEach((category) => {
                    const truncatedDescription = category.description && category.description.length > 50
                            ? category.description.slice(0, 50) + "..."
                            : category.description;

                    const row = `
                <tr>
                    <td>${escapeHTML(String(category.category_id))}</td>
                    <td>${escapeHTML(category.name)}</td>
                    <td>${escapeHTML(truncatedDescription)}</td>
                    <td>
                        <button class="action-buttons__btn action-buttons__btn--edit category-edit"
                            data-category-id='${category.category_id}'
                            data-name='${category.name.replace(/'/g, "&#39;")}'
                            data-description='${category.description.replace(/'/g, "&#39;")}'
                        ><i class="fas fa-edit"></i></button>
                    </td>
                </tr>
                `;
                    tbody.innerHTML += row;
                });

                // Gán sự kiện cho nút Edit an toàn
                document.querySelectorAll('.category-edit').forEach(btn => {
                    btn.addEventListener('click', function () {
                        openEditCategoryModal(
                                this.dataset.categoryId,
                                this.dataset.name.replace(/&#39;/g, "'"),
                                this.dataset.description.replace(/&#39;/g, "'")
                                );
                    });
                });
            })
            .catch(error => {
                console.error('Lỗi khi tải danh mục:', error);
            });
}
// Lắng nghe sự kiện khi người dùng gõ vào ô tìm kiếm
document.getElementById("searchTerm").addEventListener("input", loadCategori);

// Gọi hàm loadCategori khi trang được tải lần đầu
document.addEventListener('DOMContentLoaded', loadCategori);



function submitFormAjaxCategory(form, resultId) {
    const formData = new FormData(form);
    const contextPath = '/SE1816_Gym_Group_4';
    const formAction = `${window.location.origin}${contextPath}/Categori`;
    if (!formData.has('formAction')) {
        formData.append('formAction', 'create');
    }
    console.log("Form action:", formData.get('formAction'));
    console.log("FormData content:", Object.fromEntries(formData));
    fetch(formAction, {
        method: 'POST',
        body: formData
    })
            .then(response => {
                if (!response.ok)
                    throw new Error(`HTTP ${response.status} - ${response.statusText}`);
                return response.text();
            })
            .then(result => {
                document.getElementById(resultId).innerText = result;
                if (result.includes("successfully")) {
                    loadCategori();
                    closeModal('addCategory');
                }
            })
            .catch(error => {
                console.error('Error during form submission:', error);
                document.getElementById(resultId).innerText = `Lỗi: ${error.message}`;
            });
    return false;
}

function openEditCategoryModal(categoryId, name, description) {
    document.getElementById('editCategoryId').value = categoryId || '';
    document.getElementById('editCategoryName').value = name || '';
    document.getElementById('editCategoryDescription').value = description || '';
    document.getElementById('editCategoryModal').style.display = 'block';
}

function submitEditCategoryForm(form, resultId) {
    const formData = new FormData(form);
    const contextPath = window.location.pathname.split('/')[1] ? `/${window.location.pathname.split('/')[1]}` : '';
    const formAction = `${window.location.origin}${contextPath}/Categori`; // URL của servlet

    // In thông tin formData để kiểm tra
    console.log("FormData being sent:", Object.fromEntries(formData));

    if (!formData.has('formAction')) {
        formData.append('formAction', 'edit');
    }

    // Kiểm tra lại URL trước khi gửi
    console.log("Sending request to URL:", formAction);

    fetch(formAction, {
        method: 'POST',
        body: formData
    })
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP ${response.status} - ${response.statusText}`);
                }
                return response.text();
            })
            .then(result => {
                console.log("Form submission result:", result); // In kết quả trả về
                document.getElementById(resultId).innerText = result;
                if (result.includes("successfully")) {
                    loadCategori(); // Gọi lại để cập nhật danh sách
                    closeModal('editCategoryModal'); // Đóng modal nếu thành công
                }
            })
            .catch(error => {
                // In lỗi chi tiết vào console để biết chính xác nguyên nhân
                console.error('Error during form submission:', error);
                document.getElementById(resultId).innerText = `Lỗi: ${error.message}`;
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
    const searchTerm = document.getElementById('searchInputMember').value;
    const contextPath = window.location.pathname.split('/')[1] ? `/${window.location.pathname.split('/')[1]}` : '';

    let url = `${window.location.origin}${contextPath}/admin/customer?action=ajaxList`;
    if (searchTerm) {
        url = `${window.location.origin}${contextPath}/admin/customer?action=ajaxList&fullName=${encodeURIComponent(searchTerm)}`;
    }

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
                    const avatarUrl = `${window.location.origin}${contextPath}/AvatarServlet?user=${encodeURIComponent(cus.account.username)}&t=${Date.now()}`;
                    const row = `
                    <tr>
                     <td>${index + 1}</td>
                     <td><img src="${escapeHTML(avatarUrl)}" alt="Avatar" style="width:40px;height:40px;border-radius:50%;"></td>
                     <td>${escapeHTML(cus.account.username)}</td>
                     <td>${escapeHTML(cus.fullName)}</td>
                     <td>${escapeHTML(cus.email)}</td>
                     <td>${escapeHTML(cus.phone)}</td>
                     <td>${escapeHTML(cus.customerCode || '')}</td>
                     <td>
                     <button class="action-buttons__btn action-buttons__btn--edit"
                     onclick="openEditCustomerModal('${escapeJSAttr(cus.customerId)}')">
                     <i class="fas fa-edit"></i></button>
                     <button class="action-buttons__btn action-buttons__btn--delete"
                     onclick="openDeleteCustomerModal('${escapeJSAttr(cus.customerId)}')">
                     <i class="fas fa-trash-alt"></i></button>
                     </td>
                    </tr>
                 `;
                    tbody.innerHTML += row;
                });
                console.log("DEBUG: customerDataMap", customerDataMap);
                for (let key in customerDataMap) {
                    console.log("Customer:", key, customerDataMap[key]);
                    break;
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
    const contextPath = window.location.pathname.split('/')[1] ? `/${window.location.pathname.split('/')[1]}` : '';
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
            `${window.location.origin}${contextPath}/AvatarServlet?user=${cus.account.username}&t=${Date.now()}`;
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
                return res.json();
            })
            .then(data => {
                if (data.status === 'success') {
                    document.getElementById("resultDeleteCustomer").innerHTML = `<p style="color:green;font-weight:bold;">${data.message}</p>`;
                    setTimeout(() => {
                        closeModal("deleteCustomerModal");
                        loadCustomers();
                    }, 800);
                } else {
                    document.getElementById("resultDeleteCustomer").innerHTML = `<p style="color:red;">${data.message}</p>`;
                }
            })
            .catch(error => {
                console.error("❌ Lỗi khi xóa:", error);
                document.getElementById("resultDeleteCustomer").innerText = `Lỗi khi gửi yêu cầu xóa: ${error.message}`;
            });

    return false;
}

// ... (Các hàm khác giữ nguyên)

//// Hàm xử lý submit form AJAX
function submitFormAjaxCO(form, resultDivId) {
    const formData = new FormData(form);
    const resultDiv = document.getElementById(resultDivId);
    resultDiv.innerHTML = ''; // Xóa message cũ

    const contextPath = window.location.pathname.split('/')[1] ? `/${window.location.pathname.split('/')[1]}` : '';
    const url = `${window.location.origin}${contextPath}/admin/customer`;

    fetch(url, {
        method: 'POST',
        body: formData
    })
            .then(response => {
                if (!response.ok)
                    throw new Error(`HTTP ${response.status}`);
                return response.json();
            })
            .then(data => {
                if (data.status === 'success') {
                    resultDiv.style.color = 'green';
                    resultDiv.innerHTML = data.message;
                    console.log("DEBUG: Success - Preparing to close modal");

                    // Đóng modal ngay lập tức (loại bỏ setTimeout để tránh delay gây lỗi)
                    const modalId = form.closest('.modal').id || 'editCustomerModal'; // Fallback nếu closest không hoạt động
                    closeModal(modalId);
                    loadCustomers(); // Tải lại danh sách ngay
                } else {
                    resultDiv.style.color = 'red';
                    resultDiv.innerHTML = data.message;
                }
            })
            .catch(error => {
                resultDiv.style.color = 'red';
                resultDiv.innerHTML = `Lỗi kết nối: ${error.message}`;
            });

    return false; // Ngăn submit form mặc định
}

// Hàm đóng modal (thêm fallback display none)
function closeModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.classList.remove('modal--active');
        modal.style.display = 'none'; // Fallback để đảm bảo ẩn modal
        console.log("DEBUG: Modal closed successfully", modalId);
    } else {
        console.error("DEBUG: Modal not found when closing", modalId);
    }
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
    console.log('🔄 Loading blogs with filters...');
    const contextPath = '/' + window.location.pathname.split('/')[1];

    // Lấy giá trị từ input filter
    const searchTitle = document.getElementById('searchBlog') ? document.getElementById('searchBlog').value.trim() : '';
    const startDate = document.getElementById('blogStartDate') ? document.getElementById('blogStartDate').value : '';
    const endDate = document.getElementById('blogEndDate') ? document.getElementById('blogEndDate').value : '';

    // Tạo URL có query string
    let url = `${window.location.origin}${contextPath}/admin/blogs?action=ajaxList`;
    url += `&search=${encodeURIComponent(searchTitle)}`;
    url += `&startDate=${encodeURIComponent(startDate)}`;
    url += `&endDate=${encodeURIComponent(endDate)}`;

    fetch(url)
            .then(response => {
                if (!response.ok)
                    throw new Error(`HTTP ${response.status}`);
                return response.json();
            })
            .then(data => {
                const tbody = document.querySelector('#blogsTable tbody');
                tbody.innerHTML = '';

                if (!Array.isArray(data) || data.length === 0) {
                    tbody.innerHTML = `<tr><td colspan="7" style="text-align:center;">Không có blog phù hợp</td></tr>`;
                    return;
                }

                data.forEach((blog, index) => {
                    const imageUrl = blog.primaryImageId
                            ? `${window.location.origin}${contextPath}/ImagesServlet?type=blog&imageId=${blog.primaryImageId}&t=${Date.now()}`
                            : `${contextPath}/avatar/default.png`;

                    // Escape khi render bảng
                    const escapedTitle = escapeHTML(blog.title || '');
                    let escapedContent = escapeHTML(blog.content || '');
                    if (!escapedContent || escapedContent === 'null') {
                        escapedContent = 'Chưa có nội dung';
                    }

                    const truncatedContent = escapedContent.length > 150 ? escapedContent.substring(0, 150) + '...' : escapedContent;

                    // Chỉ escape khi hiển thị bảng. Khi truyền data, chỉ escape dấu '
                    const row = `
                <tr>
                    <td>${index + 1}</td>
                    <td><img src="${escapeHTML(imageUrl)}" alt="Blog Image" style="width:90px;height:100px;border-radius:10px;"></td>
                    <td>${escapedTitle}</td>
                    <td>${truncatedContent}</td>
                    <td>${escapeHTML(new Date(blog.createdAt).toLocaleString('vi-VN'))}</td>
                    <td>${escapeHTML(new Date(blog.updatedAt).toLocaleString('vi-VN'))}</td>
                    <td>
                        <button class="action-buttons__btn action-buttons__btn--edit blog-edit"
                            data-blog-id='${blog.blogId}'
                            data-title='${(blog.title || '').replace(/'/g, "&#39;")}'
                            data-content='${(blog.content || '').replace(/'/g, "&#39;")}'
                            data-image-url='${imageUrl.replace(/'/g, "&#39;")}'
                        >
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="action-buttons__btn action-buttons__btn--delete blog-delete"
                            data-blog-id='${blog.blogId}'>
                            <i class="fas fa-trash-alt"></i>
                        </button>
                    </td>
                </tr>
                `;
                    tbody.innerHTML += row;
                });

                // Gán sự kiện cho các nút Edit/Delete
                document.querySelectorAll('.blog-edit').forEach(btn => {
                    btn.addEventListener('click', function () {
                        openEditBlogModal(
                                this.dataset.blogId,
                                this.dataset.title.replace(/&#39;/g, "'"),
                                this.dataset.content.replace(/&#39;/g, "'"),
                                this.dataset.imageUrl.replace(/&#39;/g, "'")
                                );
                    });
                });
                document.querySelectorAll('.blog-delete').forEach(btn => {
                    btn.addEventListener('click', function () {
                        openDeleteBlogModal(this.dataset.blogId);
                    });
                });
            })
            .catch(error => {
                console.error('❌ Lỗi khi load blog list:', error);
            });
}

// Ví dụ modal:
function openEditBlogModal(id, title, content, imageUrl) {
    document.getElementById("editBlogId").value = id;
    document.getElementById("editBlogTitle").value = title || '';
    document.getElementById("editBlogContent").value = content || '';
    document.getElementById("editBlogImagePreview").src = imageUrl || '';
    document.getElementById("editBlogModal").style.display = "block";
}
function openDeleteBlogModal(id) {
    document.getElementById("deleteBlogId").value = id;
    document.getElementById("deleteBlogModal").style.display = "block";
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

                // Hiển thị các ảnh phụ
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
                    deleteBtn.textContent = "no";
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

                //  Mở modal chỉnh sửa blog
                openModal('editBlogModal');
            })
            .catch(error => {
                console.error(" Lỗi khi load blog:", error);
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

function loadLoginLogs() {
    const contextPath = window.location.pathname.split('/')[1] ? `/${window.location.pathname.split('/')[1]}` : '';
    const url = `${window.location.origin}${contextPath}/admin/loginLog`;

    fetch(url)
            .then(res => res.json())
            .then(data => {
                const tbody = document.querySelector('#loginLogsTable tbody');
                tbody.innerHTML = '';

                if (data.length === 0) {
                    tbody.innerHTML = `<tr><td colspan="5" style="text-align:center;">Không có log nào</td></tr>`;
                    return;
                }

                data.forEach(log => {
                    const row = `
                    <tr>
                        <td>${log.index}</td>
                        <td>${log.username}</td>
                        <td>${log.loginTime}</td>
                        <td>${log.ip}</td>
                        <td>${log.userAgent}</td>
                    </tr>
                `;
                    tbody.innerHTML += row;
                });
            })
            .catch(err => {
                console.error("Lỗi khi tải login logs:", err);
            });
}
// Override showTable để ẩn biểu đồ và hiện đúng bảng cần thiết

// Tự động reload login logs mỗi 10 giây nếu bảng đang mở
setInterval(() => {
    const table = document.getElementById('loginLogsTable');
    if (table && table.style.display === 'block') {
        loadLoginLogs();
    }
}, 10000); // 10000ms = 10 giây

function loadPackages(searchKeyword = '') {
    const pathParts = window.location.pathname.split('/');
    const contextPath = pathParts.length > 1 ? `/${pathParts[1]}` : '';
    let url = `${contextPath}/admin/packages`;

    if (searchKeyword && searchKeyword.trim() !== '') {
        url += `?name=${encodeURIComponent(searchKeyword.trim())}`;
    }

    fetch(url)
            .then(res => {
                if (!res.ok) {
                    throw new Error("HTTP status " + res.status);
                }
                return res.json();
            })
            .then(data => {
                const tbody = document.querySelector("#packagesTableData tbody");
                tbody.innerHTML = "";

                data.forEach((pkg, index) => {
                    const tr = document.createElement("tr");

                    const shortDescription = pkg.description && pkg.description.length > 150
                            ? pkg.description.slice(0, 150) + "..."
                            : pkg.description || "";

                    tr.innerHTML = `
                    <td>${index + 1}</td>
                    <td>${escapeHTML(pkg.name)}</td>
                    <td>${escapeHTML(pkg.price.toLocaleString())}₫</td>
                    <td>${escapeHTML(String(pkg.durationDays))}</td>
                    <td>${escapeHTML(shortDescription)}</td>
                    <td>
                        <button class="action-buttons__btn action-buttons__btn--edit package-edit"
                            data-id='${pkg.id}'
                            data-name='${pkg.name.replace(/'/g, "&#39;")}'
                            data-description='${(pkg.description || '').replace(/'/g, "&#39;")}'
                            data-duration='${pkg.durationDays}'
                            data-price='${pkg.price}'
                            data-status='${pkg.isActive ? "1" : "0"}'>
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="action-buttons__btn action-buttons__btn--delete package-delete"
                            data-id='${pkg.id}'>
                            <i class="fas fa-trash-alt"></i>
                        </button>
                    </td>
                `;
                    tbody.appendChild(tr);
                });

                // Gán sự kiện Edit/Delete
                document.querySelectorAll('.package-edit').forEach(btn => {
                    btn.addEventListener('click', function () {
                        openEditPackageModal(
                                this.dataset.id,
                                this.dataset.name.replace(/&#39;/g, "'"),
                                this.dataset.description.replace(/&#39;/g, "'"),
                                this.dataset.duration,
                                this.dataset.price,
                                this.dataset.status
                                );
                    });
                });
                document.querySelectorAll('.package-delete').forEach(btn => {
                    btn.addEventListener('click', function () {
                        openDeletePackageModal(this.dataset.id);
                    });
                });
            })
            .catch(error => {
                console.error("❌ Failed to load packages:", error);
                alert("Không thể tải danh sách gói tập!");
            });
}

// Khi nhập filter và khi trang vừa load
document.getElementById('packageSearchInput').addEventListener('input', function () {
    loadPackages(this.value);
});
document.addEventListener('DOMContentLoaded', function () {
    loadPackages();
});

// Nhận đủ data, KHÔNG fetch lại nếu không thật sự cần update mới từ server!
function openEditPackageModal(id, name, description, duration, price, status) {
    document.getElementById("editPackageId").value = id || '';
    document.getElementById("editPackageName").value = name || '';
    document.getElementById("editPackageDescription").value = description || '';
    document.getElementById("editPackageDuration").value = duration || '';
    document.getElementById("editPackagePrice").value = price || '';
    document.getElementById("editPackageStatus").value = status || '1';

    document.getElementById("editPackageModal").style.display = "block";
}

function openDeletePackageModal(id) {
    document.getElementById("deletePackageId").value = id;
    document.getElementById("resultDeletePackage").innerHTML = "";
    document.getElementById("deletePackageModal").style.display = "block";
}
//function openAddPackageModal() {
//    document.getElementById("resultAddPackage").innerHTML = "";
//    document.getElementById("addPackageModal").style.display = "block";
//}
