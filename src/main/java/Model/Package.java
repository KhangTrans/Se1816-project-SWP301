package Model;

public class Package {

    private int id;
    private String name;
    private String description;
    private int durationDays;
    private double price;
    private boolean isActive;

    // Constructor đầy đủ
    public Package(int id, String name, String description, int durationDays, double price, boolean isActive) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.durationDays = durationDays;
        this.price = price;
        this.isActive = isActive;
    }

    // Getter & Setter
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
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
    public boolean isIsActive() {
        return isActive;
    }
    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }
}
