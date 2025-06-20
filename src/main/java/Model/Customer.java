package Model;

public class Customer {

    private int customerId;
    private Account account; // Liên kết 1-1 với bảng accounts
    private String fullName;
    private String email;
    private String phone;
    private String customerCode;
    private String address;

    public Customer() {
    }

    public Customer(int customerId, Account account, String fullName, String email, String phone, String customerCode, String address) {
        this.customerId = customerId;
        this.account = account;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.customerCode = customerCode;
        this.address = address;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
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

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getCustomerCode() {
        return customerCode;
    }

    public void setCustomerCode(String customerCode) {
        this.customerCode = customerCode;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    @Override
    public String toString() {
        return "Customer{"
                + "customerId=" + customerId
                + ", fullName='" + fullName + '\''
                + ", email='" + email + '\''
                + ", phone='" + phone + '\''
                + ", customerCode='" + customerCode + '\''
                + ", address='" + address + '\''
                + '}';
    }
}
