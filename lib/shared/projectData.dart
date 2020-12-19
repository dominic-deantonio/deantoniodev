import 'package:deantoniodev/shared/project.dart';
import 'package:flutter/material.dart';

import 'gif.dart';

class ProjectData {
  static List<Project> projects = [
    Project(
      title: 'Project 1 Title',
      description: 'Here is a description. It is kind of longer than the title.',
      color: Colors.red,
      imageUrl: 'https://www.picamon.com/wp-content/uploads/2014/10/hq-wallpapers_ru_city_7921_1920x1080.jpg',
      gifs: [
        Gif(url: 'https://i.gifer.com/PX3Q.gif', description: 'Here is some information about this gif. It is a gif and it is pronounced with a hard G.'),
        Gif(
            url: 'https://media3.giphy.com/media/xTiTnyUkad7YQsA4Cs/source.gif',
            description: 'This is another gif. Except it is from a different location than the first one. It is not a very nice gif, but it is one nonetheless.'),
        Gif(url: 'https://i.gifer.com/PX3Q.gif', description: 'We are back to looking at the first gif again.'),
      ],
    ),
    Project(
      title: 'Project 2 Title',
      description: 'Here is another description. It is kind of longer than the title.',
      color: Colors.green,
      imageUrl: 'https://media.glassdoor.com/l/8d/22/cb/3b/hq.jpg',
      gifs: [
        Gif(url: 'https://i.gifer.com/PX3Q.gif', description: 'Here is some information about this gif. It is a gif and it is pronounced with a hard G.'),
        Gif(
            url: 'https://media3.giphy.com/media/xTiTnyUkad7YQsA4Cs/source.gif',
            description: 'This is another gif. Except it is from a different location than the first one. It is not a very nice gif, but it is one nonetheless.'),
        Gif(url: 'https://i.gifer.com/PX3Q.gif', description: 'We are back to looking at the first gif again.'),
      ],
    ),
    Project(
      title: 'Project 3 Title',
      description: 'Here is yet another description. It is kind of longer than the title.',
      color: Colors.blue[900],
      imageUrl: 'https://cdn.wallpapersafari.com/8/74/KbLH6C.jpg',
      gifs: [
        Gif(url: 'https://i.gifer.com/PX3Q.gif', description: 'Here is some information about this gif. It is a gif and it is pronounced with a hard G.'),
        Gif(
            url: 'https://media3.giphy.com/media/xTiTnyUkad7YQsA4Cs/source.gif',
            description: 'This is another gif. Except it is from a different location than the first one. It is not a very nice gif, but it is one nonetheless.'),
        Gif(url: 'https://i.gifer.com/PX3Q.gif', description: 'We are back to looking at the first gif again.'),
      ],
    ),
    Project(
      title: 'Project 4 Title',
      description: 'Here is yet another description. It is kind of longer than the title.',
      color: Colors.purple,
      imageUrl: 'https://miro.medium.com/max/1600/0*dAOhY7v2EFxTBp3m.png',
      gifs: [
        Gif(url: 'https://i.gifer.com/PX3Q.gif', description: 'Here is some information about this gif. It is a gif and it is pronounced with a hard G.'),
        Gif(
            url: 'https://media3.giphy.com/media/xTiTnyUkad7YQsA4Cs/source.gif',
            description: 'This is another gif. Except it is from a different location than the first one. It is not a very nice gif, but it is one nonetheless.'),
        Gif(url: 'https://i.gifer.com/PX3Q.gif', description: 'We are back to looking at the first gif again.'),
      ],
    ),
  ];
}
