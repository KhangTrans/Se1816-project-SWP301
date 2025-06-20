/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author Admin
 */
public class Trainers {

    private int trainerId;
    private Account accountId;
    private String fullName;
    private String email;
    private String bio;
    private int experienceYears;  
    private float rating;
    private String trainer_code;
    private String phone;

    public Trainers() {
    }

    public Trainers(int trainerId, Account accountId, String fullName, String email, String bio, int experienceYears, float rating, String trainer_code, String phone) {
        this.trainerId = trainerId;
        this.accountId = accountId;
        this.fullName = fullName;
        this.email = email;
        this.bio = bio;
        this.experienceYears = experienceYears;
        this.rating = rating;
        this.trainer_code = trainer_code;
        this.phone = phone;
    }

    public int getTrainerId() {
        return trainerId;
    }

    public void setTrainerId(int trainerId) {
        this.trainerId = trainerId;
    }

    public Account getAccountId() {
        return accountId;
    }

    public void setAccountId(Account accountId) {
        this.accountId = accountId;
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

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }

    public int getExperienceYears() {
        return experienceYears;
    }

    public void setExperienceYears(int experienceYears) {
        this.experienceYears = experienceYears;
    }

    public float getRating() {
        return rating;
    }

    public void setRating(float rating) {
        this.rating = rating;
    }

    public String getTrainer_code() {
        return trainer_code;
    }

    public void setTrainer_code(String trainer_code) {
        this.trainer_code = trainer_code;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

}
