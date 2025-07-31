
document.addEventListener('DOMContentLoaded', function () {
    let currentPage = 1;
    let totalPages = parseInt(document.getElementById('totalPages').value) || 1; // Fallback to 1 if invalid
    console.log('totalPages initialized:', totalPages);

    window.changePageProduct = function (direction) {
        console.log('changePage called with direction:', direction, 'currentPage:', currentPage, 'totalPages:', totalPages);
        if (direction === 'previous' && currentPage > 1) {
            currentPage--;
        } else if (direction === 'next' && currentPage < totalPages) {
            currentPage++;
        } else if (typeof direction === 'number') {
            currentPage = direction;
        }
        fetchDataForPage(currentPage);
    }

    function fetchDataForPage(page) {
        const url = `${window.location.pathname}?page=${page}`; // Include page number
        console.log('Fetching URL:', url);

        fetch(url, {
            method: 'GET', // Use GET request
            headers: {
                'X-Requested-With': 'XMLHttpRequest', // Ensure it's an AJAX request
            }
        })
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP ${response.status}`);
                    }
                    return response.json();  // This line expects a JSON response
                })
                .then(data => {
                    console.log("Data received:", data);  // For debugging
                    updateProductGrid(data);
                    updatePagination(data.totalPages, data.currentPage);
                })
                .catch(error => {
                    console.error('Fetch error:', error);
                });
    }


    function updateProductGrid(data) {
        const productList = document.getElementById('product-list');
        productList.innerHTML = ''; // Clear current content
        data.products.forEach(product => {
            const productCard = document.createElement('div');
            productCard.classList.add('product-card');

            // Add product image, name, and price
            productCard.innerHTML = `
            <img src="${product.image}" alt="Product Image" class="product-image" />
            <p><strong>${product.name}</strong></p>`;
            // Stock info
            const stockStatus = product.stock < 1
                    ? '<span style="display:block; color: #ff6b6b; font-size: 14px; margin-top: 4px; font-weight: bold;">Out of stock</span>'
                    : `<span style="display:block; color: #aaa; font-size: 14px; margin-top: 4px;">In stock: ${product.stock}</span>`;

            productCard.innerHTML += stockStatus;
            productCard.innerHTML += `<p style="font-size: 18px; font-weight: 600; color: #d9ff68;">${product.price.toLocaleString('de-DE')}đ</p>`;
            // Add buttons for Add to Cart, Buy Now, and Details
            const contextPath = window.location.pathname.split('/')[1] ? '/' + window.location.pathname.split('/')[1] : '';
            const actionButtons = `
            <div class="product-actions">
                <button onclick="addToCart(${product.productId})"
                     class="cart-icon-btn neon-button cart"
                      ${product.stock < 1 ? 'disabled style="opacity:0.5;pointer-events:none;"\n\
                        title="Out of stock"' : ''}>
                    <i class="fas fa-shopping-cart"></i> Cart
                </button>
    <button class="cart-icon-btn neon-button buy-now btn-buy-now"
      data-productid="${product.productId}"
      ${product.stock < 1 ? 'disabled style="opacity:0.5;pointer-events:none;" title="Out of stock"' : ''}>
      <i class="fas fa-bolt"></i> Buy Now
    </button>

                <button  class="cart-icon-btn neon-button details" onclick="window.location.href = '${contextPath}/ProductDetail?productId=${product.productId}'" title="View Details">
                    <i class="fas fa-info-circle"></i> Details
                </button>
            </div>
        `;

            productCard.innerHTML += actionButtons;

            // Append product card to the product list
            productList.appendChild(productCard);
        });
        setupBuyNowEvents();
    }

    function updatePagination(totalPages, currentPage) {
        const paginationContainer = document.getElementById('pagination');
        paginationContainer.innerHTML = '';
        const previousButton = document.createElement('a');
        previousButton.classList.add('pagination-btn', 'previous');
        previousButton.textContent = '< previous';
        previousButton.onclick = () => changePageProduct('previous');
        paginationContainer.appendChild(previousButton);

        for (let i = 1; i <= totalPages; i++) {
            const pageButton = document.createElement('a');
            pageButton.href = '#';
            pageButton.classList.add('pagination-btn');
            if (i === currentPage)
                pageButton.classList.add('active');
            pageButton.textContent = i;
            pageButton.onclick = () => changePageProduct(i);
            paginationContainer.appendChild(pageButton);
        }

        const nextButton = document.createElement('a');
        nextButton.classList.add('pagination-btn', 'next');
        nextButton.textContent = 'next >';
        nextButton.onclick = () => changePageProduct('next');
        paginationContainer.appendChild(nextButton);
    }
});
