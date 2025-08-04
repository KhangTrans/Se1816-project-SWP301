package Model;

public class MembershipPackage {

    private int packageId;
    private String name;
    private String description;
    private int durationDays;
    private double price;
    private boolean isActive;

    public MembershipPackage() {
    }

    public MembershipPackage(int packageId, String name, String description, int durationDays, double price, boolean isActive) {
        this.packageId = packageId;
        this.name = name;
        this.description = description;
        this.durationDays = durationDays;
        this.price = price;
        this.isActive = isActive;
    }

    public int getPackageId() {
        return packageId;
    }

    public void setPackageId(int packageId) {
        this.packageId = packageId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getDurationDays() {
        return durationDays;
    }

    public void setDurationDays(int durationDays) {
        this.durationDays = durationDays;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    @Override
    public String toString() {
        return "MembershipPackage{"
                + "packageId=" + packageId
                + ", name='" + name + '\''
                + ", durationDays=" + durationDays
                + ", price=" + price
                + ", isActive=" + isActive
                + '}';
    }
}
