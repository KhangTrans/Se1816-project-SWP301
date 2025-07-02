<%@page import="Model.BlogImage"%>
<%@page import="Model.Blog"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Base64"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/head.jsp" %>
<%@include file="/WEB-INF/include/Login.jsp" %>
<%@include file="/WEB-INF/include/Register.jsp" %>
<%@include file="/WEB-INF/include/forgotPassword.jsp" %>
<%@include file="/WEB-INF/include/header.jsp" %>
<style>
    .blog-item {
        background-color: #1d1d1d;
        color: white;
        padding: 20px;
        margin-bottom: 30px;
        border-radius: 8px;
        max-width: 950px;
        margin: 5px auto;
    }

    .blog-title {
        font-size: 24px;
        color: #39b54a;
    }

    .blog-content {
        font-size: 16px;
        margin: 10px 0;
        text-align: justify;
    }

    .created-at {
        font-size: 14px;
        color: #aaa;
    }

    .image-gallery {
        grid-template-columns: repeat(2, 1fr);
        gap: 20px;
        margin: 20px 0;
        text-align: center;
    }

    .blog-image {
        width: 200px;
        height: auto;
        margin: 0 auto;
        border-radius: 8px;
    }

    .read-more-link {
        color: #39b54a;
        cursor: pointer;
        font-weight: bold;
        text-decoration: underline;
    }

    .read-more-link:hover {
        color: #2a8b2f;
    }

    .full-content {
        display: none;
        margin-top: 15px;
        font-size: 16px;
        color: #ccc;
    }

</style>
<h1 class="header-content" style="margin-top: 80px">Tất Cả Các Bài Blog</h1>

<%
    // Lấy danh sách các blog từ request
    List<Blog> blogs = (List<Blog>) request.getAttribute("blogs");

    if (blogs != null && !blogs.isEmpty()) {
        // Duyệt qua danh sách các blog để hiển thị
        for (Blog blog : blogs) {
%>

<div class="blog-item">
    <p class="created-at">Ngày tạo: <%= blog.getCreatedAt()%></p>
    <h2 class="blog-title"><%= blog.getTitle()%></h2>

    <%-- Hiển thị các hình ảnh trong blog --%>
    <div class="image-gallery">
        <%
            List<BlogImage> images = blog.getImages();
            if (images != null && !images.isEmpty()) {
                for (int i = 0; i < Math.min(images.size(), 4); i++) { // Hiển thị tối đa 4 ảnh
                    BlogImage image = images.get(i);
                    byte[] imageData = image.getImageUrl();
                    if (imageData != null) {
                        String base64Image = Base64.getEncoder().encodeToString(imageData);
        %>
        <img src="data:image/jpeg;base64,<%= base64Image%>" alt="Blog Image" class="blog-image" />
        <%
                    }
                }
            }
        %>
    </div>

    <%-- Hiển thị nội dung bị rút gọn ban đầu --%>
    <p class="blog-content" id="content-<%= blog.getBlogId()%>">
        <%
            String content = blog.getContent();
            if (content.length() > 300) {
                out.print(content.substring(0, 300) + "...");
            } else {
                out.print(content);
            }
        %>

        <%-- Liên kết "Xem Thêm" để mở rộng nội dung --%>
        <%
            if (blog.getContent().length() > 300) {
        %>
        <span class="read-more-link" onclick="toggleContent('<%= blog.getBlogId()%>')">Xem Thêm</span>
        <%
            }
        %>
    </p>

    <%-- Nội dung đầy đủ (ban đầu ẩn) --%>
    <p class="full-content" id="full-content-<%= blog.getBlogId()%>" style="display: none;">
        <%= blog.getContent()%>
        <%-- Liên kết "Ẩn bớt" khi nội dung được mở rộng --%>
        <span class="read-more-link" onclick="toggleContent('<%= blog.getBlogId()%>')">Ẩn bớt</span>
    </p>

</div>

<%
    }
} else {
%>
<p>Không có bài viết nào.</p>
<% }%>

<%@include file="/WEB-INF/include/footer.jsp" %>

<script>
    function toggleContent(blogId) {
        var fullContent = document.getElementById('full-content-' + blogId);
        var shortContent = document.getElementById('content-' + blogId);
        var readMoreLink = document.querySelectorAll('span[onclick="toggleContent(\'' + blogId + '\')"]')[0];

        // Chuyển đổi giữa việc hiển thị và ẩn nội dung đầy đủ
        if (fullContent.style.display === "none") {
            fullContent.style.display = "block";   // Hiển thị nội dung đầy đủ
            shortContent.style.display = "none";   // Ẩn nội dung rút gọn
            readMoreLink.innerText = "Ẩn bớt";     // Thay đổi văn bản thành "Ẩn bớt"
        } else {
            fullContent.style.display = "none";    // Ẩn nội dung đầy đủ
            shortContent.style.display = "block";  // Hiển thị nội dung rút gọn
            readMoreLink.innerText = "Xem Thêm";   // Thay đổi văn bản trở lại "Xem Thêm"
        }
    }
</script>
