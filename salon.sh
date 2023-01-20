#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n======| The Hipsters' Barbershop |======\n"

MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "\nWelcome to my humble Salon. How can I help you?" 
  echo -e "\n1) cut\n2) shave\n3) both"
  read SERVICE_ID_SELECTED
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  if [[ ! $SERVICE_ID_SELECTED =~ ^[1-3]$ ]]
  then
    MENU "Well, that's not something we do...\nPlease try again with numbers 1-3."
  else
    echo -e "\nCool! Let me check your phone number, please?"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nIt seems you're new here. What's your name?"
      read CUSTOMER_NAME
      INSERT_NAME=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
      echo -e "\nAll right, $CUSTOMER_NAME, nice to meet you!\nWhat time would you like your $SERVICE_NAME?"
      read SERVICE_TIME      
      GET_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
      INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES('$SERVICE_TIME', $GET_CUSTOMER_ID, $SERVICE_ID_SELECTED)")
      echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."    
    else
      echo -e "\nHey, $CUSTOMER_NAME, welcome back!\nWhat time would you like your$SERVICE_NAME?"
      read SERVICE_TIME
      GET_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
      INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES('$SERVICE_TIME', $GET_CUSTOMER_ID, $SERVICE_ID_SELECTED)")
      echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."      
    fi
  fi
}

MENU

