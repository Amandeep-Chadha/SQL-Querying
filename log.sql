-- Keep a log of any SQL queries you execute as you solve the mystery.
-- Getting the crime scene report which mentions baker/bakery
SELECT * FROM crime_scene_reports WHERE description LIKE "%baker%";
-- Going throuhg interviews for retrieving transcripts
SELECT * FROM interviews WHERE transcript LIKE "%bakery%";
--Withdrawal transaction from the date and location of the crime
SELECT * FROM atm_transactions WHERE year = 2021
AND month = 7
AND day = 28
AND atm_location = "Leggett Street"
AND transaction_type = "withdraw";
-- Finding people's names who withdrew money in the same scenario
SELECT * FROM people
WHERE id IN (SELECT person_id FROM bank_accounts
JOIN atm_transactions ON atm_transactions.account_number = bank_accounts.account_number
WHERE year = 2021
AND month = 7
AND day = 28
AND atm_location = "Leggett Street"
AND transaction_type = "withdraw");

--Matching security plates from atm to bakery's security tapes
SELECT * FROM people
WHERE id IN (SELECT person_id FROM bank_accounts
JOIN atm_transactions ON atm_transactions.account_number = bank_accounts.account_number
WHERE year = 2021
AND month = 7
AND day = 28
AND atm_location = "Leggett Street"
AND transaction_type = "withdraw");

--Matching license plates from leggett street atm and bakery and exited in the given time frame
SELECT * FROM bakery_security_logs
WHERE license_plate IN (SELECT license_plate FROM people
WHERE id IN (SELECT person_id FROM bank_accounts
JOIN atm_transactions ON atm_transactions.account_number = bank_accounts.account_number
WHERE year = 2021
AND month = 7
AND day = 28
AND atm_location = "Leggett Street"
AND transaction_type = "withdraw"))
AND year = 2021
AND month = 7
AND day = 28
AND activity = "exit"
AND hour = 10
AND minute <= 25;

-- Checking which of the cars went to the airport
SELECT license_plate FROM bakery_security_logs
WHERE license_plate IN (SELECT license_plate FROM people
WHERE id IN (SELECT person_id FROM bank_accounts
JOIN atm_transactions ON atm_transactions.account_number = bank_accounts.account_number
WHERE year = 2021
AND month = 7
AND day = 28
AND atm_location = "Leggett Street"
AND transaction_type = "withdraw"))
AND year = 2021
AND month = 7
AND day = 28
AND activity = "exit"
AND hour = 10
AND minute <= 25;

-- Finding out list of suspects
SELECT * FROM people
WHERE license_plate IN (SELECT license_plate FROM bakery_security_logs
WHERE license_plate IN (SELECT license_plate FROM people
WHERE id IN (SELECT person_id FROM bank_accounts
JOIN atm_transactions ON atm_transactions.account_number = bank_accounts.account_number
WHERE year = 2021
AND month = 7
AND day = 28
AND atm_location = "Leggett Street"
AND transaction_type = "withdraw"))
AND year = 2021
AND month = 7
AND day = 28
AND activity = "exit"
AND hour = 10
AND minute <= 25);

-- finding suspects
SELECT * FROM phone_calls
JOIN people ON phone_calls.caller = people.phone_number
WHERE caller IN (SELECT phone_number FROM people
WHERE license_plate IN (SELECT license_plate FROM bakery_security_logs
WHERE license_plate IN (SELECT license_plate FROM people
WHERE id IN (SELECT person_id FROM bank_accounts
JOIN atm_transactions ON atm_transactions.account_number = bank_accounts.account_number
WHERE year = 2021
AND month = 7
AND day = 28
AND atm_location = "Leggett Street"
AND transaction_type = "withdraw"))
AND year = 2021
AND month = 7
AND day = 28
AND activity = "exit"
AND hour = 10
AND minute <= 25))
AND month = 7
AND year = 2021
AND day = 28
AND duration <= 60;

-- Suspects are narrowed down to diana and Bruce
-- searching for their passport number in the flights leaving fiftyville on 29
SELECT * FROM passengers
JOIN flights ON passengers.flight_id = flights.id
WHERE passport_number IN (5773159633, 3592750733);

-- Since both of them left fiftyville, we'll check if their call receiver have left or not
SELECT passport_number from people
WHERE phone_number IN (SELECT receiver FROM phone_calls
JOIN people ON phone_calls.caller = people.phone_number
WHERE caller IN (SELECT phone_number FROM people
WHERE license_plate IN (SELECT license_plate FROM bakery_security_logs
WHERE license_plate IN (SELECT license_plate FROM people
WHERE id IN (SELECT person_id FROM bank_accounts
JOIN atm_transactions ON atm_transactions.account_number = bank_accounts.account_number
WHERE year = 2021
AND month = 7
AND day = 28
AND atm_location = "Leggett Street"
AND transaction_type = "withdraw"))
AND year = 2021
AND month = 7
AND day = 28
AND activity = "exit"
AND hour = 10
AND minute <= 25))
AND month = 7
AND year = 2021
AND day = 28
AND duration <= 60);


-- Since the thief were to take the earliest flight, passport number 5773159633 satisfies the category

SELECT * FROM people
WHERE passport_number = 5773159633;

-- Bruce Commited the theft and his accomplice was robin

-- This gives us the accomplice's number
SELECT receiver FROM phone_calls
WHERE caller = "(367) 555-5533"
AND duration <= 60
AND month = 7
AND day = 28
AND year = 2021;

-- Gives us the accomplice's information
SELECT * FROM people
WHERE phone_number = "(375) 555-8161";

-- Thief escaped to
SELECT * FROM airports
WHERE id = 4;