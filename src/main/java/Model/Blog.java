package Model;

import java.time.LocalDateTime;

public class Blog {

    private int blogId;
    private String title;
    private String content;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private Staff author; // Nếu bạn dùng Admin thay vì Staff, đổi sang Admin
    private boolean isPublished;
    private int primaryImageId; // thêm dòng này

    public Blog() {
    }

    public Blog(int blogId, String title, String content, LocalDateTime createdAt,
            LocalDateTime updatedAt, Staff author, boolean isPublished) {
        this.blogId = blogId;
        this.title = title;
        this.content = content;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.author = author;
        this.isPublished = isPublished;
    }

    public Blog(int blogId, String title, String content, LocalDateTime createdAt, LocalDateTime updatedAt, Staff author) {
        this.blogId = blogId;
        this.title = title;
        this.content = content;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.author = author;
    }

    public int getPrimaryImageId() {
        return primaryImageId;
    }

    public void setPrimaryImageId(int primaryImageId) {
        this.primaryImageId = primaryImageId;
    }

    public int getBlogId() {
        return blogId;
    }

    public void setBlogId(int blogId) {
        this.blogId = blogId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Staff getAuthor() {
        return author;
    }

    public void setAuthor(Staff author) {
        this.author = author;
    }

    public boolean isPublished() {
        return isPublished;
    }

    public void setPublished(boolean isPublished) {
        this.isPublished = isPublished;
    }
}
