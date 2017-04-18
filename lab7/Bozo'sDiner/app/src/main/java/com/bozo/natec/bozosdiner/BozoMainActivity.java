package com.bozo.natec.bozosdiner;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.AdapterView;
import android.widget.ListView;

public class BozoMainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_bozo_main);

        AdapterView.OnItemClickListener itemClickListener = new AdapterView.OnItemClickListener() {
            public void onItemClick(AdapterView<?>menuList, View view, int position, long id) {
                String menutime = (String) menuList.getItemAtPosition(position);
                Intent intent = new Intent(BozoMainActivity.this, MenuCategoryActivity.class);
                intent.putExtra("menutime", menutime);
                startActivity(intent);
            }
        };
        ListView menuList = (ListView) findViewById(R.id.menuList);
        menuList.setOnItemClickListener(itemClickListener);
    }


    public boolean onCreateOptionsMenu(Menu menu){
        getMenuInflater().inflate(R.menu.menu_contact, menu);
        return super.onCreateOptionsMenu(menu);
    }

    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()){
            case R.id.contact_info:
                Intent intent = new Intent(this, ContactActivity.class);
                startActivity(intent);
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

}
