package Model;

public class Staff {

    private int staffId;
    private String status;
    private Account account; // Liên kết 1-1 với bảng accounts
    private String fullName;
    private String email;
    private String staffCode;
    private String phone;
    private String position;

    public Staff() {
    }

    public Staff(int staffId, String status, Account account, String fullName, String email, String staffCode, String phone, String position) {
        this.staffId = staffId;
        this.status = status;
        this.account = account;
        this.fullName = fullName;
        this.email = email;
        this.staffCode = staffCode;
        this.phone = phone;
        this.position = position;
    }

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Account getAccount() {
        return account;
    }

    public void setAccount(Account account) {
        this.account = account;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getStaffCode() {
        return staffCode;
    }

    public void setStaffCode(String staffCode) {
        this.staffCode = staffCode;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    @Override
    public String toString() {
        return "Staff{"
                + "staffId=" + staffId
                + ", status='" + status + '\''
                + ", fullName='" + fullName + '\''
                + ", email='" + email + '\''
                + ", staffCode='" + staffCode + '\''
                + ", phone='" + phone + '\''
                + ", position='" + position + '\''
                + '}';
    }
}
