package Model;

import java.time.LocalDateTime;

public class BlogImage {
    private int imageId;
    private Blog blog; // Liên kết đến đối tượng Blog
    private byte[] imageUrl; // Lưu dữ liệu ảnh dạng byte[]
    private String caption;
    private LocalDateTime uploadedAt;

    public BlogImage() {}

    public BlogImage(int imageId, Blog blog, byte[] imageUrl, String caption, LocalDateTime uploadedAt) {
        this.imageId = imageId;
        this.blog = blog;
        this.imageUrl = imageUrl;
        this.caption = caption;
        this.uploadedAt = uploadedAt;
    }

    public int getImageId() {
        return imageId;
    }

    public void setImageId(int imageId) {
        this.imageId = imageId;
    }

    public Blog getBlog() {
        return blog;
    }

    public void setBlog(Blog blog) {
        this.blog = blog;
    }

    public byte[] getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(byte[] imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getCaption() {
        return caption;
    }

    public void setCaption(String caption) {
        this.caption = caption;
    }

    public LocalDateTime getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(LocalDateTime uploadedAt) {
        this.uploadedAt = uploadedAt;
    }
}
