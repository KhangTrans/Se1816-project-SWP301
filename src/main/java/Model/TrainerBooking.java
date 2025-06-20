package Model;

import java.time.LocalDate;

public class TrainerBooking {

    private int bookingId;
    private Customer customer;
    private Trainers trainer;
    private TrainerSchedule schedule;
    private LocalDate bookingDate;
    private String status; // "pending", "confirmed", "cancelled"

    public TrainerBooking() {}

    public TrainerBooking(int bookingId, Customer customer, Trainers trainer, TrainerSchedule schedule, LocalDate bookingDate, String status) {
        this.bookingId = bookingId;
        this.customer = customer;
        this.trainer = trainer;
        this.schedule = schedule;
        this.bookingDate = bookingDate;
        this.status = status;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public Trainers getTrainer() {
        return trainer;
    }

    public void setTrainer(Trainers trainer) {
        this.trainer = trainer;
    }

    public TrainerSchedule getSchedule() {
        return schedule;
    }

    public void setSchedule(TrainerSchedule schedule) {
        this.schedule = schedule;
    }

    public LocalDate getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(LocalDate bookingDate) {
        this.bookingDate = bookingDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
