#!/bin/bash
# Script that produces a salon interface for scheduling
# an appointmnet with a specific service provided. 

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

echo -e "Welcome to My Salon, how can I help you?\n"

SCHEDULE_TIME() {
    GET_CUSTOMER_ID_QUERY="SELECT customer_id FROM customers WHERE name = '$1'"
    CUSTOMER_ID=$($PSQL "$GET_CUSTOMER_ID_QUERY")

    # INSERT 

    echo -e "What time would you like your appointment?"
    read SERVICE_TIME

    INSERT_APPOINTMENT_QUERY="INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $2, '$SERVICE_TIME')"
    INSERT_APPOINTMENT=$($PSQL "$INSERT_APPOINTMENT_QUERY")

    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = '$2'")

    if [[ $INSERT_APPOINTMENT == "INSERT 0 1" ]]
    then 
        echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $1."
    fi
}

GET_DETAILS() {
    SERVICE_ID=$1
    echo "What's your phone number?"
    read CUSTOMER_PHONE

    PHONE_NUMBER_QUERY="SELECT phone FROM customers WHERE phone = '$CUSTOMER_PHONE'"
    SEARCH_PHONE_NUMBER=$($PSQL "$PHONE_NUMBER_QUERY")

    if [[ -z $SEARCH_PHONE_NUMBER ]]
    then 
        echo -e "I don't have a record for that phone number, what's your name?"
        read CUSTOMER_NAME

        # Insert new customer
        INSERT_CUSTOMER_QUERY="INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')"
        INSERT_CUSTOMER=$($PSQL "$INSERT_CUSTOMER_QUERY")
        if [[ $INSERT_CUSTOMER == "INSERT 0 1" ]] 
        then 
          SCHEDULE_TIME $CUSTOMER_NAME $SERVICE_ID
        else
          echo "Customer insert failed."
          exit
        fi
    else
        CUSTOMER_NAME_QUERY="SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'"
        CUSTOMER_NAME=$($PSQL "$CUSTOMER_NAME_QUERY")
        SCHEDULE_TIME $CUSTOMER_NAME $SERVICE_ID
    fi
}

SERVICE_MENU() {
    # get available services
    AVAILABLE_SERVICES_QUERY="SELECT service_id, name FROM services ORDER BY service_id"
    AVAILABLE_SERVICES=$($PSQL "$AVAILABLE_SERVICES_QUERY")
    # there will be at least three services
    # but if no services available
    if [[ -z $AVAILABLE_SERVICES ]]
    then
        # exit because no services available
        echo -e "There are no available services"
        # EXIT
        echo -e "I could not find that service. What would you like today?"
        SERVICE_MENU
    else
        # display available services
        echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME
        do
            echo "$SERVICE_ID) $NAME"
        done

        read SERVICE_ID_SELECTED

        # if input is not a number
        if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
        then
            # send to main menu
            echo -e "I could not find that service. What would you like today?"
            SERVICE_MENU
        else
            # find service
            SERVICE_AVAILABLE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
            if [[ $SERVICE_AVAILABLE != '' ]]
            then
              GET_DETAILS $SERVICE_ID_SELECTED

            else
              echo "Service is not available."
              SERVICE_MENU
            fi
        fi
    fi
}

SERVICE_MENU