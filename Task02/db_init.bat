#!/bin/bash
python3 generate_sql_script.py
sqlite3 movies_rating.db < db_init.sql