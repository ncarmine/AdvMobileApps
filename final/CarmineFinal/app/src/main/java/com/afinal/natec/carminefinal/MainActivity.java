package com.afinal.natec.carminefinal;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        AdapterView.OnItemClickListener itemClickListener = new AdapterView.OnItemClickListener() {
            public void onItemClick(AdapterView<?> listView, View view, int position, long id) {
                String activityType = (String) listView.getItemAtPosition(position);
                Intent intent = new Intent(MainActivity.this, EventsActivity.class);
                intent.putExtra("activityType", activityType);
                startActivity(intent);
            }

        };
        ListView listView = (ListView) findViewById(R.id.mainListView);
        listView.setOnItemClickListener(itemClickListener);
    }
}
