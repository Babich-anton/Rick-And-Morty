#  Rick and Morty

#### Используя https://rickandmortyapi.com/documentation/ создать приложение

###### с 4 нижними табиками:
    
    1. Character + 
    2. Location + 
    3. Episodes + 
    4. Profile +
    
    + 1) В каждом показывать спискок всех объектов.
    + 2) В каждом, при нажатии на объект, сделать запрос на его детальную инфу и отобразить на экране.
    + 3) На экранах списка, добавить поиск по объектам, используя также запросы API.
    + 4) Сделать экран регистрации в приложении через Firebase (только по логину).
    + 5) На экране профиля сделать функцию логаут (используя Firebase).
    + 6) на экране профиля должна быть возможность добавить/изменить картинку пользователя, имя, фамилию.

### Используем архитектуру MVVM
### Используем Cocoapods модели наследовать от Codable
### Используем парсинг через JSONDecoder



# Character schema
### https://rickandmortyapi.com/api/character/
    {
      "info": {
        "count": 394,
        "pages": 20,
        "next": "https://rickandmortyapi.com/api/character/?page=2",
        "prev": ""
      },
      "results": [
        {
          "id": 1,
          "name": "Rick Sanchez",
          "status": "Alive",
          "species": "Human",
          "type": "",
          "gender": "Male",
          "origin": {
            "name": "Earth",
            "url": "https://rickandmortyapi.com/api/location/1"
          },
          "location": {
            "name": "Earth",
            "url": "https://rickandmortyapi.com/api/location/20"
          },
          "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
          "episode": [
            "https://rickandmortyapi.com/api/episode/1",
            "https://rickandmortyapi.com/api/episode/2",
            // ...
          ],
          "url": "https://rickandmortyapi.com/api/character/1",
          "created": "2017-11-04T18:48:46.250Z"
        },
        // ...
      ]
    }

### https://rickandmortyapi.com/api/character/2
    {
      "id": 2,
      "name": "Morty Smith",
      "status": "Alive",
      "species": "Human",
      "type": "",
      "gender": "Male",
      "origin": {
        "name": "Earth",
        "url": "https://rickandmortyapi.com/api/location/1"
      },
      "location": {
        "name": "Earth",
        "url": "https://rickandmortyapi.com/api/location/20"
      },
      "image": "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
      "episode": [
        "https://rickandmortyapi.com/api/episode/1",
        "https://rickandmortyapi.com/api/episode/2",
        // ...
      ],
      "url": "https://rickandmortyapi.com/api/character/2",
      "created": "2017-11-04T18:50:21.651Z"
    }

### Filter
    Available parameters:

    name: filter by the given name.
    status: filter by the given status (alive, dead or unknown).
    species: filter by the given species.
    type: filter by the given type.
    gender: filter by the given gender (female, male, genderless or unknown).
    
    Sample: https://rickandmortyapi.com/api/character/?name=rick&status=alive

# Locations
### https://rickandmortyapi.com/api/location/
    {
      "info": {
        "count": 67,
        "pages": 4,
        "next": "https://rickandmortyapi.com/api/location?page=2",
        "prev": ""
      },
      "results": [
        {
          "id": 1,
          "name": "Earth",
          "type": "Planet",
          "dimension": "Dimension C-137",
          "residents": [
            "https://rickandmortyapi.com/api/character/1",
            "https://rickandmortyapi.com/api/character/2",
            // ...
          ],
          "url": "https://rickandmortyapi.com/api/location/1",
          "created": "2017-11-10T12:42:04.162Z"
        }
        // ...
      ]
    }

### https://rickandmortyapi.com/api/location/3
    [
      {
        "id": 3,
        "name": "Citadel of Ricks",
        "type": "Space station",
        "dimension": "unknown",
        "residents": [
          "https://rickandmortyapi.com/api/character/8",
          "https://rickandmortyapi.com/api/character/14",
          // ...
        ],
        "url": "https://rickandmortyapi.com/api/location/3",
        "created": "2017-11-10T13:08:13.191Z"
      }
    ]

### Filter
    Available parameters:

    name: filter by the given name.
    type: filter by the given type.
    dimension: filter by the given dimension.
    Sample: https://rickandmortyapi.com/api/location/?name=earth


# Episodes
### https://rickandmortyapi.com/api/episode/
    {
      "info": {
        "count": 31,
        "pages": 2,
        "next": "https://rickandmortyapi.com/api/episode?page=2",
        "prev": ""
      },
      "results": [
        {
          "id": 1,
          "name": "Pilot",
          "air_date": "December 2, 2013",
          "episode": "S01E01",
          "characters": [
            "https://rickandmortyapi.com/api/character/1",
            "https://rickandmortyapi.com/api/character/2",
            //...
          ],
          "url": "https://rickandmortyapi.com/api/episode/1",
          "created": "2017-11-10T12:56:33.798Z"
        },
        // ...
      ]
    }

### https://rickandmortyapi.com/api/episode/28
    {
      "id": 28,
      "name": "The Ricklantis Mixup",
      "air_date": "September 10, 2017",
      "episode": "S03E07",
      "characters": [
        "https://rickandmortyapi.com/api/character/1",
        "https://rickandmortyapi.com/api/character/2",
        // ...
      ],
      "url": "https://rickandmortyapi.com/api/episode/28",
      "created": "2017-11-10T12:56:36.618Z"
    }
