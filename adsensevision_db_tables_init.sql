-- Создание таблиц
CREATE TABLE camera -- Камеры
(
    id SERIAL PRIMARY KEY,
    name VARCHAR(120) NOT NULL, -- Название камеры
    url_address VARCHAR(80) NOT NULL, -- Общедоступный IP-адрес или DNS(доменный) адрес
    connection_login VARCHAR(50) NOT NULL, -- Логин для подключения к камере
    connection_password VARCHAR(50) NOT NULL -- Пароль для подключения к камере
);

CREATE TABLE screen -- Экраны для транлсяции контента
(
	id SERIAL PRIMARY KEY,
	name VARCHAR(120)NOT NULL, -- Название экрана
	start_time TIME NOT NULL, -- Время запуска трансляции контента
    end_time TIME NOT NULL, -- Время остановки трянcляции контента
    pause_time TIME NOT NULL, -- Время паузы между показами видео
    update_date DATE -- Дата обновления проигрываемого на экране контента
);

CREATE TABLE broadcast_station -- Станция для трансляции контента (Связующая таблица камеры и экрана)
(
	id SERIAL PRIMARY KEY,
	name VARCHAR(120) NOT NULL, -- Название станции
	camera_id INT, -- Камера
    FOREIGN KEY(camera_id) REFERENCES camera(id), 
    screen_id INT, -- Экран
    FOREIGN KEY(screen_id) REFERENCES screen(id),
    location_address VARCHAR(120) -- Локация (адрес), где расположена станция
);

CREATE TABLE media_content -- Транслируемый контент
(
	id SERIAL PRIMARY KEY,
	video VARCHAR(250) NOT NULL, -- Адрес видеозаписи в файловой системе
	name VARCHAR(120), -- Название контента
	description VARCHAR(360), -- Описание контента
	upload_date DATE, -- Дата загрузки видео
	duration TIME, -- Продолжительность видео
	preview VARCHAR(250) -- Адрес превью видеозаписи в файловой системе
);

CREATE TABLE schedule -- Расписание показа контента (цикличное), плейлист
(
	id SERIAL PRIMARY KEY,
	queue_number INT NOT NULL, -- Порядковый номер контента в очереди трансляции
	media_content_id INT, -- Транслируемый контент 
    FOREIGN KEY(media_content_id) REFERENCES media_content(id),
    screen_id INT, -- Экран транслирующий контент
    FOREIGN KEY(screen_id) REFERENCES screen(id)
);

CREATE TABLE statistics -- Статистика по показам контента на каждой станции
(
	id SERIAL PRIMARY KEY,	
	media_content_id INT, -- Контент, статистику котрого записываем
    FOREIGN KEY(media_content_id) REFERENCES media_content(id), 
    broadcast_station_id INT, -- Станция транслирующая контент и анализирующая заинтересованность публики
    FOREIGN KEY(broadcast_station_id) REFERENCES broadcast_station(id), 
    total_viewing_time TIME, -- Общее время просмотра контента
    max_viewers_count INT, -- Максимальное количество зрителей в момент времени   
    show_count INT -- Количество показов контента
);


CREATE TABLE statistics_per_show -- Статистика по каждому отдельному показу контента
(
	id SERIAL PRIMARY KEY,	
	media_content_id INT, -- Контент, статистику котрого записываем
    FOREIGN KEY(media_content_id) REFERENCES media_content(id), 
    broadcast_station_id INT, -- Станция транслирующая контент и анализирующая заинтересованность публики
    FOREIGN KEY(broadcast_station_id) REFERENCES broadcast_station(id), 
    viewing_time TIME NOT NULL, -- Время просмотра контента за показ
    max_viewers_count INT NOT NULL, -- Максимальное количество зрителей в момент времени
    show_datetime TIMESTAMP NOT NULL -- Дата и время трансляции
);

