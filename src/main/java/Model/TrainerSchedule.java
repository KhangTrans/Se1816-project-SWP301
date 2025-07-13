package Model;

import java.time.LocalTime;

public class TrainerSchedule {

    private int scheduleId;
    private String weekday;      // Monday - Sunday
    private LocalTime startTime;
    private LocalTime endTime;
    private boolean isAvailable;

    public TrainerSchedule() {}

    public TrainerSchedule(int scheduleId, String weekday, LocalTime startTime, LocalTime endTime, String room, boolean isAvailable) {
        this.scheduleId = scheduleId;
        this.weekday = weekday;
        this.startTime = startTime;
        this.endTime = endTime;
        this.isAvailable = isAvailable;
    }

    public int getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(int scheduleId) {
        this.scheduleId = scheduleId;
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

    // Getter
    public boolean isAvailable() {
        return isAvailable;
    }

    // Setter
    public void setAvailable(boolean available) {
        this.isAvailable = available;
    }
}
