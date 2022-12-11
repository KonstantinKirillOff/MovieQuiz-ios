## **BestMovieQuiz**

MovieQuiz - это приложение с квизами о фильмах из топ-250 рейтинга и самых популярных фильмах по версии IMDb.
## **Описание приложения**

- Одностраничное приложение с квизами о фильмах из топ-250 рейтинга и самых популярных фильмов IMDb. Пользователь приложения последовательно отвечает на вопросы о рейтинге фильма. По итогам каждого раунда игры показывается статистика о количестве правильных ответов и лучших результатах пользователя. Цель игры — правильно ответить на все 10 вопросов раунда.

## **Логика работы приложения**
- После запуска приложения показывается экран вопроса с текстом вопроса, картинкой и двумя вариантами ответа, “Да” и “Нет”, только один из них правильный;
- Вопрос квиза составляется относительно IMDb рейтинга фильма по 10-балльной шкале, например: "Рейтинг этого фильма больше 6?";
- Можно нажать на один из вариантов ответа на вопрос и получить отклик о том, правильный он или нет, при этом рамка фотографии поменяет цвет на соответствующий;
- После выбора ответа на вопрос через 1 секунду автоматически появляется следующий вопрос;
- После завершения раунда из 10 вопросов появляется алерт со статистикой пользователя и возможностью сыграть ещё раз;
- Статистика содержит: результат текущего раунда (количество правильных ответов из 10 вопросов), количество сыгранных квизов, рекорд (лучший результат раунда за сессию, дата и время этого раунда), статистику сыгранных квизов в процентном соотношении (среднюю точность);
- Пользователь может запустить новый раунд, нажав в алерте на кнопку "Сыграть еще раз";
- При невозможности загрузить данные пользователь видит алерт с сообщением о том, что что-то пошло не так, а также кнопкой, по нажатию на которую можно повторить сетевой запрос.

## **Примеры из приложения**
<img width="195" alt="image" src="https://user-images.githubusercontent.com/53314883/206917104-470a72d1-e149-4c77-b806-e9b802f898f0.png">   <img width="195" alt="image" src="https://user-images.githubusercontent.com/53314883/206917037-3c1c1041-a0bc-42f7-b924-aebcc0975fc3.png">


## **Технические особенности**
- Приложение поддерживает только устройства iPhone с iOS 13, предусмотрен только портретный режим.


## **В разработке использовалось: **
- MVP
- UserDefaults
- URLSession 
- JSON
- Concurrency
- UnitTests/UITests
- SOLID
- Storyboards
- Figma

