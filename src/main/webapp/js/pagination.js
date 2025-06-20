let currentPage = 1;
let totalPages = parseInt(document.getElementById('totalPages').value);

// Chức năng thay đổi trang khi người dùng bấm nút phân trang
function changePage(direction) {
    if (direction === 'previous' && currentPage > 1) {
        currentPage--;
    } else if (direction === 'next' && currentPage < totalPages) {
        currentPage++;
    }

    fetchDataForPage(currentPage);
}

// Hàm gửi yêu cầu AJAX để tải sản phẩm cho trang hiện tại
function fetchDataForPage(page) {
    const url = `${window.location.pathname}?page=${page}`;
    const resultContainerId = 'product-list';  // Phần tử cần cập nhật danh sách sản phẩm

    fetch(url)
        .then(response => {
            if (!response.ok) {
                throw new Error(`HTTP ${response.status}`);
            }
            return response.json();
        })
        .then(data => {
            updateProductGrid(data);
            updatePagination();
        })
        .catch(error => {
            console.error('Error:', error);
        });
}

// Cập nhật phần danh sách sản phẩm
function updateProductGrid(data) {
    const productList = document.getElementById('product-list');
    productList.innerHTML = '';  // Xóa tất cả sản phẩm cũ

    data.products.forEach(product => {
        const productCard = document.createElement('div');
        productCard.classList.add('product-card');
        productCard.innerHTML = `
            <img src="${product.image}" alt="Product Image" class="product-image" />
            <p><strong>${product.name}</strong></p>
            <p>${product.price}đ</p>
        `;
        productList.appendChild(productCard);
    });

    totalPages = data.totalPages;
    currentPage = data.currentPage;
}


// Cập nhật phân trang
function updatePagination() {
    const paginationContainer = document.getElementById('pagination');
    paginationContainer.innerHTML = '';  // Xóa các nút phân trang cũ

    // Nút previous
    const previousButton = document.createElement('a');
    previousButton.classList.add('pagination-btn', 'previous');
    previousButton.textContent = '< previous';
    previousButton.onclick = () => changePage('previous');
    paginationContainer.appendChild(previousButton);

    // Các nút trang
    for (let i = 1; i <= totalPages; i++) {
        const pageButton = document.createElement('a');
        pageButton.href = '#';
        pageButton.classList.add('pagination-btn');
        if (i === currentPage) {
            pageButton.classList.add('active');
        }
        pageButton.textContent = i;
        pageButton.onclick = () => changePage(i);
        paginationContainer.appendChild(pageButton);
    }

    // Nút next
    const nextButton = document.createElement('a');
    nextButton.classList.add('pagination-btn', 'next');
    nextButton.textContent = 'next >';
    nextButton.onclick = () => changePage('next');
    paginationContainer.appendChild(nextButton);
}

