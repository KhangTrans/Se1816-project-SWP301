/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.time.LocalDate;

/**
 *
 * @author PC
 */
public class SlotAvailability {

    private int availabilityId;
    private int scheduleId;
    private Trainers trainer;
    private LocalDate slotDate;
    private boolean isAvailable;

    public SlotAvailability() {
    }

    
    public SlotAvailability(int availabilityId, int scheduleId, Trainers trainer, LocalDate slotDate, boolean isAvailable) {
        this.availabilityId = availabilityId;
        this.scheduleId = scheduleId;
        this.trainer = trainer;
        this.slotDate = slotDate;
        this.isAvailable = isAvailable;
    }

    public int getAvailabilityId() {
        return availabilityId;
    }

    public void setAvailabilityId(int availabilityId) {
        this.availabilityId = availabilityId;
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

    public LocalDate getSlotDate() {
        return slotDate;
    }

    public void setSlotDate(LocalDate slotDate) {
        this.slotDate = slotDate;
    }

    public boolean isIsAvailable() {
        return isAvailable;
    }

    public void setIsAvailable(boolean isAvailable) {
        this.isAvailable = isAvailable;
    }
    
    
}
