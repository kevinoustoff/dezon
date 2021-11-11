import 'package:dezon/views/profile/userProfile.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final int id;
  final String userPhoto,
      userName,
      userTagLine,
      userDescription,
      userReview,
      userRegistrationDate;
  final List userSkills;
  UserCard({
    @required this.id,
    @required this.userPhoto,
    @required this.userName,
    @required this.userTagLine,
    @required this.userDescription,
    @required this.userSkills,
    @required this.userReview,
    @required this.userRegistrationDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 35,
              backgroundImage: Image.network(
                userPhoto,
              ).image,
            ),
            SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 4.0,
                    ),
                    child: Text(
                      userName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              userTagLine,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 5),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  "< $userDescription >",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  userReview,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
                Icon(
                  Icons.star,
                  color: Colors.yellow.shade800,
                ),
              ],
            ),
            SizedBox(height: 5),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  "Membre depuis " + userRegistrationDate,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ),
            ),
            SizedBox(height: 5),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UserProfile(
                        id: id,
                      ),
                    ),
                  );
                },
                child: Text("Voir le profil")),
          ],
        ),
      ),
    );
  }
}
