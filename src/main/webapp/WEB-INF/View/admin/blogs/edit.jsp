<div class="modal" id="editBlogModal" style="display:none;">
    <div class="modal__content">      
        <form method="post" action="${pageContext.request.contextPath}/admin/blogs"
              enctype="multipart/form-data"
              onsubmit="return submitFormAjax(this, 'resultEditBlog', event)">

            <input type="hidden" name="action" value="update">
            <input type="hidden" name="blogId" id="editBlogId">

            <div class="modal__header">
                <h2>Edit Blog</h2>
            </div>
            <div class="modal__body"> 

                <div class="modal__form-group">
                    <label class="modal__label">Title</label>
                    <input type="text" name="title" id="editBlogTitle" class="modal__input" required>
                </div>
                <div class="modal__form-group">
                    <label class="modal__label">Content</label>
                    <textarea name="content" id="editBlogContent" class="modal__textarea"></textarea>
                </div>
                <div class="modal__form-group">
                    <label class="modal__label">Caption</label>
                    <input type="text" name="caption" id="editBlogCaption" class="modal__input" required>
                </div>
                <div class="modal__form-group">
                    <label class="modal__label">Change Main Images</label>
                    <input type="file" name="mainImage" class="modal__input" accept="image/*" onchange="previewEditBlogImage(this)">
                    <span id="mainImageFilename" style="font-size: 12px; color: gray;"></span>
                    <img id="editBlogImagePreview"
                         src=""
                         alt="Main Preview"
                         style="margin-top:10px; width: 80px; border-radius: 6px; display: none;"
                         onerror="this.style.display='none';">
                </div>
                <!-- Existing Images with actions -->
                <div class="modal__form-group">
                    <label class="modal__label"> Existing Images</label>
                    <div id="editBlogImageList" style="display: flex; flex-wrap: wrap; gap: 10px;"></div>
                </div>
                <!-- New Images Upload -->
                <div class="modal__form-group">
                    <label class="modal__label">New Images Upload</label>
                    <input type="file" name="images" id="editNewImages" class="modal__input" accept="image/*" multiple onchange="previewNewImages(this)">
                    <div id="editNewImagePreviewList" style="display: flex; flex-wrap: wrap; gap: 10px; margin-top: 10px;"></div>
                </div>

                <div id="resultEditBlog" style="margin-top:10px;"></div>

            </div>
            <div class="modal__footer">
                <button type="submit" class="modal__btn modal__btn--primary">Edit</button>
                <button type="button" class="modal__btn modal__btn--secondary" onclick="closeModal('editBlogModal')">Cancel</button>
            </div>

        </form>
    </div>
</div>
