<div class="modal" id="deleteBlogModal">
    <div class="modal__content">
        <form method="post" action="${pageContext.request.contextPath}/admin/blogs" 
              onsubmit="return submitFormAjax(this, 'resultDeleteBlog')">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="blogId" id="deleteBlogId">
            <div class="modal__header">
                <h2 class="modal__title">Delete Blog</h2>
                <button type="button" class="modal__close" onclick="closeModal('deleteBlogModal')">&times;</button>
            </div>
            <div class="modal__body">
                <p>Are you sure you want to delete this blog?</p>
                <div id="resultDeleteBlog"></div>
            </div>
            <div class="modal__footer">
                <button type="submit" class="modal__btn modal__btn--primary">Delete</button>
                <button type="button" class="modal__btn modal__btn--secondary" onclick="closeModal('deleteBlogModal')">Cancel</button>
            </div>
        </form>
    </div>
</div>