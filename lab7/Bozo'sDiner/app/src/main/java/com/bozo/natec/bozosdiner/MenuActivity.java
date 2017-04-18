package com.bozo.natec.bozosdiner;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;

public class MenuActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_menu);

        int itemnum = (Integer)getIntent().getExtras().get("itemid");
        String time = (String)getIntent().getExtras().get("itemtime");
        Menu item;
        switch (time) {
            case "Breakfast":
                item = Menu.breakfast[itemnum];
                break;
            case "Lunch":
                item = Menu.lunch[itemnum];
                break;
            case "Dinner":
                item = Menu.dinner[itemnum];
                break;
            default:
                item = Menu.notfound[0];
        }


        TextView itemName = (TextView)findViewById(R.id.item_name);
        itemName.setText(item.getName());

        TextView itemDesc = (TextView)findViewById(R.id.item_description);
        itemDesc.setText(item.getDescription());
    }
}
