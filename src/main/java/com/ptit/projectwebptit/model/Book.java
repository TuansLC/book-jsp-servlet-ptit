package com.ptit.projectwebptit.model;

public class Book {
    private int id;
    private String title;
    private String author;
    private int quantity;
    private String category;
    private String description;
    
    // Constructor
    public Book(int id, String title, String author, int quantity, String category, String description) {
        this.id = id;
        this.title = title;
        this.author = author;
        this.quantity = quantity;
        this.category = category;
        this.description = description;
    }

    public Book() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}