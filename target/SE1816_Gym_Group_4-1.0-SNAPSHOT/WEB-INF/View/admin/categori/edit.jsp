<div class="modal" id="editCategoryModal">
    <div class="modal-content">
        <h2>Edit Category</h2>
        <form method="post" action="/SE1816_Gym_Group_4/Categori"
              onsubmit="return submitEditCategoryForm(this, 'editCategoryResult');">
            <input type="hidden" name="formAction" value="edit">
            <input type="hidden" name="categoryId" id="editCategoryId">
            <label for="editCategoryName">Category Name:</label>
            <input type="text" name="name" id="editCategoryName" required>
            <label for="editCategoryDescription">Description:</label>
            <input type="text" name="description" id="editCategoryDescription">
            <button type="submit">Save</button>
            <button type="button" onclick="closeModal('editCategoryModal')">Cancel</button>
        </form>
        <div id="editCategoryResult" style="margin-top: 10px;"></div>
    </div>
</div>
