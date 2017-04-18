package com.bozo.natec.bozosdiner;

import android.app.ListActivity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.ListView;

public class MenuCategoryActivity extends ListActivity {
    private String menutime;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Intent in = getIntent();
        menutime = in.getStringExtra("menutime");
        ListView itemList = getListView();
        ArrayAdapter<Menu> listAdapter;
        switch (menutime) {
            case "Breakfast":
                listAdapter = new ArrayAdapter<Menu>(this, android.R.layout.simple_list_item_1, Menu.breakfast);
                break;
            case "Lunch":
                listAdapter = new ArrayAdapter<Menu>(this, android.R.layout.simple_list_item_1, Menu.lunch);
                break;
            case "Dinner":
                listAdapter = new ArrayAdapter<Menu>(this, android.R.layout.simple_list_item_1, Menu.dinner);
                break;
            default:
                listAdapter = new ArrayAdapter<Menu>(this, android.R.layout.simple_list_item_1, Menu.notfound);
        }
        itemList.setAdapter(listAdapter);
    }

    @Override
    public void onListItemClick(ListView listView, View view, int position, long id){
        Intent intent = new Intent(MenuCategoryActivity.this, MenuActivity.class);
        intent.putExtra("itemid", (int) id);
        intent.putExtra("itemtime", menutime);
        startActivity(intent);
    }
}
