CREATE SCHEMA todoapp;

CREATE TABLE todoapp.users (
  id SERIAL PRIMARY KEY,
  version BIGINT NOT NULL DEFAULT 1,
  title TEXT NOT NULL,
  full_name VARCHAR(255) NOT NULL CHECK (
    char_length(full_name) BETWEEN 3
    AND 255
  ),
  phone_number VARCHAR(15) UNIQUE NOT NULL CHECK (
    char_length(phone_number) BETWEEN 10
    AND 15
  ),
  email VARCHAR(255) NOT NULL
);

CREATE TABLE todoapp.tasks (
  id SERIAL PRIMARY KEY,
  version BIGINT NOT NULL DEFAULT 1,
  title TEXT NOT NULL,
  description TEXT,
  completed BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
  completed_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
  user_id INTEGER NOT NULL REFERENCES todoapp.users (id) ON DELETE CASCADE CHECK (
    (
      completed = TRUE
      AND completed_at IS NOT NULL
    )
    OR (
      completed = FALSE
      AND completed_at IS NULL
    )
  )
);