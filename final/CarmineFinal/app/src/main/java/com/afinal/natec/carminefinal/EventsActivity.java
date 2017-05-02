package com.afinal.natec.carminefinal;

import android.app.ListActivity;
import android.content.Intent;
import android.os.Bundle;
import android.widget.ArrayAdapter;
import android.widget.ListView;

public class EventsActivity extends ListActivity {
    private String activityType;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Intent i = getIntent();
        activityType = i.getStringExtra("activityType");

        ListView listEvents = getListView();

        ArrayAdapter<EventAct> listAdapter;

        switch (activityType) {
            case "Indoors":
                listAdapter = new ArrayAdapter<EventAct>(this, android.R.layout.simple_list_item_1, EventAct.indoors);
                break;
            case "Outdoors":
                listAdapter = new ArrayAdapter<EventAct>(this, android.R.layout.simple_list_item_1, EventAct.outdoors);
                break;
            default:
                listAdapter = new ArrayAdapter<EventAct>(this, android.R.layout.simple_list_item_1, EventAct.notfound);
        }
        listEvents.setAdapter(listAdapter);
    }
}
