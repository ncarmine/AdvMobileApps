package com.list.natec.medialist;

import com.google.firebase.database.Exclude;

import java.util.HashMap;
import java.util.Map;

public class MediaItem {
    private String name;
    private String url;

    public MediaItem() {
        //required for DatSnapshot.getValue calls
    }

    public MediaItem(String newName, String newURL) {
        name = newName;
        url = newURL;
    }

    public String getName() {
        return name;
    }

    public String getUrl() {
        return url;
    }

    //for writing to Firebase
    @Exclude
    public Map<String, Object> toMap() {
        HashMap<String, Object> result = new HashMap<>();
        result.put(name, url);
        return result;
    }

    public String toString() {
        return this.name;
    }
}
