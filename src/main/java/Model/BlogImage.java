package Model;

import java.time.LocalDateTime;

public class BlogImage {

    private int imageId;
    private Blog blog; // Liên kết đến đối tượng Blog
    private byte[] imageUrl; // Lưu dữ liệu ảnh dạng byte[]
    private LocalDateTime uploadedAt;
    private boolean is_primary;

    public BlogImage() {
    }

    public BlogImage(int imageId, Blog blog, byte[] imageUrl, LocalDateTime uploadedAt, boolean is_primary) {
        this.imageId = imageId;
        this.blog = blog;
        this.imageUrl = imageUrl;
        this.uploadedAt = uploadedAt;
        this.is_primary = is_primary;
    }

    public boolean isIs_primary() {
        return is_primary;
    }

    public void setIs_primary(boolean is_primary) {
        this.is_primary = is_primary;
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

    public LocalDateTime getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(LocalDateTime uploadedAt) {
        this.uploadedAt = uploadedAt;
    }
}
