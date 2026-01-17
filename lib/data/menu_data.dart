import '../models/menu_item.dart';

class MenuData {
  static List<MenuItem> items = [
    // Non Veg Snacks
    MenuItem(id: 'nv1', category: 'Non Veg Snacks', name: 'Chicken Sausage', price: 50),
    MenuItem(id: 'nv2', category: 'Non Veg Snacks', name: 'Sausage Sadheko Chicken', price: 160),
    MenuItem(id: 'nv3', category: 'Non Veg Snacks', name: 'Egg Roll', price: 120),
    MenuItem(id: 'nv4', category: 'Non Veg Snacks', name: 'Double Egg Roll', price: 150),
    MenuItem(id: 'nv5', category: 'Non Veg Snacks', name: 'Chicken Egg Roll', price: 200),
    MenuItem(id: 'nv6', category: 'Non Veg Snacks', name: 'Chicken Lollypop', price: 260),
    MenuItem(id: 'nv7', category: 'Non Veg Snacks', name: 'Chicken Chilly', price: 350),
    MenuItem(id: 'nv8', category: 'Non Veg Snacks', name: 'Chicken Sadheko', price: 290),
    MenuItem(id: 'nv9', category: 'Non Veg Snacks', name: 'Chicken Choila', price: 290),
    MenuItem(id: 'nv10', category: 'Non Veg Snacks', name: 'Spicy Chicken', price: 350),
    MenuItem(id: 'nv11', category: 'Non Veg Snacks', name: 'Chicken Wings (Spicy)', price: 380),
    MenuItem(id: 'nv12', category: 'Non Veg Snacks', name: 'Chicken Leg Piece', price: 220),
    MenuItem(id: 'nv13', category: 'Non Veg Snacks', name: 'Chicken Roast', price: 350),
    MenuItem(id: 'nv14', category: 'Non Veg Snacks', name: 'Crispy Chicken', price: 330),
    MenuItem(id: 'nv15', category: 'Non Veg Snacks', name: 'Paneer Chilly', price: 270),
    MenuItem(id: 'nv16', category: 'Non Veg Snacks', name: 'Keema Noodles', price: 200),
    MenuItem(id: 'nv17', category: 'Non Veg Snacks', name: 'Chicken Corn Dog', price: 160),
    MenuItem(id: 'nv18', category: 'Non Veg Snacks', name: 'Cheese Corn Dog', price: 180),

    // Veg Snacks
    MenuItem(id: 'v1', category: 'Veg Snacks', name: 'Aloo Stick', price: 60),
    MenuItem(id: 'v2', category: 'Veg Snacks', name: 'Aloo Chop', price: 120),
    MenuItem(id: 'v3', category: 'Veg Snacks', name: 'Chau Chau Sadheko', price: 85),
    MenuItem(id: 'v4', category: 'Veg Snacks', name: 'Bhatmas Sadheko', price: 120),
    MenuItem(id: 'v5', category: 'Veg Snacks', name: 'Peanut Sadheko', price: 130),
    MenuItem(id: 'v6', category: 'Veg Snacks', name: 'Onion Pakoda', price: 190),
    MenuItem(id: 'v7', category: 'Veg Snacks', name: 'Mixed Veg Pakoda', price: 190),
    MenuItem(id: 'v8', category: 'Veg Snacks', name: 'French Fries', price: 170),
    MenuItem(id: 'v9', category: 'Veg Snacks', name: 'Masala French Fries', price: 220),
    MenuItem(id: 'v10', category: 'Veg Snacks', name: 'Cheese Ball', price: 230),
    MenuItem(id: 'v11', category: 'Veg Snacks', name: 'Cheese Potato', price: 240),
    MenuItem(id: 'v12', category: 'Veg Snacks', name: 'Veg Roll', price: 110),
    MenuItem(id: 'v13', category: 'Veg Snacks', name: 'Samosa', price: 30),
    MenuItem(id: 'v14', category: 'Veg Snacks', name: 'Chana Egg', price: 100),

    // Shake & Lassi
    MenuItem(id: 'sl1', category: 'Shake & Lassi', name: 'Plain Lassi', price: 130),
    MenuItem(id: 'sl2', category: 'Shake & Lassi', name: 'Sweet Lassi', price: 140),
    MenuItem(id: 'sl3', category: 'Shake & Lassi', name: 'Banana Lassi', price: 170),
    MenuItem(id: 'sl4', category: 'Shake & Lassi', name: 'Salted Lassi', price: 170),
    MenuItem(id: 'sl5', category: 'Shake & Lassi', name: 'Banana Smoothie', price: 190),
    MenuItem(id: 'sl6', category: 'Shake & Lassi', name: 'Smoothie (Mixed/Apple)', price: 220),

    // Aloo Paratha
    MenuItem(id: 'ap1', category: 'Aloo Paratha', name: 'Aloo Paratha Set', price: 200),

    // Breakfast
    MenuItem(id: 'bf1', category: 'Breakfast', name: 'Jam Sandwich', price: 75),
    MenuItem(id: 'bf2', category: 'Breakfast', name: 'Butter Sandwich', price: 115),
    MenuItem(id: 'bf3', category: 'Breakfast', name: 'Veg Sandwich', price: 120),
    MenuItem(id: 'bf4', category: 'Breakfast', name: 'Omlet Sandwich', price: 165),
    MenuItem(id: 'bf5', category: 'Breakfast', name: 'Chicken Sandwich', price: 190),
    MenuItem(id: 'bf6', category: 'Breakfast', name: 'Chicken Omlet', price: 130),
    MenuItem(id: 'bf7', category: 'Breakfast', name: 'Plain Omlet', price: 100),
    MenuItem(id: 'bf8', category: 'Breakfast', name: 'Masala Omlet', price: 110),
    MenuItem(id: 'bf9', category: 'Breakfast', name: 'Veg Soup', price: 150),
    MenuItem(id: 'bf10', category: 'Breakfast', name: 'Chicken Soup', price: 190),
    MenuItem(id: 'bf11', category: 'Breakfast', name: 'Veg Fry Rice', price: 150),
    MenuItem(id: 'bf12', category: 'Breakfast', name: 'Chicken Fry Rice', price: 200),
    MenuItem(id: 'bf13', category: 'Breakfast', name: 'Panny Fried Rice', price: 200),

    // Refreshing
    MenuItem(id: 'r1', category: 'Refreshing', name: 'Lemon Water', price: 50),
    MenuItem(id: 'r2', category: 'Refreshing', name: 'Cold Drinks', price: 80),
    MenuItem(id: 'r3', category: 'Refreshing', name: 'Masala Coke', price: 110),
    MenuItem(id: 'r4', category: 'Refreshing', name: 'Fresh Lemon Soda', price: 130),
    MenuItem(id: 'r5', category: 'Refreshing', name: 'Mint Lemonade', price: 180),
    MenuItem(id: 'r6', category: 'Refreshing', name: 'Peach Ice Tea', price: 190),
    MenuItem(id: 'r7', category: 'Refreshing', name: 'Apple Ice Tea', price: 170),
    MenuItem(id: 'r8', category: 'Refreshing', name: 'Cold Coffee', price: 150),
    MenuItem(id: 'r9', category: 'Refreshing', name: 'Virgin Mojito', price: 200),
    MenuItem(id: 'r10', category: 'Refreshing', name: 'Water Melon Mojito', price: 200),

    // Chiya and Coffee
    MenuItem(id: 'cc1', category: 'Chiya and Coffee', name: 'Chocolate Chiya', price: 70),
    MenuItem(id: 'cc2', category: 'Chiya and Coffee', name: 'Normal Chiya', price: 40),
    MenuItem(id: 'cc3', category: 'Chiya and Coffee', name: 'Masala Chiya', price: 50),
    MenuItem(id: 'cc4', category: 'Chiya and Coffee', name: 'Cutting Chiya', price: 35),
    MenuItem(id: 'cc5', category: 'Chiya and Coffee', name: 'Black Chiya', price: 35),
    MenuItem(id: 'cc6', category: 'Chiya and Coffee', name: 'Masala Black Chiya', price: 45),
    MenuItem(id: 'cc7', category: 'Chiya and Coffee', name: 'Masala B. (Lemon Chiya)', price: 55),
    MenuItem(id: 'cc8', category: 'Chiya and Coffee', name: 'Lemon Chiya', price: 40),
    MenuItem(id: 'cc9', category: 'Chiya and Coffee', name: 'Green Chiya', price: 55),
    MenuItem(id: 'cc10', category: 'Chiya and Coffee', name: 'Mint Chiya', price: 45),
    MenuItem(id: 'cc11', category: 'Chiya and Coffee', name: 'Mint Lemon Chiya', price: 55),
    MenuItem(id: 'cc12', category: 'Chiya and Coffee', name: 'Matka Chiya', price: 70),
    MenuItem(id: 'cc13', category: 'Chiya and Coffee', name: 'Peach Chiya', price: 90),
    MenuItem(id: 'cc14', category: 'Chiya and Coffee', name: 'Honey Ginger Chiya', price: 70),
    MenuItem(id: 'cc15', category: 'Chiya and Coffee', name: 'Hot Lemon', price: 50),
    MenuItem(id: 'cc16', category: 'Chiya and Coffee', name: 'Hot Lemon With Honey', price: 100),
    MenuItem(id: 'cc17', category: 'Chiya and Coffee', name: 'Hot Lemon (Honey & Ginger)', price: 120),
    MenuItem(id: 'cc18', category: 'Chiya and Coffee', name: 'Black Coffee', price: 80),
    MenuItem(id: 'cc19', category: 'Chiya and Coffee', name: 'Milk Coffee', price: 100),

    // Mo: Mo:
    MenuItem(id: 'mm1', category: 'Mo: Mo:', name: 'Veg Mo: Mo:', price: 110),
    MenuItem(id: 'mm2', category: 'Mo: Mo:', name: 'Chicken Mo: Mo:', price: 150),
    MenuItem(id: 'mm3', category: 'Mo: Mo:', name: 'Jhol Mo: Mo: (Veg)', price: 150),
    MenuItem(id: 'mm4', category: 'Mo: Mo:', name: 'Jhol Mo: Mo: (Chicken)', price: 180),
    MenuItem(id: 'mm5', category: 'Mo: Mo:', name: 'Fried Mo: Mo: (Veg)', price: 140),
    MenuItem(id: 'mm6', category: 'Mo: Mo:', name: 'Fried Mo: Mo: (Chicken)', price: 200),
    MenuItem(id: 'mm7', category: 'Mo: Mo:', name: 'Sadheko Mo: Mo: (Veg)', price: 200),
    MenuItem(id: 'mm8', category: 'Mo: Mo:', name: 'Sadheko Mo: Mo: (Chicken)', price: 225),

    // Chowmein
    MenuItem(id: 'ch1', category: 'Chowmein', name: 'Veg Chowmein', price: 125),
    MenuItem(id: 'ch2', category: 'Chowmein', name: 'Egg Chowmein', price: 140),
    MenuItem(id: 'ch3', category: 'Chowmein', name: 'Chicken Chowmein', price: 150),
    MenuItem(id: 'ch4', category: 'Chowmein', name: 'Mixed Non Veg Chowmein', price: 190),
    MenuItem(id: 'ch5', category: 'Chowmein', name: 'Noodles', price: 110),
    MenuItem(id: 'ch6', category: 'Chowmein', name: 'Veg Thukpa', price: 135),
    MenuItem(id: 'ch7', category: 'Chowmein', name: 'Chicken Thukpa', price: 170),
    MenuItem(id: 'ch8', category: 'Chowmein', name: 'Current Noodle with Egg', price: 160),
    MenuItem(id: 'ch9', category: 'Chowmein', name: 'Current Noodle Plain', price: 130),

    // Burger
    MenuItem(id: 'bg1', category: 'Burger', name: 'Veg Burger', price: 150),
    MenuItem(id: 'bg2', category: 'Burger', name: 'Chicken Cheese Burger', price: 220),
    MenuItem(id: 'bg3', category: 'Burger', name: 'Crispy Chicken Burger', price: 230),
    MenuItem(id: 'bg4', category: 'Burger', name: 'Grilled Chicken Burger', price: 260),

    // Pizza
    MenuItem(id: 'pz1', category: 'Pizza', name: 'Veg Pizza', price: 300),
    MenuItem(id: 'pz2', category: 'Pizza', name: 'Cheeze Pizza', price: 420),
    MenuItem(id: 'pz3', category: 'Pizza', name: 'Chicken Pizza', price: 380),
    MenuItem(id: 'pz4', category: 'Pizza', name: 'Chicken Cheeze Pizza', price: 460),
    MenuItem(id: 'pz5', category: 'Pizza', name: 'Veg Mixed Pizza', price: 360),
    MenuItem(id: 'pz6', category: 'Pizza', name: 'Mushroom Pizza', price: 400),
    MenuItem(id: 'pz7', category: 'Pizza', name: 'Chizza', price: 450),

    // Hookah
    MenuItem(id: 'hk1', category: 'Hookah', name: 'Hookah', price: 350),
    MenuItem(id: 'hk2', category: 'Hookah', name: 'Flavour Change', price: 200),
    MenuItem(id: 'hk3', category: 'Hookah', name: 'Mix Hookah Flavour', price: 400),
    MenuItem(id: 'hk4', category: 'Hookah', name: 'Coil Change', price: 50),
    MenuItem(id: 'hk5', category: 'Hookah', name: 'Cloud Hookah', price: 700),
  ];
}
