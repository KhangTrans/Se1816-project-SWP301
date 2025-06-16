<div class="modal" id="deleteProductModal">
    <div class="modal__content">
        <form method="post" action="${pageContext.request.contextPath}/admin/products" 
              onsubmit="return submitFormAjax(this, 'resultDeleteProduct')">
            <input type="hidden" name="formAction" value="delete">
            <input type="hidden" name="productId" id="deleteProductId">
            <div class="modal__header">
                <h2 class="modal__title">Delete Product</h2>
                <button type="button" class="modal__close" onclick="closeModal('deleteProductModal')">&times;</button>
            </div>
            <div class="modal__body">
                <p>Are you sure you want to delete this product?</p>
                <div id="resultDeleteProduct"></div>
            </div>
            <div class="modal__footer">
                <button type="submit" class="modal__btn modal__btn--primary">Delete</button>
                <button type="button" class="modal__btn modal__btn--secondary" onclick="closeModal('deleteProductModal')">Cancel</button>
            </div>
        </form>
    </div>
</div>