package Model;

import java.time.LocalDateTime;

public class LoginLog {
    private int logId;
    private Account account; // Quan hệ với bảng accounts
    private LocalDateTime loginTime;
    private String ipAddress;
    private String userAgent;

    public LoginLog() {}

    public LoginLog(int logId, Account account, LocalDateTime loginTime, String ipAddress, String userAgent) {
        this.logId = logId;
        this.account = account;
        this.loginTime = loginTime;
        this.ipAddress = ipAddress;
        this.userAgent = userAgent;
    }

    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public Account getAccount() {
        return account;
    }

    public void setAccount(Account account) {
        this.account = account;
    }

    public LocalDateTime getLoginTime() {
        return loginTime;
    }

    public void setLoginTime(LocalDateTime loginTime) {
        this.loginTime = loginTime;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public String getUserAgent() {
        return userAgent;
    }

    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }
}
