# Zoo Management Database

## Overview
This project is a **relational database system** designed as a term project to manage zoo operations.  
It covers animals, exhibits, staff, visitors, feeding schedules, and medical records.  
The schema is normalized to **Boyce-Codd Normal Form (BCNF)** to ensure consistency and data integrity.

## Features
- **Schema setup** (`aar_zoo_database_setup.sql`):  
  - Tables for animals, employees, exhibits, tickets, visitors, caretakers, veterinarians, and feedings.  
  - Constraints, foreign keys, and triggers for integrity (feeding updates, health records, employee transitions).  
  - Sample dataset with animals, staff, exhibits, and tickets.  

- **Complex queries** (`aar_zoo_complex_queries.sql`):  
  - JOIN queries (caretakers → animals).  
  - GROUP BY queries (feeding schedules by exhibit).  
  - SUBQUERIES (ticket sales & revenue by date).  
  - WINDOW FUNCTIONS (health status statistics by species).  
  - HAVING clause queries (exhibits nearing capacity).  
  - TRANSACTIONS (updating animal health status + logging veterinary check).  

## Tech Stack
- **Database**: MySQL
- **Tools**: MySQL Workbench  

## My Contribution
This repository contains **my implementation** of the Zoo Management Database.  
It demonstrates my skills in **database design, normalization, advanced SQL queries, and transaction management**.

## How to Run
1. Clone the repo:  
   ```bash
   git clone https://github.com/your-username/zoo-database.git
