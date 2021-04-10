pragma foreign_keys = on;

create table if not exists services
(
    id integer primary key,
    name varchar(32)
);

insert into services (name)
values
('Ручная мойка кузова'),
('Бесконтактная мойка кузова'),
('Чистка салона пылесосом и влажная уборка пластмассовых деталей'),
('Чистка стекол изнутри химическими средствами'),
('Полировка пластмассовых деталей салона химическими средствами'),
('Чистка багажника'),
('Комплексная мойка'),
('Мойка двигателя и моторного отсека'),
('Покрытие кузова воском на основе тефлоновой полировки'),
('Кондиционер кожанных сидений');


create table if not exists car_class
(
    id integer primary key,
    name varchar(32)
);

insert into car_class (name)
values
('A-класс'),
('B-класс'),
('C-класс'),
('D-класс'),
('E-класс'),
('F-класс');

create table if not exists services_by_car_class
(
    service_id integer,
    car_class_id integer,
    duration integer,
    price real,
    foreign key (service_id) references services(id),
    foreign key (car_class_id) references car_class(id),
    check (duration > 0 and price > 0)
);

insert into services_by_car_class (service_id, car_class_id, duration, price)
values
(1, 1, 20, 100.00),
(2, 1, 25, 120.00),
(3, 1, 10, 110.00),
(4, 1, 20, 150.00),
(5, 1, 30, 180.00),
(6, 1, 60, 140.00),
(7, 1, 40, 250.00),
(8, 1, 30, 200.00),
(9, 1, 25, 190.00),
(10, 1, 20, 120.00),
(1, 2, 20, 110.00),
(2, 2, 25, 130.00),
(3, 2,  10, 120.00),
(4, 2, 20, 160.00),
(5, 2, 30, 190.00),
(6, 2, 60, 150.00),
(7, 2, 40, 260.00),
(8, 2, 30, 210.00),
(9, 2, 25, 200.00),
(10, 2, 20, 130.00),
(1, 2, 20, 100.00),
(2, 3, 20, 120.00),
(3, 3, 10, 110.00),
(4, 3, 20, 150.00),
(5, 3, 30, 180.00),
(6, 3, 60, 140.00),
(7, 3, 40, 250.00),
(8, 3, 30, 200.00),
(9, 3, 25, 190.00),
(10, 3, 20, 120.00),
(1, 4, 40, 140.00),
(2, 4, 45, 160.00),
(3, 4, 30, 170.00),
(4, 4, 40, 210.00),
(5, 4, 50, 240.00),
(6, 4, 80, 200.00),
(7, 4, 60, 310.00),
(8, 4, 50, 240.00),
(9, 4, 45, 230.00),
(10, 4, 40, 160.00),
(1, 5, 40, 140.00),
(2, 5, 45, 160.00),
(3, 5, 30, 170.00),
(4, 5, 40, 210.00),
(5, 5, 50, 240.00),
(6, 5, 80, 200.00),
(7, 5, 60, 310.00),
(8, 5, 50, 240.00),
(9, 5, 45, 230.00),
(10, 5, 40, 160.00),
(1, 6, 40, 240.00),
(2, 6, 45, 260.00),
(3, 6, 30, 270.00),
(4, 6, 40, 310.00),
(5, 6, 50, 340.00),
(6, 6, 80, 300.00),
(7, 6, 60, 410.00),
(8, 6, 50, 340.00),
(9, 6, 45, 330.00),
(10, 6, 40, 260.00);


create table if not exists masters
(
    id integer primary key,
    first_name varchar(32),
    patronymic varchar(32),
    last_name varchar(32),
    gender varchar(8),
    birthdate date,
    salary_coefficient real default 1.0,
    hiring_date date,
    dismissal_date date,
    check (gender = 'муж' or gender = 'жен'),
    check (salary_coefficient > 0.0 and salary_coefficient < 5.0),
    check (hiring_date < date()),
    check (dismissal_date < hiring_date)
);

insert into masters (first_name, patronymic, last_name, gender, birthdate, salary_coefficient, hiring_date, dismissal_date)
values
('Петр', 'Петрович', 'Петров', 'муж', '2000-01-02', 1.5, '2020-02-01', NULL),
('Иван', 'Иванович', 'Иванов', 'муж', '2000-03-04', 2.5, '2020-01-02', NULL),
('Сидор', 'Сидорович', 'Сидоров', 'муж', '2000-05-06', 2.0, '2020-04-03', NULL),
('Николай', 'Николаевич', 'Николаев', 'муж', '2000-07-08', 1.25, '2020-03-04', NULL),
('Александр', 'Александрович', 'Александров', 'муж', '2000-09-10', 3.0, '2020-05-05', NULL);

create table if not exists boxes
(
    id integer primary key,
    number integer
);

insert into boxes(number)
values
(1),
(2),
(3),
(4),
(5);

create table if not exists service_reservation
(
    service_id integer,
    car_class_id integer,
    master_id integer,
    box_id integer,
    date date,
    time time,
    foreign key (service_id) references services(id),
    foreign key (car_class_id) references car_class(id),
    foreign key (master_id) references masters(id),
    foreign key (box_id) references boxes(id),
    check (date > date())
);

insert into service_reservation (service_id, car_class_id, master_id, box_id, date, time)
values
(1, 1, 1, 1, '2021-06-01', '10:00'),
(2, 1, 2, 2, '2021-06-01', '10:00'),
(1, 3, 3, 3, '2021-06-01', '10:00'),
(4, 1, 4, 4, '2021-06-01', '10:00'),
(2, 3, 5, 5, '2021-06-01', '10:00');


create table if not exists completed_services
(
    service_id integer,
    master_id integer,
    date date,
    foreign key (service_id) references services(id),
    foreign key (master_id) references masters(id),
    check (date < date())
);

insert into completed_services (service_id, master_id, date)
values
(1, 1, '2021-02-06'),
(1, 1, '2021-02-06'),
(1, 2, '2021-02-06'),
(1, 2, '2021-02-06'),
(1, 3, '2021-02-06'),
(1, 3, '2021-02-06'),
(1, 4, '2021-02-06'),
(1, 4, '2021-02-06'),
(1, 5, '2021-02-06'),
(1, 5, '2021-02-06');

create table if not exists day_schedule
(
    id integer primary key,
    start_time time default '08:00',
    end_time time default '16:00',
    check(start_time >= '08:00' and start_time <= '14:00')
    check(end_time >= '16:00' and end_time <= '22:00')
);

insert into day_schedule (start_time, end_time)
values
('08:00', '16:00'),
('09:00', '17:00'),
('10:00', '18:00'),
('11:00', '19:00'),
('12:00', '20:00'),
('13:00', '21:00'),
('14:00', '22:00');

create table if not exists master_schedule
(
    day_schedule_id integer,
    master_id integer,
    day_of_week varchar(2),
    foreign key (day_schedule_id) references day_schedule(id),
    foreign key (master_id) references masters(id),
    check (day_of_week = 'Пн' or day_of_week = 'Вт' or day_of_week = 'Ср' or day_of_week = 'Чт' or day_of_week = 'Пт' or day_of_week = 'Сб' or day_of_week = 'Вс')
);

insert into master_schedule (day_schedule_id, master_id, day_of_week)
values
(1, 1, 'Пн'),
(2, 1, 'Вт'),
(1, 1, 'Ср'),
(1, 1, 'Чт'),
(1, 1, 'Пт'),
(1, 1, 'Сб'),
(1, 1, 'Вс'),
(1, 2, 'Пн'),
(1, 2, 'Вт'),
(1, 2, 'Ср'),
(1, 2, 'Чт'),
(1, 2, 'Пт'),
(1, 2, 'Сб'),
(1, 2, 'Вс'),
(1, 3, 'Пн'),
(1, 3, 'Вт'),
(1, 3, 'Ср'),
(1, 3, 'Чт'),
(1, 3, 'Пт'),
(5, 4, 'Пн'),
(5, 4, 'Вт'),
(5, 4, 'Ср'),
(5, 4, 'Чт'),
(5, 4, 'Пт'),
(5, 4, 'Сб'),
(5, 4, 'Вс'),
(1, 5, 'Пн'),
(1, 5, 'Вт'),
(1, 5, 'Ср'),
(1, 5, 'Чт'),
(1, 5, 'Пт');