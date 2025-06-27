let currentPage = 1;
    let totalPages = 1;

    // Hàm thay đổi trang
    function changePage(direction) {
        if (direction === 'previous' && currentPage > 1) {
            currentPage--;
        } else if (direction === 'next' && currentPage < totalPages) {
            currentPage++;
        } else if (typeof direction === 'number') {
            currentPage = direction;
        }

        fetchDataForPage(currentPage);
    }

    // Hàm gửi yêu cầu AJAX và nhận dữ liệu JSON
    function fetchDataForPage(page) {
        const url = `${window.location.pathname}?page=${page}`;  // Gọi servlet để lấy dữ liệu trang mới

        fetch(url)
            .then(response => response.json())  // Nhận dữ liệu JSON từ servlet
            .then(data => {
                updateProductGrid(data.products);  // Cập nhật danh sách sản phẩm
                updatePagination(data.totalPages, data.currentPage);  // Cập nhật phân trang
            })
            .catch(error => {
                console.error('Lỗi:', error);
            });
    }

    function updateProductGrid(products) {
        const productList = document.getElementById('product-list');
        productList.innerHTML = '';  // Xóa các sản phẩm cũ

        products.forEach(product => {
            const productCard = document.createElement('div');
            productCard.classList.add('product-card');
            
            const imageUrl = product.primaryImageId ? `path_to_images/${product.primaryImageId}.jpg` : './img/placeholder.jpg';
            
            productCard.innerHTML = `
                <img src="${imageUrl}" alt="Product Image" class="product-image" />
                <p><strong>${product.name}</strong></p>
                <p>${product.price}đ</p>
            `;
            productList.appendChild(productCard);
        });
    }

    function updatePagination(totalPages, currentPage) {
        const paginationContainer = document.getElementById('pagination');
        paginationContainer.innerHTML = '';  // Xóa các nút phân trang cũ

        // Nút Previous
        const previousButton = document.createElement('a');
        previousButton.classList.add('pagination-btn', 'previous');
        previousButton.textContent = '< previous';
        previousButton.onclick = () => changePage('previous');
        paginationContainer.appendChild(previousButton);

        // Các nút trang
        for (let i = 1; i <= totalPages; i++) {
            const pageButton = document.createElement('a');
            pageButton.classList.add('pagination-btn');
            if (i === currentPage) {
                pageButton.classList.add('active');
            }
            pageButton.textContent = i;
            pageButton.onclick = () => changePage(i);
            paginationContainer.appendChild(pageButton);
        }

        // Nút Next
        const nextButton = document.createElement('a');
        nextButton.classList.add('pagination-btn', 'next');
        nextButton.textContent = 'next >';
        nextButton.onclick = () => changePage('next');
        paginationContainer.appendChild(nextButton);
    }

    // Ban đầu, tải trang đầu tiên
    fetchDataForPage(currentPage);