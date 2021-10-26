// ignore_for_file: file_names, prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:convert' as convert;
import 'dart:async';
import 'package:flutter_web_auth/flutter_web_auth.dart';

int globalSelected = 0;

var pictureList = [
  'assets/images/test-thumbnail.jpg',
  'assets/images/test-thumbnail.jpg',
  'assets/images/test-thumbnail.jpg',
  'assets/images/test-thumbnail.jpg',
  'assets/images/test-thumbnail.jpg',
  'assets/images/test-thumbnail.jpg',
  'assets/images/test-thumbnail.jpg',
  'assets/images/test-thumbnail.jpg',
  'assets/images/test-thumbnail.jpg',
  'assets/images/test-thumbnail.jpg',
];

class landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return DesktopLanding();
        } else {
          return MobileLanding();
        }
      },
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class DesktopLanding extends StatefulWidget {
  const DesktopLanding({Key? key}) : super(key: key);

  @override
  State<DesktopLanding> createState() => _DesktopLanding();
}

/// This is the private State class that goes with MyStatefulWidget.
class _DesktopLanding extends State<DesktopLanding> {
  // This class manages the state of the landing page and what it is current displaying
  //  with animations between the transitions.

  // Variable that stores the state of the landing page
  int selected = 0;
  // Variable to tell the animated container if it should be using the animation or if the website is just being scaled
  bool switching = false;
  // Variable to store the selected playlists name
  dynamic selectedPlaylist = "";

  int bpm = 100;
  int key = 80;
  int dance = 35;
  int acoustic = 25;
  int energy = 65;
  int liveness = 0;
  int loudness = 20;
  int speechiness = 15;
  int valence = 30;

  dynamic userName = "";

  List<dynamic> playlistNames = [];
  List<dynamic> playlistId = [];
  List<dynamic> playlistPicture = [];

  bool first_start = true;

  bool hasPlaylists = false; 

  Future<String> getList(String url) async {
    var auth = js.context.callMethod('getAuthorization', []);
    var response = await http.get(Uri.parse(url), headers: {
      "Access-Control-Allow-Origin": "*",
      HttpHeaders.authorizationHeader: auth,
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    //var response = js.context.callMethod('httpRequest', [url, "GET"]);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Error();
    }
  }

  void grabUserInfo(var jsonResponse) {
    // Function to grab the given users information from the json response
    // jsonResponse -> decoded json of the users basic info

    // sets the state of the class variables to appropriate values
    setState(() {
      userName = jsonResponse['name'];
      hasPlaylists = jsonResponse['have_playlists'];

      if (hasPlaylists)
      {
        var playlists = jsonResponse['playlists'];

        for (int i = 0; i < playlists.length; i++) {
          playlistNames.insert(i, playlists[i]['name']);
          playlistId.insert(i, playlists[i]['id']);
          playlistPicture.insert(i, playlists[i]['image_link']);
        }
      }
    });
    incrementSelected();
  }

  void webInitialization() async {
    // Function that kicks off the users experience, if the user has visited before it will
    //  remember them and automatically move to the playlist select page but if not, they
    //  will be taken to the beginning and prompted to log in.

    // Default link to API
    String response = await getList('http://127.0.0.1:5000/');
    print(response);

    // Decode json into a string
    var jsonResponse = convert.jsonDecode(response);

    // Checks if user has visited before
    bool returningUser = jsonResponse['returning_user'];

    // if user has visited and logged in
    if (returningUser) {
      // User info automatically grabbed
      grabUserInfo(jsonResponse);
    }
    // else, goes to the default beginning of the program
    else {
      setState(() {
        selected = 0;
      });
    }
  }

  void logIn() async {
    html.window.location.assign(
        "https://accounts.spotify.com/authorize?client_id=7c9a373b495447e3a9992322ee41ec94&response_type=code&redirect_uri=http%3A%2F%2Flocalhost%3A5000%2Foauth&scope=playlist-read-private+playlist-modify-public");
  }

  // Increments the state by 1
  void incrementSelected() {
    // Function to Iterate the selector value for the state of the program
    // val -> value of the current state that needs to be iterated
    setState(() {
      if (selected < 3) {
        // Current amount of max states is 3
        selected++;
      } else {
        selected = 0;
      }
      // Tells the animator that it should be using the animation
      switching = true;
    });
  }

  // Decrements the state by 1
  void decrementSelected() {
    // Function to Decrement the selected value for the state of the program
    // val -> value of the current state that needs to be decremented
    setState(() {
      if (selected > 0) {
        selected--;
      } else {
        selected = 3; // Current amount of max states is 3
      }
      // Tells the animator that it should be using the animation
      switching = true;
    });
  }

  Widget giveChild(double maxWidth, double maxHeight) {
    // Function to return the correct child for the container based on the state of the program
    // val -> the current state the program should be in

    // sets child to default value so it is allowed to be returned
    Widget child = Text('Hello');

    // Variables for layout items:

    // Amount of Playlists to be shown per row, Dynamic based on the width of the container it is wrapped in
    int axisCount = (widthSelector(maxWidth) * 0.8) ~/ 150;
    // Amount of Horizontal space between each of the playlist boxes
    double crossSpace = 15;
    // Amount of Vertical space between each of the playlist boxes
    double vertSpace = 15;
    // Aspect ratio of the playlist boxes (width/height), this makes them slighty taller rectangles
    double gridBoxAspect = 0.85;

    // Based on the current state, sets child to the appropriate widget
    switch (selected) {
      // Sign in Button
      case 0:
        // Wrapped in container to take the parents size
        child = Container(
            // Wrapped in tooltip to tell the user what they are hovering over
            child: Tooltip(
              // Tooltip message
              message: 'Link your Spotify Account',
              // Time before tooltip is displayed
              waitDuration: Duration(seconds: 1),
              // Tooltip wrapped over Text button
              child: TextButton.icon(
                // Sets the text to the main font and gives padding + color
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(35.0),
                  primary: Colors.black,
                ),
                // Creates icon from SVG
                icon: SvgPicture.asset(
                  'assets/images/spotify-logo.svg',
                  height:
                      40, // These can be static because this button doesn't scale
                  width: 40,
                  color: Colors.black,
                ),
                // Sets the icon Label to log in text
                label: Text(
                  'Log In',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 30,
                  ),
                ),
                // When pressed, increment the selection
                onPressed: () {
                  //incrementSelected();
                  logIn();
                  // This is also where Oauth2 will go
                },
              ),
            ),
            // Sets the key to the iteration value so the animator knows that this is a different container from the previous
            key: ValueKey<int>(selected));
        break;
      // Playlist Selector page
      case 1:
        if(hasPlaylists)
        {
          // Wrapped in container to get parents size
          child = Container(
              // Column of the elements: Welcome message -> instructions -> Grid View scrollable playlist thing
              child: Column(
                // Alligns elements to be evenly spread out between the very top and bottom of the container
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dynamic spacer to add padding to the top
                  Spacer(flex: 2),
                  // Wraps text in flexible to dynamically spize it
                  Flexible(
                    flex: 3,
                    // Text that welcomes the user
                    child: 
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        'Welcome, ' + userName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 50,
                        ),
                      ),
                    ),
                  ),
                  // Dynamic spacer to add padding between the welcome and instruction text
                  Spacer(flex: 1),
                  // Wraps text in flexible to dynamically size it
                  Flexible(
                    flex: 2,
                    // Text to tell the user to pick a playlist
                    child: 
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        'Select One Of Your Playlists',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  // Dynamic spacer to add padding between the instructions and the grid
                  Spacer(flex: 1),
                  // Wraps grid in flexible to dynamically size it
                  Flexible(
                      // Fits it tightly
                      fit: FlexFit.tight,
                      flex: 40,
                      // Rectangular clip to give the grid rounded corners
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          // Matches the bottom corners to the Animated Container
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        // Container to hold the Grid Veiw in a different color box
                        child: Container(
                          // Sets container to gray box
                          color: Color.fromRGBO(25, 20, 20, 1.0),
                          // Container to create padding around the grid
                          child: Container(
                            // Left right and bottom padding
                            padding:
                                EdgeInsets.only(left: 10, right: 10, bottom: 10),
                            // Clips the gridviww box so it doesnt have sharp corners
                            child: ClipRRect(
                                // Corner clip size
                                borderRadius: BorderRadius.circular(5),
                                // Gridview dyanmic builder
                                child: GridView.builder(
                                  // Settings for the grid
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    // Dynamically sets the number of boxes wide it is
                                    crossAxisCount: axisCount,
                                    // Space horizontally between boxes
                                    crossAxisSpacing: crossSpace,
                                    // Space vertically between boxes
                                    mainAxisSpacing: vertSpace,
                                    // Aspect ratio of boxes (width/height)
                                    childAspectRatio: gridBoxAspect,
                                  ),
                                  // Number of playlists (based on number of playlist images)
                                  itemCount: playlistNames.length,
                                  // Gridview builder
                                  itemBuilder: (BuildContext context, int index) {
                                    // Returns gesture detector to allow user to click each box
                                    return GestureDetector(
                                      // I don't know what this does
                                      behavior: HitTestBehavior.deferToChild,
                                      // When a grid is clicked
                                      onTap: () {
                                        // Move to the next page
                                        incrementSelected();
                                        //print('cringe ' + index.toString());
                                        setState(() {
                                          selectedPlaylist = playlistNames[index];
                                          // ALSO ADD PLAYLIST ID SUTFF HERE TO QUERY LATER THIS IS WHERE WE MOVE ON
                                        });
                                        // Playlist is clicked, return the playlist.
                                      },
                                      // Creates mouse region to change the pointer to select when over a grid
                                      child: MouseRegion(
                                        // Changes cursor
                                        cursor: SystemMouseCursors.click,
                                        // Clip to round corners
                                        child: ClipRRect(
                                          // Corner clip settings
                                          borderRadius: BorderRadius.circular(5),
                                          // Container to hold the grid
                                          child: Container(
                                              // Slightly lighter gray so it pops out
                                              color:
                                                  Color.fromRGBO(35, 30, 30, 1.0),
                                              // Column of elements inside each grid
                                              //  Playlist image -> Playlist title
                                              child: Column(
                                                children: <Widget>[
                                                  // Top padding, dynamically spaced
                                                  Spacer(flex: 1),
                                                  // Image wrapped in flexible to scale with the page
                                                  Flexible(
                                                    flex: 20,
                                                    // Clip to round the corners of the image
                                                    child: ClipRRect(
                                                      // Corner clip settings
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      // Image
                                                      child: Image.network(
                                                        playlistPicture[index],
                                                        // Sets scale so it takes up a good amount of space
                                                        scale: 0.68,
                                                      ),
                                                    ),
                                                  ),
                                                  // Spacer to dynamically space the image and the playlist title
                                                  Spacer(flex: 2),
                                                  // Row to hold the title text with good spacing
                                                  Row(children: <Widget>[
                                                    // 10 pixel sized box
                                                    SizedBox(width: 10),
                                                    // Scales the text in the remaining space
                                                    FittedBox(
                                                      fit: BoxFit.fitWidth,
                                                      // Playlist title text
                                                      child: Text(
                                                        playlistNames[index],
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                                  // Spacer to add slight padding to the bottom
                                                  Spacer(flex: 2),
                                                ],
                                              )),
                                        ),
                                      ),
                                    );
                                  },
                                )),
                          ),
                        ),
                      )),
                ],
              ),
              // Sets the key to the iteration value so the animator knows that this is a different container from the previous
              key: ValueKey<int>(selected));
        }
        else
        {
                    // Wrapped in container to get parents size
          child = Container(
              // Column of the elements: Welcome message -> instructions -> Grid View scrollable playlist thing
              child: Column(
                // Alligns elements to be evenly spread out between the very top and bottom of the container
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dynamic spacer to add padding to the top
                  Spacer(flex: 2),
                  // Wraps text in flexible to dynamically spize it
                  Flexible(
                    flex: 3,
                    // Text that welcomes the user
                    child: 
                    FittedBox(
                      fit: BoxFit.cover,
                      child: Text(
                        'Welcome, ' + userName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          //fontSize: 50,
                        ),
                      ),
                    )
                  ),
                  // Dynamic spacer to add padding between the welcome and instruction text
                  Spacer(flex: 1),
                  // Wraps text in flexible to dynamically size it
                  Flexible(
                    flex: 2,
                    // Text to tell the user to pick a playlist
                    child: 
                    FittedBox(
                      fit: BoxFit.cover,
                      child: Text(
                        'Please Create a Playlist',
                        style: TextStyle(
                          color: Colors.black,
                          //fontSize: 15,
                        ),
                      ),
                    )
                  ),
                  // Dynamic spacer to add padding between the instructions and the grid
                  Spacer(flex: 1),
                  ],
              ),
              // Sets the key to the iteration value so the animator knows that this is a different container from the previous
              key: ValueKey<int>(selected)
            );
        }
        break;
      case 2:
        child = Container(
            child: Column(
              // Alligns elements to be evenly spread out between the very top and bottom of the container
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Dynamic spacer to add padding to the top
                Spacer(flex: 2),
                // Wraps text in flexible to dynamically spize it
                Flexible(
                  flex: 3,
                  // Text that welcomes the user
                  child: Text(
                    selectedPlaylist,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 50,
                    ),
                  ),
                ),
                // Dynamic spacer to add padding between the welcome and instruction text
                Spacer(flex: 1),
                // Wraps text in flexible to dynamically size it
                Flexible(
                  flex: 2,
                  // Text to tell the user to pick a playlist
                  child: Text(
                    'Adjust Sorting Parameters',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
                // Dynamic spacer to add padding between the instructions and the grid
                Spacer(flex: 1),
                Flexible(
                  // Fits it tightly
                  fit: FlexFit.tight,
                  flex: 25,
                  // Rectangular clip to give the grid rounded corners
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      // Matches the bottom corners to the Animated Container
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    // Container to hold the Grid Veiw in a different color box
                    child: Container(
                      // Sets container to gray box
                      color: Color.fromRGBO(25, 20, 20, 1.0),
                      child: Column(children: [
                        Spacer(flex: 1),
                        Flexible(
                          flex: 5,
                          child: Row(children: [
                            Spacer(flex: 1),
                            Flexible(
                                flex: 5,
                                child: Column(children: [
                                  Text(
                                    'bpm',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Slider(
                                    value: bpm.toDouble(),
                                    min: 0,
                                    max: 100,
                                    label: bpm.toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        bpm = value.toInt();
                                      });
                                    },
                                  ),
                                ])),
                            Spacer(flex: 1),
                            Flexible(
                                flex: 5,
                                child: Column(children: [
                                  Text(
                                    'key',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Slider(
                                    value: key.toDouble(),
                                    min: 0,
                                    max: 100,
                                    label: key.toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        key = value.toInt();
                                      });
                                    },
                                  ),
                                ])),
                            Spacer(flex: 1),
                            Flexible(
                                flex: 5,
                                child: Column(children: [
                                  Text(
                                    'energy',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Slider(
                                    value: energy.toDouble(),
                                    min: 0,
                                    max: 100,
                                    label: energy.toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        energy = value.toInt();
                                      });
                                    },
                                  ),
                                ])),
                            Spacer(flex: 1),
                          ]),
                        ),
                        Spacer(flex: 1),
                        Flexible(
                          flex: 5,
                          child: Row(children: [
                            Spacer(flex: 1),
                            Flexible(
                                flex: 5,
                                child: Column(children: [
                                  Text(
                                    'Acousticness',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Slider(
                                    value: acoustic.toDouble(),
                                    min: 0,
                                    max: 100,
                                    label: acoustic.toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        acoustic = value.toInt();
                                      });
                                    },
                                  ),
                                ])),
                            Spacer(flex: 1),
                            Flexible(
                                flex: 5,
                                child: Column(children: [
                                  Text(
                                    'Danceability',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Slider(
                                    value: dance.toDouble(),
                                    min: 0,
                                    max: 100,
                                    label: dance.toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        dance = value.toInt();
                                      });
                                    },
                                  ),
                                ])),
                            Spacer(flex: 1),
                            Flexible(
                                flex: 5,
                                child: Column(children: [
                                  Text(
                                    'Loudness',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Slider(
                                    value: loudness.toDouble(),
                                    min: 0,
                                    max: 100,
                                    label: loudness.toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        loudness = value.toInt();
                                      });
                                    },
                                  ),
                                ])),
                            Spacer(flex: 1),
                          ]),
                        ),
                        Spacer(flex: 1),
                        Flexible(
                          flex: 5,
                          child: Row(children: [
                            Spacer(flex: 1),
                            Flexible(
                                flex: 5,
                                child: Column(children: [
                                  Text(
                                    'Liveness',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Slider(
                                    value: liveness.toDouble(),
                                    min: 0,
                                    max: 100,
                                    label: liveness.toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        liveness = value.toInt();
                                      });
                                    },
                                  ),
                                ])),
                            Spacer(flex: 1),
                            Flexible(
                                flex: 5,
                                child: Column(children: [
                                  Text(
                                    'Speechiness',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Slider(
                                    value: speechiness.toDouble(),
                                    min: 0,
                                    max: 100,
                                    label: speechiness.toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        speechiness = value.toInt();
                                      });
                                    },
                                  ),
                                ])),
                            Spacer(flex: 1),
                            Flexible(
                                flex: 5,
                                child: Column(children: [
                                  Text(
                                    'Valence',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Slider(
                                    value: valence.toDouble(),
                                    min: 0,
                                    max: 100,
                                    label: valence.toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        valence = value.toInt();
                                      });
                                    },
                                  ),
                                ])),
                            Spacer(flex: 1),
                          ]),
                        ),
                        Spacer(flex: 1),
                        Tooltip(
                          // Tooltip message
                          message: 'Sort Playlist Using These Parameters',
                          // Time before tooltip is displayed
                          waitDuration: Duration(seconds: 1),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(35),
                            // Tooltip wrapped over Text button
                            child: TextButton(
                              // Sets the text to the main font and gives padding + color
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    Color.fromRGBO(29, 185, 84, 1.0),
                                padding: const EdgeInsets.all(35.0),
                                primary: Colors.black,
                              ),
                              // Sets the icon Label to log in text
                              child: Text(
                                'Sort Playlist',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 30,
                                ),
                              ),
                              // When pressed, increment the selection
                              onPressed: () {
                                incrementSelected();
                                // This is also where Oauth2 will go
                              },
                            ),
                          ),
                        ),
                        Spacer(flex: 1),
                      ]),
                    ),
                  ),
                ),
              ],
            ),
            // Sets the key to the iteration value so the animator knows that this is a different container from the previous
            key: ValueKey<int>(selected));
        break;
      case 3:
        child = Text('Here is Playlist',
            style: TextStyle(color: Colors.white, fontSize: 30),
            key: ValueKey<int>(selected));
        break;
    }
    // Returns the Widget
    return child;
  }

  double widthSelector(double maxWidth) {
    // Function to return the width of the block based on the current state
    // val -> current state of the program
    // maxWidth -> current max screen size of the program

    double width = 0;
    //double maxWidth = MediaQuery.of(context).size.width;

    // Sets 'width' to the correct size based on its current state. These are Dyanmic based on screen size
    switch (selected) {
      case 0: // Log In Button
        width = 200;
        break;
      case 1: // Select Playlist
        width = maxWidth * 0.5;
        break;
      case 2: // Selecting Parameters
        width = maxWidth * 0.9;
        break;
      case 3: // Viewing Sorted Playlist
        width = maxWidth * 0.8;
        break;
    }
    // Returns correct width
    return width;
  }

  double heightSelector(double maxHeight) {
    // Function to return the height of the block based on the current state
    // val -> current state of the program
    // maxHeight -> current max screen size of the program

    double height = 0;
    //double maxHeight = MediaQuery.of(context).size.height;

    // Sets 'height' to the correct size based on its current state. These are Dyanmic based on screen size
    switch (selected) {
      case 0: // Log In Button
        height = 90;
        break;
      case 1: // Select Playlist
        height = maxHeight*0.95;
        break;
      case 2: // Selecting Parameters
        height = (maxHeight - 233) *
            0.9; // 233 is the number of pixels left, Idk how to make it dynamic LUL
        break;
      case 3: // Viewing Sorted Playlist
        height = (maxHeight - 233) * 0.9;
        break;
    }
    return height;
  }

  // Handeling the animated switches on the landing page
  @override
  Widget build(BuildContext context) {
    if (first_start) {
      webInitialization();
      setState(() {
        first_start = false;
      });
    }
    // Container to get the parents size
    return Container(
      // use LayoutBuilder to fetch the parent widget's constraints
      child: LayoutBuilder(builder: (context, constraints) {
        // Stores the parents size (size of the screen)
        var parentHeight = constraints.maxHeight;
        var parentWidth = constraints.maxWidth;
        // Returns animated container to switch between elements
        return AnimatedContainer(
          // Sets size based on current state of program and size of screen
          width: widthSelector(parentWidth),
          height: heightSelector(parentHeight),
          // Centers elements
          alignment: Alignment.center,
          // Creates animation only if an element is being incremented or decremented, no animation when the screen
          //  is being rescaled. This was annoying asf to figure out.
          duration: switching ? Duration(seconds: 1) : Duration(seconds: 0),
          // Type of animation the container will have
          curve: Curves.fastOutSlowIn,
          // Animated switcher of the content inside those containers
          child: AnimatedSwitcher(
            // Total duration of content switch
            duration: const Duration(milliseconds: 1500),
            // Builds custom transition
            transitionBuilder: (Widget child, Animation<double> animation) {
              // First sets the container animation controller to false since it is currently animating
              //  based off the state of the program.
              switching = false;
              // Returns fade transition
              return FadeTransition(
                // Controls opacity of the child over time
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                  // Smooth curve
                  CurvedAnimation(
                    parent: animation,
                    // From half way through to the end of the time frame
                    curve: Interval(0.5, 1.0),
                  ),
                ),
                child: child,
              );
            },
            // Gets child based on the curent state of the program
            child: giveChild(parentWidth, parentHeight),
          ),
          // Decoration of the animated container
          decoration: BoxDecoration(
            // Sets to spotify green
            color: Color.fromRGBO(29, 185, 84, 1.0),
            // Sets rounded corners
            borderRadius: BorderRadius.all(Radius.circular(20)),
            // Creates box shadow
            boxShadow: const [
              BoxShadow(
                // Black box shadow
                color: Colors.black,
                // soften the edges
                blurRadius: 35.0,
                //extend the shadow
                spreadRadius: 8.0,
                // No offset but keeping this here in case i change my mind
                offset: Offset(
                  0.0, // Move to right 10  horizontally
                  0.0, // Move to bottom 10 Vertically
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}

class MobileLanding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// Working main switcher

/*
Flexible(
      child: AnimatedContainer(
        width: widthSelector(),
        height: heightSelector(),
        alignment: Alignment.center,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
        child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 1500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Interval(0.5, 1.0),
                            ),
                          ),
                          child: child,
                        );
                },
                child: giveChild(),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
              ),
        decoration: BoxDecoration(
            color: Color.fromRGBO(29, 185, 84, 1.0),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                blurRadius: 35.0, // soften the shadow
                spreadRadius: 8.0, //extend the shadow
                offset: Offset(
                  0.0, // Move to right 10  horizontally
                  0.0, // Move to bottom 10 Vertically
                ),
              )
            ],
        ),
      ),
    );
*/

// Working second screen....

/*
Container(
                  width: double.infinity,
                  height: heightSelector(),
                  //alignment: Alignment.topCenter,
                  child: Column(
                            children: [
                              SizedBox(height: 15),
                              Text(
                                'Welcome, Zach',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black, 
                                  fontSize: 50,
                                  ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Select One Of Your Playlists',
                                style: TextStyle(
                                  color: Colors.black, 
                                  fontSize: 15,
                                  ),
                              ),
                              SizedBox(height: 25,),
                              ClipRRect(
                               borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                topRight: Radius.circular(5),
                                                bottomLeft: Radius.circular(18),
                                                bottomRight: Radius.circular(18),
                                              ),
                                child: Container(
                                  width: widthSelector(),
                                  height: (heightSelector() - 127),
                                  color: Color.fromRGBO(25, 20, 20, 1.0),
                                  child: Column(
                                          children: <Widget>[
                                              SizedBox(height: 30,),
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(5),
                                                child: Container(
                                                  width: gridWidth,
                                                  height: gridHeight,
                                                  child: GridView.builder(
                                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: axisCount,
                                                        crossAxisSpacing: crossSpace,
                                                        mainAxisSpacing: vertSpace,
                                                        childAspectRatio: gridBoxAspect,
                                                      ),
                                                      itemCount: pictureList.length,
                                                      itemBuilder: (BuildContext context, int index) {
                                                        return 
                                                        GestureDetector(
                                                          behavior: HitTestBehavior.translucent,
                                                          onTap: () {
                                                            incrementSelected();
                                                            print('cringe'); 
                                                            // Playlist is clicked, return the playlist.
                                                          },
                                                          child: MouseRegion(
                                                            cursor: SystemMouseCursors.click,
                                                            child:ClipRRect(
                                                              borderRadius: BorderRadius.circular(5),
                                                              child: Container(
                                                                color: Color.fromRGBO(30, 25, 25, 1.0),
                                                                child: Column( 
                                                                children: <Widget> [
                                                                    SizedBox(height: 20,),
                                                                    ClipRRect(
                                                                      borderRadius: BorderRadius.circular(5),
                                                                      child: Image.asset(
                                                                        pictureList[index],
                                                                        width: gridBoxWidth*0.9,
                                                                        height: gridBoxWidth*0.9,
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 20,),
                                                                    Row(
                                                                      children: <Widget> [
                                                                        SizedBox(width: 25,),
                                                                        Text(
                                                                        'Playlist ' + index.toString(),
                                                                        textAlign: TextAlign.left,
                                                                        style: TextStyle(
                                                                          //fontWeight: FontWeight.bold,
                                                                          color: Colors.white, 
                                                                          fontSize: 18,
                                                                          ),
                                                                        ),
                                                                      ]
                                                                    ),
                                                                  ],
                                                                )
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    )
                                                ),
                                              ),
                                            ],
                                          )
                                  )
                              ),
                            ], 
                          ),
                  key: ValueKey<int>(selected)
                );
*/

//                            Old code that I am just keeping around for referance.......

/*
        Center(
          child: Container(
            height: MediaQuery.of(context).size.height - 233,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color.fromRGBO(25, 20, 20, 1.0),Color.fromRGBO(29, 185, 84, 1.0)]
              ),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 25.0, // soften the shadow
                  spreadRadius: 5.0, //extend the shadow
                  offset: Offset(
                    0.0, // Move to right 10  horizontally
                    -15.0, // Move to bottom 10 Vertically
                  ),
                )
              ],
            ),
          ),
        ),
        //padding: const EdgeInsets.all(20),
        Center(
          child:
          Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const SizedBox(height: 50),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(29, 185, 84, 1.0) 
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                          primary: Colors.black,
                          textStyle: const TextStyle(fontSize: 40),
                        ),
                        onPressed: () {},
                        child: const Text('Sign In'),
                      ),
                    ]
                  )
                ),
            ]
          )
        ),
*/