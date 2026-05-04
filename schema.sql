-- Self-development tracker "Prudence".
-- You organize the tasks you set for yourself daily, weekly, monthly and the tracker records and generates the progress you've made.
-- Important: It's not about reaching the 100% within the first month, it's about building and preserving consistency.

-- Below the table to organize the type of tasks you aim to do throughout the month, e.g. book, film, meditation, etc..
CREATE TABLE "category" (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);


-- Below the main table where you store all the tasks you aim to do throughout the month.
-- It references the "category" table through Foreign Key "category_id".
CREATE TABLE "tasks" (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    category_id INTEGER NOT NULL,
    target_per_week INTEGER NOT NULL CHECK (target_per_week BETWEEN 1 AND 7),
    FOREIGN KEY("category_id") REFERENCES "category"("id")
);

-- Below the table that keeps track of the progress you make with your tasks, whether you are completing them or not.
-- It is related to "tasks" table through the Foreign Key "task_id".
-- Thanks to the Foreign Key you can understand the % completion of your tasks and how is your week/month looking.
CREATE TABLE "task_progress" (
    id INTEGER PRIMARY KEY,
    task_id INTEGER NOT NULL,
    month TEXT NOT NULL DEFAULT (STRFTIME('%Y-%m', 'now')),
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    week INTEGER NOT NULL CHECK (week BETWEEN 1 AND 4), -- the 4 weeks of the month, so we don't complicate it using 28/29/30/31 days
    completed BOOLEAN NOT NULL CHECK (completed IN (0,1)), -- where 1 = done and 0 = yet
    FOREIGN KEY("task_id") REFERENCES "tasks"("id") ON DELETE CASCADE -- if you delete a task, the rows associated with it are deleted too.
);

-- To make the idea a bit more fun and stimulating I have attributed a respective color to % ranges, which represent progress.
-- The shades become stronger jumping in range for then to achieve the final shade that is Violet.
CREATE TABLE "color_attribution" (
    id INTEGER PRIMARY KEY,
    min_percentage REAL NOT NULL,
    max_percentage REAL NOT NULL,
    color_name TEXT NOT NULL,
    color_hex TEXT NOT NULL
);

-- I will want to check the progress by shade and not by % so I can see where I'm at for the month:
CREATE VIEW "monthly_progress" AS
SELECT "color_name", "color_hex", ROUND(SUM("completed") * 100.0 / SUM("target_per_week" * 4), 1) AS "progress_pc"
FROM "task_progress"
JOIN "tasks" ON "task_progress"."task_id" = "tasks"."id"
JOIN "color_attribution" ON ROUND(SUM("completed") * 100.0 / SUM("target_per_week" * 4), 1) BETWEEN "min_percentage" AND "max_percentage";
GROUP BY "month";

-- To speed up category lookups on the tasks table since I will frequently check on them:
CREATE INDEX tasks_category_index
ON tasks(category_id);

-- To speed up filtering by week/date/month:
CREATE INDEX task_progress_week_index
ON task_progress(week);

CREATE INDEX task_progress_date_index
ON task_progress(date);

CREATE INDEX task_progress_month_index
ON task_progress(month);
