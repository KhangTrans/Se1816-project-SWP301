<div class="modal" id="addCategory" style="display: none;">
    <div class="modal-content">
        <form id="addCategoryForm"
              method="post" action="${pageContext.request.contextPath}/Categori" 
              onsubmit="return submitFormAjaxCategory(this, 'resultAdd')">


            <input type="hidden" name="formAction" value="create">

            <div class="modal__header">
                <h2 class="modal__title">Add Category</h2>
            </div>

            <div class="modal__body">
                <label for="categoryName">Category Name:</label>
                <input type="text" name="name" id="categoryName" required><br><br>

                <label for="categoryDescription">Description:</label>
                <textarea name="description" id="categoryDescription" rows="4" required></textarea><br><br>
            </div>

            <div class="modal__footer">
                <button type="submit">Create</button>
                <button type="button" onclick="closeModal('addCategory')">Cancel</button>
            </div>
        </form>

        <div id="resultAdd" style="margin-top: 10px;"></div>
    </div>
    
    
</div>
