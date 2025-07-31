<!-- View Product Modal -->
<div class="modal" id="viewProductModal">
    <div class="modal-content" style="width: 750px">
        <div class="modal__header">
            <h2 class="modal__title">View Product</h2>
        </div>

        <div class="modal__body">
            <!-- Name -->
            <div class="modal__form-group">
                <label class="modal__label">Name</label>
                <p id="viewProductName" class="modal__view-text"></p>
            </div>

            <!-- Description -->
            <div class="modal__form-group">
                <label class="modal__label">Description</label>
                <p id="viewProductDescription" class="modal__view-text" style="white-space: pre-wrap;"></p>
            </div>

            <!-- Price -->
            <div class="modal__form-group">
                <label class="modal__label">Price</label>
                <p id="viewProductPrice" class="modal__view-text"></p>
            </div>

            <!-- Stock -->
            <div class="modal__form-group">
                <label class="modal__label">Stock Quantity</label>
                <p id="viewProductStock" class="modal__view-text"></p>
            </div>

            <!-- Category -->
            <div class="modal__form-group">
                <label class="modal__label">Category</label>
                <p id="viewProductCategory" class="modal__view-text"></p>
            </div>

            <div class="modal__form-group">
                <label class="modal__label">Existing Images</label>
                <div id="viewProductImageList" class="modal__image-list" style="display: flex; flex-wrap: wrap; gap: 10px;"></div>
            </div>
        </div>

        <div class="modal__footer">
            <button type="button" class="modal__btn modal__btn--secondary" onclick="closeModal('viewProductModal')">Close</button>
        </div>
    </div>
</div>
