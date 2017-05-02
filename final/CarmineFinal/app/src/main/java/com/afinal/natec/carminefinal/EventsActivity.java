package com.afinal.natec.carminefinal;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.ListActivity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;

public class EventsActivity extends Activity {

    private String activityType;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_events);

        Intent i = getIntent();
        activityType = i.getStringExtra("activityType");

        ListView listEvents = (ListView) findViewById(R.id.eventListView);

        ArrayAdapter<EventAct> listAdapter;

        Log.i("actType", String.valueOf(activityType));

        switch (activityType) {
            case "Indoors":
                listAdapter = new ArrayAdapter<>(this, android.R.layout.simple_list_item_1, EventAct.indoors);
                break;
            case "Outdoors":
                listAdapter = new ArrayAdapter<>(this, android.R.layout.simple_list_item_1, EventAct.outdoors);
                break;
            default:
                listAdapter = new ArrayAdapter<>(this, android.R.layout.simple_list_item_1, EventAct.notfound);
        }
        listEvents.setAdapter(listAdapter);

        final Button addButton = (Button) findViewById(R.id.addButton);
//        addButton.setOnClickListener(new View.OnClickListener() {
//            AlertDialog builder = new AlertDialog().Builder(getAct)
//        });

        listAdapter.notifyDataSetChanged();
    }
}
