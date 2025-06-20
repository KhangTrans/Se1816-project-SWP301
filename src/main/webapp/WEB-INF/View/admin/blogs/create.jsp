<div class="modal" id="addBlogModal" style="display:none;">
    <div class="modal-content">      
        <form method="post" action="${pageContext.request.contextPath}/admin/blogs"
              enctype="multipart/form-data"
              onsubmit="return submitFormAjax(this, 'resultAddBlog')">

            <input type="hidden" name="action" value="create">
            <div class="modal__header">
                <h2>Create New Blog</h2>
            </div>
            <div class="modal__body"> 

                <div class="modal__form-group">
                    <label class="modal__label">Title</label>
                    <input type="text" name="title" class="modal__input" required>
                </div>
                <div class="modal__form-group">
                    <label class="modal__label">Content</label>
                    <textarea name="content" class="modal__textarea"></textarea>
                </div>
                <div class="modal__form-group">
                    <label class="modal__label">Images</label>
                    <input type="file" name="image" class="modal__input" multiple required>
                </div>
                <div id="resultAddBlog" style="margin-top:10px;"></div>

            </div>
            <div class="modal__footer">
                <button type="submit" class="modal__btn modal__btn--primary">Create</button>
                <button type="button" class="modal__btn modal__btn--secondary" onclick="closeModal('addBlogModal')">Cancel</button>
            </div>

        </form>
    </div>
</div>
