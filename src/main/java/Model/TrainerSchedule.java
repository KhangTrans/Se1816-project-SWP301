package Model;

import java.time.LocalTime;

public class TrainerSchedule {

    private int scheduleId;
    private Trainers trainer;     // Quan hệ với Trainer
    private String weekday;      // Monday - Sunday
    private LocalTime startTime;
    private LocalTime endTime;
    private String room;
    private boolean isAvailable;

    public TrainerSchedule() {}

    public TrainerSchedule(int scheduleId, Trainers trainer, String weekday, LocalTime startTime, LocalTime endTime, String room, boolean isAvailable) {
        this.scheduleId = scheduleId;
        this.trainer = trainer;
        this.weekday = weekday;
        this.startTime = startTime;
        this.endTime = endTime;
        this.room = room;
        this.isAvailable = isAvailable;
    }

    public int getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(int scheduleId) {
        this.scheduleId = scheduleId;
    }

    public Trainers getTrainer() {
        return trainer;
    }

    public void setTrainer(Trainers trainer) {
        this.trainer = trainer;
    }

    public String getWeekday() {
        return weekday;
    }

    public void setWeekday(String weekday) {
        this.weekday = weekday;
    }

    public LocalTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalTime startTime) {
        this.startTime = startTime;
    }

    public LocalTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalTime endTime) {
        this.endTime = endTime;
    }

    public String getRoom() {
        return room;
    }

    public void setRoom(String room) {
        this.room = room;
    }

    public boolean isAvailable() {
        return isAvailable;
    }

    public void setAvailable(boolean available) {
        isAvailable = available;
    }
}
