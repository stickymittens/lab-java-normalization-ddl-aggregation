CREATE DATABASE lab_week_6;
USE lab_week_6;

CREATE TABLE exercise1_db (
                              author VARCHAR(100),
                              title VARCHAR(255),
                              word_count INT,
                              views INT
);

INSERT INTO exercise1_db (author, title, word_count, views) VALUES
                                                                ('Maria Charlotte', 'Best Paint Colors', 814, 14),
                                                                ('Juan Perez', 'Small Space Decorating Tips', 1146, 221),
                                                                ('Maria Charlotte', 'Hot Accessories', 986, 105),
                                                                ('Maria Charlotte', 'Mixing Textures', 765, 22),
                                                                ('Juan Perez', 'Kitchen Refresh', 1242, 307),
                                                                ('Maria Charlotte', 'Homemade Art Hacks', 1002, 193),
                                                                ('Gemma Alcocer', 'Refinishing Wood Floors', NULL, NULL);

#authors
CREATE TABLE authors (
                         author VARCHAR(100) PRIMARY KEY
);

INSERT INTO authors (author)
SELECT DISTINCT author
FROM exercise1_db;

SELECT * FROM authors;

#books
CREATE TABLE books (
                       author VARCHAR(100),
                       title VARCHAR(255),
                       word_count INT,
                       views INT,
                       PRIMARY KEY (author, title),
                       FOREIGN KEY (author) REFERENCES authors(author)
);

INSERT INTO books (author, title, word_count, views)
SELECT DISTINCT author, title, word_count, views
FROM exercise1_db;

SELECT * FROM books;
