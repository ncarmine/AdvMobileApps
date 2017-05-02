package com.afinal.natec.carminefinal;

/**
 * Created by natec on 2/5/17.
 */

public class EventAct {
    private String name;

    private EventAct(String newName) {
        this.name = newName;
    }

    public static final EventAct[] indoors = {
            new EventAct("Swimming"),
            new EventAct("Climbing"),
            new EventAct("Sportsketball")
    };

    public static final EventAct[] outdoors = {
            new EventAct("Hiking"),
            new EventAct("Cycling"),
            new EventAct("Running")
    };

    public static final EventAct[] notfound = {
            new EventAct("ERROR")
    };

    public String getName(){
        return name;
    }

    public String toString(){
        return this.name;
    }
}
