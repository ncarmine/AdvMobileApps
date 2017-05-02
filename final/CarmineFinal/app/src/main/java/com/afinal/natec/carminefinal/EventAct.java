package com.afinal.natec.carminefinal;

import java.util.ArrayList;

/**
 * Created by natec on 2/5/17.
 */

public class EventAct {
    private String name;

    private EventAct(String newName) {
        this.name = newName;
    }


    //credit to http://stackoverflow.com/a/1005083/2490299 for this abomination
    public static ArrayList<EventAct> indoors = new ArrayList<EventAct>() {{
            add(new EventAct("Swimming"));
            add(new EventAct("Climbing"));
            add(new EventAct("Basketball"));
    }};

    public static ArrayList<EventAct> outdoors = new ArrayList<EventAct>() {{
            add(new EventAct("Hiking"));
            add(new EventAct("Cycling"));
            add(new EventAct("Running"));
    }};

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
