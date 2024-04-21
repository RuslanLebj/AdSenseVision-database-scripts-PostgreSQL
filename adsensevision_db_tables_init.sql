-- Создание таблиц
CREATE TABLE camera -- Камера
(
    id SERIAL PRIMARY KEY,
    name VARCHAR(120) NOT NULL, -- Название камеры (можно указать адрес, помещение, номер камеры)
    address VARCHAR(80) NOT NULL, -- Общедоступный IP-адрес или DNS(доменный) адрес
    connection_login VARCHAR(50) NOT NULL, -- Логин для подключения к камере
    connection_password VARCHAR(50) NOT NULL -- Пароль для подключения к камере
);

CREATE TABLE screen -- Экраны (медиаплощади для транлсяции контента)
(
	id SERIAL PRIMARY KEY,
	name VARCHAR(120)NOT NULL, -- Название экрана (можно указать адрес, помещение, номер экрана)
	start_time TIME NOT NULL, -- Время запуска трансляции контента
    end_time TIME NOT NULL -- Время остановки трянcляции контента
);

CREATE TABLE camera_screen -- Связующая таблица камеры и экрана
(
	id SERIAL PRIMARY KEY,
	camera_id INT, -- Камера
    FOREIGN KEY(camera_id) REFERENCES camera(id), 
    screen_id INT, -- Экран
    FOREIGN KEY(screen_id) REFERENCES screen(id)
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

CREATE TABLE statistics -- Общая статистика по показам контента
(
	id SERIAL PRIMARY KEY,	
	media_content_id INT, -- Контент, статистику котрого записываем
    FOREIGN KEY(media_content_id) REFERENCES media_content(id), 
    screen_id INT, -- Экран транслировавший контент
    FOREIGN KEY(screen_id) REFERENCES screen(id), 
    total_viewing_time TIME NOT NULL, -- Общее время просмотра контента
    max_viewers_count INT NOT NULL -- Максимальное количество зрителей в момент времени   
);

CREATE TABLE schedule -- Расписание показа контента (цикличное), сессия
(
	id SERIAL PRIMARY KEY,
	queue_number INT NOT NULL, -- Порядковый номер контента в очереди трансляции
	media_content_id INT, -- Транслируемый контент 
    FOREIGN KEY(media_content_id) REFERENCES media_content(id),
    screen_id INT, -- Экран транслирующий контент
    FOREIGN KEY(screen_id) REFERENCES screen(id)
);

CREATE TABLE frame_statistics -- Статистика показа по каждому кадру
(
	id SERIAL PRIMARY KEY,	
	media_content_id INT, -- Контент, статистику котрого записываем
    FOREIGN KEY(media_content_id) REFERENCES media_content(id), 
    screen_id INT, -- Экран транслировавший контент
    FOREIGN KEY(screen_id) REFERENCES screen(id), 
    viewing_time TIME NOT NULL, -- Время просмотра кадра
    viewers_count INT NOT NULL -- Количество зрителей в кадре  
);

