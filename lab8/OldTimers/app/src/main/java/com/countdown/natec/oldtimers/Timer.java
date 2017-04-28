package com.countdown.natec.oldtimers;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;

import static android.content.Context.MODE_PRIVATE;

public class Timer {
    private String name;
    private long time;

    public Timer(String newName, long newTime) {
        this.name = newName;
        this.time = newTime;
    }

    public static ArrayList<Timer> timers = new ArrayList<>();

    public String getName() {
        return name;
    }

    public long getTime() {
        return time;
    }

    public String toString() {
        return this.name;
    }
}
