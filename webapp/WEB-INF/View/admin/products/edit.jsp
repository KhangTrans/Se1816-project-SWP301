<div class="modal" id="editProductModal">
    <div class="modal__content">
        <form method="post"
              action="${pageContext.request.contextPath}/admin/products"
              enctype="multipart/form-data"
              onsubmit="return submitFormAjax(this, 'resultEditProduct', event)">

            <input type="hidden" name="formAction" value="update">
            <input type="hidden" name="productId" id="editProductId">

            <div class="modal__header">
                <h2 class="modal__title">Edit Product</h2>
                <button type="button" class="modal__close" onclick="closeModal('editProductModal')">&times;</button>
            </div>

            <div class="modal__body">
                <!-- Name -->
                <div class="modal__form-group">
                    <label class="modal__label">Name</label>
                    <input type="text" name="name" id="editProductName" class="modal__input" required>
                </div>

                <!-- Description -->
                <div class="modal__form-group">
                    <label class="modal__label">Description</label>
                    <textarea name="description" id="editProductDescription" class="modal__textarea"></textarea>
                </div>

                <!-- Price -->
                <div class="modal__form-group">
                    <label class="modal__label">Price</label>
                    <input type="number" name="price" id="editProductPrice" class="modal__input" step="0.01" min="0.01" required>
                </div>

                <!-- Stock -->
                <div class="modal__form-group">
                    <label class="modal__label">Stock Quantity</label>
                    <input type="number" name="stockQuantity" id="editProductStock" class="modal__input" min="1" required>
                </div>

                <!-- Category -->
                <div class="modal__form-group">
                    <label class="modal__label">Category</label>
                    <select name="categoryId" id="editProductCategory" class="modal__input" required>
                        <!-- Filled by JS -->
                    </select>
                </div>

                <!-- Main Image Upload -->
                <div class="modal__form-group">
                    <label class="modal__label">Change Main Image</label>
                    <input type="file" name="mainImage" class="modal__input" accept="image/*" onchange="previewEditProductImage(this)">
                    <span id="mainImageFilename" style="font-size: 12px; color: gray;"></span>
                    <img id="editProductImagePreview"
                         src=""
                         alt="Main Preview"
                         style="margin-top:10px; width: 80px; border-radius: 6px; display: none;"
                         onerror="this.style.display='none';">
                </div>

                <!-- Existing Images with actions -->
                <div class="modal__form-group">
                    <label class="modal__label">T?t c? ?nh hi?n t?i</label>
                    <div id="editProductImageList" style="display: flex; flex-wrap: wrap; gap: 10px;"></div>
                </div>

                <!-- New Images Upload -->
                <div class="modal__form-group">
                    <label class="modal__label">Thêm ?nh ph? m?i</label>
                    <input type="file" name="images" id="editNewImages" class="modal__input" accept="image/*" multiple onchange="previewNewImages(this)">
                    <div id="editNewImagePreviewList" style="display: flex; flex-wrap: wrap; gap: 10px; margin-top: 10px;"></div>
                </div>

                <!-- Result -->
                <div id="resultEditProduct"></div>
            </div>

            <div class="modal__footer">
                <button type="submit" class="modal__btn modal__btn--primary">Update</button>
                <button type="button" class="modal__btn modal__btn--secondary" onclick="closeModal('editProductModal')">Cancel</button>
            </div>
        </form>
    </div>
</div>
