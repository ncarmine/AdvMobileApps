package com.bozo.natec.bozosdiner;

public class Menu {
    private String name;
    private String description;

    private Menu(String newName, String newDesc) {
        this.name = newName;
        this.description = newDesc;
    }

    public static final Menu[] notfound = {
            new Menu("Not Found", "Error: Menu item not found")
    };

    public static final Menu[] breakfast = {
            new Menu("Scrambled Eggs", "Bozo's finest eggs, now scrambled on your plate. Served with hash browns and your choice of ham, bacon, or sausage."),
            new Menu("Fried Eggs", "Bozo's finest eggs, now fried on your plate however you like them. Served with hash browns and your choice of ham, bacon, or sausage."),
            new Menu("Breakfast Burrito", "Bozo's finest eggs, now scrambled and wrapped into a burrito along with cheese, potatoes, green chilies, avocado, and your choice of ham, bacon, or sausage."),
            new Menu("Ham", "Bozo's finest ham, now served on your plate WITHOUT Bozo's finest eggs."),
            new Menu("Pancakes", "Bozo's famous pancakes, served with bacon and filled with the berry of your choice."),
            new Menu("Waffles", "Bozo's waffles, served with bacon and filled with the berry of your choice.")
    };

    public static final Menu[] lunch = {
            new Menu("Club Sandwich", "Bozo's wonderful club sandwich, packed with toasted bread, thin ham, fried bacon, lettuce, tomato, and mayonnaise."),
            new Menu("Reuben", "Bozo's classic reuben, with beef, Swiss cheese, sauerkraut, and Russian dressing, grilled between slices of rye bread."),
            new Menu("BLT", "Bozo's simplest: bacon, lettuce, and tomato"),
            new Menu("Chicken wrap", "Wrap your morning up with Bozo's chicken, lettuce, tomato, and avocado wrap."),
            new Menu("Soup", "Bozo's slurpiest: a simple noodle soup anyone can enjoy on a cold day.")
    };

    public static final Menu[] dinner = {
            new Menu("Burger", "Bozo's smoked 1/4 patty on whatever bread bun of your choice. Served with fries or fruit."),
            new Menu("Biscuits and Gravy", "You thought Bozo stopped serving all breakfast at 11? You know we left the richest thing on the menu for later."),
            new Menu("Monty Cristo", "Bozo says this is only for the bravest of souls."),
            new Menu("Chicken Noodle Soup", "Bozo's thick noodle, fall-off-the-spoon chicken noodle soup."),
            new Menu("Salad", "Don't be a Bozo; be healthy and order a salad.")
    };

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    public String toString() {
        return this.name;
    }
}
