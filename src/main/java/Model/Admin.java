package Model;

public class Admin {

    private int adminId;
    private Account account; // Tham chiếu tới bảng accounts
    private String filename;
    private String email;

    public Admin() {
    }

    public Admin(int adminId, Account account, String filename, String email) {
        this.adminId = adminId;
        this.account = account;
        this.filename = filename;
        this.email = email;
    }

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    public Account getAccount() {
        return account;
    }

    public void setAccount(Account account) {
        this.account = account;
    }

    public String getFilename() {
        return filename;
    }

    public void setFilename(String filename) {
        this.filename = filename;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    @Override
    public String toString() {
        return "Admin{"
                + "adminId=" + adminId
                + ", filename='" + filename + '\''
                + ", email='" + email + '\''
                + '}';
    }
}
