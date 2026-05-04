INSERT INTO "Category" ("name")
VALUES ('Book'),
('Film'),
('Meditation'),
('Radio show');

INSERT INTO "Tasks" ("title", "category_id", "target_per_week")
VALUES ('Assata Autobiography', 1, 3),
('Didion and Babitz', 1, 3),
('Mindhunter', 1, 3),
('Continental Divide', 2, 1),
('A Streetcar Named Desire', 2, 1),
('Girlfriends', 2, 1),
('Mean Streets', 2, 1),
('A Woman Under The Influence', 2, 1),
('Janis Little Girl Blue', 2, 1),
('TLC Forever', 2, 1),
('One Battle After Another', 2, 1),
('The Smashing Machine', 2, 1),
('Nouvelle Vague', 2, 1),
('Meditation', 3, 7),
('NLRH', 4, 7);

-- If this were to become an app, the visual of your month grid would be colored with the shade of purple on account of your % progress.
INSERT INTO "color_attribution" ("min_percentage", "max_percentage", "color_name", "color_hex")
VALUES (0, 24.99, 'Lavender', '#E6E6FA'),
(25, 49.99, 'Lilac', '#C8A2C8'),
(50, 74.99, 'Mauve', '#B784A7'),
(75, 99.99, 'Amethyst', '#9966CC'),
(100, 100, 'Violet', '#7F00FF');

-- I want to see how many more Radio show episodes I have to listen to (NLRH stands for National Lampoon Radio Hour):
SELECT COUNT(*) FROM "task_progress"
WHERE "task_id" = (
    SELECT "id" FROM "tasks"
    WHERE "title" = 'NLRH'
)
AND "completed" = 0;

-- I want to check my progress but by looking at the color attribution:
SELECT * FROM "monthly_progress" WHERE "month" = '2026-04';

-- I will be travelling with my family the day I was set to start Didion and Babitz so I will postpone it for the next day:
UPDATE "task_progress"
SET "date" = '2026-04-30'
WHERE "task_id" = 2 AND "date" = '2026-04-29';

-- I couldn't catch the film One Battle After Another at the theatre so now I have to wait to stream it online:
DELETE FROM "tasks" WHERE "title" = 'One Battle After Another';
