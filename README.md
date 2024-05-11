# Salon Appointment Scheduler created using PostgreSQL and Bash
A PostgreSQL database containing typical Hair Salon data populated using Bash scripting. Created for FCC Relational Database Certification.

## Dependencies
- [PostgreSQL](https://www.postgresql.org/download/)
- [Bash](https://www.gnu.org/software/bash/)

## Files
- `salon.sql`: PSQL dump of queries and commands to generate the database, create the tables, and insert some dummy data.
- `salon.sh`: Small Bash script functioning as the interactive shell to insert data.
- `examples.txt`: Examples used as reference for implementation of features (guided code creation).
- `salon_predump.sql`: The SQL commands I used to create the database, tables, and dummy data.

## Installation
- Clone this repo: 
`git clone https://github.com/travboz/Salon-Appointment-Scheduler.git`.

- Navigate into your project directory: 
`cd your_project_folder/Salon-Appointment-Scheduler` (for example).

The commands used to build the database are contained in the `salon.sql` file. 

- Building the database
When in the folder containing the `salon.sql` file, run the following command to create and populate the database:
`psql -U postgres < salon.sql`

Using a program like [pgAdmin](https://www.pgadmin.org/download/) you can inspect the architecture of the database. Alternatively, you can use SQL queries to explore.


## Tables
There exist three tables with each table containing relevant information.

| Table Name    | Description                                                                                                           |
|---------------|-----------------------------------------------------------------------------------------------------------------------|
| `customers`   | Stores team_id and team name information. |
| `services`    | Contains data of services offered by the salon. |
| `appointments`| Holds the customer's id, the service requested, and the time for the appointment. |


This project was created to follow the FreeCodeCamp certification project.

Project link: [Salon Appointment Scheduler](https://www.freecodecamp.org/learn/relational-database/build-a-salon-appointment-scheduler-project/build-a-salon-appointment-scheduler)